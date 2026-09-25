# meta-ads-mcp — Full Setup Walkthrough (Direct Meta Auth)

This is the detailed version of the connection process, including the exact errors seen in the wild and how to fix them. The MCP server is `meta-ads-mcp` (open-source, by pipeboard-co), run via `uvx`. We use **direct Meta authentication** — the user's own Developer App — so there is no paid platform in the loop.

## Authentication models (why we pick direct)

`meta-ads-mcp` supports two auth paths:
- **Pipeboard** (`PIPEBOARD_API_TOKEN`) — easiest OAuth, but routes through pipeboard.co (a third party; has a free tier but it's still a middleman).
- **Direct Meta** (`META_APP_ID` + `META_APP_SECRET`) — the user's own Meta app, token stored locally, zero third parties.

Default to **direct** unless the user specifically wants Pipeboard's convenience. Everything below assumes direct.

## Prerequisites

- **uvx** — part of the `uv` toolchain. Check with `uvx --version`. If absent: `pip install uv`, or the standalone installer from astral.sh. `uvx meta-ads-mcp` then downloads and runs the server on demand (no global install).
- **A Meta Developer App** — created by the user (browser task, see below).
- A Meta account that is an **admin** of the target ad account.

## Step 1 — Create the Meta Developer App (user, one time)

1. Go to https://developers.facebook.com → **My Apps** → **Create App**.
2. App type: **Business**.
3. Inside the app, add the **Marketing API** product.
4. **Settings → Basic**: copy **App ID** and **App Secret** (click "Show").

The app can stay in **Development mode** for using your own ad account — no App Review needed. The user just has to be admin/developer of the app (automatic for the creator).

## Step 2 — `.mcp.json`

In the project root:
```json
{
  "mcpServers": {
    "meta-ads": {
      "command": "uvx",
      "args": ["meta-ads-mcp"],
      "env": {
        "META_APP_ID": "THE_APP_ID",
        "META_APP_SECRET": "THE_APP_SECRET"
      }
    }
  }
}
```
Then add `.mcp.json` to `.gitignore` (it contains the secret). On Windows, `uvx` resolves fine as the `command`.

## Step 3 — Authentication (the built-in flow is broken; here's what works)

The built-in auth (`uvx meta-ads-mcp --login` and the `get_login_link` MCP tool) does NOT work reliably in this version. Two independent bugs combine to make it fail, and they waste a lot of time if you trust the happy path. Skip straight to **the procedure that works** below.

### Why the built-in flow fails

**Bug 1 — wrong scope (silent).** Both `--login` and `get_login_link` build an OAuth URL whose `scope` is `business_management,public_profile,pages_show_list,pages_read_engagement` — note there is **no `ads_management` and no `ads_read`**. You can authenticate "successfully" and the token is real, but then `get_ad_accounts` and every campaign call return:
```
(#100) Unsupported get request. Please read the Graph API documentation...
```
That cryptic error on `me/adaccounts` is what a *missing ads permission* looks like. This is the trap: auth looks done, but the token is useless for ads.

**Bug 2 — broken callback handler.** The OAuth URL uses `response_type=token`, so Meta returns the token in the URL **fragment** (`...callback?#access_token=...`). But the local callback server parses the query string for an authorization `code`. It finds neither `code` nor `error`, logs `OAuth callback received without code or error`, and shows the user **"Unexpected Response — No authorization code or error received."** Deleting the `#` does NOT help here (unlike older versions) because the handler wants `code`, not `access_token`. So the token is never saved.

### The procedure that works

The trick is to bypass the broken callback entirely: build the OAuth URL yourself **with the ads scopes**, let the user grab the token from their own address bar, then exchange + cache it manually.

**1. Build the correct OAuth URL** and give it to the user (substitute the real App ID):
```
https://www.facebook.com/v24.0/dialog/oauth?client_id=APP_ID&redirect_uri=http://localhost:8080/callback&scope=ads_management,ads_read,business_management,pages_show_list,pages_read_engagement&response_type=token
```
`redirect_uri` must be one already whitelisted on the app — `http://localhost:8080/callback` (the MCP server's port) and `http://localhost:8888/callback` both work since the tooling registered them. On the consent screen the user must see and **accept "Manage your ads"** — if it's absent, the user isn't an admin/dev of the app or the app can't grant `ads_management` (in Development mode an admin can grant it with no App Review).

**2. User copies the token from the address bar.** After authorizing, the browser lands on `http://localhost:8080/callback?#access_token=EAA...&data_access_expiration_time=...&expires_in=...&long_lived_token=EAA...` and shows the "Unexpected Response" error page — that's expected, ignore it. The user copies the **`access_token`** value (everything after `access_token=` up to the first `&`) and pastes it back to you.

**3. Verify scope** by calling `get_ad_accounts(access_token="<pasted token>")`. If it returns a `data` array of `act_...` accounts, the scope is correct. If it returns `(#100) Unsupported get request`, the ads scope is still missing — recheck the URL's `scope` and that the user accepted the ads permission.

**4. Exchange for a 60-day token and write the cache.** The pasted token is short-lived (~1h, `expires_in≈3600`). Exchange it and persist it so the server auto-authenticates on future startups. Run (Python is available via the env; this needs App ID + Secret):
```python
import urllib.request, urllib.parse, json, time, os, pathlib
APP_ID="..."; APP_SECRET="..."; SHORT="<pasted access_token>"
q=urllib.parse.urlencode({"grant_type":"fb_exchange_token","client_id":APP_ID,
    "client_secret":APP_SECRET,"fb_exchange_token":SHORT})
r=json.load(urllib.request.urlopen("https://graph.facebook.com/v25.0/oauth/access_token?"+q))
tok=r["access_token"]; exp=r.get("expires_in",5184000)
base=pathlib.Path(os.environ["APPDATA"])/"meta-ads-mcp"   # Windows; mac: ~/Library/Application Support, linux: ~/.config
base.mkdir(parents=True, exist_ok=True)
(base/"token_cache.json").write_text(json.dumps(
    {"access_token":tok,"expires_in":exp,"user_id":None,"created_at":int(time.time())}))
```
The cache file format is exactly the server's `TokenInfo`: `access_token`, `expires_in` (seconds), `user_id`, `created_at` (unix epoch). The server reads `token_cache.json` from its config dir (`%APPDATA%\meta-ads-mcp\` on Windows) **only at startup** (`_load_cached_token` runs in the auth manager's `__init__`).

**5. Use it now, persist for later.** The server process that's already running won't see the new cache (it loaded auth at startup, before the file existed). So for the *current* session, pass `access_token="<long-lived token>"` explicitly on tool calls. After the **next window reload**, the server reads the cache and authenticates automatically — no token needed for ~60 days. You can read the long-lived token back from `token_cache.json` whenever you need it for explicit calls.

### Where the token lives

On Windows: `%APPDATA%\meta-ads-mcp\token_cache.json` (e.g. `C:\Users\<you>\AppData\Roaming\meta-ads-mcp\`). Debug log sits beside it as `meta_ads_debug.log` — grep it for `TOKEN VALIDATION FAILED` and `Found META_APP_ID` when diagnosing. Everything is local; nothing goes to a third party.

## Step 4 — Load the server in Claude Code

`.mcp.json` is read at startup only. After creating/editing it:
1. **Reload Window** (Ctrl+Shift+P → "Reload Window").
2. **Approve** the new `meta-ads` MCP server when Claude Code prompts.
3. Run `/mcp` → confirm `meta-ads` is **connected**.

The `mcp__meta-ads__*` tools are now available to Claude.

## Verifying the connection

Ask Claude (with tools loaded) to list ad accounts. A successful call returning the user's `act_XXXXXXXX` account(s) confirms end-to-end auth. If it errors with a permission/token problem, the token may have expired (re-run `--login`) or the app/account admin link is missing.

## Security checklist

- `.mcp.json` is gitignored.
- App Secret never committed or pasted into shared channels. If exposed, reset it in **Settings → Basic** and re-run `--login`.
- Access tokens grant ad-spend control — treat like a password.

## CLI reference (from `meta-ads-mcp --help`)

```
--login                 Authenticate with Meta and store the token
--app-id APP_ID         Meta App ID (Client ID) for authentication
--version               Show version
--transport {stdio,streamable-http}   default stdio (what Claude Code uses)
--port / --host         only for streamable-http transport
```
Docs: https://github.com/pipeboard-co/meta-ads-mcp
