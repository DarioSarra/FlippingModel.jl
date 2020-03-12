module FlippingModel

using DataDeps, CSV
using DataFrames, ShiftedArrays
using Optim
using Distributions, StructArrays, StatsBase

export pokes, streaks, process_bouts, fit
export AbstractModel, Log_LikeliHood, params
export PoissonLapseUniform, PoissonLapseExponential

include("datadeps.jl")
include("loaddata.jl")
include("bouts.jl")
include("Models.jl")
include("LogLikeliHood.jl")
include("survival.jl")

greet() = print("Hello World!")

end # module
