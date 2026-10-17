# test/runtests.jl — Bộ kiểm thử DT011 (Sắp xếp lựa chọn).
# Lệnh: julia --startup-file=no test/runtests.jl

using Test
using Random
include(joinpath(@__DIR__, "..", "src", "DeTai.jl"))
using .DeTai

# Kiểm tra bất biến chung: output tăng dần, là hoán vị của input,
# số so sánh đúng n(n-1)/2, số đổi chỗ không quá n-1, vị trí min khớp tham chiếu.
function kiem_bat_bien(a)
    kq = sap_xep_lua_chon(a)
    n = length(a)
    @test kq.so_sanh == n * (n - 1) ÷ 2
    @test kq.so_doi <= max(n - 1, 0)
    @test length(kq.cac_min) == max(n - 1, 0)
    @test issorted(kq.mang)
    @test sort(a) == kq.mang
    @test kq.cac_min == _cac_min_tham_chieu(a)
    return kq
end

# Tham chiếu độc lập: tự quét tay để có vị trí min từng lượt.
function _cac_min_tham_chieu(a)
    b = copy(a)
    n = length(b)
    out = Int[]
    for i in 1:(n - 1)
        m = i
        for j in (i + 1):n
            if b[j] < b[m]
                m = j
            end
        end
        push!(out, m)
        if m != i
            b[i], b[m] = b[m], b[i]
        end
    end
    return out
end

@testset "DT011 - 12 ca chuc nang va bien" begin
    # VD01 — Ví dụ 1 phiếu.
    kq = sap_xep_lua_chon([8, 3, 5, 1, 9, 2])
    @test kq.mang == [1, 2, 3, 5, 8, 9]
    @test kq.so_sanh == 15
    @test kq.so_doi == 5
    @test kq.cac_min == [4, 6, 6, 6, 6]

    # VD02 — Ví dụ 2 phiếu (giữ đủ hai phần tử 2).
    kq = sap_xep_lua_chon([2, 1, 2])
    @test kq.mang == [1, 2, 2]
    @test kq.so_sanh == 3
    @test kq.so_doi == 1
    @test kq.cac_min == [2, 2]

    # TK01 — Tự thiết kế 1: có phần tử trùng (hai số 1).
    kq = sap_xep_lua_chon([5, 1, 4, 1, 3])
    @test kq.mang == [1, 1, 3, 4, 5]
    @test kq.so_sanh == 10
    @test kq.so_doi == 4

    # TK02 — Tự thiết kế 2: mảng giảm dần.
    kq = sap_xep_lua_chon([9, 7, 5, 3, 1])
    @test kq.mang == [1, 3, 5, 7, 9]
    @test kq.so_sanh == 10
    @test kq.so_doi == 2
    @test kq.cac_min == [5, 4, 3, 4]

    # BIEN01 — Đã tăng, không đổi chỗ.
    kq = sap_xep_lua_chon([1, 2, 3])
    @test kq.mang == [1, 2, 3]
    @test kq.so_doi == 0
    @test kq.cac_min == [1, 2]

    # BIEN02 — Toàn bộ trùng nhau, giữ đủ phần tử.
    kq = sap_xep_lua_chon([4, 4, 4])
    @test kq.mang == [4, 4, 4]
    @test kq.so_sanh == 3
    @test kq.so_doi == 0

    # BIEN03 — Một phần tử.
    kq = sap_xep_lua_chon([7])
    @test kq.mang == [7]
    @test kq.so_sanh == 0
    @test kq.so_doi == 0
    @test isempty(kq.cac_min)

    # BIEN03b — Mảng rỗng.
    kq = sap_xep_lua_chon(Int[])
    @test isempty(kq.mang)
    @test kq.so_sanh == 0
    @test kq.so_doi == 0

    # KT09 — Số âm.
    kq = sap_xep_lua_chon([-3, -1, -2])
    @test kq.mang == [-3, -2, -1]
    @test kq.so_doi == 1
    @test kq.cac_min == [1, 3]

    # KT10 — Biên giá trị |a[i]| = 10^6.
    kq = sap_xep_lua_chon([1000000, -1000000, 0])
    @test kq.mang == [-1000000, 0, 1000000]
    @test kq.so_sanh == 3
    @test kq.so_doi == 2

    # KT11 — Toàn số 0.
    kq = sap_xep_lua_chon([0, 0, 0, 0])
    @test kq.mang == [0, 0, 0, 0]
    @test kq.so_sanh == 6
    @test kq.so_doi == 0

    # KT12 — Mảng tổng quát dài 8; kiểm bằng sort độc lập và bất biến.
    a = [3, 1, 4, 1, 5, 9, 2, 6]
    kq = sap_xep_lua_chon(a)
    @test kq.mang == sort(a)
    @test kq.so_sanh == 28
    @test kq.so_doi <= 7
    @test issorted(kq.mang)
end

@testset "DT011 - doi chieu ham con va bat bien" begin
    # tim_min_doan trả vị trí min đầu tiên khi trùng.
    @test tim_min_doan([5, 1, 4, 1, 3], 1, 5) == 2
    @test tim_min_doan([2, 1, 2], 2, 3) == 2
    @test tim_min_doan([7], 1, 1) == 1
    @test_throws ArgumentError tim_min_doan([1, 2], 2, 1)

    # Bất biến giữ trên một số mảng sinh ngẫu nhiên có seed cố định.
    Random.seed!(2026)
    for n in 0:8
        for _ in 1:50
            a = rand(-100:100, n)
            kiem_bat_bien(a)
        end
    end

    # Đối chứng: sắp xếp đổi chỗ cùng output, cùng số so sánh, nhiều đổi chỗ hơn/không ít hơn.
    for a in ([8, 3, 5, 1, 9, 2], [5, 1, 4, 1, 3], [9, 7, 5, 3, 1])
        lc = sap_xep_lua_chon(a)
        dc = sap_xep_doi_cho(a)
        @test lc.mang == dc.mang == sort(a)
        @test lc.so_sanh == dc.so_sanh
        @test lc.so_doi <= dc.so_doi
    end
end

@testset "DT011 - kiem tra du lieu vao" begin
    @test kiem_tra_dau_vao(Int[]) == true            # LOI-rong hop le
    @test kiem_tra_dau_vao([1, 2, 3]) == true
    @test_throws ArgumentError kiem_tra_dau_vao(fill(0, 2001))      # LOI01: n > 2000
    @test_throws ArgumentError kiem_tra_dau_vao([10^6 + 1])          # LOI02: |a[i]| > 10^6
    @test_throws ArgumentError kiem_tra_dau_vao([-(10^6) - 1])       # LOI02b
    @test_throws ArgumentError kiem_tra_dau_vao([1.5, 2.0])          # LOI03: khong phai Vector{Int}
end

println("DA QUA BO KIEM THU DT011: 12 ca chuc nang, doi chieu ham con/bat bien va kiem tra du lieu vao.")
