function Log_LikeliHood(m::AbstractModel, om, leaves)
    if leaves
        #= if the animal has left we want the probability of this to happen
        at that omission, given that it has not left before.
        Since we assume that the events are independent the product of each likelihood
        should give me the total probability. Using the log we can simply sum them =#
        return log(cdf(m,om) - cdf(m,om-1))
    else
        #= if the animal hasn't left we want the probability of not leaving until om =#
        # this is equivalent log(1-cdf(dist,om)) but it's safe when cdf is near 1
        return log(1-cdf(m, om))
    end
end

function  nll_data(m::AbstractModel,cm::Dict)
    -sum(v*Log_LikeliHood(m, k...) for (k, v) in cm)
end

function Distributions.fit(::Type{T}, b::DataFrames.AbstractDataFrame) where T<:AbstractModel
    cm = countmap(StructArray((Omissions_plus_one = b.Omissions_plus_one, Leave = b.Leave)))
    p = init(T, cm)
    res = optimize(params(p)) do param
        all(param .> 1e-10) || return 1e10
        params(p) .= param
        return nll_data(p, cm)
    end
    params(p) .= Optim.minimizer(res)
    return p
end

###
function simulate(m::AbstractModel,n_samples=1)
    w = [cdf(m,x)-cdf(m,x-1) for x in 1:maximum(m)]
    weights = StatsBase.weights(w)
    [sample(1:maximum(m),weights) for _ in 1:n_samples]
end
