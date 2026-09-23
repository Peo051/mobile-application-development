import os
import sys
from docx import Document
from docx.shared import Inches, Pt, RGBColor
from docx.enum.text import WD_ALIGN_PARAGRAPH
from docx.enum.table import WD_TABLE_ALIGNMENT
from docx.oxml import OxmlElement, parse_xml
from docx.oxml.ns import nsdecls, qn

doc_path = r"f:\Thuc Hanh\LTDD\docs\BaiTapTuan5_TranDuongGiaBao_2001240039.docx"
screenshots_dir = r"f:\Thuc Hanh\LTDD\screenshots"

doc = Document()

# Thiết lập lề trang A4 chuẩn (Top: 2cm, Bottom: 2cm, Left: 2cm, Right: 2cm)
sections = doc.sections
for section in sections:
    section.top_margin = Inches(0.8)
    section.bottom_margin = Inches(0.8)
    section.left_margin = Inches(0.8)
    section.right_margin = Inches(0.8)

# Hàm style cho tiêu đề chính
def add_title(text):
    p = doc.add_paragraph()
    p.alignment = WD_ALIGN_PARAGRAPH.CENTER
    p.paragraph_format.space_before = Pt(0)
    p.paragraph_format.space_after = Pt(6)
    run = p.add_run(text)
    run.font.name = "Arial"
    run.font.size = Pt(18)
    run.font.bold = True
    run.font.color.rgb = RGBColor(26, 82, 118) # Deep navy blue

def add_subtitle(text):
    p = doc.add_paragraph()
    p.alignment = WD_ALIGN_PARAGRAPH.CENTER
    p.paragraph_format.space_after = Pt(14)
    run = p.add_run(text)
    run.font.name = "Arial"
    run.font.size = Pt(13)
    run.font.bold = True
    run.font.color.rgb = RGBColor(80, 80, 80)

# Thêm bảng thông tin sinh viên đẹp mắt
def add_info_box():
    tbl = doc.add_table(rows=1, cols=1)
    tbl.alignment = WD_TABLE_ALIGNMENT.CENTER
    cell = tbl.cell(0, 0)
    
    # Border và background màu nhạt
    shading = parse_xml(r'<w:shd {} w:fill="F4F6F7"/>'.format(nsdecls('w')))
    cell._tc.get_or_add_tcPr().append(shading)
    
    tcPr = cell._tc.get_or_add_tcPr()
    borders = parse_xml(r'''
        <w:tcBorders {} >
            <w:top w:val="single" w:sz="8" w:space="0" w:color="BDC3C7"/>
            <w:left w:val="single" w:sz="24" w:space="0" w:color="1A5276"/>
            <w:bottom w:val="single" w:sz="8" w:space="0" w:color="BDC3C7"/>
            <w:right w:val="single" w:sz="8" w:space="0" w:color="BDC3C7"/>
        </w:tcBorders>
    '''.format(nsdecls('w')))
    tcPr.append(borders)
    
    p = cell.paragraphs[0]
    p.paragraph_format.space_before = Pt(4)
    p.paragraph_format.space_after = Pt(4)
    
    lines = [
        ("Họ và tên: ", "Trần Dương Gia Bảo"),
        ("Mã số sinh viên: ", "2001240039"),
        ("Lớp học phần: ", "15DHTH02"),
        ("Môn học: ", "Lập trình di động (Flutter & Dart)"),
        ("Github: ", "https://github.com/Peo051/mobile-application-development"),
    ]
    for label, val in lines:
        r1 = p.add_run(label)
        r1.font.name = "Arial"
        r1.font.size = Pt(10.5)
        r1.font.bold = True
        
        r2 = p.add_run(val + "\n" if label != lines[-1][0] else val)
        r2.font.name = "Arial"
        r2.font.size = Pt(10.5)
        if "http" in val:
            r2.font.color.rgb = RGBColor(21, 101, 192)
            r2.font.underline = True

def add_heading_1(text):
    p = doc.add_paragraph()
    p.paragraph_format.space_before = Pt(18)
    p.paragraph_format.space_after = Pt(8)
    p.paragraph_format.keep_with_next = True
    run = p.add_run(text)
    run.font.name = "Arial"
    run.font.size = Pt(14)
    run.font.bold = True
    run.font.color.rgb = RGBColor(180, 40, 40) # Strong Red / Ruby

def add_heading_2(text):
    p = doc.add_paragraph()
    p.paragraph_format.space_before = Pt(14)
    p.paragraph_format.space_after = Pt(6)
    p.paragraph_format.keep_with_next = True
    run = p.add_run(text)
    run.font.name = "Arial"
    run.font.size = Pt(12)
    run.font.bold = True
    run.font.color.rgb = RGBColor(24, 106, 59) # Forest Green

def add_desc(text):
    p = doc.add_paragraph()
    p.paragraph_format.space_before = Pt(2)
    p.paragraph_format.space_after = Pt(6)
    run = p.add_run(text)
    run.font.name = "Arial"
    run.font.size = Pt(10.5)
    run.font.italic = True
    run.font.color.rgb = RGBColor(90, 90, 90)

def add_sublabel(text):
    p = doc.add_paragraph()
    p.paragraph_format.space_before = Pt(6)
    p.paragraph_format.space_after = Pt(4)
    p.paragraph_format.keep_with_next = True
    run = p.add_run(text)
    run.font.name = "Arial"
    run.font.size = Pt(10.5)
    run.font.bold = True
    run.font.color.rgb = RGBColor(40, 40, 40)

def add_image_centered(img_name, width_inch=5.8):
    path = os.path.join(screenshots_dir, img_name)
    if os.path.exists(path):
        p = doc.add_paragraph()
        p.alignment = WD_ALIGN_PARAGRAPH.CENTER
        p.paragraph_format.space_before = Pt(4)
        p.paragraph_format.space_after = Pt(10)
        p.add_run().add_picture(path, width=Inches(width_inch))
    else:
        print(f"Warning: Image not found: {path}")

# ==================== NỘI DUNG TÀI LIỆU ====================

add_title("BÁO CÁO BÀI TẬP THỰC HÀNH - TUẦN 5")
add_subtitle("CHƯƠNG 03: THIẾT KẾ LAYOUT TRONG FLUTTER")
add_info_box()

# ----------------- BÀI TẬP 03 -----------------
add_heading_1("BÀI TẬP 03: THIẾT KẾ GIAO DIỆN \"QUÀ CỦA VINH (7)\"")
add_desc("Xây dựng giao diện mô phỏng màn hình Quà của Vinh trên ứng dụng Momo: Thanh tiêu đề màu hồng nhạt, bộ lọc cuộn ngang, 2 thẻ ưu đãi & điểm thưởng, và danh sách 5 quà tặng thương hiệu thực tế (CGV, Sim Mobifone, Ngân hàng VIB, Bảo hiểm, Phí không dừng).")

add_sublabel("1. Source code tạo nên giao diện Quà của Vinh:")
add_image_centered("code_bai03_qua_cua_vinh.png", width_inch=6.0)

add_sublabel("2. Ảnh chụp kết quả giao diện thực tế:")
add_image_centered("week5_bai3_qua_cua_vinh.png", width_inch=3.0)


# ----------------- BÀI TẬP 04 -----------------
doc.add_page_break()
add_heading_1("BÀI TẬP 04: THIẾT KẾ ỨNG DỤNG CỬA HÀNG ĐIỆN THOẠI ĐƠN GIẢN")
add_desc("Xây dựng ứng dụng hoàn chỉnh gồm: Màn hình giới thiệu (Intro), Màn hình Cửa hàng (Shop) danh sách điện thoại cuộn ngang, Menu Drawer điều hướng, Hộp thoại thêm vào giỏ, Màn hình Giỏ hàng (Cart) với chức năng xóa và hộp thoại thanh toán.")

# Mục 4.1
add_heading_2("1. Màn hình Giới thiệu cửa hàng (IntroScreen)")
add_desc("Màn hình mở đầu với logo HUIT tròn, tên cửa hàng, địa chỉ và nút chuyển tiếp bo tròn viên thuốc.")
add_sublabel("a) Source code màn hình Giới thiệu:")
add_image_centered("code_bai04_01_intro.png", width_inch=6.0)
add_sublabel("b) Kết quả giao diện thực tế:")
add_image_centered("week5_bai4_01_intro.png", width_inch=2.8)

# Mục 4.2
add_heading_2("2. Màn hình Cửa hàng (ShopScreen - Danh sách sản phẩm)")
add_desc("Giao diện Cửa hàng điện thoại với AppBar màu vàng cam, danh sách sản phẩm hiển thị dưới dạng thẻ cuộn ngang kèm nút thêm vào giỏ hàng.")
add_sublabel("a) Source code bố cục Cửa hàng & Danh sách sản phẩm:")
add_image_centered("code_bai04_02_shop.png", width_inch=6.0)
add_sublabel("b) Kết quả giao diện thực tế:")
add_image_centered("week5_bai4_02_shop.png", width_inch=2.8)

# Mục 4.3
add_heading_2("3. Ngăn kéo Menu điều hướng (Drawer Navigation)")
add_desc("Menu bên trái gồm Header màu trắng chứa ảnh đại diện, tên giảng viên Vũ Văn Vĩnh, email, và thân menu màu xanh dương với các mục Cửa hàng, Giỏ hàng, Thoát.")
add_sublabel("a) Source code cấu hình Drawer:")
add_image_centered("code_bai04_03_drawer.png", width_inch=6.0)
add_sublabel("b) Kết quả giao diện thực tế:")
add_image_centered("week5_bai4_03_drawer.png", width_inch=2.8)

# Mục 4.4
add_heading_2("4. Hộp thoại Xác nhận thêm sản phẩm vào Giỏ hàng")
add_desc("Hộp thoại AlertDialog xuất hiện khi người dùng nhấn nút dấu cộng (+) màu xanh ngọc trên từng thẻ sản phẩm.")
add_sublabel("a) Source code hộp thoại Xác nhận thêm vào giỏ:")
add_image_centered("code_bai04_04_dialog_add.png", width_inch=6.0)
add_sublabel("b) Kết quả giao diện thực tế:")
add_image_centered("week5_bai4_04_dialog_add.png", width_inch=2.8)

# Mục 4.5
add_heading_2("5. Màn hình Giỏ hàng của bạn (CartScreen)")
add_desc("Màn hình hiển thị toàn bộ danh sách các điện thoại đã được chọn vào giỏ, mỗi mục có tên, giá và icon thùng rác để xóa, cùng nút 'Thanh toán' ở đáy màn hình.")
add_sublabel("a) Source code màn hình Giỏ hàng:")
add_image_centered("code_bai04_05_cart.png", width_inch=6.0)
add_sublabel("b) Kết quả giao diện thực tế:")
add_image_centered("week5_bai4_05_cart_with_items.png", width_inch=2.8)

# Mục 4.6
add_heading_2("6. Hộp thoại Xác nhận loại bỏ sản phẩm ra khỏi giỏ hàng")
add_desc("Hộp thoại AlertDialog cảnh báo khi người dùng nhấn vào biểu tượng thùng rác của bất kỳ sản phẩm nào trong giỏ.")
add_sublabel("a) Source code hộp thoại Xác nhận loại bỏ sản phẩm:")
add_image_centered("code_bai04_07_dialog_remove.png", width_inch=6.0)
add_sublabel("b) Kết quả giao diện thực tế:")
add_image_centered("week5_bai4_07_dialog_remove.png", width_inch=2.8)

# Mục 4.7
add_heading_2("7. Hộp thoại Xác nhận Thanh toán thành công")
add_desc("Hộp thoại AlertDialog thông báo 'Bạn đã thanh toán xong giỏ hàng' khi người dùng nhấn nút Thanh toán, sau đó làm rỗng giỏ hàng.")
add_sublabel("a) Source code hộp thoại Thanh toán:")
add_image_centered("code_bai04_06_checkout.png", width_inch=6.0)
add_sublabel("b) Kết quả giao diện thực tế:")
add_image_centered("week5_bai4_06_checkout.png", width_inch=2.8)

doc.save(doc_path)
print(f"Report updated successfully at: {doc_path}")
