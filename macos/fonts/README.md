# Fonts

## Kaiu.ttf — 標楷體 (DFKai-SB)

| Item | Value |
|---|---|
| Family | DFKai-SB / 標楷體 |
| PostScript name | `DFKai-SB` |
| Size | 28 MB |

**Why:** Many Taiwanese school and government documents (reports, grant proposals, theses, official forms) require 標楷體. macOS does not ship with it, so `.docx` files written on Windows fall back to a different font and the layout breaks.

**Where:** `Kaiu.ttf` is a commercial font by DynaComware, licensed with Microsoft Windows. This repo is public, so the file is in the private repo `Royyang1203/dotfiles-private`. Its `setup.sh` copies the font to `~/Library/Fonts`:

```bash
gh repo clone Royyang1203/dotfiles-private ~/dotfiles-private
```

```bash
~/dotfiles-private/setup.sh
```

Restart Word / PowerPoint afterwards.

**Check:**

```bash
ls ~/Library/Fonts/Kaiu.ttf
```

`.gitignore` still blocks `macos/fonts/*.ttf` and `*.otf`, so a font file put here by mistake is not committed.
