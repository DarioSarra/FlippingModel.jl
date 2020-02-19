export Model, f_loglikelihood, optimize

#using  Optim, Distributions, StructArrays, StatsBase

mutable struct Model{N,p <: AbstractArray,d}
    pars::p
    dist
    #Model(pars,dist) = length(fieldnames(dist)) == length(pars) ? new{pars,dist}(pars,dist) : error("wrong n of parameters")
    Model{N}(pars::p,dist::d) where {N,p,d} =
        new{N,p,d}(pars,dist)
end

StatsBase.sample(x,m::Model) = sample(x,StatsBase.Weights(pdf(m.dist(m.pars...),x)))
##
p = Model{:loglike}([2,5],Gamma)
sample(0:20,p)
##
function  f_loglikelihood(cm, dist,pars)
    ϵ = 1e-10 #constant to make sure that params are somewhat far from 0
    if any(pars .< ϵ)
        return 1e10 #return a huge number to punish the choice
    end
    D = dist(pars...)
    v = sum(Log_LikeliHood(key..., D)*val for (key, val) in cm)
    return -v
end

Optim.optimize(cm,m::Model{:loglike}) = optimize(x->f_loglikelihood(cm,m.dist,x),m.pars)
##
##This step is to calculate the moments of a gamma with the last parameters
function f_momentsmatching(cm, dist,pars)
    ϵ = 1e-10 #constant to make sure that params are somewhat far from 0
    if any(pars .< ϵ)
        return 1e10 #return a huge number to punish the choice
    end
    D = dist(pars...)
    moments = Moments(weight = x -> pdf(D,x))
    Ms = fit!(moments,1:100)

    v = sum(Log_LikeliHood(key..., D)*val for (key, val) in cm)
    return -v
end
