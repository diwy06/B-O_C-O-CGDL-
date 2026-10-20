# DT011 — Sắp xếp lựa chọn và tiết kiệm đổi chỗ

Đồ án cá nhân INT13185 — Trần Hữu Duy — N24DCDT022 — D24CQDT01-N.

Mã nguồn Julia thuần (chỉ thư viện chuẩn), không dùng package ngoài.

## Yêu cầu

- Julia 1.13.1 (hoặc 1.10+)
- Windows / Linux / macOS đều chạy được

## Cấu trúc

```
.
├── bin/dt011.jl          # CLI: demo, trace, bench, check, input, version
├── src/DT011.jl          # module lõi (validator, tim min, sắp xếp, lần vết, đối chứng)
├── spec/cases.jl         # dữ liệu 14 ca kiểm thử
├── spec/runtests.jl      # bộ kiểm thử độc lập
├── bench/scales.jl       # khảo sát theo quy mô
├── evidence/logs/        # log chạy thật
├── evidence/images/      # ảnh minh chứng
├── Run_all.ps1           # chạy toàn bộ bằng một lệnh
└── README.md
```

## Lệnh chạy

```powershell
# một ca
julia --startup-file=no bin/dt011.jl demo --case VD01

# toàn bộ ca + bảng tổng hợp + ca lỗi
julia --startup-file=no bin/dt011.jl demo --all

# lần vết từng lượt
julia --startup-file=no bin/dt011.jl trace --case VD01
julia --startup-file=no bin/dt011.jl trace --input "8,3,5,1,9,2"

# khảo sát bốn quy mô
julia --startup-file=no bin/dt011.jl bench --scales 5,20,100,500 --seed 20261020

# bộ kiểm thử 14 ca
julia --startup-file=no bin/dt011.jl check

# nhập từ bàn phím
julia --startup-file=no bin/dt011.jl input
```

Hoặc chạy tất cả:

```powershell
powershell -ExecutionPolicy Bypass -File .\Run_all.ps1
```

## Hợp đồng dữ liệu

- `a::Vector{Int}`, `0 ≤ n ≤ 2000`, `|a[i]| ≤ 10^6`
- Phần tử trùng hợp lệ; mảng rỗng hợp lệ
- Ba hàm bắt buộc: `kiem_tra_dau_vao`, `tim_min_doan`, `sap_xep_lua_chon`,
  `lan_vet_lua_chon`
- Yêu cầu tùy chọn: `sap_xep_lua_chon(a; giam=true)` chọn max để sắp giảm dần

## Kết quả

- 14/14 ca PASS, 137 phép kiểm đạt (log `evidence/logs/check.log`)
- Ví dụ 1: `[8,3,5,1,9,2] → [1,2,3,5,8,9]`, 15 so sánh, 5 đổi chỗ, min `[4,6,6,6,6]`
- Ví dụ 2: `[2,1,2] → [1,2,2]`, 3 so sánh, 1 đổi chỗ, min `[2,2]`
- Đối chứng `[9,7,5,3,1]`: lựa chọn 2 đổi chỗ, đổi chỗ 10 đổi chỗ
- Khảo sát n = 5/20/100/500: số so sánh `10 / 190 / 4.950 / 124.750`, đổi chỗ lựa chọn
  `4 / 15 / 93 / 492`, đổi chỗ của đổi chỗ `6 / 111 / 2.383 / 64.815`

## Ghi chú

- Không dùng `sort` trong lõi thuật toán; `sort` chỉ dùng làm oracle trong kiểm thử.
- Sắp xếp lựa chọn không ổn định: khi trùng khóa, thứ tự tương đối có thể đổi.
- Số so sánh luôn bằng `n(n-1)/2`, không phụ thuộc dữ liệu; số đổi chỗ ≤ `n-1`.
