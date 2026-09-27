# Build pipeline: Markdown → PPTX

The house-style decks are built from a single content file. **Content lives in `content.md`; the engine never changes.** This keeps the source of truth one readable Markdown file and makes every rebuild a safe, full regeneration.

## Files (copy `templates/` into the deck folder)

```
deck/
  content.md        # the ONLY file you edit — content + slide order
  engine.js         # generic engine (parser + renderers + house style). Never edit.
  custom.js         # deck-specific slides md can't express (figures, step-through tables)
  build.js          # entry: read content.md → engine → deck.pptx
  package.json      # pptxgenjs dependency
  image/*.png       # figures referenced by custom.js
```

Start from `templates/content.example.md` (rename to `content.md`).

## Data flow

`content.md` → `parse()` → `[slide objects]` → one renderer per `type` → `deck.pptx`.

- All style (colours, fonts, sizes, margins, footer, card look) is hardcoded in `engine.js`. **The Markdown contains no coordinates or colours** — only content.
- Cover and Reference are generated from the Markdown **frontmatter**, so even those stay content-driven.
- Page numbers are added centrally: every slide is numbered except the cover, reference, and `outline`.

## Markdown format (Style 1)

Frontmatter (drives cover + reference):

```markdown
---
title: Deck Title
author: Name
date: 2026 / 06
citation: |
  Author, A. (2024).
  Paper title.
  Journal, 8(7), 1285–1295.
affiliations: |
  Lab, Institute
citations: 618
link: https://...
---
```

Slides:

| Markdown | Slide |
|---|---|
| `# text` | section divider (left-middle; `**bold**` → accent) |
| `## title` + `- bullet` lines | title + bullets |
| `## title` + plain line | that plain line becomes a **lead** under the title |
| `::: boxes` / `- label` | row of boxes |
| `::: pillars` / `- label \| big \| gloss` | big-number cards |
| `::: cards` / `- label \| gloss` | accent-bar cards |
| `::: quote` / first line big, rest sub | big quote card |
| `::: outline` / `- head \| sub` (or `- n \| head \| sub`) | numbered outline |
| `caption: text` | grey caption at the bottom of the current slide |
| `highlight: text` | tinted emphasis card (`**bold**` → accent) |
| `> text` | one-line takeaway (`**bold**` → accent) |
| `@slide name` | insert a deck-specific slide defined in `custom.js` |

Fields inside a block are separated by `|`. `**word**` anywhere a rich line is allowed renders that word in the accent colour. A literal `\n` inside any field becomes a line break (e.g. a two-line pillar gloss). Two plain lines under a `##` become a two-line lead.

## Complex slides → `custom.js`

Figures, step-through result tables, and anything needing precise coordinates stay as named renderers in `custom.js`, placed in order via `@slide <name>` in the Markdown (so the Markdown still owns slide order). Each renderer is `(s, sl, api)` and uses `api.{ pres, card, bar, title, rich, caption, shadow, ACC, TEXT, SEC, TINT, FONT, ML, USABLE, PAGE_W, PAGE_H }` so it never hardcodes the house style. Use `s.addImage({ path: "image/fig.png", ... })` for figures. Set `fn.nonum = true` on a renderer to suppress its page number (e.g. a closing slide).

## Build + QA

```bash
npm install          # once
node build.js        # content.md → deck.pptx
# visual QA:
soffice --headless --convert-to pdf deck.pptx
pdftoppm -jpeg -r 110 deck.pdf slide
```

Inspect the rendered `slide-*.jpg` against the house-style checklist before declaring done.

## Retheme

The one config block at the top of `engine.js` holds the palette (`BG/TEXT/SEC/ACC/TINT/FONT`). Default is the documented house style (warm white + terracotta). Change those constants to retheme the whole deck (e.g. wine `ACC = "7C2B3A"`, `BG = "FCFCFC"`).
