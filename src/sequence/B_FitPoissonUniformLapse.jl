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


cm = countmap(StructArray((Omissions_plus_one = b.Omissions_plus_one, Leave = b.Leave)))
pE = FlippingModel.init(PoissonLapseExponential,cm)

##
e = Exponential(3)
g = Gamma(10,1/2)
plot([cdf(g,x) - cdf(g,x-1) for x in 1:20])
plot!([cdf(e,x) - cdf(e,x-1) for x in 1:20])
plot!([cdf(pE,om) - cdf(pE,om-1) for om in 1:20])
##
plot([cdf(g,x) for x in 1:20])
plot!([cdf(e,x) for x in 1:20])
plot!([cdf(pE,om) for om in 1:20])
##
