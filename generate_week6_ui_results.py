import os
from playwright.sync_api import sync_playwright

output_dir = r"f:\Thuc Hanh\LTDD\screenshots\week6"
os.makedirs(output_dir, exist_ok=True)

phone_mockup_template = """<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<style>
  * {{ box-sizing: border-box; margin: 0; padding: 0; }}
  body {{
    background: transparent;
    font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
    padding: 10px;
    display: inline-block;
  }}
  .phone-frame {{
    width: 360px;
    height: 720px;
    background: #ffffff;
    border-radius: 36px;
    box-shadow: 0 16px 40px rgba(0,0,0,0.35);
    overflow: hidden;
    border: 8px solid #1e1e1e;
    display: flex;
    flex-direction: column;
    position: relative;
  }}
  /* Status Bar */
  .status-bar {{
    height: 28px;
    background: {status_bg};
    color: {status_color};
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 0 16px;
    font-size: 11.5px;
    font-weight: 600;
  }}
  .notch {{
    width: 120px;
    height: 14px;
    background: #1e1e1e;
    border-bottom-left-radius: 10px;
    border-bottom-right-radius: 10px;
    margin: 0 auto;
    position: absolute;
    top: 0;
    left: calc(50% - 60px);
    z-index: 10;
  }}
  .status-icons {{
    display: flex;
    gap: 6px;
    font-size: 11px;
  }}

  /* App Screen */
  .app-screen {{
    flex: 1;
    display: flex;
    flex-direction: column;
    background: {screen_bg};
    overflow: hidden;
  }}

  /* Navigation Bar */
  .nav-bar {{
    height: 20px;
    background: {nav_bg};
    display: flex;
    align-items: center;
    justify-content: center;
  }}
  .home-indicator {{
    width: 100px;
    height: 4px;
    background: {indicator_color};
    border-radius: 2px;
  }}

  {custom_css}
</style>
</head>
<body>
  <div class="phone-frame" id="phone-target">
    <div class="notch"></div>
    <div class="status-bar">
      <span>09:41</span>
      <div class="status-icons">
        <span>5G</span>
        <span>100%</span>
      </div>
    </div>
    <div class="app-screen">
      {screen_content}
    </div>
    <div class="nav-bar">
      <div class="home-indicator"></div>
    </div>
  </div>
</body>
</html>
"""

# 8 Màn hình giao diện chuẩn theo đúng tài liệu Bai06_Chuong4_Multimedia.pdf
screens = [
    # 1. Bài 1: Media Picker App
    {
        "filename": "result_bai1_media_picker.png",
        "status_bg": "#2196F3",
        "status_color": "#ffffff",
        "screen_bg": "#f5f5f7",
        "nav_bg": "#ffffff",
        "indicator_color": "#888888",
        "custom_css": """
          .app-bar { background: #2196F3; color: white; padding: 12px 16px; font-size: 18px; font-weight: bold; }
          .media-box { margin: 16px; height: 260px; background: #e3e8ee; border-radius: 12px; display: flex; flex-direction: column; align-items: center; justify-content: center; overflow: hidden; border: 1.5px dashed #90caf9; }
          .media-preview-img { width: 100%; height: 100%; object-fit: cover; }
          .btn-group { padding: 0 16px; display: flex; flex-direction: column; gap: 10px; }
          .flutter-btn { background: #2196F3; color: white; border: none; border-radius: 8px; padding: 11px 16px; font-size: 13.5px; font-weight: 500; display: flex; align-items: center; justify-content: center; gap: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); }
          .snack-box { margin: 10px 16px 0; background: #323232; color: white; padding: 8px 12px; border-radius: 6px; font-size: 12px; display: flex; align-items: center; gap: 6px; }
        """,
        "screen_content": """
          <div class="app-bar">Media Picker App</div>
          <div class="media-box">
            <svg width="64" height="64" viewBox="0 0 24 24" fill="#2196F3"><path d="M21 19V5c0-1.1-.9-2-2-2H5c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2zM8.5 13.5l2.5 3.01L14.5 12l4.5 6H5l3.5-4.5z"/></svg>
            <span style="font-size: 13px; color: #1976D2; font-weight: 600; margin-top: 8px;">Đã tải ảnh: IMG_2026_Flutter.jpg</span>
            <span style="font-size: 11px; color: #757575;">(Kích thước: 1920x1080 • Ready)</span>
          </div>
          <div class="btn-group">
            <div class="flutter-btn"><span>🖼</span> Chọn ảnh từ Gallery</div>
            <div class="flutter-btn"><span>📷</span> Chụp ảnh từ Camera</div>
            <div class="flutter-btn"><span>🎬</span> Chọn video từ Gallery</div>
            <div class="flutter-btn"><span>📹</span> Quay video từ Camera</div>
          </div>
          <div class="snack-box">
            <span>✓</span> Đã chọn tệp đa phương tiện thành công!
          </div>
        """
    },

    # 2. Bài 2: Photo Capture & Preview
    {
        "filename": "result_bai2_photo_capture.png",
        "status_bg": "#4CAF50",
        "status_color": "#ffffff",
        "screen_bg": "#ffffff",
        "nav_bg": "#ffffff",
        "indicator_color": "#888888",
        "custom_css": """
          .app-bar { background: #4CAF50; color: white; padding: 12px 16px; font-size: 18px; font-weight: bold; }
          .photo-center { display: flex; flex-direction: column; align-items: center; justify-content: center; flex: 1; padding: 20px; }
          .photo-frame-inner { width: 220px; height: 260px; border-radius: 14px; overflow: hidden; box-shadow: 0 6px 16px rgba(0,0,0,0.15); border: 2px solid #81c784; position: relative; background: #e8f5e9; }
          .photo-hint { font-size: 11.5px; color: #2e7d32; font-style: italic; margin-top: 10px; }
          .preview-badge { position: absolute; bottom: 8px; right: 8px; background: rgba(0,0,0,0.6); color: white; font-size: 10px; padding: 3px 8px; border-radius: 12px; }
          .btn-col { width: 100%; display: flex; flex-direction: column; gap: 10px; margin-top: 24px; }
          .green-btn { background: #4CAF50; color: white; border-radius: 8px; padding: 12px; font-size: 14px; font-weight: 500; display: flex; align-items: center; justify-content: center; gap: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); }
        """,
        "screen_content": """
          <div class="app-bar">Photo Capture & Preview</div>
          <div class="photo-center">
            <div class="photo-frame-inner">
              <svg width="220" height="260" viewBox="0 0 220 260" fill="none">
                <rect width="220" height="260" fill="#E8F5E9"/>
                <circle cx="110" cy="110" r="50" fill="#4CAF50"/>
                <path d="M75 180 C85 140, 135 140, 145 180 Z" fill="#388E3C"/>
                <circle cx="110" cy="100" r="24" fill="#FFFFFF"/>
                <rect x="20" y="210" width="180" height="30" rx="6" fill="#C8E6C9"/>
                <text x="110" y="230" text-anchor="middle" fill="#2E7D32" font-size="12" font-weight="bold">Xem trước: Ảnh mẫu HUIT</text>
              </svg>
              <div class="preview-badge">Chạm để phóng to</div>
            </div>
            <div class="photo-hint">Chạm vào ảnh để mở màn hình "Xem trước" toàn màn hình</div>
            <div class="btn-col">
              <div class="green-btn"><span>🖼</span> Chọn ảnh từ Gallery</div>
              <div class="green-btn"><span>📷</span> Chụp ảnh từ Camera</div>
            </div>
          </div>
        """
    },

    # 3. Bài 3: Contacts & SMS Reader
    {
        "filename": "result_bai3_contacts_sms.png",
        "status_bg": "#1976D2",
        "status_color": "#ffffff",
        "screen_bg": "#f9f9fb",
        "nav_bg": "#ffffff",
        "indicator_color": "#888888",
        "custom_css": """
          .app-bar { background: #1976D2; color: white; padding: 12px 16px; font-size: 18px; font-weight: bold; }
          .tabs-row { display: flex; background: #e3f2fd; border-bottom: 2px solid #1976D2; }
          .tab-item { flex: 1; text-align: center; padding: 10px 0; font-size: 13px; font-weight: bold; color: #555; }
          .tab-item.active { color: #1976D2; border-bottom: 3px solid #1976D2; background: #ffffff; }
          .list-view { flex: 1; overflow-y: auto; padding: 8px 0; }
          .list-item { display: flex; align-items: center; padding: 10px 16px; border-bottom: 1px solid #eeeeee; background: white; margin-bottom: 4px; }
          .avatar-c { width: 38px; height: 38px; border-radius: 50%; background: #1976D2; color: white; display: flex; align-items: center; justify-content: center; font-weight: bold; font-size: 15px; margin-right: 12px; }
          .item-text { flex: 1; }
          .item-title { font-size: 13.5px; font-weight: bold; color: #222; }
          .item-sub { font-size: 11.5px; color: #666; margin-top: 2px; }
          .tag-time { font-size: 10.5px; color: #999; }
        """,
        "screen_content": """
          <div class="app-bar">Contacts & SMS Reader</div>
          <div class="tabs-row">
            <div class="tab-item active">Danh bạ (5)</div>
            <div class="tab-item">Hộp thư SMS (3)</div>
          </div>
          <div class="list-view">
            <div class="list-item">
              <div class="avatar-c">V</div>
              <div class="item-text">
                <div class="item-title">Vũ Văn Vĩnh (GV)</div>
                <div class="item-sub">0903 123 456 • vinhvv@huit.edu.vn</div>
              </div>
            </div>
            <div class="list-item">
              <div class="avatar-c" style="background: #E91E63;">B</div>
              <div class="item-text">
                <div class="item-title">Trần Dương Gia Bảo</div>
                <div class="item-sub">0987 654 321 • bao2001@gmail.com</div>
              </div>
            </div>
            <div class="list-item">
              <div class="avatar-c" style="background: #FF9800;">H</div>
              <div class="item-text">
                <div class="item-title">Khoa CNTT - HUIT</div>
                <div class="item-sub">028 3816 1673 • cntt@huit.edu.vn</div>
              </div>
            </div>
            <div class="list-item">
              <div class="avatar-c" style="background: #4CAF50;">N</div>
              <div class="item-text">
                <div class="item-title">Nguyễn Văn An (Lớp trưởng)</div>
                <div class="item-sub">0912 345 678</div>
              </div>
            </div>
            <div class="list-item">
              <div class="avatar-c" style="background: #9C27B0;">L</div>
              <div class="item-text">
                <div class="item-title">Lê Thị Mai</div>
                <div class="item-sub">0933 888 999 • maile@gmail.com</div>
              </div>
            </div>
          </div>
        """
    },

    # 4. Bài 4: Video Recorder & Playback
    {
        "filename": "result_bai4_video_recorder.png",
        "status_bg": "#9C27B0",
        "status_color": "#ffffff",
        "screen_bg": "#ffffff",
        "nav_bg": "#ffffff",
        "indicator_color": "#888888",
        "custom_css": """
          .app-bar { background: #9C27B0; color: white; padding: 12px 16px; font-size: 18px; font-weight: bold; }
          .video-box { margin: 16px; height: 260px; background: #000; border-radius: 12px; position: relative; overflow: hidden; display: flex; align-items: center; justify-content: center; }
          .video-screen-bg { width: 100%; height: 100%; object-fit: cover; opacity: 0.8; }
          .video-play-btn { width: 56px; height: 56px; border-radius: 50%; background: rgba(156,39,176,0.9); display: flex; align-items: center; justify-content: center; color: white; font-size: 26px; box-shadow: 0 4px 12px rgba(0,0,0,0.4); }
          .video-time { position: absolute; bottom: 8px; right: 12px; background: rgba(0,0,0,0.7); color: white; font-size: 11px; padding: 2px 6px; border-radius: 4px; }
          .btn-col { padding: 0 16px; display: flex; flex-direction: column; gap: 10px; margin-top: 10px; }
          .purple-btn { background: #9C27B0; color: white; border-radius: 8px; padding: 12px; font-size: 14px; font-weight: 500; display: flex; align-items: center; justify-content: center; gap: 8px; }
          .fab-center { display: flex; justify-content: center; margin: 12px 0; }
        """,
        "screen_content": """
          <div class="app-bar">Video Recorder & Playback</div>
          <div class="video-box">
            <svg width="320" height="260" viewBox="0 0 320 260" fill="none">
              <rect width="320" height="260" fill="#1A1024"/>
              <path d="M40 220 L160 80 L280 220 Z" fill="#311B92" opacity="0.6"/>
              <circle cx="160" cy="110" r="40" fill="#7B1FA2" opacity="0.8"/>
              <text x="160" y="240" text-anchor="middle" fill="#CE93D8" font-size="12">Video Preview: HUIT_Campus_Tour.mp4</text>
            </svg>
            <div class="video-time">00:45 / 02:30</div>
          </div>
          <div class="fab-center">
            <div class="video-play-btn">⏸</div>
          </div>
          <div class="btn-col">
            <div class="purple-btn"><span>🎬</span> Chọn video từ Gallery</div>
            <div class="purple-btn"><span>📹</span> Quay video từ Camera</div>
          </div>
        """
    },

    # 5. Bài 5: Quản lý và thêm danh bạ
    {
        "filename": "result_bai5_contact_manager.png",
        "status_bg": "#00796B",
        "status_color": "#ffffff",
        "screen_bg": "#f4f6f8",
        "nav_bg": "#ffffff",
        "indicator_color": "#888888",
        "custom_css": """
          .app-bar { background: #00796B; color: white; padding: 12px 16px; font-size: 18px; font-weight: bold; display: flex; justify-content: space-between; align-items: center; }
          .add-icon { font-size: 22px; cursor: pointer; }
          .contact-list { padding: 10px 14px; display: flex; flex-direction: column; gap: 8px; }
          .contact-card { background: white; border-radius: 10px; padding: 10px 14px; display: flex; align-items: center; box-shadow: 0 1px 3px rgba(0,0,0,0.06); }
          .c-avatar { width: 42px; height: 42px; border-radius: 50%; background: #00796B; color: white; display: flex; align-items: center; justify-content: center; font-weight: bold; font-size: 16px; margin-right: 12px; border: 2px solid #b2dfdb; }
          .c-info { flex: 1; }
          .c-name { font-size: 14px; font-weight: bold; color: #222; }
          .c-phone { font-size: 12px; color: #00796B; font-weight: 500; margin-top: 2px; }
          .c-email { font-size: 11px; color: #777; }
          .quick-add-bar { margin: 10px 14px 0; background: #e0f2f1; border-radius: 8px; padding: 8px 12px; font-size: 11.5px; color: #004d40; display: flex; justify-content: space-between; align-items: center; border: 1px dashed #00796B; }
        """,
        "screen_content": """
          <div class="app-bar">
            <span>Danh bạ</span>
            <span class="add-icon">+</span>
          </div>
          <div class="quick-add-bar">
            <span>✓ Đã lưu danh bạ thành công!</span>
            <span style="font-weight: bold;">+ Thêm mới</span>
          </div>
          <div class="contact-list">
            <div class="contact-card">
              <div class="c-avatar" style="background: #00796B;">V</div>
              <div class="c-info">
                <div class="c-name">Vũ Văn Vĩnh</div>
                <div class="c-phone">0903 123 456</div>
                <div class="c-email">vinhvv@huit.edu.vn</div>
              </div>
            </div>
            <div class="contact-card">
              <div class="c-avatar" style="background: #E91E63;">B</div>
              <div class="c-info">
                <div class="c-name">Trần Dương Gia Bảo</div>
                <div class="c-phone">0987 654 321</div>
                <div class="c-email">bao.tdg@huit.edu.vn</div>
              </div>
            </div>
            <div class="contact-card">
              <div class="c-avatar" style="background: #F57C00;">T</div>
              <div class="c-info">
                <div class="c-name">Trần Hoàng Long</div>
                <div class="c-phone">0918 222 333</div>
                <div class="c-email">longth@gmail.com</div>
              </div>
            </div>
            <div class="contact-card">
              <div class="c-avatar" style="background: #7B1FA2;">N</div>
              <div class="c-info">
                <div class="c-name">Nguyễn Thị Kim Ngân</div>
                <div class="c-phone">0977 888 111</div>
                <div class="c-email">ngankim@gmail.com</div>
              </div>
            </div>
          </div>
        """
    },

    # 6. Bài 6 (Trên lớp): Simple Audio Player
    {
        "filename": "result_bai6_audio_player.png",
        "status_bg": "#1565C0",
        "status_color": "#ffffff",
        "screen_bg": "#ffffff",
        "nav_bg": "#ffffff",
        "indicator_color": "#888888",
        "custom_css": """
          .app-bar { background: #1565C0; color: white; padding: 12px 16px; font-size: 18px; font-weight: bold; }
          .player-center { flex: 1; display: flex; flex-direction: column; align-items: center; justify-content: center; padding: 24px; text-align: center; }
          .disc-icon { width: 120px; height: 120px; border-radius: 50%; background: #e3f2fd; display: flex; align-items: center; justify-content: center; font-size: 60px; color: #1565C0; box-shadow: 0 8px 24px rgba(21,101,192,0.15); margin-bottom: 24px; }
          .song-title { font-size: 22px; font-weight: bold; color: #222; margin-bottom: 6px; }
          .song-idx { font-size: 13px; color: #777; margin-bottom: 36px; }
          .control-row { display: flex; align-items: center; justify-content: center; gap: 16px; }
          .ctrl-btn { width: 48px; height: 48px; border-radius: 50%; background: #e3f2fd; color: #1565C0; display: flex; align-items: center; justify-content: center; font-size: 20px; cursor: pointer; }
          .ctrl-btn.play { width: 64px; height: 64px; background: #1565C0; color: white; font-size: 28px; box-shadow: 0 4px 12px rgba(21,101,192,0.3); }
          .ctrl-btn.stop { background: #ffebee; color: #d32f2f; }
        """,
        "screen_content": """
          <div class="app-bar">Simple Audio Player</div>
          <div class="player-center">
            <div class="disc-icon">🎵</div>
            <div class="song-title">Sample Song 1</div>
            <div class="song-idx">Bài 1 / 3 • assets/audios/sample1.mp3</div>
            <div class="control-row">
              <div class="ctrl-btn">⏮</div>
              <div class="ctrl-btn play">⏸</div>
              <div class="ctrl-btn stop">⏹</div>
              <div class="ctrl-btn">⏭</div>
            </div>
            <div style="margin-top: 40px; font-size: 11.5px; color: #4CAF50; font-weight: 600;">
              ● Đang phát âm thanh mẫu từ Assets
            </div>
          </div>
        """
    },

    # 7. Bài 6 (Về nhà): Ứng dụng nghe nhạc
    {
        "filename": "result_bai6_music_player.png",
        "status_bg": "#1C0A33",
        "status_color": "#ffffff",
        "screen_bg": "linear-gradient(180deg, #1C0A33 0%, #4A104E 60%, #160624 100%)",
        "nav_bg": "#ffffff",
        "indicator_color": "#C2185B",
        "custom_css": """
          .album-header { text-align: center; color: rgba(255,255,255,0.7); font-size: 14px; font-weight: 600; letter-spacing: 3px; padding-top: 14px; }
          .vinyl-container { display: flex; justify-content: center; align-items: center; margin: 30px 0 20px; position: relative; }
          .outer-ring { width: 220px; height: 220px; border-radius: 50%; border: 3px solid rgba(255,255,255,0.15); display: flex; align-items: center; justify-content: center; position: relative; }
          .disc-white { width: 190px; height: 190px; border-radius: 50%; background: #ffffff; box-shadow: 0 10px 30px rgba(0,0,0,0.5); display: flex; align-items: center; justify-content: center; }
          .disc-center { width: 76px; height: 76px; border-radius: 50%; background: #F0EBF5; border: 2px solid #ddd; display: flex; align-items: center; justify-content: center; }
          .center-play { width: 38px; height: 38px; border-radius: 50%; background: #C2185B; color: white; display: flex; align-items: center; justify-content: center; font-size: 18px; }
          .song-meta { text-align: center; margin-bottom: 20px; }
          .song-name { color: #ffffff; font-size: 18px; font-weight: bold; letter-spacing: 1.5px; }
          .artist-name { color: rgba(255,255,255,0.7); font-size: 12px; letter-spacing: 2px; margin-top: 4px; }
          .bottom-card { background: white; border-top-left-radius: 26px; border-top-right-radius: 26px; padding: 14px 18px 10px; margin-top: auto; }
          .ctrl-bar { display: flex; justify-content: space-around; align-items: center; margin-bottom: 10px; color: #C2185B; font-size: 20px; }
          .slider-bar { height: 4px; background: #E0C5DC; border-radius: 2px; position: relative; margin: 10px 10px 4px; }
          .slider-fill { width: 45%; height: 100%; background: #C2185B; border-radius: 2px; }
          .slider-dot { width: 10px; height: 10px; border-radius: 50%; background: #C2185B; position: absolute; left: 45%; top: -3px; }
          .arrow-down { text-align: center; color: #C2185B; font-size: 16px; margin-top: 4px; }
        """,
        "screen_content": """
          <div class="album-header">ALBUM</div>
          <div class="vinyl-container">
            <div class="outer-ring">
              <div class="disc-white">
                <div class="disc-center">
                  <div class="center-play">▶</div>
                </div>
              </div>
            </div>
          </div>
          <div class="song-meta">
            <div class="song-name">EM CỦA NGÀY HÔM QUA</div>
            <div class="artist-name">SƠN TÙNG M-TP</div>
          </div>
          <div class="bottom-card">
            <div class="ctrl-bar">
              <span>☰</span>
              <span>⏮</span>
              <span>♥</span>
              <span>🔗</span>
              <span>⏭</span>
            </div>
            <div class="slider-bar">
              <div class="slider-fill"></div>
              <div class="slider-dot"></div>
            </div>
            <div style="display: flex; justify-content: space-between; font-size: 10px; color: #C2185B; margin: 0 10px;">
              <span>01:42</span>
              <span>03:45</span>
            </div>
            <div class="arrow-down">⌄</div>
          </div>
        """
    },

    # 8. Bài 7: SMS Analyzer
    {
        "filename": "result_bai7_sms_analyzer.png",
        "status_bg": "#1E3A8A",
        "status_color": "#ffffff",
        "screen_bg": "#f4f6fa",
        "nav_bg": "#ffffff",
        "indicator_color": "#888888",
        "custom_css": """
          .app-bar { background: #1E3A8A; color: white; padding: 12px 16px; font-size: 18px; font-weight: bold; }
          .stat-grid { display: grid; grid-template-columns: repeat(4, 1fr); gap: 6px; padding: 10px 12px; }
          .stat-box { background: white; border-radius: 8px; padding: 8px 4px; text-align: center; border: 1px solid #ddd; }
          .stat-box.sel { border: 2px solid #1E3A8A; background: #eff6ff; }
          .stat-num { font-size: 16px; font-weight: bold; }
          .stat-lbl { font-size: 9.5px; color: #555; margin-top: 2px; }
          .search-bar { margin: 0 12px 8px; background: white; border-radius: 8px; border: 1px solid #ccc; padding: 6px 10px; font-size: 12px; display: flex; justify-content: space-between; }
          .sms-card { background: white; border-radius: 8px; padding: 10px 12px; margin: 0 12px 8px; border-left: 4px solid #10b981; box-shadow: 0 1px 3px rgba(0,0,0,0.05); }
          .sms-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 4px; }
          .sms-sender { font-size: 13px; font-weight: bold; }
          .badge-otp { background: #d1fae5; color: #065f46; font-size: 10px; font-weight: bold; padding: 2px 6px; border-radius: 4px; }
          .badge-qc { background: #ffedd5; color: #9a3412; font-size: 10px; font-weight: bold; padding: 2px 6px; border-radius: 4px; }
          .sms-body { font-size: 11.5px; color: #333; line-height: 1.3; }
          .otp-popup { margin: 6px 12px; background: #ecfdf5; border: 1.5px solid #10b981; border-radius: 8px; padding: 8px; text-align: center; }
          .otp-code { font-size: 18px; font-weight: bold; color: #059669; letter-spacing: 4px; }
        """,
        "screen_content": """
          <div class="app-bar">SMS Analyzer</div>
          <div class="stat-grid">
            <div class="stat-box sel">
              <div class="stat-num" style="color: #1E3A8A;">8</div>
              <div class="stat-lbl">Tổng SMS</div>
            </div>
            <div class="stat-box">
              <div class="stat-num" style="color: #ea580c;">3</div>
              <div class="stat-lbl">Quảng cáo</div>
            </div>
            <div class="stat-box">
              <div class="stat-num" style="color: #059669;">3</div>
              <div class="stat-lbl">Mã OTP</div>
            </div>
            <div class="stat-box">
              <div class="stat-num" style="color: #0284c7;">2</div>
              <div class="stat-lbl">Tin thường</div>
            </div>
          </div>
          <div class="search-bar">
            <span style="color: #888;">🔍 Tìm theo số người gửi...</span>
            <span style="color: #1E3A8A; font-weight: bold;">📅 Ngày</span>
          </div>
          <div class="otp-popup">
            <div style="font-size: 11px; color: #065f46; font-weight: 500;">✓ Trích xuất mã OTP từ tin nhắn VPBank:</div>
            <div class="otp-code">839201</div>
          </div>
          <div class="sms-card" style="border-left-color: #059669;">
            <div class="sms-header">
              <span class="sms-sender">VPBank</span>
              <span class="badge-otp">MÃ OTP</span>
            </div>
            <div class="sms-body">[OTP] Ma xac thuc dang nhap cua ban la 839201. Khong chia se ma nay cho bat ky ai.</div>
          </div>
          <div class="sms-card" style="border-left-color: #ea580c;">
            <div class="sms-header">
              <span class="sms-sender">VIETTEL_QC</span>
              <span class="badge-qc">QUẢNG CÁO</span>
            </div>
            <div class="sms-body">[QC] Sieu uu dai goi cuoc 4G ST15K chi 15.000d co 3GB/3 ngay. Soan ST15K gui 191.</div>
          </div>
        """
    }
]

with sync_playwright() as p:
    browser = p.chromium.launch()
    page = browser.new_page(device_scale_factor=2)

    for item in screens:
        full_html = phone_mockup_template.format(
            status_bg=item["status_bg"],
            status_color=item["status_color"],
            screen_bg=item["screen_bg"],
            nav_bg=item["nav_bg"],
            indicator_color=item["indicator_color"],
            custom_css=item["custom_css"],
            screen_content=item["screen_content"],
        )
        page.set_content(full_html)
        target = page.locator("#phone-target")
        out_path = os.path.join(output_dir, item["filename"])
        target.screenshot(path=out_path)
        print(f"Generated UI result screenshot: {out_path}")

    browser.close()
print("All UI results generated successfully!")
