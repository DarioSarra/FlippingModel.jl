using Recombinase, Plots
##
args, kwargs = Recombinase.series2D(
    Recombinase.discrete(FlippingModel.survival),
    b,
    error = :MouseID,
    Recombinase.Group(color = :Protocol, linestyle = :Wall),
    select = (:Omissions_plus_one, :Leave),
    ribbon = true
    )
p1 = plot(args...;
    kwargs...,
    legend = false,
    grid = false,
    thickness_scaling = 2.5,
    tick_orientation = :out,
    size = (809,500),
    linewidth=2,
    fillalpha= 0,
    xlims = (0,16),
    xticks = 1:2:16)
##
savefig(p1,"/Volumes/GoogleDrive/My Drive/Reports for Zach/NewProtocols/Fitting/Survival_from_data.pdf")
##
figures = "/Users/dariosarra/Documents/Lab/Mainen/Presentations/Walton_visit/figures/unprocessed_plots"
savefig(p1,joinpath(figures,"New_data_survival.pdf"))
##
Simulated[!, :Leave] .= true
args, kwargs = series2D(
    Recombinase.discrete(FlippingModel.survival),
    Simulated,
    error = :MouseID,
    Recombinase.Group(color = :Protocol, linestyle = :Wall),
    select = (:simulation, :Leave),
    ribbon = true
    )
p2 = plot!(p1,args...;kwargs...,
    legend = false,
    fillalpha = 0.25,linealpha=0)
##
savefig(p1,"/Volumes/GoogleDrive/My Drive/Reports for Zach/NewProtocols/Fitting/Survival_from_fit.pdf")
##
args, kwargs = series2D(
    Recombinase.discrete(FlippingModel.survival),
    b,
    error = :MouseID,
    Recombinase.Group(color = :Protocol, linestyle = :Wall),
    select = (:Omissions_plus_one, :Leave),
    ribbon = true
    )
p2 = plot!(p1,args...;kwargs...,
    legend = false
    ,fillalpha = 0,linewidth=2)
##
savefig(p1,"/Volumes/GoogleDrive/My Drive/Reports for Zach/NewProtocols/Fitting/Survival_fit.pdf")
##
figures = "/Users/dariosarra/Documents/Lab/Mainen/Presentations/Walton_visit/figures/unprocessed_plots"
savefig(p1,joinpath(figures,"New_data_survival_fit.pdf"))
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
