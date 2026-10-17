# demo.jl — Chạy minh hoạ và so sánh cho DT011 (Sắp xếp lựa chọn).
# Lệnh: julia --startup-file=no demo.jl [--ca=N | --nhap | --so-sanh]

include(joinpath(@__DIR__, "src", "DeTai.jl"))
using .DeTai

function chay_ca(a; nhan="")
    println("="^70)
    println("CA: ", nhan)
    println("Input  : ", a)
    kiem_tra_dau_vao(a)
    kq = sap_xep_lua_chon(a)
    println("Output : ", kq.mang)
    println("So sanh: ", kq.so_sanh, "  (n(n-1)/2 = ", (length(a) * (length(a) - 1)) ÷ 2, ")")
    println("So doi : ", kq.so_doi, "  (toi da n-1 = ", max(length(a) - 1, 0), ")")
    println("Vi tri min tung luot: ", kq.cac_min)
    println()
end

# Bảy ca demo hợp lệ tương ứng kế hoạch ảnh A01–A07.
const CAC_CA = [
    ([8, 3, 5, 1, 9, 2], "A01 - Vi du 1 phieu [8,3,5,1,9,2] -> [1,2,3,5,8,9]"),
    ([2, 1, 2],          "A02 - Vi du 2 phieu [2,1,2] -> [1,2,2]"),
    ([5, 1, 4, 1, 3],    "A03 - Tu thiet ke 1 (co phan tu trung 1)"),
    ([9, 7, 5, 3, 1],    "A04 - Tu thiet ke 2 (mang giam dan)"),
    ([1, 2, 3],          "A05 - Bien 1 (da tang, khong doi cho)"),
    ([4, 4, 4],          "A06 - Bien 2 (toan bo trung nhau)"),
    ([7],                "A07 - Bien 3 (mot phan tu / mang rong)"),
]

# Ca A08: input không hợp lệ bị validator từ chối.
function chay_ca_loi()
    println("="^70)
    println("CA: A08 - Input khong hop le (validator tu choi)")
    for (nhan, du_lieu) in [
            ("n = 2001 vuot gioi han", fill(0, 2001)),
            ("|a[i]| = 10^6 + 1 vuot gioi han", [10^6 + 1]),
            ("khong phai Vector{Int}", [1.5, 2.0]),
        ]
        print("  ", nhan, ": ")
        try
            kiem_tra_dau_vao(du_lieu)
            println("KHONG PHAT HIEN (LOI)")
        catch e
            println(typeof(e), " - ", e.msg)
        end
    end
    println()
end

function chay_ca_rong()
    println("="^70)
    println("CA: A07b - Mang rong Int[]")
    a = Int[]
    kiem_tra_dau_vao(a)
    kq = sap_xep_lua_chon(a)
    println("Input  : Int[]")
    println("Output : ", kq.mang)
    println("So sanh: ", kq.so_sanh, "  So doi: ", kq.so_doi)
    println()
end

function chay_tat_ca()
    for (a, nhan) in CAC_CA
        chay_ca(a; nhan)
    end
    chay_ca_rong()
    chay_ca_loi()
    so_sanh_lua_chon_va_doi_cho()
end

function so_sanh_lua_chon_va_doi_cho()
    println("="^70)
    println("SO SANH: sap xep lua chon voi sap xep doi cho (cung O(n^2))")
    for a in ([8, 3, 5, 1, 9, 2], [5, 1, 4, 1, 3], [9, 7, 5, 3, 1])
        lc = sap_xep_lua_chon(a)
        dc = sap_xep_doi_cho(a)
        println("Input      : ", a)
        println("  Lua chon : so_sanh=", lc.so_sanh, " so_doi=", lc.so_doi, " -> ", lc.mang)
        println("  Doi cho  : so_sanh=", dc.so_sanh, " so_doi=", dc.so_doi, " -> ", dc.mang)
    end
    println()
end

function nhap_ban_phim()
    println("Nhap n (so phan tu, 0 <= n <= 2000):")
    n = parse(Int, readline())
    println("Nhap $n so nguyen (|a[i]| <= 10^6), moi so mot dong:")
    a = Int[parse(Int, readline()) for _ in 1:n]
    kiem_tra_dau_vao(a)
    chay_ca(a; nhan="Nhap ban phim")
end

if "--nhap" in ARGS
    nhap_ban_phim()
elseif "--so-sanh" in ARGS
    so_sanh_lua_chon_va_doi_cho()
else
    ca_chon = [a for a in ARGS if startswith(a, "--ca=")]
    if !isempty(ca_chon)
        i = parse(Int, split(ca_chon[1], '=')[2])
        (1 <= i <= 8) || error("ca $i nam ngoai 1..8")
        if i == 8
            chay_ca_loi()
        else
            a, nhan = CAC_CA[i]
            chay_ca(a; nhan)
        end
    else
        chay_tat_ca()
    end
end
