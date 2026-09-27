// custom.js — deck-specific slides that Markdown can't express (figures, step-through
// result tables, anything with precise coordinates). Reference them from content.md with
//   @slide <name>
// Each renderer gets (s, sl, api). `api` exposes the house-style helpers so you never
// hardcode colours/fonts:  api.{ pres, card, bar, title, rich, caption, ACC, TEXT, SEC,
// TINT, FONT, ML, USABLE, PAGE_W, PAGE_H }.  Use api.pres.shapes / s.addImage as needed.

module.exports = {
  // EXAMPLE — a titled figure with a caption. Replace the placeholder with:
  //   s.addImage({ path: "image/fig1.png", x, y, w, h });
  "demo-figure"(s, sl, api) {
    const { title, caption, pres, ACC, SEC, TINT, FONT, ML, USABLE } = api;
    title(s, "Figure example");
    s.addShape(pres.shapes.RECTANGLE, { x: ML, y: 1.7, w: USABLE, h: 3.6, fill: { color: TINT, transparency: 55 }, line: { color: ACC, width: 1.25, dashType: "dash" } });
    s.addText("image/your-figure.png", { x: ML, y: 3.2, w: USABLE, h: 0.6, fontFace: FONT, fontSize: 15, italic: true, color: SEC, align: "center", margin: 0 });
    caption(s, "One-line takeaway about the figure.");
  },
};
