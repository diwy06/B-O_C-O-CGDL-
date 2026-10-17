# DT011 — Sắp xếp lựa chọn và tiết kiệm đổi chỗ

Báo cáo đồ án học phần **INT13185 — Cấu trúc dữ liệu và giải thuật, Nhóm 03**.

- **Họ tên, MSSV, lớp:** Trần Hữu Duy — N24DCDT022 — D24CQDT01-N.
- **Mã đề / tên đề:** DT011 — Sắp xếp lựa chọn và tiết kiệm đổi chỗ.
- **Giáo trình:** *Cấu trúc dữ liệu và Giải thuật* INT1306, Chương 2, Mục 2.2.2;
  bảng 2.2; mục 2.8 bài 3, 11, 19; trang in 35–37, 60–61; trang PDF 47–49, 72–73.
- **Ngôn ngữ:** Julia (được kiểm với **Julia 1.13.1**, chỉ dùng thư viện chuẩn).

## Bắt đầu

Từ thư mục mã, chạy trong PowerShell:

```powershell
.\Run_all.ps1
```

Nếu `julia.exe` chưa có trên PATH, truyền đường dẫn:

```powershell
.\Run_all.ps1 -Julia 'DUONG_DAN_DEN_JULIA_EXE'
```

`Run_all.ps1` chạy lần lượt các lệnh dưới và dừng ngay khi một lệnh trả mã lỗi.
Không cần CSV, Excel, mạng hay tệp dữ liệu ngoài.

```powershell
julia --startup-file=no demo.jl            # chạy toàn bộ 8 ca + so sánh đổi chỗ
julia --startup-file=no demo.jl --ca=1     # chạy riêng ca 1..8
julia --startup-file=no demo.jl --so-sanh  # chỉ in so sánh lựa chọn vs đổi chỗ
julia --startup-file=no demo.jl --nhap     # nhập dữ liệu từ bàn phím
julia --startup-file=no test/runtests.jl
julia --startup-file=no scripts/test_catalog.jl
julia --startup-file=no scripts/trace_and_scales.jl
```

## Hợp đồng bài toán

- **Đầu vào:** `a::Vector{Int}`, `0 ≤ n ≤ 2000`, `|a[i]| ≤ 10^6`; phần tử trùng hợp lệ.
  Nhập bàn phím hoặc khai báo trực tiếp; không đọc tệp dữ liệu ngoài.
- **Đầu ra:** mảng tăng dần, số phép **so sánh**, số phép **hoán đổi thực sự** và
  vị trí min được chọn ở mỗi lượt.
- Mỗi lượt `i` quét đoạn `a[i:n]` tìm min rồi **chỉ đổi khi `min_index != i`**,
  nên không tính phép đổi một ô với chính nó.
- Luôn `n(n-1)/2` phép so sánh; số đổi chỗ không quá `n-1`; bộ nhớ phụ O(1).

## Các phần đã giải

| Tệp | Vai trò |
|---|---|
| `src/DeTai.jl` | `kiem_tra_dau_vao`, `tim_min_doan`, `sap_xep_lua_chon`, `lan_vet_lua_chon`, `sap_xep_doi_cho` |
| `demo.jl` | 8 ca minh hoạ A01–A08 + so sánh với sắp xếp đổi chỗ + nhập bàn phím |
| `test/runtests.jl` | 12 ca chức năng/biên + đối chiếu hàm con/bất biến + kiểm tra dữ liệu vào |
| `scripts/test_catalog.jl` | In input/expected/actual/PASS của 12 ca có mã |
| `scripts/trace_and_scales.jl` | Truy vết T01 và khảo sát n = 5, 20, 100, 500 |
| `Run_all.ps1` | Chạy toàn bộ quy trình bằng một lệnh |

## Lập luận và kiểm chứng

Sau lượt `i`, `i` phần tử đầu đã cố định đúng vị trí tăng dần; vòng lặp ngoài
chạy `n-1` lần nên dừng. Vòng trong luôn so sánh đúng `n-i` lần, cộng lại bằng
`n(n-1)/2`. Chỉ thực hiện đổi chỗ sau khi quét hết đoạn và khi `min_index != i`,
nên tối đa `n-1` phép đổi chỗ. Đây chính là điểm khác biệt với sắp xếp đổi chỗ
(mục 2.2.1): cùng `n(n-1)/2` phép so sánh nhưng đổi chỗ nhiều hơn hẳn, vì vậy
tuy cùng lớp O(n²) nhưng lựa chọn thay đổi mảng ít hơn.

## Phiên bản và chạy lại

- Commit **C** chứa mã/test/input dùng tạo kết quả; ghi SHA C đầy đủ và permalink
  hàm chính/test trong báo cáo.
- Commit **S** là phiên bản nộp cuối sau khi thêm ảnh/báo cáo; ghi SHA S trong
  `ThongTinNop.txt` nộp rời (không đưa SHA của chính S vào S).

```powershell
git init
git add README.md .gitignore src demo.jl test scripts docs
git commit -m "Hoan thanh de tai DT011 va bang chung"
git branch -M main
git remote add origin https://github.com/TEN_TAI_KHOAN/TEN_REPO.git
git push -u origin main
git rev-parse HEAD
```

Clone sạch và chạy lại:

```powershell
git clone https://github.com/TEN_TAI_KHOAN/TEN_REPO.git kiem_tra_ban_nop_N24DCDT022
cd kiem_tra_ban_nop_N24DCDT022
git rev-parse HEAD
.\Run_all.ps1
```

## Quy ước nộp Classroom

Nộp đủ bốn tệp đúng tên `N24DCDT022_DT011_TranHuuDuy_*` (Word, PDF, ZIP mã, TXT).
Repo riêng tư phải cấp quyền cho giảng viên trước hạn nộp. Không đưa token/mật
khẩu vào repo hoặc báo cáo.
