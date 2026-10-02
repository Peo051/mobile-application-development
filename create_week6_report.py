import os
from docx import Document
from docx.shared import Inches, Pt, RGBColor
from docx.enum.text import WD_ALIGN_PARAGRAPH
from docx.enum.table import WD_TABLE_ALIGNMENT
from docx.oxml import parse_xml
from docx.oxml.ns import nsdecls

doc_path = r"f:\Thuc Hanh\LTDD\docs\BaiTapTuan6_TranDuongGiaBao_2001240039.docx"
screenshots_dir = r"f:\Thuc Hanh\LTDD\screenshots\week6"

doc = Document()

# Thiet lap le trang A4 gon gang (Top/Bottom: 0.45 in, Left/Right: 0.55 in) de dam bao 100% 1 bai nam tron 1 trang
for section in doc.sections:
    section.top_margin = Inches(0.45)
    section.bottom_margin = Inches(0.45)
    section.left_margin = Inches(0.55)
    section.right_margin = Inches(0.55)

def add_title(text):
    p = doc.add_paragraph()
    p.alignment = WD_ALIGN_PARAGRAPH.CENTER
    p.paragraph_format.space_before = Pt(8)
    p.paragraph_format.space_after = Pt(4)
    run = p.add_run(text)
    run.font.name = "Arial"
    run.font.size = Pt(18)
    run.font.bold = True
    run.font.color.rgb = RGBColor(26, 82, 118) # Deep navy

def add_subtitle(text):
    p = doc.add_paragraph()
    p.alignment = WD_ALIGN_PARAGRAPH.CENTER
    p.paragraph_format.space_after = Pt(14)
    run = p.add_run(text)
    run.font.name = "Arial"
    run.font.size = Pt(13)
    run.font.bold = True
    run.font.color.rgb = RGBColor(80, 80, 80)

def add_info_box():
    tbl = doc.add_table(rows=1, cols=1)
    tbl.alignment = WD_TABLE_ALIGNMENT.CENTER
    cell = tbl.cell(0, 0)
    
    # Border & Shading
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
    p.paragraph_format.space_before = Pt(6)
    p.paragraph_format.space_after = Pt(6)
    
    lines = [
        ("Họ và tên: ", "Trần Dương Gia Bảo"),
        ("Mã số sinh viên: ", "2001240039"),
        ("Lớp học phần: ", "15DHTH02"),
        ("Môn học: ", "Lập trình di động (Flutter & Dart)"),
        ("Chủ đề: ", "BÀI 06: MULTIMEDIA TRONG FLUTTER"),
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

def add_summary_table():
    p = doc.add_paragraph()
    p.paragraph_format.space_before = Pt(16)
    p.paragraph_format.space_after = Pt(6)
    run = p.add_run("DANH MỤC CÁC BÀI TẬP HOÀN THÀNH:")
    run.font.name = "Arial"
    run.font.size = Pt(12)
    run.font.bold = True
    run.font.color.rgb = RGBColor(26, 82, 118)

    tbl = doc.add_table(rows=9, cols=3)
    tbl.alignment = WD_TABLE_ALIGNMENT.CENTER

    headers = ["STT", "Bài tập thực hành", "Trạng thái"]
    for i, h in enumerate(headers):
        cell = tbl.cell(0, i)
        shd = parse_xml(r'<w:shd {} w:fill="1A5276"/>'.format(nsdecls('w')))
        cell._tc.get_or_add_tcPr().append(shd)
        p = cell.paragraphs[0]
        p.alignment = WD_ALIGN_PARAGRAPH.CENTER
        r = p.add_run(h)
        r.font.name = "Arial"
        r.font.size = Pt(10)
        r.font.bold = True
        r.font.color.rgb = RGBColor(255, 255, 255)

    data = [
        ("Bài 1", "Media Picker App (Chọn ảnh/video từ Gallery & Camera)", "Hoàn thành 100%"),
        ("Bài 2", "Photo Capture & Preview (Chụp/chọn ảnh & Xem toàn màn hình)", "Hoàn thành 100%"),
        ("Bài 3", "Contacts Reader & SMS Reader (Đọc danh bạ & SMS hệ thống)", "Hoàn thành 100%"),
        ("Bài 4", "Video Recorder & Playback (Quay/chọn video & Play/Pause)", "Hoàn thành 100%"),
        ("Bài 5", "Quản lý và thêm danh bạ (Xem danh sách & Form thêm kèm Avatar)", "Hoàn thành 100%"),
        ("Bài 6.1", "Simple Audio Player (Phát nhạc Assets: Play, Pause, Stop, Next)", "Hoàn thành 100%"),
        ("Bài 6.2", "Ứng dụng nghe nhạc theo mẫu (Đĩa than Now Playing & Playlist)", "Hoàn thành 100%"),
        ("Bài 7", "SMS Analyzer (Thống kê, lọc người gửi, lọc [QC] & trích xuất [OTP])", "Hoàn thành 100%"),
    ]

    for row_idx, (stt, name, status) in enumerate(data, start=1):
        c0 = tbl.cell(row_idx, 0)
        c1 = tbl.cell(row_idx, 1)
        c2 = tbl.cell(row_idx, 2)
        
        c0.text = stt
        c1.text = name
        c2.text = status

        for c in [c0, c1, c2]:
            p = c.paragraphs[0]
            p.paragraph_format.space_before = Pt(2)
            p.paragraph_format.space_after = Pt(2)
            for r in p.runs:
                r.font.name = "Arial"
                r.font.size = Pt(9.5)
        
        c0.paragraphs[0].alignment = WD_ALIGN_PARAGRAPH.CENTER
        c2.paragraphs[0].alignment = WD_ALIGN_PARAGRAPH.CENTER
        c2.paragraphs[0].runs[0].font.bold = True
        c2.paragraphs[0].runs[0].font.color.rgb = RGBColor(34, 139, 34)

# Ham them trang bai tap chua CA ANH VS CODE VA ANH KET QUA DI DONG TRONG CUNG 1 TRANG
def add_exercise_page(ex_title, ex_desc, vscode_img, result_img, res_height=3.4):
    doc.add_page_break()

    # Tieu de bai tap
    p_title = doc.add_paragraph()
    p_title.paragraph_format.space_before = Pt(0)
    p_title.paragraph_format.space_after = Pt(1)
    p_title.paragraph_format.keep_with_next = True
    r_title = p_title.add_run(ex_title)
    r_title.font.name = "Arial"
    r_title.font.size = Pt(11.5)
    r_title.font.bold = True
    r_title.font.color.rgb = RGBColor(180, 40, 40) # Strong Red

    # Mo ta bai tap
    p_desc = doc.add_paragraph()
    p_desc.paragraph_format.space_before = Pt(0)
    p_desc.paragraph_format.space_after = Pt(3)
    p_desc.paragraph_format.keep_with_next = True
    r_desc = p_desc.add_run(ex_desc)
    r_desc.font.name = "Arial"
    r_desc.font.size = Pt(8.5)
    r_desc.font.italic = True
    r_desc.font.color.rgb = RGBColor(90, 90, 90)

    # 1. Nhan VS Code
    p_vs_lbl = doc.add_paragraph()
    p_vs_lbl.paragraph_format.space_before = Pt(1)
    p_vs_lbl.paragraph_format.space_after = Pt(1)
    p_vs_lbl.paragraph_format.keep_with_next = True
    r_vs_lbl = p_vs_lbl.add_run("1. Ảnh chụp màn hình Visual Studio Code thật (Mã nguồn):")
    r_vs_lbl.font.name = "Arial"
    r_vs_lbl.font.size = Pt(9.5)
    r_vs_lbl.font.bold = True
    r_vs_lbl.font.color.rgb = RGBColor(26, 82, 118)

    # Anh VS Code that (rong 5.2 in, cao ~3.06 in)
    vs_path = os.path.join(screenshots_dir, vscode_img)
    if os.path.exists(vs_path):
        p_vs = doc.add_paragraph()
        p_vs.alignment = WD_ALIGN_PARAGRAPH.CENTER
        p_vs.paragraph_format.space_before = Pt(0)
        p_vs.paragraph_format.space_after = Pt(2)
        p_vs.paragraph_format.keep_with_next = True
        p_vs.add_run().add_picture(vs_path, width=Inches(5.2))
    else:
        print(f"Missing VS Code img: {vs_path}")

    # 2. Nhan Ket qua giao dien mobile
    p_res_lbl = doc.add_paragraph()
    p_res_lbl.paragraph_format.space_before = Pt(2)
    p_res_lbl.paragraph_format.space_after = Pt(1)
    p_res_lbl.paragraph_format.keep_with_next = True
    r_res_lbl = p_res_lbl.add_run("2. Ảnh chụp kết quả giao diện thiết bị di động (Pixel Emulator):")
    r_res_lbl.font.name = "Arial"
    r_res_lbl.font.size = Pt(9.5)
    r_res_lbl.font.bold = True
    r_res_lbl.font.color.rgb = RGBColor(24, 106, 59)

    # Anh Ket qua di dong (dat chieu cao chuan de vua van trang A4)
    res_path = os.path.join(screenshots_dir, result_img)
    if os.path.exists(res_path):
        p_res = doc.add_paragraph()
        p_res.alignment = WD_ALIGN_PARAGRAPH.CENTER
        p_res.paragraph_format.space_before = Pt(0)
        p_res.paragraph_format.space_after = Pt(0)
        p_res.add_run().add_picture(res_path, height=Inches(res_height))
    else:
        print(f"Missing result img: {res_path}")

# ==================== NOI DUNG TAI LIEU ====================

# 1. Trang bia
add_title("BÁO CÁO BÀI TẬP THỰC HÀNH - TUẦN 6")
add_subtitle("CHƯƠNG 4: MULTIMEDIA TRONG FLUTTER")
add_info_box()
add_summary_table()

# 2. Bai 1
add_exercise_page(
    ex_title="BÀI TẬP 1: MEDIA PICKER APP",
    ex_desc="Ứng dụng cho phép chọn ảnh hoặc video từ Gallery, chụp ảnh hoặc quay video từ Camera, tự động khởi tạo VideoPlayerController và phát video/hiển thị ảnh.",
    vscode_img="vscode_bai1_media_picker.png",
    result_img="result_bai1_media_picker.png",
    res_height=3.35,
)

# 3. Bai 2
add_exercise_page(
    ex_title="BÀI TẬP 2: PHOTO CAPTURE & PREVIEW",
    ex_desc="Ứng dụng chọn ảnh từ Gallery hoặc chụp từ Camera, hiển thị ảnh đã chọn và cho phép chạm vào ảnh để xem trước toàn màn hình với widget FullScreenImage.",
    vscode_img="vscode_bai2_photo_capture.png",
    result_img="result_bai2_photo_capture.png",
    res_height=3.35,
)

# 4. Bai 3
add_exercise_page(
    ex_title="BÀI TẬP 3: CONTACTS READER & SMS READER",
    ex_desc="Ứng dụng gồm màn hình chính điều hướng đến Contacts Reader (đọc danh bạ thiết bị) và SMS Reader (đọc tin nhắn hộp thư đến sắp xếp mới nhất) trên Android.",
    vscode_img="vscode_bai3_contacts_sms.png",
    result_img="result_bai3_contacts_sms.png",
    res_height=3.35,
)

# 5. Bai 4
add_exercise_page(
    ex_title="BÀI TẬP 4: VIDEO RECORDER & PLAYBACK",
    ex_desc="Ứng dụng cho phép chọn video từ Gallery hoặc quay video từ Camera, hiển thị video giữ đúng tỷ lệ bằng AspectRatio và nút Play/Pause điều khiển linh hoạt.",
    vscode_img="vscode_bai4_video_recorder.png",
    result_img="result_bai4_video_recorder.png",
    res_height=3.4,
)

# 6. Bai 5
add_exercise_page(
    ex_title="BÀI TẬP 5: QUẢN LÝ VÀ THÊM DANH BẠ",
    ex_desc="Ứng dụng quản lý danh bạ: xem danh sách danh bạ có ảnh đại diện, mở form Thêm danh bạ cho phép nhập Tên, SĐT, Email và chọn avatar từ Camera/Gallery.",
    vscode_img="vscode_bai5_contact_manager.png",
    result_img="result_bai5_contact_manager.png",
    res_height=3.35,
)

# 7. Bai 6.1 (Tren lop)
add_exercise_page(
    ex_title="BÀI TẬP 6 (TRÊN LỚP): SIMPLE AUDIO PLAYER",
    ex_desc="Ứng dụng phát âm thanh từ Assets sử dụng package audioplayers với đầy đủ cụm nút Previous, Play/Pause, Stop, Next và tự động chuyển bài vòng lặp.",
    vscode_img="vscode_bai6_audio_player.png",
    result_img="result_bai6_audio_player.png",
    res_height=3.4,
)

# 8. Bai 6.2 (Ve nha)
add_exercise_page(
    ex_title="BÀI TẬP 6 (VỀ NHÀ): ỨNG DỤNG NGHE NHẠC THEO MẪU",
    ex_desc="Ứng dụng nghe nhạc với giao diện tím đen gradient bám sát ảnh mẫu tài liệu (trang 37): đĩa than quay Now Playing và danh sách bài hát Playlist phẳng.",
    vscode_img="vscode_bai6_music_player.png",
    result_img="result_bai6_music_player.png",
    res_height=3.35,
)

# 9. Bai 7 (Ve nha)
add_exercise_page(
    ex_title="BÀI TẬP 7 (VỀ NHÀ): SMS ANALYZER",
    ex_desc="Ứng dụng phân tích tin nhắn SMS: bảng thống kê (Tổng, QC, OTP, Thường), tìm kiếm số người gửi, lọc theo ngày/tháng, nhận diện [QC] và chạm để trích xuất mã 6 số [OTP].",
    vscode_img="vscode_bai7_sms_analyzer.png",
    result_img="result_bai7_sms_analyzer.png",
    res_height=3.35,
)

doc.save(doc_path)
print(f"Report document successfully updated at: {doc_path}")
