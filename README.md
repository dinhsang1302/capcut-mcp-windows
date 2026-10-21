# CapCut MCP cho máy Windows mới

Bản lưu mã nguồn CapCut MCP kèm hướng dẫn tiếng Việt để cài trên máy khác từ đầu. Có thể clone hoặc tải ZIP từ repo này; không cần lấy mã nguồn lại từ repo tác giả.

**Repo:** https://github.com/kinika1302-sys/capcut-mcp-windows

**File Word:** [Hướng dẫn cài máy Windows mới](docs/Huong_dan_CapCut_MCP_may_Windows_moi.docx)

**Mã nguồn gốc và giới hạn:** [UPSTREAM_README.md](docs/UPSTREAM_README.md)

**Kết quả kiểm thử có phạm vi rõ ràng:** [VALIDATION.md](docs/VALIDATION.md)

Đây là công cụ bên thứ ba, không phải sản phẩm chính thức của CapCut/OpenAI. Giấy phép MIT và copyright của tác giả gốc được giữ nguyên trong [LICENSE](LICENSE). Các file `src/capcut_mcp/` được sao từ bộ đã lưu local; hướng dẫn, constraints và script cài đặt được bổ sung riêng.

## 1 Cần chuẩn bị gì

- Máy Windows có kết nối Internet; chọn bộ cài đúng kiến trúc x64/ARM64. Quy trình thực tế được kiểm tra đến đâu xem VALIDATION.md; không giả định mọi kiến trúc đều đã được thử.
- Quyền cài ứng dụng theo chính sách máy. Không tắt antivirus, thay quyền Windows hoặc đổi Execution Policy.
- Một video mẫu trên máy để tạo project `MCP_SETUP_TEST`. Không dùng project quan trọng cho bước thử cài.
- Các khối lệnh chạy trong **PowerShell**, không phải CMD. Bấm Start → gõ PowerShell → mở. Dán từng khối, dừng khi có lỗi.

`--version`/`-version` là lệnh kiểm tra, không phải lệnh cài. Nếu máy chưa có gì, làm bước 2–5 trước. Hướng dẫn không yêu cầu ổ D hoặc tên tài khoản ADMIN.

## 2 Cài Python từ đầu

1. Mở [trang Python](https://www.python.org/downloads/), cài **Python Install Manager** cho Windows từ nguồn chính thức/Microsoft Store được trang này liên kết.
2. Đóng PowerShell cũ, mở cửa sổ mới rồi chạy:

```powershell
py install 3.13
py -3.13 --version
py -3.13 -m pip --version
```

Phải thấy Python 3.13.x và thông tin pip. `py -3.13` giúp chọn đúng phiên bản, không phụ thuộc lệnh `python` mặc định. Nếu không nhận `py`, kiểm tra lại cài đặt và mở terminal mới; xem [troubleshooting chính thức](https://docs.python.org/3/using/windows.html#troubleshooting). Không dùng Python embeddable. Với bộ cài EXE truyền thống, bật Add Python to PATH và Python Launcher nếu có tùy chọn; không cần cài hai phương án chồng nhau.

## 3 Cài Git từ đầu

1. Mở [Git cho Windows](https://git-scm.com/install/windows), tải và chạy trình cài đúng kiến trúc máy.
2. Cho phép dùng Git từ command line/third-party software khi trình cài hỏi về PATH.
3. Mở PowerShell mới và chạy:

```powershell
git --version
```

Không cần khai báo tên/email Git để clone. Nếu máy đã có WinGet, trang Git cũng hướng dẫn `winget install --id Git.Git -e --source winget`; không bắt buộc WinGet cho quy trình này.

## 4 Cài FFmpeg và FFprobe

1. Mở [FFmpeg Download](https://ffmpeg.org/download.html) → Windows EXE Files → chọn nhà cung cấp build được liên kết ở đó. Trang FFmpeg cung cấp mã nguồn và liên kết đến các bản Windows đóng gói bởi bên khác.
2. Tải ZIP đúng kiến trúc có **cả** `ffmpeg.exe` và `ffprobe.exe` (không tải archive source code).
3. Trong File Explorer nhập `%USERPROFILE%` vào thanh địa chỉ, tạo `Tools\ffmpeg`. Giải nén và sắp xếp để có:

```text
%USERPROFILE%\Tools\ffmpeg\bin\ffmpeg.exe
%USERPROFILE%\Tools\ffmpeg\bin\ffprobe.exe
```

4. Start → **Edit environment variables for your account** → User variables → Path → Edit → New. Thêm đường dẫn **thực** đến thư mục `bin`, ví dụ `C:\Users\Lan\Tools\ffmpeg\bin`. Không xóa các mục cũ, không thêm riêng tên file exe. Nếu chưa có User Path, tạo biến Path cho tài khoản.
5. Đóng rồi mở lại PowerShell và Codex để nạp PATH. Kiểm tra:

```powershell
ffmpeg -version
ffprobe -version
git --version
py -3.13 --version
```

Cả bốn lệnh phải chạy được. FFprobe đi cùng bộ FFmpeg, không cần một bộ cài riêng.

## 5 Cài Codex và CapCut

- **Codex:** theo [hướng dẫn ứng dụng Windows của OpenAI](https://learn.chatgpt.com/docs/windows/windows-app), cài ứng dụng hiện hành có Codex, đăng nhập tài khoản có quyền sử dụng và chọn thư mục làm việc local. Không cần cài Node.js/Codex CLI chỉ để khai báo MCP trong ứng dụng.
- **CapCut Desktop:** tải từ [CapCut chính thức](https://www.capcut.com/tools/desktop-video-editor). Mở ứng dụng, tạo `MCP_SETUP_TEST`, nhập video mẫu và kéo lên timeline. Chờ lưu, quay về danh sách project rồi đóng CapCut.

Cài CapCut thành công chưa chứng minh draft tương thích. Bước `capcut_probe` sẽ kiểm tra JSON thực tế; nếu draft bị mã hóa hoặc schema không đọc được, dừng chỉnh sửa và báo lỗi.

## 6 Tải repo này

Sau khi Git chạy được:

```powershell
$repo = Join-Path $env:USERPROFILE 'capcut-mcp-windows'
git clone https://github.com/kinika1302-sys/capcut-mcp-windows.git $repo
Set-Location $repo
```

Nếu thư mục đích đã tồn tại, không clone đè: kiểm tra xem đó có đúng repo không. Cách không cần Git: **Code → Download ZIP**, giải nén vào vị trí cố định rồi mở PowerShell trong thư mục có `pyproject.toml`. Không chuyển repo sau khi tạo `.venv`; nếu chuyển, tạo môi trường mới và cập nhật command.

## 7 Cài package và cấu hình MCP

Đọc script trước khi chạy. Script chỉ tạo `.venv` local, cài package, kiểm tra tools và (khi truyền `-ConfigureCodex`) thêm/sửa command CapCut. Nó không tự cài ứng dụng hệ thống, không sửa PATH, không đọc/sửa timeline.

```powershell
.\scripts\install-windows.ps1 -ConfigureCodex
```

Script sẽ backup `config.toml` trước khi sửa, giữ cấu hình MCP khác và kiểm tra TOML. Nếu file chưa có sẽ tạo mới. Chạy lại khi command đã đúng không tạo thêm backup không cần thiết. Nếu section hiện tại có cú pháp phức tạp mà script không xử lý chắc chắn, nó dừng để chỉnh tay.

Nếu Windows chặn script tải về, **không đổi Execution Policy**. Chạy các lệnh riêng dưới đây từ thư mục repo:

```powershell
py -3.13 -m venv .venv
& '.\.venv\Scripts\python.exe' -m pip install -e . -c constraints.txt
& '.\.venv\Scripts\python.exe' scripts/verify_tools.py
& '.\.venv\Scripts\python.exe' scripts/configure_codex.py --exe "$PWD\.venv\Scripts\capcut-mcp.exe"
```

Khi `.venv` đã tồn tại và hoạt động, không cần chạy lại bước tạo. Lệnh dùng exe trực tiếp nên không cần `Activate.ps1`. `constraints.txt` ghim MCP 2.3.0 từng có trong môi trường local; dependency gián tiếp/build backend chưa được khóa toàn bộ. Cài lần đầu vẫn cần Internet/PyPI, không phải bộ cài offline.

Kiểm tra cài đặt CapCut (chỉ đọc):

```powershell
& '.\.venv\Scripts\python.exe' scripts/verify_setup.py
```

Để kiểm tra trực tiếp handshake stdio và chỉ gọi probe, có thể chạy thêm:

```powershell
& '.\.venv\Scripts\python.exe' scripts/verify_connection.py
```

Nếu thiếu CapCut/project hoặc kho draft chưa tìm được, làm lại bước 5 hoặc bước 9; không kết luận cài xong hoàn toàn chỉ vì pip thành công.

## 8 Kiểm tra cấu hình và kết nối

File mặc định: `%USERPROFILE%\.codex\config.toml`. Ví dụ với tài khoản Lan:

```toml
[mcp_servers.capcut]
command = "C:/Users/Lan/capcut-mcp-windows/.venv/Scripts/capcut-mcp.exe"
```

Đây chỉ là ví dụ. Không ghi nguyên `Lan` hoặc `%USERPROFILE%` vào command. Script tự lấy đường dẫn thực của máy. Không thêm trùng `[mcp_servers.capcut]`, không thay nguyên config bằng file mẫu.

Thoát hẳn rồi mở lại Codex, gửi:

```text
Dùng CapCut MCP. Chỉ chạy capcut_probe.
Không chỉnh sửa hoặc lưu project nào.
```

Kiểm tra `capcut_version`, `draft_root`, `plaintext_drafts: true`, `ffmpeg`, và `warnings`. `running_pids: []` nghĩa là không phát hiện CapCut đang chạy. Nếu chưa có draft mẫu, giá trị plaintext có thể chưa xác định: tạo project thử rồi kiểm tra lại. Kiểm tra này không sửa nội dung project.

## 9 Nếu kho draft ở vị trí khác

Tìm thư mục thật chứa `root_meta_info.json` và các thư mục project. Backup config trước khi chỉnh tay, thêm (thay đường dẫn theo máy):

```toml
[mcp_servers.capcut.env]
CAPCUT_MCP_DRAFT_ROOT = "C:/Users/Lan/AppData/Local/CapCut/User Data/Projects/com.lveditor.draft"
```

Mở lại Codex và probe. Source trên NAS phải đọc được bằng tài khoản Windows hiện tại; không tự đổi quyền hoặc giả định video đã nằm local.

## 10 Prompt dùng trên máy khác

Dán URL repo kèm prompt sau vào agent có terminal local. Cài ứng dụng có thể cần người dùng hoàn tất giao diện/đăng nhập; agent phải báo rõ thay vì tự nói đã xong.

```text
Hãy cài CapCut MCP từ https://github.com/kinika1302-sys/capcut-mcp-windows
trên máy Windows này. Đọc README.md và AGENTS.md trước.
Kiểm tra máy đang có gì; hướng dẫn/cài Python 3.13, Git, FFmpeg và FFprobe
còn thiếu theo nguồn chính thức trong README. Cài Codex/CapCut nếu thiếu;
báo tôi thao tác các bước đăng nhập hoặc giao diện cần người dùng.
Clone repo, tạo .venv, cài dependency và cấu hình MCP bằng script trong repo.
Backup config trước khi sửa, giữ các MCP khác, kiểm tra cú pháp TOML.
Không thay quyền Windows, tắt bảo mật, đổi Execution Policy hoặc dùng force save.
Không chỉnh/sửa/lưu bất kỳ project thật nào trong bước cài đặt.
Sau khi mở lại Codex, chạy capcut_probe và báo kết quả thực tế cùng lỗi còn lại.
```

Thử chữ rồi hủy sau khi đã kết nối thành công:

```text
Trong MCP_SETUP_TEST, thêm MCP TEST từ 0 đến 2 giây.
Render frame giây 1, kiểm tra chữ rồi capcut_discard.
Không lưu project.
```

## 11 Lưu project và giới hạn

- Chỉ lưu khi người dùng yêu cầu; đóng CapCut trước, không dùng force save. Mọi thao tác sửa phải được kiểm tra trước khi lưu.
- `capcut_discard` bỏ chỉnh sửa chưa lưu. `capcut_save` tạo backup trong `.mcp_backups` rồi ghi project; giữ tối đa 40 bản theo mã nguồn. `capcut_revert` là thao tác khôi phục có ghi ổ đĩa.
- Proxy FFmpeg không tái hiện đầy đủ hiệu ứng/transition/filter riêng. Mở CapCut kiểm tra cuối và xuất video trong CapCut.
- Không commit project, source video, `.venv`, config, token hoặc cache. Repo không kèm các dữ liệu này.

## 12 Xử lý lỗi

| Lỗi | Cách xử lý |
|---|---|
| `py`, `git` không nhận | Kiểm tra đã cài đúng, mở terminal mới, xem hướng dẫn chính thức. |
| `ffmpeg`, `ffprobe` không nhận | Kiểm tra hai exe và thư mục bin trong User Path; mở lại Codex. |
| pip lỗi | Giữ nguyên log, kiểm tra Internet/Python 3.13 và đang ở thư mục có pyproject.toml. Không tiếp tục nếu dependency chưa cài xong. |
| Không thấy CapCut tools | Kiểm tra command exe tồn tại, TOML hợp lệ, config đúng tài khoản; restart Codex. |
| Config cú pháp phức tạp | Script dừng an toàn; backup rồi sửa đúng command trong section CapCut bằng tay. |
| CapCut đang mở | Đóng ứng dụng bình thường; không ép lưu hoặc tự kill process. |
| Draft không đọc được | Dừng chỉnh sửa, báo phiên bản và lỗi; không tự suy diễn schema. |

Nguồn cài đặt: [Python](https://docs.python.org/3/using/windows.html), [Git](https://git-scm.com/install/windows), [FFmpeg](https://ffmpeg.org/download.html), [OpenAI MCP](https://learn.chatgpt.com/docs/extend/mcp?surface=cli), [CapCut](https://www.capcut.com/tools/desktop-video-editor). Không cần API trả phí để chạy server local; việc dùng Codex tuân theo tài khoản/gói đang có.
