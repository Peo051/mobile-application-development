import os
from pygments import highlight
from pygments.lexers import DartLexer
from pygments.formatters import HtmlFormatter
from playwright.sync_api import sync_playwright

output_dir = r"f:\Thuc Hanh\LTDD\screenshots\week6"
os.makedirs(output_dir, exist_ok=True)

files_info = [
    {
        "filename": "vscode_bai1_media_picker.png",
        "dart_file": "bai1_media_picker.dart",
        "title": "Bài tập 1: Media Picker App",
        "path": r"f:\Thuc Hanh\LTDD\code\Week6\lib\bai1_media_picker.dart",
        "start_line": 1,
        "max_lines": 55,
    },
    {
        "filename": "vscode_bai2_photo_capture.png",
        "dart_file": "bai2_photo_capture.dart",
        "title": "Bài tập 2: Photo Capture & Preview",
        "path": r"f:\Thuc Hanh\LTDD\code\Week6\lib\bai2_photo_capture.dart",
        "start_line": 1,
        "max_lines": 55,
    },
    {
        "filename": "vscode_bai3_contacts_sms.png",
        "dart_file": "bai3_contacts_sms.dart",
        "title": "Bài tập 3: Contacts Reader & SMS Reader",
        "path": r"f:\Thuc Hanh\LTDD\code\Week6\lib\bai3_contacts_sms.dart",
        "start_line": 1,
        "max_lines": 55,
    },
    {
        "filename": "vscode_bai4_video_recorder.png",
        "dart_file": "bai4_video_recorder.dart",
        "title": "Bài tập 4: Video Recorder & Playback",
        "path": r"f:\Thuc Hanh\LTDD\code\Week6\lib\bai4_video_recorder.dart",
        "start_line": 1,
        "max_lines": 55,
    },
    {
        "filename": "vscode_bai5_contact_manager.dart.png",
        "dart_file": "bai5_contact_manager.dart",
        "title": "Bài tập 5: Quản lý và thêm danh bạ",
        "path": r"f:\Thuc Hanh\LTDD\code\Week6\lib\bai5_contact_manager.dart",
        "start_line": 1,
        "max_lines": 55,
    },
    {
        "filename": "vscode_bai6_audio_player.png",
        "dart_file": "bai6_audio_player.dart",
        "title": "Bài tập 6 (Trên lớp): Simple Audio Player",
        "path": r"f:\Thuc Hanh\LTDD\code\Week6\lib\bai6_audio_player.dart",
        "start_line": 1,
        "max_lines": 55,
    },
    {
        "filename": "vscode_bai6_music_player.png",
        "dart_file": "bai6_music_player.dart",
        "title": "Bài tập 6 (Về nhà): Ứng dụng nghe nhạc",
        "path": r"f:\Thuc Hanh\LTDD\code\Week6\lib\bai6_music_player.dart",
        "start_line": 1,
        "max_lines": 55,
    },
    {
        "filename": "vscode_bai7_sms_analyzer.png",
        "dart_file": "bai7_sms_analyzer.dart",
        "title": "Bài tập 7 (Về nhà): SMS Analyzer",
        "path": r"f:\Thuc Hanh\LTDD\code\Week6\lib\bai7_sms_analyzer.dart",
        "start_line": 1,
        "max_lines": 55,
    },
]

# Chuẩn bị HTML formatter cho Pygments
formatter = HtmlFormatter(style='monokai', linenos=True, cssclass='source')
pygments_css = formatter.get_style_defs('.source')

vscode_template = """<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<style>
  * {{ box-sizing: border-box; margin: 0; padding: 0; }}
  body {{
    background: #111;
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    padding: 10px;
    display: inline-block;
  }}
  .vscode-window {{
    width: 1080px;
    background: #1e1e1e;
    color: #cccccc;
    border-radius: 8px;
    box-shadow: 0 12px 36px rgba(0,0,0,0.65);
    overflow: hidden;
    border: 1px solid #333333;
    display: flex;
    flex-direction: column;
  }}
  /* Titlebar */
  .titlebar {{
    height: 32px;
    background: #323233;
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 0 12px;
    font-size: 12px;
    color: #999999;
    user-select: none;
    border-bottom: 1px solid #252526;
  }}
  .titlebar-left {{
    display: flex;
    align-items: center;
    gap: 8px;
  }}
  .vscode-icon {{
    width: 16px;
    height: 16px;
  }}
  .menu-items {{
    display: flex;
    gap: 12px;
    margin-left: 10px;
    color: #cccccc;
    font-size: 12px;
  }}
  .titlebar-center {{
    color: #cccccc;
    font-weight: 500;
  }}
  .titlebar-right {{
    display: flex;
    gap: 14px;
    font-size: 11px;
    color: #cccccc;
  }}
  .win-controls {{
    display: flex;
    gap: 14px;
  }}
  .win-btn {{
    cursor: pointer;
    opacity: 0.8;
  }}

  /* Main Workspace */
  .workspace {{
    display: flex;
    height: 580px;
  }}

  /* Activity Bar */
  .activity-bar {{
    width: 48px;
    background: #333333;
    display: flex;
    flex-direction: column;
    justify-content: space-between;
    align-items: center;
    padding: 10px 0;
  }}
  .act-top, .act-bottom {{
    display: flex;
    flex-direction: column;
    gap: 18px;
    align-items: center;
  }}
  .act-icon {{
    width: 24px;
    height: 24px;
    display: flex;
    align-items: center;
    justify-content: center;
    color: #858585;
    cursor: pointer;
  }}
  .act-icon.active {{
    color: #ffffff;
    border-left: 2px solid #ffffff;
    padding-left: 4px;
  }}

  /* Sidebar Explorer */
  .sidebar {{
    width: 210px;
    background: #252526;
    border-right: 1px solid #1e1e1e;
    display: flex;
    flex-direction: column;
    font-size: 11.5px;
    color: #cccccc;
    user-select: none;
  }}
  .sidebar-header {{
    padding: 8px 12px;
    font-size: 11px;
    font-weight: 600;
    letter-spacing: 0.8px;
    display: flex;
    justify-content: space-between;
    color: #bbbbbb;
  }}
  .file-tree {{
    padding: 4px 0;
    line-height: 22px;
  }}
  .tree-item {{
    padding: 2px 12px;
    display: flex;
    align-items: center;
    gap: 6px;
    cursor: pointer;
  }}
  .tree-item.folder {{
    font-weight: 600;
    color: #cccccc;
  }}
  .tree-item.file {{
    padding-left: 28px;
    color: #9cdcfe;
  }}
  .tree-item.active-file {{
    background: #37373d;
    color: #ffffff;
    font-weight: 600;
  }}
  .badge-dart {{
    color: #4fc1ff;
    font-size: 10px;
    font-weight: bold;
  }}

  /* Editor Area */
  .editor-area {{
    flex: 1;
    background: #1e1e1e;
    display: flex;
    flex-direction: column;
    overflow: hidden;
  }}
  /* Tabs */
  .editor-tabs {{
    height: 35px;
    background: #252526;
    display: flex;
    align-items: center;
  }}
  .tab {{
    background: #1e1e1e;
    color: #ffffff;
    padding: 8px 16px;
    font-size: 12px;
    display: flex;
    align-items: center;
    gap: 8px;
    border-top: 2px solid #007acc;
    border-right: 1px solid #252526;
  }}
  .tab-close {{
    font-size: 13px;
    color: #999;
    margin-left: 6px;
  }}

  /* Breadcrumbs */
  .breadcrumbs {{
    height: 24px;
    background: #1e1e1e;
    padding: 4px 16px;
    font-size: 11px;
    color: #888888;
    display: flex;
    align-items: center;
    gap: 6px;
    border-bottom: 1px solid #282828;
  }}
  .breadcrumbs span {{
    color: #cccccc;
  }}

  /* Code Container */
  .code-container {{
    flex: 1;
    display: flex;
    padding: 8px 0;
    overflow: hidden;
    font-family: Consolas, 'Fira Code', 'Courier New', monospace;
    font-size: 12.5px;
    line-height: 1.5;
  }}
  .code-scroll {{
    flex: 1;
    padding: 0 14px;
    overflow-y: auto;
  }}
  .minimap {{
    width: 60px;
    background: #1e1e1e;
    border-left: 1px solid #252525;
    opacity: 0.35;
    padding: 6px 4px;
    font-size: 3px;
    line-height: 4px;
    color: #999;
    user-select: none;
    overflow: hidden;
  }}

  /* Status Bar */
  .statusbar {{
    height: 22px;
    background: #007acc;
    color: #ffffff;
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 0 10px;
    font-size: 11.5px;
  }}
  .status-left, .status-right {{
    display: flex;
    align-items: center;
    gap: 14px;
  }}

  /* Pygments custom styles */
  .linenodiv {{
    border-right: 1px solid #333333;
    padding-right: 12px;
    margin-right: 12px;
  }}
  .linenodiv pre {{
    color: #858585 !important;
  }}
  {pygments_css}
</style>
</head>
<body>
  <div class="vscode-window" id="capture-target">
    <!-- Titlebar -->
    <div class="titlebar">
      <div class="titlebar-left">
        <svg class="vscode-icon" viewBox="0 0 24 24" fill="#007acc">
          <path d="M23.15 2.587L18.21.21a1.494 1.494 0 0 0-1.705.29l-9.46 8.63-4.12-3.128a.999.999 0 0 0-1.276.057L.327 7.27a.998.998 0 0 0-.057 1.464l3.54 3.266-3.54 3.266a.998.998 0 0 0 .057 1.464l1.322 1.21a.999.999 0 0 0 1.276.057l4.12-3.128 9.46 8.63a1.492 1.492 0 0 0 1.704.29l4.94-2.377A1.5 1.5 0 0 0 24 20.06V3.939a1.5 1.5 0 0 0-.85-1.352z"/>
        </svg>
        <div class="menu-items">
          <span>File</span>
          <span>Edit</span>
          <span>Selection</span>
          <span>View</span>
          <span>Go</span>
          <span>Run</span>
          <span>Terminal</span>
          <span>Help</span>
        </div>
      </div>
      <div class="titlebar-center">
        {dart_file} - week6 - Visual Studio Code
      </div>
      <div class="titlebar-right">
        <div class="win-controls">
          <span class="win-btn">—</span>
          <span class="win-btn">▢</span>
          <span class="win-btn">✕</span>
        </div>
      </div>
    </div>

    <!-- Workspace -->
    <div class="workspace">
      <!-- Activity Bar -->
      <div class="activity-bar">
        <div class="act-top">
          <div class="act-icon active">
            <svg width="20" height="20" viewBox="0 0 24 24" fill="currentColor"><path d="M19 3H5c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2zm-7 14H6v-2h6v2zm4-4H6v-2h10v2zm0-4H6V7h10v2z"/></svg>
          </div>
          <div class="act-icon">
            <svg width="20" height="20" viewBox="0 0 24 24" fill="currentColor"><path d="M15.5 14h-.79l-.28-.27C15.41 12.59 16 11.11 16 9.5 16 5.91 13.09 3 9.5 3S3 5.91 3 9.5 5.91 16 9.5 16c1.61 0 3.09-.59 4.23-1.57l.27.28v.79l5 4.99L20.49 19l-4.99-5zm-6 0C7.01 14 5 11.99 5 9.5S7.01 5 9.5 5 14 7.01 14 9.5 11.99 14 9.5 14z"/></svg>
          </div>
          <div class="act-icon">
            <svg width="20" height="20" viewBox="0 0 24 24" fill="currentColor"><path d="M18 16.08c-.76 0-1.44.3-1.96.77L8.91 12.7c.05-.23.09-.46.09-.7s-.04-.47-.09-.7l7.05-4.11c.54.5 1.25.81 2.04.81 1.66 0 3-1.34 3-3s-1.34-3-3-3-3 1.34-3 3c0 .24.04.47.09.7L8.04 9.81C7.5 9.31 6.79 9 6 9c-1.66 0-3 1.34-3 3s1.34 3 3 3c.79 0 1.5-.31 2.04-.81l7.12 4.16c-.05.21-.08.43-.08.65 0 1.61 1.31 2.92 2.92 2.92 1.61 0 2.92-1.31 2.92-2.92s-1.31-2.92-2.92-2.92z"/></svg>
          </div>
          <div class="act-icon">
            <svg width="20" height="20" viewBox="0 0 24 24" fill="currentColor"><path d="M8 5v14l11-7z"/></svg>
          </div>
        </div>
        <div class="act-bottom">
          <div class="act-icon">
            <svg width="20" height="20" viewBox="0 0 24 24" fill="currentColor"><path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm0 3c1.66 0 3 1.34 3 3s-1.34 3-3 3-3-1.34-3-3 1.34-3 3-3zm0 14.2c-2.5 0-4.71-1.28-6-3.22.03-1.99 4-3.08 6-3.08 1.99 0 5.97 1.09 6 3.08-1.29 1.94-3.5 3.22-6 3.22z"/></svg>
          </div>
          <div class="act-icon">
            <svg width="20" height="20" viewBox="0 0 24 24" fill="currentColor"><path d="M19.14 12.94c.04-.3.06-.61.06-.94 0-.32-.02-.64-.07-.94l2.03-1.58c.18-.14.23-.41.12-.61l-1.92-3.32c-.12-.22-.37-.29-.59-.22l-2.39.96c-.5-.38-1.03-.7-1.62-.94l-.36-2.54c-.04-.24-.24-.41-.48-.41h-3.84c-.24 0-.43.17-.47.41l-.36 2.54c-.59.24-1.13.57-1.62.94l-2.39-.96c-.22-.08-.47 0-.59.22L2.74 8.87c-.12.21-.08.47.12.61l2.03 1.58c-.05.3-.09.63-.09.94s.02.64.07.94l-2.03 1.58c-.18.14-.23.41-.12.61l1.92 3.32c.12.22.37.29.59.22l2.39-.96c.5.38 1.03.7 1.62.94l.36 2.54c.05.24.24.41.48.41h3.84c.24 0 .44-.17.47-.41l.36-2.54c.59-.24 1.13-.56 1.62-.94l2.39.96c.22.08.47 0 .59-.22l1.92-3.32c.12-.22.07-.47-.12-.61l-2.01-1.58zM12 15.6c-1.98 0-3.6-1.62-3.6-3.6s1.62-3.6 3.6-3.6 3.6 1.62 3.6 3.6-1.62 3.6-3.6 3.6z"/></svg>
          </div>
        </div>
      </div>

      <!-- Sidebar -->
      <div class="sidebar">
        <div class="sidebar-header">
          <span>EXPLORER: WEEK6</span>
          <span>...</span>
        </div>
        <div class="file-tree">
          <div class="tree-item folder">⌄ WEEK6</div>
          <div class="tree-item folder" style="padding-left: 20px;">> android</div>
          <div class="tree-item folder" style="padding-left: 20px;">> assets</div>
          <div class="tree-item folder" style="padding-left: 20px;">⌄ lib</div>
          {file_tree_items}
          <div class="tree-item file" style="padding-left: 20px;">📄 pubspec.yaml</div>
        </div>
      </div>

      <!-- Editor Area -->
      <div class="editor-area">
        <!-- Tab -->
        <div class="editor-tabs">
          <div class="tab">
            <span class="badge-dart">🎯</span>
            <span>{dart_file}</span>
            <span class="tab-close">✕</span>
          </div>
        </div>

        <!-- Breadcrumbs -->
        <div class="breadcrumbs">
          week6 > lib > <span>{dart_file}</span>
        </div>

        <!-- Code Container -->
        <div class="code-container">
          <div class="code-scroll">
            {highlighted_code}
          </div>
          <div class="minimap">
            {minimap_text}
          </div>
        </div>
      </div>
    </div>

    <!-- Status Bar -->
    <div class="statusbar">
      <div class="status-left">
        <span>⎇ main*</span>
        <span>⊗ 0  ⚠ 0</span>
      </div>
      <div class="status-right">
        <span>Ln 1, Col 1</span>
        <span>Spaces: 2</span>
        <span>UTF-8</span>
        <span>Dart</span>
        <span>Flutter: 3.47.0</span>
      </div>
    </div>
  </div>
</body>
</html>
"""

with sync_playwright() as p:
    browser = p.chromium.launch()
    page = browser.new_page(device_scale_factor=2)

    for item in files_info:
        # Đọc nội dung file code thực tế
        with open(item["path"], "r", encoding="utf-8") as f:
            code_lines = f.readlines()
        
        display_code = "".join(code_lines[:item["max_lines"]])
        highlighted = highlight(display_code, DartLexer(), formatter)
        minimap_content = "<br>".join([line.strip()[:20] for line in code_lines[:50]])

        # Tạo file tree với active file tương ứng
        file_list = [
            "bai1_media_picker.dart",
            "bai2_photo_capture.dart",
            "bai3_contacts_sms.dart",
            "bai4_video_recorder.dart",
            "bai5_contact_manager.dart",
            "bai6_audio_player.dart",
            "bai6_music_player.dart",
            "bai7_sms_analyzer.dart",
            "main.dart",
        ]
        tree_html = ""
        for f in file_list:
            is_active = (f == item["dart_file"])
            cls = "tree-item active-file" if is_active else "tree-item file"
            tree_html += f'<div class="{cls}"><span class="badge-dart">🎯</span> {f}</div>\n'

        html_content = vscode_template.format(
            pygments_css=pygments_css,
            dart_file=item["dart_file"],
            file_tree_items=tree_html,
            highlighted_code=highlighted,
            minimap_text=minimap_content,
        )

        page.set_content(html_content)
        target = page.locator("#capture-target")
        out_path = os.path.join(output_dir, item["filename"].replace(".dart.png", ".png"))
        target.screenshot(path=out_path)
        print(f"Generated VS Code screenshot: {out_path}")

    browser.close()
print("All VS Code screenshots generated successfully!")
