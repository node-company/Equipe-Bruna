---
name: meta-ads-campaign
description: Connect Claude Code to a Meta (Facebook/Instagram) Ads account via the meta-ads-mcp MCP server using DIRECT Meta authentication (no paid third-party platform), then create and manage ad campaigns — conversions, leads, traffic. Use this skill whenever the user wants to create, launch, edit, or analyze Meta Ads / Facebook Ads / Instagram Ads campaigns from Claude, mentions connecting Claude to Meta Ads, asks "how do I run ads with you", talks about ad sets / creatives / pixel / ad account setup, or hits the known OAuth setup snags ("ID do app inválido", callback token in the URL). Covers first-time MCP connection AND day-to-day campaign creation.
---

# Meta Ads Campaign (via meta-ads-mcp)

This skill does two things: (1) get the `meta-ads` MCP server connected the first time, and (2) drive campaign creation once it's connected. Figure out which stage the user is in and jump there. Most repeat use is stage 2 — if `mcp__meta-ads__*` tools are already available, skip straight to **Creating a campaign**.

The whole setup uses **direct Meta authentication** — the user's own Meta Developer App, no Pipeboard or other paid middleman. The only cost is the ad spend itself.

## Quick state check

Before anything, check whether the MCP tools are already loaded (search for `mcp__meta-ads__` tools). 
- **Tools present** → connected. Go to [Creating a campaign](#creating-a-campaign).
- **Tools absent but `.mcp.json` has a `meta-ads` entry** → configured but not loaded. Tell the user to reload the window (see [step 5](#5-load-the-mcp-server)).
- **No `.mcp.json` / no entry** → fresh setup. Start at [Connecting](#connecting-first-time-setup).

---

## Connecting (first-time setup)

Read `references/setup.md` for the full walkthrough with every command and the OAuth gotchas. The short version is below — but when the user hits an error, the reference has the fixes, so consult it.

### 1. Check prerequisites
Run `uvx --version`. `meta-ads-mcp` runs through `uvx` (from the `uv` toolchain) — no permanent install. If `uvx` is missing, the user installs `uv` first (`pip install uv` or the official installer).

### 2. The user creates a Meta Developer App (one time)
At [developers.facebook.com](https://developers.facebook.com) → My Apps → Create App → type **Business** → add the **Marketing API** product. Then in **Settings → Basic**, copy the **App ID** and **App Secret**.

This is the user's task in a browser — you can't do it for them. Give clear steps and wait.

### 3. Write `.mcp.json`
Create (or add to) `.mcp.json` in the project root:
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
**Add `.mcp.json` to `.gitignore`** — it holds the App Secret. Never commit it.

### 4. Authenticate — DO NOT trust the built-in `--login` / `get_login_link`
**This is the hardest part and the built-in flows are broken in practice.** Read `references/setup.md` for the full play-by-play. Two things WILL bite you:

- **The default OAuth scope is missing ad permissions.** Both `--login` and the `get_login_link` MCP tool request a scope WITHOUT `ads_management`/`ads_read`. A token from those flows lists nothing and every campaign call fails with `(#100) Unsupported get request`. You MUST authenticate with a hand-built OAuth URL that includes the ads scopes.
- **The local callback server is broken** (it parses for `code` but the URL returns a `token`), so it always shows "Unexpected Response / No authorization code received" and never saves anything. The `#`-deletion trick does NOT fix it. Capture the token manually from the browser instead.

**The procedure that actually works** (full commands in `references/setup.md`):
1. Have the user open this URL (substitute the real App ID), authorize, and **accept the "manage your ads" permission**:
   `https://www.facebook.com/v24.0/dialog/oauth?client_id=APP_ID&redirect_uri=http://localhost:8080/callback&scope=ads_management,ads_read,business_management,pages_show_list,pages_read_engagement&response_type=token`
2. The browser lands on `localhost:8080/callback?#access_token=...` and shows an error page — ignore it. The user copies the **`access_token`** value from the address bar (the part after `access_token=`, up to the `&`) and pastes it back.
3. That token is short-lived (~1h). Exchange it for a 60-day token and write it to the server's cache so it persists — see `references/setup.md` for the exact `fb_exchange_token` call and the `token_cache.json` format. The server reads that cache at startup.

Everything stays on the machine.

### 5. Load the MCP server
`.mcp.json` is only read at startup, so after creating it the user must **reload the window** (Ctrl+Shift+P → "Reload Window") and **approve the new `meta-ads` server** when prompted. Then `/mcp` should show `meta-ads` as connected, and the `mcp__meta-ads__*` tools become available.

### Security note
The App Secret and any access token are sensitive — anyone with them can spend the ad budget. If either was pasted into chat or a shared file during setup, tell the user to reset the App Secret (Settings → Basic) and re-run `--login` afterward.

---

## Creating a campaign

Once `mcp__meta-ads__*` tools are live, this is the repeat workflow.

### Collect the briefing first
Don't build blind. Confirm these before touching the API:

1. **Objective** — conversions/sales, leads, traffic, or awareness. (Conversions needs a Pixel.)
2. **Product / offer + the promise** — what's being sold and the hook.
3. **Ticket / price.**
4. **Daily budget** to test with.
5. **Audience** — age range, gender, location, interests/behaviors. Or "advantage+/broad" to let Meta optimize.
6. **Pixel + conversion event** (for conversions) — is the Pixel installed on the sales/checkout page, and which event (Purchase, Lead, etc.)?
7. **Creative** — image/video + primary text + headline + destination URL.

If the user hasn't given these, ask for the missing ones in one batch rather than building on guesses.

### Discover the account
Use the MCP tools to list ad accounts and the pixel before creating anything, so you target the right IDs:
- List ad accounts → get the `act_XXXXXXXX` ID.
- List pixels (for conversions) → get the pixel ID and confirm it's receiving events.

### Gotcha: app must be in Live mode to create ad creatives
With the Meta app in **Development mode** you can create campaigns and ad sets and upload images (`/adimages`), but `create_ad_creative`/`create_ad` fail with `error_subcode 1885183` ("post created by an app in development mode; must be in public/live mode"). The user must flip the app to **Live** in the App Dashboard (requires a Privacy Policy URL + app category). There's no API workaround short of promoting an existing organic page post via `object_story_id`. Surface this early if the user only has a dev-mode app.

Also: uploading local image/video files through `upload_ad_image` means stuffing huge base64 into a tool call — impractical. Instead upload binaries straight to the Graph API from disk via a Python script (`POST {act}/adimages` multipart → returns `image_hash`; `POST {act}/advideos` → `video_id`), then pass the hash/id to `create_ad_creative`.

### Build the structure
Meta campaigns are three nested levels — create them in order:
1. **Campaign** — sets the objective (e.g. `OUTCOME_SALES` for conversions). Start **paused** so nothing spends before review.
2. **Ad Set** — budget, schedule, audience, optimization goal + the pixel/conversion event, placements.
3. **Ad** — the creative (links to a page post or uploads media) + primary text, headline, CTA, destination URL.

### Before activating
- Show the user the full structure (campaign → ad set → ad) and the targeting/budget as a summary.
- Keep everything **paused** until the user explicitly says go live. Activating spends real money — treat it as an outward-facing, hard-to-reverse action and confirm first.

### Analyzing / managing existing campaigns
For "how's my campaign doing" requests, use the insights tools to pull spend, CPM, CTR, CPA, conversions over a date range. Summarize what matters (cost per result, what's winning) rather than dumping every metric.

---

## Reference files
- `references/setup.md` — full first-time connection walkthrough, every command, and the OAuth error fixes in detail. Read it when setting up or when the user reports a connection/login error.