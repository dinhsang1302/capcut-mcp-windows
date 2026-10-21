# Phạm vi kiểm thử

Ghi nhận ngày 21 tháng 10 năm 2026 trên Windows x64 hiện có. Đây **không phải** kết quả cài trên máy Windows trắng hoặc máy ảo mới.

## Đã kiểm tra thực tế

- Cài package vào virtual environment mới bằng Python 3.12 trên máy hiện có.
- Tải riêng Python **3.13.14 x64** bằng uv vào thư mục kiểm thử, không đăng ký registry hoặc thêm PATH; tạo một bản repo thử và `.venv` mới độc lập.
- Chạy `scripts/install-windows.ps1 -PythonExe <python313> -ConfigureCodex -ConfigPath <config-thu>` trên bản thử: cài package từ mã nguồn và MCP **2.3.0**, liệt kê **35 tools**, tạo config TOML thử thành công.
- `pip check` trên môi trường Python 3.13: không có dependency bị hỏng.
- Sáu bài kiểm tra `tests/test_configure_codex.py` chạy qua trên Python 3.13: tạo config chưa có, chạy lại không đổi file, giữ nguyên MCP khác và backup byte chính xác, giữ env/tham số của CapCut, từ chối TOML hỏng, giữ BOM, từ chối header không hỗ trợ mà không ghi file (một số bài kiểm tra nhiều điều kiện).
- `scripts/verify_connection.py`: khởi chạy exe qua stdio, initialize MCP, list_tools và gọi **capcut_probe** thành công. Không gọi tool chỉnh sửa hoặc lưu.
- Probe local: CapCut **9.6.0.4097**, draft plaintext đọc được, FFmpeg **9.0.1**, không có warning tại thời điểm chạy. Đây chỉ là tình trạng máy kiểm thử, không đảm bảo phiên bản khác tương thích.
- Mã Python gốc trong `src/` và ba script kiểm tra gốc giữ nguyên theo snapshot; checksum ở SOURCE_PROVENANCE.json.
- Word được render bằng Word có sẵn; kiểm tra trực quan đủ **8 trang**. PDF/ảnh QA không đưa vào repo.

## Chưa kiểm thử trên máy trắng

- Cài mới Windows, Python Install Manager, Git, FFmpeg, Codex và CapCut bằng giao diện từ đầu.
- Nhánh tự tìm Python qua `py -3.13` trên máy mới: lần thử dùng `-PythonExe` để không đổi cấu hình hệ thống của máy hiện có.
- Windows ARM64, tài khoản Windows khác, quyền doanh nghiệp, proxy hoặc cài hoàn toàn offline.
- Tương thích mọi phiên bản/schema CapCut; hiệu ứng/transition riêng và xuất video cuối qua CapCut.

README và Word có quy trình tải/cài các phần mềm còn thiếu từ nguồn chính thức. Người dùng/agent cần thực hiện các bước đó trên từng máy, hoàn tất giao diện/đăng nhập khi được yêu cầu, rồi probe lại. Không coi pip thành công là hoàn tất toàn bộ môi trường.

## Chạy lại kiểm tra

Từ thư mục repo sau khi cài `.venv`:

```powershell
& '.\.venv\Scripts\python.exe' -m unittest discover -s tests -v
& '.\.venv\Scripts\python.exe' -m pip check
& '.\.venv\Scripts\python.exe' scripts/verify_connection.py
```

Lệnh cuối gọi probe chỉ đọc. Kết quả local có thể chứa đường dẫn/tên project: không commit log hoặc config cá nhân. Các bài test cấu hình chỉ làm việc trong thư mục tạm và không dùng config thật.
