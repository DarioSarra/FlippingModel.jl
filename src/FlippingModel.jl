module FlippingModel

using DataDeps, CSV
using DataFrames, ShiftedArrays
using Optim
using Distributions, StructArrays, StatsBase

export pokes, streaks, process_bouts, fit

include("datadeps.jl")
include("loaddata.jl")
include("bouts.jl")
include("LogLikeliHood.jl")
include("Models.jl")

greet() = print("Hello World!")

end # module
