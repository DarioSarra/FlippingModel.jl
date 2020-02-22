comp = by(b,[:Protocol,:Wall,:MouseID]) do dd
    m = fit(FlippingModel.PoissonLapseUniform, dd)
    T, r, lapse = params(m)
    (T=T, r=r, lapse=lapse, model=m)
end
##
comp = by(b,[:Protocol,:Wall,:MouseID]) do dd
    m = fit(FlippingModel.PoissonLapseExponential, dd)
    T, r, lapse = params(m)
    (T=T, r=r, lapse=lapse, model=m)
end
##
Simulated = by(comp,[:Protocol,:Wall,:MouseID]) do dd
    (simulation = FlippingModel.simulate(dd[1,:model], 500),)
end
##
##
##
using Distributions, StatsBase, StructArrays

prova = Exponential(3)
w = [cdf(prova,x)-cdf(prova,x-1) for x in 1:20]
weights = StatsBase.weights(w)
[sample(1:20,weights) for _ in 1:500]

plot([pdf(prova,x) for x in 1:20])
cm = countmap(StructArray((Omissions_plus_one = b.Omissions_plus_one, Leave = b.Leave)))
pE = FlippingModel.init(PoissonLapseExponential,cm)

plot([cdf(pE,x) for x in 1:20])
