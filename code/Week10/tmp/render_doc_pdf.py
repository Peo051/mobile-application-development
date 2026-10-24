import pypdfium2 as pdfium
from pathlib import Path
pdf_path = Path(r"E:\Learn\Ky5_26_27\BaiTapTuan10\tmp\docx-review-final2\HuongDan_DuAn_QuanLyDoAn.pdf")
out = pdf_path.parent
pdf = pdfium.PdfDocument(pdf_path)
for i in range(len(pdf)):
    page = pdf[i]
    bitmap = page.render(scale=1.35)
    bitmap.to_pil().save(out / f"page-{i+1:02d}.png")
print(f"Rendered {len(pdf)} pages")
