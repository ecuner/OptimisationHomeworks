using JuMP, Clp, Printf

d = [40 60 75 25]

m = Model(with_optimizer(Clp.Optimizer))

@variable(m, 0 <= x[1:5] <= 40)       # boats produced with regular labor
@variable(m, y[1:5] >= 0)             # boats produced with overtime labor
@variable(m, h[1:5])

@variable(m, inc[1:4] >= 0)
@variable(m, dec[1:4] <= 0) # diğer örneklere nazaran bende dec negatif, inc'le topluyorum

@variable(m, incH[1:5] >= 0)
@variable(m, decH[1:5] <= 0)

@constraint(m, h[1] == 10) # işleme başlamadan envanterde 10 tane var

@constraint(m, x[1] == 40) # işleme başlamadan önce 50 tane üretilmiş olacak
@constraint(m, y[1] == 10)

@constraint(m, incH[5] >= 10)
@constraint(m, decH[5] == 0)

@constraint(m, invH[i in 1:5], h[i] == incH[i] + decH[i]) # Q'deki envanter = incH + decH

@constraint(m, inv[i in 1:4], h[i]+x[i+1]+y[i+1] == d[i] + h[i+1]) 

@constraint(m, incdec[i in 1:4], (x[i+1]+y[i+1]) - (x[i]+y[i]) == (inc[i] + dec[i])) # Q2- Q1 üretim farkı = inc + dec

@objective(m, Min, 400*sum(x) + 450*sum(y) + 20*sum(incH) + 400*sum(inc) - 500*sum(dec) - 100*sum(decH))

optimize!(m)

@printf("Boats to build regular labor: %d %d %d %d %d\n", value(x[1]), value(x[2]), value(x[3]), value(x[4]), value(x[5]))
@printf("Boats to build extra labor: %d %d %d %d %d\n", value(y[1]), value(y[2]), value(y[3]), value(y[4]), value(y[5]))
@printf("Inventories: %d %d %d %d %d\n ", value(h[1]), value(h[2]), value(h[3]), value(h[4]), value(h[5]))
@printf("Inv. inc.: %d %d %d %d %d\n ", value(incH[1]), value(incH[2]), value(incH[3]), value(incH[4]), value(incH[5]))
@printf("Inv. dec.: %d %d %d %d %d\n ", value(decH[1]), value(decH[2]), value(decH[3]), value(decH[4]), value(decH[5]))


@printf("Prod. inc.: %d %d %d %d\n ", value(inc[1]), value(inc[2]), value(inc[3]), value(inc[4]))
@printf("Prod. dec.: %d %d %d %d\n ", value(dec[1]), value(dec[2]), value(dec[3]), value(dec[4]))



@printf("Objective cost: %f\n", objective_value(m))


