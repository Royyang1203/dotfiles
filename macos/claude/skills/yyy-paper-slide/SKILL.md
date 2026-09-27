---
name: yyy-paper-slide
description: >-
  The user's personal house style for academic / paper-report presentation
  slides (light warm-white base, single terracotta accent, large fonts,
  image-first layouts, minimal text, left-aligned). Use this skill WHENEVER the
  user is building, drafting, or restyling slides for an academic talk — e.g.
  presenting/reporting a paper, a seminar, a journal-club / paper-review deck, a
  lab meeting, conference or proposal slides — even if they only say "make slides
  for this paper", "做投影片", "報告這篇論文", "幫我做 seminar 投影片" without naming a style.
  It pairs with the pptx skill: this skill decides HOW it should look, the pptx
  skill builds the .pptx. Do NOT use for non-academic decks (sales/pitch/marketing)
  unless the user explicitly asks for this same style.
---

# Academic Paper-Report Slides — House Style

This is the user's personal style for academic talks. The goal: **图为主、文字精简、字大、淺色、不花俏**. Apply it whenever you build or restyle academic slides, then generate the deck with the **pptx** skill.

## One-line north star

> **BDAF 的「圖為主、每頁幾句短句」配置 + 乾淨的淺色基底 + 比一般學術簡報更大的字 − 一切花俏裝飾。**

Before every slide ask: ① 這頁的「一張主圖」是什麼？ ② 文字能不能砍到 2–3 句？ ③ 太密了嗎，要不要拆兩頁？

## Exact spec (use these values, don't improvise)

**Colors**

| Role | Hex | Use |
|------|-----|-----|
| Background | `#FAF8F4` warm off-white | every content slide; never pure white |
| Main text | `#2B2B2B` dark charcoal | titles + body; never pure black |
| Secondary text | `#6B6B66` warm gray | captions, footer, citations, secondary notes |
| Accent | `#C2643C` terracotta | keywords, key numbers, the highlighted table cell/row, small marks |
| Image tint | `#F0E4DC` light terracotta | optional backing behind an image/screenshot (use sparingly) |

- **Text emphasis & decoration use ONLY the terracotta accent.** No second/third decorative color — that is exactly what makes a deck look busy.
- **Exception — functional color inside diagrams is fine.** A flowchart / architecture / KV-block style figure may use yellow/green/blue etc. to *distinguish data*. Functional color conveys information; decorative color blocks just look pretty — avoid the latter only.
- 60/30/10 weighting: mostly off-white, then charcoal text, terracotta ≈10% of the ink.
- Dark slides only for: cover, and the one-line closing slide (dark charcoal or deep terracotta bg + off-white text), as a "sandwich".

**Typography**

- One sans family throughout, mixed CJK+Latin: CJK 思源黑體 / 蘋方, Latin Inter / Helvetica.
- Title 36–44pt bold · body/bullets **22–28pt** (deliberately larger than typical academic decks) · captions 14–16pt secondary-gray.
- If it doesn't fit, the content is too much → **split the slide**, never shrink the font.

**Alignment (important — user is strict on this)**

- **Everything left-aligned. Nothing centered.**
- Content-slide title: **top-left**. Section-divider title: **left + vertically centered (left-middle)**.
- Body, bullets, one-line slides: all left-aligned. Only the *image itself* may sit centered; text never.

## Language & wording (the user is specific about this)

- **All English. No Chinese on the slides** (regardless of the conversation language). Speaker can narrate in Chinese; the slides stay English.
- **Plain, common words.** Avoid rare/fancy vocabulary — favor the simple word a non-native audience reads instantly (e.g. "use" not "leverage/utilize", "fix" not "remediate", "lets X" not "facilitates X").
- **Fragments over full sentences.** Telegraphic phrases are good: "KV cache grows per token", not "The KV cache grows with every token that is generated." Drop articles/linking verbs when meaning is clear.
- **Few adjectives.** Cut decorative modifiers. Keep words that carry facts — nouns, verbs, numbers, names.
- **High information density — short but information-rich.** This is NOT "say little". It means: few words, each one load-bearing. Pack in concrete specifics (numbers, names, mechanisms, deltas); strip filler, hedges, and adjectives. A line should lose words, not facts.

## Text budget (the core discipline)

- Max **2–3 short lines** OR **≤6 bullet lines** per slide (lines = fragments, not necessarily full sentences).
- Bullets **≤2 levels**. If a few fragments say it, **drop the bullets** — plain short lines read better.
- **One idea per slide.** When it feels dense in words, split — but keep the *information* dense. (This fixes the two failure modes: walls of text, and tiny crammed figures.)

## Layout patterns (rotate these for rhythm)

1. **Big figure centered** — title + one large figure/chart + a one-line caption.
2. **Text-left / figure-right** (the workhorse) — left: 2–3 short lines or ≤2-level bullets; right: figure/flowchart.
3. **Full-figure** — title only + one large diagram/architecture; minimal text.
4. **One-line takeaway** — a single large left-aligned line (vertically centered), to close a section. Use sparingly.
5. **Section divider** — large section name at **left-middle**, lots of whitespace, **no logo/icon**, nothing else.

Slide discipline: title position consistent across the deck; footer = paper citation (secondary gray) + page number; ≥0.5" margins; keep breathing room, don't fill every inch; align columns/figures consistently.

**Progressive reveal** — for a complex figure/flow, don't dump it on one slide. Build it across several slides, one piece per slide. This keeps density low and lets the audience follow your narration.

## Handling paper tables & figures (where decks usually fail)

- **Never paste a whole table/figure shrunk to fit** — that's what makes text tiny and unreadable.
- Crop to the region you'll actually discuss and **enlarge** it; dim or drop the rest.
- A must-show large table → split across pages, enlarging one part per page.

### Step-through table technique (the user's favorite — from the ToM deck)

When walking through a table column-by-column or region-by-region:

1. Keep the **same table on several consecutive slides**, fixed in place.
2. Put a **terracotta box around the part you're discussing now**; move the box to the next region on the next slide — the audience always knows where you are.
3. Add a **one-line takeaway at the bottom** in English (e.g. "Model trusts what it already believes"), with an arrow from the boxed cells down to it.
4. Put a **small legend diagram beside it** explaining what the rows/columns mean (roles, conditions).
5. Keep the title consistent across the group (or add a tiny sub-label for progress).

## Avoid (these read as "fancy" / "AI-generated" / "cramped")

- Decorative multi-color cards or a 2nd/3rd decorative color (functional diagram color is OK — see above).
- Quote-mark decorations, numbered colored badges, eyebrow micro-labels, decorative underlines under titles.
- Bullets 3+ levels deep.
- Whole shrunk-down small-font tables.
- Shrinking the font to cram a slide.
- Text-only slides with no visual — every slide should have a figure/diagram/chart.
- Centered text of any kind.

## Workflow

1. Plan the deck against this spec: pick a layout per slide, cut text to budget, decide each slide's main figure, plan any step-through tables and progressive reveals.
2. Build with the **Markdown → PPTX pipeline** (preferred): copy `templates/` into the deck folder, write content in `content.md`, run `node build.js`. Content stays in one readable Markdown file; the engine hardcodes the house style so rebuilds are safe full regenerations. Figures/step-through tables go in `custom.js`, ordered via `@slide`. See **references/markdown-pipeline.md** for the format and `templates/content.example.md` for a worked example. (Falling back to hand-written pptxgenjs is fine for one-off complex decks.)
3. **Visual QA** — render to images and inspect (`soffice --headless --convert-to pdf` then `pdftoppm -jpeg`). Check specifically: all text is English (no Chinese) and uses plain words; everything left-aligned; body ≥22pt; only the accent colour used for text emphasis; no whole tiny tables; dividers have no logo and sit left-middle; every slide has a visual; no slide exceeds the text budget.
4. Fix `content.md` and re-verify before declaring done.

### Build pipeline at a glance

- **Edit only `content.md`** (and `custom.js` for figures). Never hand-edit the `.pptx` — it is regenerated and overwritten every build.
- Markdown blocks: `#` divider · `##`+bullets · `::: boxes/pillars/cards/quote/outline` · `caption:` · `highlight:` · `> takeaway` · `@slide name`. Cover + reference come from frontmatter. `**word**` → accent colour.
- Retheme via the one config block at the top of `engine.js` (`BG/TEXT/SEC/ACC/TINT/FONT`).

## Pre-flight checklist

- [ ] 全英文、用字淺白、片語可不完整、少形容詞、但資訊密度高（具體名詞/數字/動詞）？
- [ ] 這頁有一張主圖／圖表嗎？
- [ ] 文字 ≤3 行 或 ≤6 行 bullet？bullet ≤2 層？
- [ ] 內文字級 ≥22pt（不夠就拆頁，不縮字）？
- [ ] 文字強調只用陶土色？（圖解功能性配色不算）
- [ ] 全部靠左、沒有置中文字？分隔頁靠左中且無 logo？
- [ ] 論文表格是裁切放大、不是整張小貼？逐步講的表有移動的框＋底部一句話結論？
- [ ] 複雜圖有用漸進式揭露分頁講？
