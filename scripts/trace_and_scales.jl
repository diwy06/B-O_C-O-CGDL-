# scripts/trace_and_scales.jl — Truy vết T01 và khảo sát quy mô DT011.
# Lệnh: julia --startup-file=no scripts/trace_and_scales.jl

include(joinpath(@__DIR__, "..", "src", "DeTai.jl"))
using .DeTai
using Random

function truy_vet_t01()
    a = [8, 3, 5, 1, 9, 2]
    println("="^70)
    println("TRUY VET T01 (Vi du 1): ", a)
    b = copy(a)
    n = length(b)
    cac_min_trace = Int[]
    for i in 1:(n - 1)
        m = i
        for j in (i + 1):n
            if b[j] < b[m]
                m = j
            end
        end
        push!(cac_min_trace, m)
        if m != i
            println("  Luot $i: min cua doan [$i..$n] tai $m -> doi a[$i]<->a[$m]: ", (b[i], b[m]), " -> ", (b[m], b[i]))
            b[i], b[m] = b[m], b[i]
        else
            println("  Luot $i: min cua doan [$i..$n] tai $m (dung vi tri, khong doi)")
        end
        println("      mang sau luot: ", b)
    end
    println("Ket qua: ", b)

    # Đối chiếu lần vết với kết quả lõi (không chỉ in ra)
    kq = sap_xep_lua_chon(a)
    @assert kq.mang == b "loi: mang sau lan vet khong khop sap_xep_lua_chon"
    @assert kq.cac_min == cac_min_trace "loi: cac_min cua lan vet khong khop sap_xep_lua_chon"
    @assert kq.so_sanh == n * (n - 1) ÷ 2 "loi: so_sanh khong bang n(n-1)/2"
    println("ASSERT OK: mang, cac_min va so_sanh cua lan vet khop voi sap_xep_lua_chon.")
    println()
end

function do_quy_mo()
    println("="^70)
    println("KHAO SAT QUY MO: lua chon vs doi cho tren cung mang ngau nhien")
    println(rpad("n", 5), "| ", rpad("so_sanh", 10), "| ",
            rpad("so_doi_lc", 10), "| ", rpad("so_doi_dc", 10), "| thoi gian")
    Random.seed!(11022026)
    for n in (5, 20, 100, 500)
        a = rand(-(10^6):10^6, n)
        best_ns = typemax(Int64)
        kq = nothing
        for _ in 1:5
            t0 = time_ns()
            kq_tmp = sap_xep_lua_chon(a)
            dt = time_ns() - t0
            if dt < best_ns
                best_ns = dt
                kq = kq_tmp
            end
        end
        dc = sap_xep_doi_cho(a)
        # Ràng buộc thật giữa hai thuật toán
        @assert kq.mang == dc.mang == sort(a) "loi: hai thuat toan cho ket qua khac nhau"
        @assert kq.so_sanh == dc.so_sanh == n * (n - 1) ÷ 2 "loi: so sanh khac n(n-1)/2"
        @assert kq.so_doi <= n - 1 "loi: so doi vuot n-1"
        println(rpad(n, 5), "| ", rpad(kq.so_sanh, 10), "| ",
                rpad(kq.so_doi, 10), "| ", rpad(dc.so_doi, 10), "| ~",
                round(best_ns / 1e6, digits=4), " ms")
    end
    println()
end

truy_vet_t01()
do_quy_mo()
println("HOAN TAT TRUY VET VA KHAO SAT QUY MO.")
