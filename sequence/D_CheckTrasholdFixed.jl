using GLM
model = lm(@formula(r ~ Protocol + Wall),comp)
nullmodel = lm(@formula(r ~ Protocol ),comp)
F1 = ftest(nullmodel.model, model.model)

model = lm(@formula(r ~ Protocol + Wall),comp)
nullmodel = lm(@formula(r ~ Wall ),comp)
ftest(nullmodel.model, model.model)

model = lm(@formula(T ~ Protocol + Wall),comp)
nullmodel = lm(@formula(T ~ Protocol ),comp)
ftest(nullmodel.model, model.model)

model = lm(@formula(T ~ Protocol + Wall),comp)
nullmodel = lm(@formula(T ~ Wall ),comp)
ftest(nullmodel.model, model.model)

###

model = lm(@formula(lapse ~ Protocol + Wall),comp)
nullmodel = lm(@formula(lapse ~ Protocol ),comp)
ftest(nullmodel.model, model.model)

model = lm(@formula(lapse ~ Protocol + Wall),comp)
nullmodel = lm(@formula(lapse ~ Wall ),comp)
ftest(nullmodel.model, model.model)
##
Rate_model = lm(@formula(r ~ 1 + Protocol + Wall),comp);
Rate_nullmodel = lm(@formula(r ~ 1 ),comp);
Rate_F = ftest(Rate_nullmodel.model, Rate_model.model);
##
Tresh_model = lm(@formula(T ~ 1 + Protocol + Wall),comp);
Tresh_nullmodel = lm(@formula(T ~ 1 ),comp);
Tresh_F = ftest(Tresh_nullmodel.model, Tresh_model.model);
##
Lapse_model = lm(@formula(lapse ~ 1 + Protocol + Wall),comp);
Lapse_nullmodel = lm(@formula(lapse ~ 1 ),comp);
Lapse_F = ftest(Lapse_nullmodel.model, Lapse_model.model);
##
args, kwargs = series2D(
    Recombinase.discrete(Recombinase.prediction),
    comp,
    Recombinase.Group(color = :Wall),
    select = (:Protocol, :r)
    )
scatter(args...;kwargs...,
    annotate =(0.8,3,text("F-test: p < 10^-7",6,:black,:center)),
    grid = false,
    linewidth = 2.5,
    markersize = 8,
    thickness_scaling = 2.5,
    tick_orientation = :out,
    size = (809,500),
    legend = false)
#scatter!(args...;kwargs...,markersize = 8,legend = false)
##
savefig("/Volumes/GoogleDrive/My Drive/Reports for Zach/NewProtocols/Fitting/rate_modulation.pdf")
##
figures = "/Users/dariosarra/Documents/Lab/Mainen/Presentations/Walton_visit/figures/unprocessed_plots"
savefig(joinpath(figures,"Rate_scatter.pdf"))
##
args, kwargs = series2D(
    Recombinase.discrete(Recombinase.prediction),
    comp,
    Recombinase.Group(color = :Wall),
    select = (:Protocol, :T)
    )
scatter(args...;kwargs...,
    annotate =(0.8,8.7,text("F-test: p = 0.3991",6,:black,:center)),
    grid = false,
    linewidth = 2.5,
    markersize = 8,
    thickness_scaling = 2.5,
    tick_orientation = :out,
    size = (809,500),
    legend = false)
# scatter!(args...;kwargs...,markersize = 8,legend = false)
##
figures = "/Users/dariosarra/Documents/Lab/Mainen/Presentations/Walton_visit/figures/unprocessed_plots"
savefig(joinpath(figures,"Threshold_scatter.pdf"))
##
savefig("/Volumes/GoogleDrive/My Drive/Reports for Zach/NewProtocols/Fitting/tresh_modulation.pdf")
##
args, kwargs = series2D(
    Recombinase.discrete(Recombinase.prediction),
    comp,
    Recombinase.Group(color = :Wall),
    select = (:Protocol, :lapse)
    )
scatter(args...;kwargs...,
    annotate =(0.8,0.095,text("F-test: p = 0.9067",6,:black,:center)),
    grid = false,
    linewidth = 2.5,
    markersize = 8,
    thickness_scaling = 2.5,
    tick_orientation = :out,
    size = (809,500),
    legend = false)
#scatter!(args...;kwargs...,markersize = 8,legend = false)
##
figures = "/Users/dariosarra/Documents/Lab/Mainen/Presentations/Walton_visit/figures/unprocessed_plots"
savefig(joinpath(figures,"Lapse_scatter.pdf"))
##
savefig("/Volumes/GoogleDrive/My Drive/Reports for Zach/NewProtocols/Fitting/lapse_modulation.pdf")
