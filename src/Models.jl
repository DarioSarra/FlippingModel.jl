abstract type AbstractModel end

struct PoissonLapseUniform <: AbstractModel
    params::Vector{Float64}
    max::Int
end
function init(::Type{<:PoissonLapseUniform}, cm::Dict)
    m = maximum(key.Omissions_plus_one for key in keys(cm))
    return PoissonLapseUniform([10, 2, 0.1], m)
end

Distributions.params(p::PoissonLapseUniform) = p.params
Base.maximum(m::PoissonLapseUniform) = m.max

function Distributions.cdf(p::PoissonLapseUniform, x::Int)
    T, r, ϵ = params(p)
    d = Gamma(T, 1/r)
    # ϵ = 0
    # 1-ϵ e faccio Gamma, ϵ e faccio uniform, sommare e' uguale a "oppure" in probabilita'
    return (1-ϵ)*cdf(d, x) + ϵ*x/p.max
end
##
struct PoissonLapseExponential <: AbstractModel
    params::Vector{Float64}
    max::Int
end
function init(::Type{<:PoissonLapseExponential}, cm::Dict)
    m = maximum(key.Omissions_plus_one for key in keys(cm))
    return PoissonLapseExponential([10, 2, 3], m)
end

Distributions.params(p::PoissonLapseExponential) = p.params
Base.maximum(m::PoissonLapseExponential) = m.max

function Distributions.cdf(p::PoissonLapseExponential, x::Int)
    T, r, ϵ = params(p)
    g = Gamma(T, 1/r)
    l = Exponential(ϵ)
    #ϵ = 0
    # 1-ϵ e faccio Gamma, ϵ e faccio uniform, sommare e' uguale a "oppure" in probabilita'
    #return (1-cdf(l,x))*cdf(d, x) + cdf(l,x)
    return (1-0.01)*cdf(g,x) + 0.01*cdf(l,x)
end
