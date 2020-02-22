using Recombinase, Plots
Simulated
args, kwargs = series2D(
    Recombinase.discrete(Recombinase.density),
    Simulated,
    error = :MouseID,
    Recombinase.Group(color = :Protocol, linestyle = :Wall),
    select = (:simulation),
    ribbon = true
    )
p1 = plot(args...;
    kwargs...,
    legend = false,
    linealpha = 0,
    fillalpha=0.3,
    ylabel = "pdf",
    xlabel = "pokes after last reward")
#savefig(p1,"/home/beatriz/Documents/Dario_reports/NewProtocols/Fitting/model_without_lapse.pdf")
###
test = filter(b) do row
    !ismissing(row.Leave) &&
    row.Omissions_plus_one <21 &&
    row.Leave
end

args, kwargs = series2D(
    Recombinase.discrete(Recombinase.density),
    test,
    error = :MouseID,
    Recombinase.Group(color = :Protocol, linestyle = :Wall),
    select = (:Omissions_plus_one),
    ribbon = true
    )
p2 = plot!(p1,args...;kwargs...,legend = false,fillalpha = 0,linewidth=2)
plot(args...;kwargs...)
#savefig(p1,"/home/beatriz/Documents/Dario_reports/NewProtocols/Fitting/model&data_without_lapse.pdf")
###
p1
p3
###
s = filter(streaks) do row
    row.Correct_start &&
    row.Streak > 10 &&
    3 < row.Streak_within_Block< 23 &&
    row.ReverseStreak > 20 &&
    (ismissing(row.Pre_Interpoke) || row.Pre_Interpoke < 1) &&
    row.Protocol_Day > 1 &&
    row.Day > 20191215
end
s[!,:AftrePlusOne] = s.AfterLast .+ 1
args, kwargs = series2D(
    Recombinase.discrete(Recombinase.density),
    s,
    error = :MouseID,
    Recombinase.Group(color = :Protocol, linestyle = :Wall),
    select = (:AftrePlusOne),
    ribbon = true
    )

p3 = plot!(p1,args...;kwargs...,legend = false,fillalpha = 0,linewidth=2)

plot!(p3,args...;kwargs...,)
