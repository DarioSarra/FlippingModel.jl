using Survival: KaplanMeier
function _survival(times, events; axis = discrete_axis(times, npoints = npoints), kwargs...)
    km = fit(KaplanMeier, times, events)
    surv = zeros(length(axis))
    for (i, ax) in enumerate(axis)
        if ax < km.times[1]
            surv[i] = 1
        elseif ax > km.times[end]
            surv[i] = km.survival[end]
        else
            surv[i] = km.survival[searchsortedfirst(km.times, ax)]
        end
    end
    return zip(axis, surv)
end

const survival = Analysis((; discrete = _survival))
