# Fonts

Fonts to install manually when setting up a new Mac.

## Kaiu.ttf — 標楷體 (DFKai-SB)

| Item | Value |
|---|---|
| Family | DFKai-SB / 標楷體 |
| PostScript name | `DFKai-SB` |
| Size | 28 MB |

**Why:** Many Taiwanese school and government documents (reports, grant proposals, theses, official forms) require 標楷體. macOS does not ship with it, so `.docx` files written on Windows fall back to a different font and the layout breaks.

**Install:**

```bash
cp ~/dotfiles/macos/fonts/Kaiu.ttf ~/Library/Fonts/
```

Or double-click `Kaiu.ttf` and click **Install Font** in Font Book. Restart Word / PowerPoint afterwards.

**Check:**

```bash
fc-list | grep -i DFKai
```

## Not in git

`Kaiu.ttf` is a commercial font by DynaComware, licensed with Microsoft Windows. This repo is public, so the font file is listed in `.gitignore` and exists only on the local machine. A fresh `git clone` will not contain it — copy the file over from an existing Mac (`~/Library/Fonts/Kaiu.ttf` or this folder) or from a personal backup.
