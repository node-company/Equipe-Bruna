---
name: video-edit-checklist
description: Disciplined audit checklist for AI-driven video editing. Use BEFORE declaring a cut "done" — catches false starts, fillers, retakes, truncated words, and overlay artifacts that surface-level review misses. Built from real production lessons (Método Desconecta, May 2026).
---

# Video Edit Checklist

The 80/20 rule of AI video editing: the cut is 80% right after the first pass. The remaining 20% — false starts, fillers, retake remnants, truncated word tails — is what makes the difference between "looks OK" and "feels professional."

This skill is the missing **verify-before-ship** step. Run it after every cut, before showing to the user.

## When to use

- After producing an EDL but before final render
- After user reports issues like "there's still a `Eee...`" or "word X got cut"
- When recutting based on user feedback (each iteration runs the full audit)
- Before adding any motion graphics or post-production

## Hard rules (correctness — non-negotiable)

These prevent silent failures. Memorize.

1. **Listen to the first 1s and last 1s of EVERY segment.** Don't rely on transcript alone — Whisper hides false starts inside elongated word boundaries.
2. **Any word duration > 1.5s is suspicious.** Single Portuguese/English words rarely exceed 1s. A 3s "risada" is hiding a pause or restart.
3. **Cross-check numbers, prices, names.** If the speaker mentions a price/quantity twice with different values, the SECOND is almost always the corrected one.
4. **For positioned overlays on HyperFrames-generated WebMs:** never use `box-shadow` on the card — it bleeds dark pixels into the "transparent" body that chroma-key can't cleanly remove. Use a solid border or no shadow.
5. **For overlay exits:** never use GSAP `opacity: 0` to fade out on a transparent body. The fade-to-black artifact is visible mid-frame. Use ffmpeg `fade=t=out:st=...:alpha=1` AFTER colorkey instead.
6. **Conservative cut padding:** head 100–150ms, tail 400–600ms. Whisper truncates consonants (-t, -p, -k) by 100–200ms.
7. **One pass of `timeline_view` per cut edge is not enough.** Actually play the audio segment.

## The audit checklist (run on every iteration)

Before declaring a cut "ready":

### A. Per-segment scan
For each segment in the EDL:
- [ ] Source word at `start + head_pad` is not mid-sentence/mid-word
- [ ] Source word at `end - tail_pad` is a clean sentence/phrase end (period, exclamation)
- [ ] If a word at end has duration > 1.5s, listen to it (likely hiding a pause)
- [ ] No segment starts with: "A", "E", "O" alone (single-letter fillers)
- [ ] No segment starts with a fragment like "Que..." or "Para..." that's mid-thought

### B. Retake/false-start detection
For each topic the speaker covers, search the transcript for:
- [ ] Same opening words appearing twice (e.g. "O primeiro módulo" appears at 245s AND 248s — second is retake)
- [ ] Phrases that abandon: "A segunda.", "Esse método prático para te auxiliar no..."
- [ ] **Numbers that change**: "R$ 124" later "R$ 127" — the second is canonical
- [ ] **Module/version names that change**: "M1" later "Módulo 1"

### C. Filler audit
Stretched single-letter words (Whisper marks them with long duration):
- [ ] Any word matching `^[AEO]$` with duration > 0.30s — likely "Aaaa", "Eeee", "Oooo" filler
- [ ] Sounds like "uh", "hm", "ah" — Whisper may transcribe as "É", "Mm", "Ah", "A"

### D. Boundary artifacts
For each cut boundary:
- [ ] No audible click/pop (verify 30ms afade is applied)
- [ ] Word at boundary not cut mid-syllable (extend tail pad if needed)
- [ ] Visual cut is on a stable frame (not mid-motion/mid-blink)

### E. Overlay sanity
For each motion graphic overlay:
- [ ] Overlay window doesn't overlap with adjacent overlay (unless intentional cross-fade)
- [ ] Overlay's trigger word lands during HOLD phase of overlay, not entrance or exit
- [ ] Exit fade completes before next overlay's entrance (300ms+ gap)
- [ ] WebM overlays produced WITHOUT box-shadow on cards
- [ ] Title cards have solid opaque background covering full frame

## Workflow

### Phase 1 — Inventory & Transcribe (do once per source)
```bash
ffprobe -v error -show_format -show_streams <source>
python helpers/transcribe.py <source> --language pt   # cached
python helpers/pack_transcripts.py --edit-dir <dir>
```

### Phase 2 — First-pass cut
1. Identify ALL retakes/false starts in `takes_packed.md` — list each with timestamps
2. **Cross-check numbers**: search transcript for prices, quantities, version numbers
3. Build EDL with conservative padding (head 100ms, tail 400–600ms)
4. Render preview

### Phase 3 — User-supervised iteration (CRITICAL)
1. Show preview to user
2. **Ask user to play through and timestamp every issue**
3. Apply each fix:
   - **Filler "Eeee" / "Aaaa"**: split the segment around the stretched single-letter word
   - **Mid-segment retake**: split into part_a (before retake) + part_b (after retake)
   - **Truncated word**: extend tail pad by another 100–200ms (don't bleed into next phrase though)
   - **Late motion graphic**: shift `start_in_output` earlier
   - **Motion exits too fast**: re-render composition without GSAP exit + use ffmpeg `fade=alpha=1`

### Phase 4 — Final audit
Run the checklist above on the recut preview. Repeat Phase 3 until user signs off.

## HyperFrames overlay specifics

HyperFrames WebM output is **yuv420p** (no native alpha). Transparent body renders as **BLACK** pixels. To composite as a real overlay:

### Composition CSS (positioned overlay)
```css
body { background: transparent; }  /* renders as black in WebM */
.card {
  background: #FDFAF5;
  border-radius: 24px;
  /* NO box-shadow — bleeds dark halo */
  /* If you need definition, use: border: 2px solid var(--accent); */
}
```

### Composition GSAP (no internal exit)
```js
// Entrance: normal
tl.from("#card", { y: 30, opacity: 0, duration: 0.6, ease: "back.out(1.3)" }, 0.2);
// Hold for most of duration
// NO exit tween — ffmpeg handles fade-out via alpha
```

### ffmpeg overlay filter
```
[overlayN]setpts=PTS-STARTPTS+{start}/TB,
         colorkey=color=black:similarity=0.06:blend=0.02,
         fade=t=out:st={dur-0.6}:d=0.6:alpha=1
[aN]
```

**Order matters:** PTS shift → colorkey (adds alpha) → fade alpha → use as overlay input.

For full-screen title cards (MP4, opaque):
```
[overlayN]setpts=...,format=yuva420p,fade=t=out:st=...:d=...:alpha=1
[aN]
```

Use `format=yuva420p` to add alpha channel before fade.

## Common pitfalls catalog

Real examples from Método Desconecta production:

| Pattern | Source quote | Fix |
|---|---|---|
| Stretched filler | "...Tudo isso. Na prática. **Eeee** o último módulo..." | Split segment around "E" (src 284.28-284.74) |
| Filler at segment start | BONUS_resumos starts with "**E** começar a atuar..." | Split: part_a ends at 353.20, part_b starts 353.40 |
| Long-duration word hides false start | "risada," tagged [47.42-51.08] — 3.66s for one word | Start segment after the hidden pause (src 50.98) |
| Module retake | "O primeiro módulo é o pré-retirada. Aqueles pré-requisitos... O segundo é a retirada. Isso mesmo..." then RESTART "O segundo módulo é a retirada" | Trim first segment to end before retake (src 258.20) |
| Number correction | "R$ 124 reais" → "R$ 127 reais" | Cut the wrong-price segment entirely |
| Word cut at boundary | "Atualmente." tagged ending 446.10 but actually decays to 446.30+ | Extend tail pad from 400ms to 550ms |
| Overlay too brief | slot_04 (pain) at 4s — user wants visible until 02:06 | Extend composition `data-duration` to 4.5s, re-render |
| Overlay appears too early | slot_08 starts before trigger word lands | Shift `start_in_output` later; position relative to trigger |

## Iteration discipline

Each iteration cycle:

1. **Receive user feedback** — collect every issue with timestamp
2. **Translate every timestamp** — output time → source time using EDL
3. **Identify cut/extend** — for each issue, decide: extend boundary, split segment, shift overlay, or re-render comp
4. **Re-extract changed segments only** (if possible) — full re-extract takes 25+ min on 4K HEVC
5. **Verify with checklist** — don't skip
6. **Present** — show user the diff (what changed since last preview)

Iteration cycles MUST end on user explicit "ok" / "aprovado". Not on Claude's self-evaluation.

## Don't do this

- Don't claim a cut is "ready" after extracting only 3 frames as spot-check — frames don't reveal audio fillers
- Don't trust Whisper transcript alone — always verify long-duration words by playing audio
- Don't assume the speaker's first take is canonical — speakers correct themselves frequently
- Don't apply `box-shadow` to HyperFrames overlay cards — it always creates halo artifacts
- Don't use GSAP fade-out exits on transparent-body WebMs — fade-to-black mid-frame is visible
- Don't increase chroma-key similarity above 0.08 to "remove halos" — it eats the card content
- Don't extend tail padding beyond the next word's start — creates word overlap on next segment
- Don't render the full video for every iteration if only overlays changed — use the saved `base_preview.mp4` and re-composite with ffmpeg directly