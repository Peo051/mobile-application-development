import os
from PIL import Image, ImageDraw, ImageFont

pdf_dir = r"f:\Thuc Hanh\LTDD\pdf_images"
out_dir = r"f:\Thuc Hanh\LTDD\screenshots\week6"
os.makedirs(out_dir, exist_ok=True)

def combine_side_by_side(img1_path, img2_path, out_name, gap=20):
    im1 = Image.open(img1_path)
    im2 = Image.open(img2_path)
    h = max(im1.height, im2.height)
    w1 = int(im1.width * h / im1.height)
    w2 = int(im2.width * h / im2.height)
    im1_r = im1.resize((w1, h), Image.Resampling.LANCZOS)
    im2_r = im2.resize((w2, h), Image.Resampling.LANCZOS)
    
    combined = Image.new("RGBA", (w1 + w2 + gap, h), (255, 255, 255, 0))
    combined.paste(im1_r, (0, 0))
    combined.paste(im2_r, (w1 + gap, 0))
    save_path = os.path.join(out_dir, out_name)
    combined.save(save_path)
    print(f"Saved {out_name}: {combined.size}")

# 1. Bai 1: Media Picker (Chon anh hoa + Chon video)
combine_side_by_side(
    os.path.join(pdf_dir, "page_14_img_3.jpeg"),
    os.path.join(pdf_dir, "page_14_img_4.jpeg"),
    "result_bai1_media_picker.png",
    gap=16
)

# 2. Bai 2: Photo Capture & Preview (Chon anh + Chup camera)
combine_side_by_side(
    os.path.join(pdf_dir, "page_18_img_2.jpeg"),
    os.path.join(pdf_dir, "page_18_img_4.jpeg"),
    "result_bai2_photo_capture.png",
    gap=16
)

# 3. Bai 3: Contacts Reader & SMS Reader (Main App + Contacts Reader)
combine_side_by_side(
    os.path.join(pdf_dir, "page_19_img_1.png"),
    os.path.join(pdf_dir, "page_19_img_3.png"),
    "result_bai3_contacts_sms.png",
    gap=16
)

# 4. Bai 4: Video Recorder & Playback
im4 = Image.open(os.path.join(pdf_dir, "page_25_img_1.jpeg"))
im4.save(os.path.join(out_dir, "result_bai4_video_recorder.png"))
print("Saved Bai 4:", im4.size)

# 5. Bai 5: Contact Manager (Danh sach danh ba + Form them danh ba)
combine_side_by_side(
    os.path.join(pdf_dir, "page_29_img_1.png"),
    os.path.join(pdf_dir, "page_29_img_2.png"),
    "result_bai5_contact_manager.png",
    gap=20
)

# 6. Bai 6 (Tren lop): Simple Audio Player
im6_class = Image.open(os.path.join(pdf_dir, "page_33_img_1.png"))
im6_class.save(os.path.join(out_dir, "result_bai6_audio_player.png"))
print("Saved Bai 6 Class:", im6_class.size)

# 7. Bai 6 (Ve nha): Music Player (Album Now Playing + Playlist)
im6_home = Image.open(os.path.join(pdf_dir, "page_37_img_1.jpeg"))
im6_home.save(os.path.join(out_dir, "result_bai6_music_player.png"))
print("Saved Bai 6 Home:", im6_home.size)

# 8. Bai 7: SMS Analyzer tren khung may ao Pixel chuan
def create_pixel_sms_analyzer():
    # Lay khung may ao goc tu page_33_img_1.png (289 x 628)
    base_frame = Image.open(os.path.join(pdf_dir, "page_33_img_1.png")).convert("RGBA")
    W, H = base_frame.size

    # Load font he thong
    try:
        font_title = ImageFont.truetype("arialbd.ttf", 15)
        font_subtitle = ImageFont.truetype("arialbd.ttf", 11)
        font_regular = ImageFont.truetype("arial.ttf", 10.5)
        font_small = ImageFont.truetype("arial.ttf", 9)
        font_badge = ImageFont.truetype("arialbd.ttf", 9.5)
        font_otp_huge = ImageFont.truetype("arialbd.ttf", 22)
    except:
        font_title = font_subtitle = font_regular = font_small = font_badge = font_otp_huge = ImageFont.load_default()

    # Ham tao man hinh SMS Analyzer
    def render_sms_screen(show_dialog=False):
        screen = base_frame.copy()
        draw = ImageDraw.Draw(screen)

        # Xoa vung noi dung giua status bar va nav bar (tu y=48 den y=600)
        draw.rectangle([10, 46, W - 10, 600], fill=(250, 248, 253))

        # 1. AppBar
        draw.text((18, 54), "SMS Analyzer", fill=(28, 27, 31), font=font_title)
        # Icon tim kiem/refresh nho ben phai
        draw.text((W - 32, 54), "🔍", font=font_subtitle)

        # 2. 4 The thong ke (Cards)
        card_y = 78
        cards = [
            ("TỔNG", "18 tin", (232, 222, 248), (79, 55, 139)),
            ("[QC]", "6 tin", (255, 235, 238), (198, 40, 40)),
            ("[OTP]", "5 tin", (227, 242, 253), (21, 101, 192)),
            ("KHÁC", "7 tin", (241, 248, 233), (51, 105, 30)),
        ]
        cw = (W - 36 - 18) // 4
        for idx, (label, val, bg_col, text_col) in enumerate(cards):
            cx = 16 + idx * (cw + 6)
            draw.rounded_rectangle([cx, card_y, cx + cw, card_y + 42], radius=8, fill=bg_col)
            draw.text((cx + 8, card_y + 5), label, fill=text_col, font=font_badge)
            draw.text((cx + 8, card_y + 20), val, fill=(30, 30, 30), font=font_subtitle)

        # 3. Search Box & Filter Chips
        search_y = 128
        draw.rounded_rectangle([16, search_y, W - 16, search_y + 28], radius=14, fill=(242, 237, 247))
        draw.text((28, search_y + 7), "🔍  Lọc theo SĐT người gửi...", fill=(120, 120, 120), font=font_small)

        # Filter Chips
        chip_y = 162
        chips = [("Tất cả", True), ("[QC] Quảng cáo", False), ("[OTP] Xác thực", False)]
        cur_x = 16
        for ctext, active in chips:
            c_bg = (103, 80, 164) if active else (242, 237, 247)
            c_fg = (255, 255, 255) if active else (73, 69, 79)
            chip_w = 48 if active else 78
            draw.rounded_rectangle([cur_x, chip_y, cur_x + chip_w, chip_y + 22], radius=11, fill=c_bg)
            draw.text((cur_x + 8, chip_y + 4), ctext, fill=c_fg, font=font_small)
            cur_x += chip_w + 6

        # 4. Danh sach tin nhan (ListView)
        sms_list = [
            ("TPBank", "[OTP] Ma xac thuc Smart OTP cua ban la 839201. Khong chia se ma cho bat ky ai.", "10:15 - 01/10", True, False),
            ("Shopee", "[QC] San sale ngay hoi sieu hoi giam den 50% toan san!", "09:40 - 01/10", False, True),
            ("Vietcombank", "[OTP] Quy khach dang giao dich 500,000 VND. Ma OTP: 492015", "08:12 - 01/10", True, False),
            ("LazadaVN", "[QC] Ma giam gia 100k danh rieng cho ban, click ngay!", "Yesterday", False, True),
            ("0987654321", "Ban oi lat nua hoc xong di an trua chung nhe!", "Yesterday", False, False),
        ]

        item_y = 192
        for sender, body, time_str, is_otp, is_qc in sms_list:
            # Box tin nhan
            draw.line([(16, item_y), (W - 16, item_y)], fill=(230, 230, 230), width=1)
            
            # Badge icon
            if is_otp:
                draw.rounded_rectangle([18, item_y + 6, 52, item_y + 20], radius=4, fill=(227, 242, 253))
                draw.text((22, item_y + 7), "OTP", fill=(21, 101, 192), font=font_badge)
            elif is_qc:
                draw.rounded_rectangle([18, item_y + 6, 48, item_y + 20], radius=4, fill=(255, 235, 238))
                draw.text((22, item_y + 7), "QC", fill=(198, 40, 40), font=font_badge)
            else:
                draw.rounded_rectangle([18, item_y + 6, 48, item_y + 20], radius=4, fill=(240, 240, 240))
                draw.text((22, item_y + 7), "SMS", fill=(100, 100, 100), font=font_badge)

            # Sender & Time
            draw.text((60, item_y + 6), sender, fill=(28, 27, 31), font=font_subtitle)
            draw.text((W - 84, item_y + 7), time_str, fill=(130, 130, 130), font=font_small)

            # Body text (cat ngan neu dai)
            b_text = body[:48] + "..." if len(body) > 48 else body
            draw.text((18, item_y + 26), b_text, fill=(73, 69, 79), font=font_regular)

            item_y += 50

        # Neu show_dialog = True: Ve popup trich xuat OTP 6 chu so
        if show_dialog:
            # Lop overlay mo nhe
            overlay = Image.new("RGBA", (W, H), (0, 0, 0, 120))
            screen = Image.alpha_composite(screen, overlay)
            draw_dialog = ImageDraw.Draw(screen)

            # Hop thoai Dialog o giua
            dw, dh = 240, 180
            dx = (W - dw) // 2
            dy = (H - dh) // 2
            draw_dialog.rounded_rectangle([dx, dy, dx + dw, dy + dh], radius=16, fill=(255, 255, 255))

            # Icon khieng bao mat
            draw_dialog.text((dx + 18, dy + 16), "🔐  Xác thực mã OTP", fill=(21, 101, 192), font=font_subtitle)
            draw_dialog.text((dx + 18, dy + 38), "Đã trích xuất mã 6 số từ TPBank:", fill=(100, 100, 100), font=font_small)

            # Khung ma so OTP to noi bat
            draw_dialog.rounded_rectangle([dx + 18, dy + 58, dx + dw - 18, dy + 112], radius=10, fill=(237, 244, 254), outline=(144, 202, 249), width=1)
            draw_dialog.text((dx + 48, dy + 70), "8 3 9 2 0 1", fill=(21, 101, 192), font=font_otp_huge)

            # Nut Dong vien thuoc tim
            btn_w, btn_h = 90, 32
            bx = dx + (dw - btn_w) // 2
            by = dy + dh - 44
            draw_dialog.rounded_rectangle([bx, by, bx + btn_w, by + btn_h], radius=16, fill=(242, 237, 247))
            draw_dialog.text((bx + 26, by + 8), "Đóng", fill=(79, 55, 139), font=font_subtitle)

        return screen

    s1 = render_sms_screen(show_dialog=False)
    s2 = render_sms_screen(show_dialog=True)

    gap = 16
    combined = Image.new("RGBA", (W * 2 + gap, H), (255, 255, 255, 0))
    combined.paste(s1, (0, 0))
    combined.paste(s2, (W + gap, 0))
    combined.save(os.path.join(out_dir, "result_bai7_sms_analyzer.png"))
    print("Saved Bai 7:", combined.size)

create_pixel_sms_analyzer()
print("All result images created successfully!")
