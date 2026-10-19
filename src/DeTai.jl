module DeTai

export kiem_tra_dau_vao, tim_min_doan, sap_xep_lua_chon, lan_vet_lua_chon, sap_xep_doi_cho

"""
    kiem_tra_dau_vao(a)

Kiểm tra hợp đồng dữ liệu vào của phiếu DT011:
  - `a` phải là `Vector{Int}`;
  - `0 ≤ n ≤ 2000` với `n = length(a)`;
  - `|a[i]| ≤ 10^6` với mọi phần tử.

Trả `true` khi hợp lệ; ném `ArgumentError` kèm lý do khi vi phạm.
Phần tử trùng nhau là hợp lệ; mảng rỗng `Int[]` là hợp lệ (n = 0).
"""
function kiem_tra_dau_vao(a)
    a isa Vector{Int} || throw(ArgumentError("du lieu vao phai la Vector{Int}"))
    n = length(a)
    n <= 2000 || throw(ArgumentError("n = $n vuot gioi han 2000"))
    for (k, x) in enumerate(a)
        abs(x) <= 10^6 || throw(ArgumentError("|a[$k]| = $(abs(x)) vuot gioi han 10^6"))
    end
    return true
end

"""
    tim_min_doan(a, l, r)

Trả chỉ số (1-based) của phần tử nhỏ nhất trong đoạn `a[l:r]`.
Khi có nhiều phần tử cùng nhỏ nhất, giữ chỉ số đầu tiên (chỉ cập nhật khi
gặp giá trị nhỏ hơn hẳn). Lưu ý: việc giữ chỉ số đầu tiên KHÔNG làm thuật
toán sắp xếp ổn định — xem ghi chú ở `sap_xep_lua_chon`.
Đoạn `l == r` trả chính `l`.
"""
function tim_min_doan(a, l::Integer, r::Integer)
    l <= r || throw(ArgumentError("doan rong: l=$l > r=$r"))
    min_idx = l
    for j in (l + 1):r
        if a[j] < a[min_idx]
            min_idx = j
        end
    end
    return min_idx
end

"""
    sap_xep_lua_chon(a)

Sắp xếp lựa chọn (selection sort) theo phiếu DT011. Trả về `NamedTuple`:
  - `mang`      : bản sao đã sắp tăng dần;
  - `so_sanh`   : số phép so sánh thực đếm trong vòng lặp (= n(n-1)/2);
  - `so_doi`    : số phép hoán đổi thực sự (không quá n-1);
  - `cac_min`   : vị trí min được chọn ở mỗi lượt (độ dài n-1).

Hàm tự kiểm tra đầu vào bằng `kiem_tra_dau_vao`. Mỗi lượt i quét đoạn a[i:n]
bằng một vòng lặp đếm so sánh thật, rồi chỉ đổi khi `min_idx != i`.

Cảnh báo: sắp xếp lựa chọn KHÔNG ổn định. Ví dụ [(2,'a'),(2,'b'),(1,'c')]
cho [(1,'c'),(2,'b'),(2,'a')] — hai phần tử khóa 2 bị đảo thứ tự tương đối.
"""
function sap_xep_lua_chon(a)
    kiem_tra_dau_vao(a)
    b = copy(a)
    n = length(b)
    so_sanh = 0
    so_doi = 0
    cac_min = Int[]
    for i in 1:(n - 1)
        min_idx = i
        for j in (i + 1):n
            so_sanh += 1
            if b[j] < b[min_idx]
                min_idx = j
            end
        end
        push!(cac_min, min_idx)
        if min_idx != i
            b[i], b[min_idx] = b[min_idx], b[i]
            so_doi += 1
        end
    end
    return (; mang=b, so_sanh, so_doi, cac_min)
end

"""
    lan_vet_lua_chon(a; io=stdout)

In từng lượt sắp xếp lựa chọn theo bảng 2.2: trước mỗi lượt ghi đoạn chưa
sắp, vị trí min tìm được, có đổi chỗ hay không và mảng sau lượt.
Trả về cùng `NamedTuple` với `sap_xep_lua_chon`.
"""
function lan_vet_lua_chon(a; io=stdout)
    kiem_tra_dau_vao(a)
    b = copy(a)
    n = length(b)
    println(io, "Lan vet sap xep lua chon, n = $n")
    println(io, "Mang dau: ", a)
    for i in 1:(n - 1)
        min_idx = tim_min_doan(b, i, n)
        doicho = min_idx != i
        if doicho
            b[i], b[min_idx] = b[min_idx], b[i]
        end
        println(io, "Luot $i: doan [$i..$n] min tai $min_idx",
                doicho ? " => doi cho a[$i]<->a[$min_idx]" : " => khong doi (min da dung vi tri)",
                " | mang: ", b)
    end
    return sap_xep_lua_chon(a)
end

"""
    sap_xep_doi_cho(a)

Sắp xếp đổi chỗ (exchange sort, giáo trình mục 2.2.1) dùng để đối chứng:
đổi `a[i]` với `a[j]` ngay khi `a[j] < a[i]`. Cùng thực hiện n(n-1)/2 phép
so sánh như sắp xếp lựa chọn nhưng số phép đổi chỗ nhiều hơn hẳn.
Hàm tự kiểm tra đầu vào. Trả về `NamedTuple` gồm `mang`, `so_sanh`, `so_doi`.
"""
function sap_xep_doi_cho(a)
    kiem_tra_dau_vao(a)
    b = copy(a)
    n = length(b)
    so_sanh = 0
    so_doi = 0
    for i in 1:(n - 1)
        for j in (i + 1):n
            so_sanh += 1
            if b[j] < b[i]
                b[i], b[j] = b[j], b[i]
                so_doi += 1
            end
        end
    end
    return (; mang=b, so_sanh, so_doi)
end

end # module DeTai
