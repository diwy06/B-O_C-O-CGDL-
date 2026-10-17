# scripts/test_catalog.jl — In danh mục input/expected/actual/PASS cho 12 ca DT011.
# Lệnh: julia --startup-file=no scripts/test_catalog.jl

include(joinpath(@__DIR__, "..", "src", "DeTai.jl"))
using .DeTai

# (id, nhan, input, expected)
const CAT = [
    ("VD01",   "Vi du 1 phieu",        [8, 3, 5, 1, 9, 2],       [1, 2, 3, 5, 8, 9]),
    ("VD02",   "Vi du 2 phieu",        [2, 1, 2],                [1, 2, 2]),
    ("TK01",   "Tu thiet ke 1",        [5, 1, 4, 1, 3],          [1, 1, 3, 4, 5]),
    ("TK02",   "Tu thiet ke 2",        [9, 7, 5, 3, 1],          [1, 3, 5, 7, 9]),
    ("BIEN01", "Da tang khong doi",    [1, 2, 3],                [1, 2, 3]),
    ("BIEN02", "Toan bo trung",        [4, 4, 4],                [4, 4, 4]),
    ("BIEN03", "Mot phan tu",          [7],                      [7]),
    ("KT09",   "So am",                [-3, -1, -2],             [-3, -2, -1]),
    ("KT10",   "Bien 10^6",            [1000000, -1000000, 0],   [-1000000, 0, 1000000]),
    ("KT11",   "Toan so 0",            [0, 0, 0, 0],             [0, 0, 0, 0]),
    ("KT12",   "Mang tong quat n=8",   [3, 1, 4, 1, 5, 9, 2, 6], [1, 1, 2, 3, 4, 5, 6, 9]),
    ("BIEN03b","Mang rong",            Int[],                    Int[]),
]

function chay_danh_muc()
    pass = 0
    for (id, nhan, inp, exp) in CAT
        kiem_tra_dau_vao(inp)
        kq = sap_xep_lua_chon(inp)
        ok = kq.mang == exp
        pass += ok ? 1 : 0
        println(rpad(id, 9), " | ", rpad(nhan, 20), " | input=", inp,
                " | expected=", exp, " | actual=", kq.mang,
                " | so_sanh=", kq.so_sanh, " so_doi=", kq.so_doi, " | ", ok ? "PASS" : "FAIL")
    end
    println("TONG KET: ", pass, "/", length(CAT), " ca PASS")
end

chay_danh_muc()
