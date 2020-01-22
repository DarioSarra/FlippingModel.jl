export f_fast

function Log_LikeliHood(om,leaves,dist)
    if leaves
        #= if the animal has left we want the probability of this to happen
        at that omission, given that it has not left before.
        Since we assume that the events are independent the product of each likelihood
        should give me the total probability. Using the log we can simply sum them =#
        return log(cdf(dist,om) - cdf(dist,om-1))
    else
        #= if the animal hasn't left we want the probability of not leaving until om =#
        # this is equivalent log(1-cdf(dist,om)) but it's safe when cdf is near 1
        return logccdf(dist, om)
    end
end


#= slow but intuitive function to fit,
params 1 is the treshold, params 2 i the shape that we want to corrispond
to the rate of the Poisson process, so we want to fit the inverse of the scale=#
function f(d::DataFrames.AbstractDataFrame, pars)
    ϵ = 1e-10 #constant to make sure that params are somewhat far from 0
    if any(pars .< ϵ)
        return 1e10 #return a huge number to punish the choice
    end
    G = Gamma(pars[1],1/pars[2])
    #=second parameters is a fraction because if the shape parameters k is an integer,
    the gamma distribution is an Erlang distribution and is the
    probability distribution of the waiting time until the kth "arrival"
    in a one-dimensional Poisson process with intensity 1/θ (1 over scale)=#
    v = sum(Log_LikeliHood.(d.Omissions_plus_one,d.Leave,G))
    return -v #because we want to minize the parameters we want to change the sign
end

#=The fast version collects the combination of
consecutive omissions and outcomes and their occurence in a dictionary
 and multiply the loglikelihood, by the number of occurrence=#
function  f_fast(b::DataFrames.AbstractDataFrame, pars)
    cm = countmap(StructArray((b.Omissions_plus_one, b.Leave)))
    f_fast(cm,pars)
end

function  f_fast(cm, pars)
    ϵ = 1e-10 #constant to make sure that params are somewhat far from 0
    if any(pars .< ϵ)
        return 1e10 #return a huge number to punish the choice
    end
    T, r = pars
    G = Gamma(T, 1/r)
    v = sum(Log_LikeliHood(key..., G)*val for (key, val) in cm)
    return -v
end
