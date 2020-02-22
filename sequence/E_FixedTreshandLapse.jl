# TODO
# prendi un topo
# prendi 8 parametri! T, lapse, r11, r12, r13, r21, r22, r23
# nll_data(dati, T, lapse, r11, r12, r13, r21, r22, r23)
# come si fa?
# splitta in df11, ..., df23 (protocollo e barrier)
# calcola nll_data(df11, T, r11, lapse), etc..
# fai la somma
# ottimizza per T, r11, r12, r13, r21, r22, r23, lapse
# simula i dati per vedere che va tutto buono!

using StructArrays: StructArray
using StatsBase
using OrderedCollections: OrderedDict
using Distributions
cm = countmap(StructArray((
    Protocol = b.Protocol,
    Wall = b.Wall,
    Omissions_plus_one = b.Omissions_plus_one,
    Leave = b.Leave
    )))

abstract type AbstractCompositeModel <: AbstractModel end

struct PoissonFixedTL <: AbstractCompositeModel
    params::Vector{Float64}
    max::Int
    dict::Dict
end

function init(::Type{<:PoissonFixedTL}, cm::Dict)
    d = OrderedDict(y => x for (x,y) in enumerate(union([(k.Wall,k.Protocol) for k in keys(cm)])))
    m = maximum(k.Omissions_plus_one for k in keys(cm))
    return PoissonFixedTL(vcat(repeat([2],length(d)),[10,0.1]), m,d,)
end

specialize(p::AbstractModel, protocol, wall) = p

function specialize(p::PoissonFixedTL, protocol, wall)
    parameters = params(p)[[p.dict[(protocol, wall)], end-1, end]]
    return PoissonLapseUniform(parameters, p.max)
end

Distributions.params(p::PoissonFixedTL) = p.params
Base.maximum(m::PoissonFixedTL) = m.max

# TODO opzionale: invece di tipo passa istanza
function Distributions.fit!(p::T, b::DataFrames.AbstractDataFrame) where T<:AbstractCompositeModel
    # TODO usa DataFrames.by ?
    cm = countmap(StructArray((
        Protocol = b.Protocol,
        Wall = b.Wall,
        Omissions_plus_one = b.Omissions_plus_one,
        Leave = b.Leave
    )))
    res = optimize(params(p)) do param
        all(param .> 1e-10) || return 1e10
        params(p) .= param
        nll = 0.0
        # TODO: create dict of specialized versions!
        for (key, val) in cm
            prot, w, om, l = key
            new_p = specialize(p, prot, w)
            nll -= val*Log_LikeliHood(new_p, om, l)
        end
        return nll
    end
    params(p) .= Optim.minimizer(res)
    return p
end

##
for (key, subdf) in pairs(groupby(bouts, [:Wall,:Protocol]))
   println("Number of data points for $((key.Protocol,key.Wall)): $(nrow(subdf))")
end

##
function fit2!(p::T, b::DataFrames.AbstractDataFrame) where T<:AbstractCompositeModel
    res = optimize(params(p)) do param
        all(param .> 1e-10) || return 1e10
        params(p) .= param
        nll = 0.0
        for (keysdf, subdf) in pairs(groupby(b, [:Wall,:Protocol]))
            new_p = specialize(p, keysdf.Wall, keysdf.Protocol)
            cm = countmap(StructArray((
            Omissions_plus_one = subdf.Omissions_plus_one,
            Leave = subdf.Leave
            )))
            for (key, val) in cm
                nll -= val*Log_LikeliHood(new_p, key.Omissions_plus_one, key.Leave)
            end
        end
        return nll
    end
    params(p) .= Optim.minimizer(res)
    return p
end
##
function fit3!(p::T, b::DataFrames.AbstractDataFrame) where T<:AbstractCompositeModel
    cm = countmap(StructArray((
        Protocol = b.Protocol,
        Wall = b.Wall,
        Omissions_plus_one = b.Omissions_plus_one,
        Leave = b.Leave
        )))
    res = optimize(params(p)) do param
    for (keysdf, subdf) in pairs(groupby(b, [:Wall,:Protocol]))
        new_p = specialize(p, keysdf.Wall, keysdf.Protocol)
        all(param .> 1e-10) || return 1e10
        params(p) .= param
        nll = 0.0
            cm = countmap(StructArray((
                Omissions_plus_one = b.Omissions_plus_one,
                Leave = b.Leave
            )))
            for (key, val) in cm
                nll -= val*Log_LikeliHood(new_p, key.Omissions_plus_one, key.Leave)
            end
        end
        return nll
    end
    params(p) .= Optim.minimizer(res)
    return p
end
##
cm = countmap(StructArray((
    Protocol = b.Protocol,
    Wall = b.Wall,
    Omissions_plus_one = b.Omissions_plus_one,
    Leave = b.Leave
    )))
p = init(PoissonFixedTL,cm)

comp = by(b,:MouseID) do dd
    m = fit2!(p, dd)
    headers = [Symbol(string(protocol,wall)) for (protocol,wall) in keys(p.dict)]
    append!(headers,[:Tresh,:Laspe])
    NamedTuple{Tuple(headers)}(params(m))
end

comp2 = stack(comp,headers)
string.(comp2.variable)[end-4:end]
comp2.Protocol = string.(comp2.variable)
comp2[!,:Protocol] .= [occursin("false",x) ? replace(x,"false"=>"") : replace(x,"true"=>"") for x in comp2.Protocol]
categorical!(comp2,:Protocol)
levels!(comp2.Protocol,["40/20","60/30","80/40"])
comp2.Wall = [occursin("true",string(x)) for x in comp2.variable]
sort!(comp2,:Protocol)
comp2.Log = log.(comp2.value)
##
using Plots
using Recombinase

args, kwargs = series2D(
    comp2,
    Recombinase.Group(color = :Wall),
    select = (:Protocol, :Log)
    )
scatter(args...;kwargs..., legend = :topleft)

plot(collect(1:100),log.(collect(1:100)))
