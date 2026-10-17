# scripts/trace_and_scales.jl — Truy vết tay T01 và khảo sát ba/quy mô DT011.
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
    for i in 1:(n - 1)
        m = i
        for j in (i + 1):n
            if b[j] < b[m]
                m = j
            end
        end
        if m != i
            println("  Luot $i: min cua doan [$i..$n] tai $m -> doi a[$i]<->a[$m]: ", (b[i], b[m]), " -> ", (b[m], b[i]))
            b[i], b[m] = b[m], b[i]
        else
            println("  Luot $i: min cua doan [$i..$n] tai $m (dung vi tri, khong doi)")
        end
        println("      mang sau luot: ", b)
    end
    println("Ket qua: ", b)
    println()
end

function do_quy_mo()
    println("="^70)
    println("KHAO SAT QUY MO: so sanh (n(n-1)/2) va so doi tren mang ngau nhien")
    Random.seed!(11022026)
    for n in (5, 20, 100, 500)
        # Chạy lặp để đo thời gian ổn định; đếm là tất định theo từng mảng.
        best_ns = typemax(Int64)
        kq = nothing
        for _ in 1:5
            a = rand(-(10^6):10^6, n)
            t0 = time_ns()
            kq_tmp = sap_xep_lua_chon(a)
            dt = time_ns() - t0
            if dt < best_ns
                best_ns = dt
                kq = kq_tmp
            end
        end
        lt = n * (n - 1) ÷ 2
        println("n = ", rpad(n, 4), " | so_sanh thuc=", kq.so_sanh, " (lt=", lt, ")",
                " | so_doi=", kq.so_doi, " (<=n-1=", n - 1, ")",
                " | thoi gian tot nhat ~", round(best_ns / 1e6, digits=3), " ms")
    end
    println()
end

truy_vet_t01()
do_quy_mo()
println("HOAN TAT TRUY VET VA KHAO SAT QUY MO.")
