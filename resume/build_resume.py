"""Build the downloadable resume: python3 resume/build_resume.py (ReportLab required)."""
import json
from pathlib import Path
from xml.sax.saxutils import escape

from reportlab.lib import colors
from reportlab.lib.pagesizes import A4
from reportlab.lib.styles import ParagraphStyle
from reportlab.platypus import SimpleDocTemplate, Paragraph, PageBreak

ROOT = Path(__file__).resolve().parents[1]
OUTPUT = ROOT / "assets/Raja_Chakraborty_Applied_AI_Product_Engineer_Resume.pdf"
BLUE = colors.HexColor("#174663")
STYLES = {
    "body": ParagraphStyle("body", fontName="Helvetica", fontSize=9.5, leading=12, spaceAfter=5),
    "section": ParagraphStyle("section", fontName="Helvetica", fontSize=10.5, leading=13, textColor=BLUE, spaceBefore=7, spaceAfter=6),
    "title": ParagraphStyle("title", fontName="Helvetica", fontSize=22, leading=26, spaceAfter=6),
    "subtitle": ParagraphStyle("subtitle", fontName="Helvetica", fontSize=10, leading=13, textColor=BLUE, spaceAfter=7),
}


def decorate(canvas, doc):
    canvas.saveState()
    canvas.setFont("Helvetica", 8)
    canvas.setFillColor(colors.HexColor("#666666"))
    canvas.drawString(42, 24, "Raja Chakraborty | AI Engineering")
    canvas.drawRightString(A4[0] - 42, 24, str(doc.page))
    if doc.page == 1:
        canvas.drawImage(str(ROOT / "assets/images/profile.png"), A4[0] - 114, A4[1] - 114, width=66, height=66, preserveAspectRatio=True)
    canvas.restoreState()


def markup(text):
    result = escape(text)
    for url in ("rjchakraborty.github.io/", "github.com/rjchakraborty", "www.linkedin.com/in/rjchakraborty21/"):
        if text.startswith(url) and " | " not in text:
            return f'<link href="https://{escape(text)}" color="#174663">{result}</link>'
    if text == "rjchakraborty.github.io/ | github.com/rjchakraborty":
        return '<link href="https://rjchakraborty.github.io/" color="#174663">rjchakraborty.github.io/</link> | <link href="https://github.com/rjchakraborty" color="#174663">github.com/rjchakraborty</link>'
    return result


def build():
    data = json.loads((ROOT / "resume/content.json").read_text())
    story = []
    for index, page in enumerate(data["pages"]):
        if index:
            story.append(PageBreak())
        for block in page:
            story.append(Paragraph(markup(block["text"]), STYLES[block["kind"]]))
    doc = SimpleDocTemplate(str(OUTPUT), pagesize=A4, leftMargin=48, rightMargin=48, topMargin=42, bottomMargin=42,
                            title="Raja Chakraborty - Applied AI and Product Engineer Resume", author="Raja Chakraborty", invariant=1)
    doc.build(story, onFirstPage=decorate, onLaterPages=decorate)


if __name__ == "__main__":
    build()
