module FlippingModel

using DataDeps, CSV
using DataFrames, ShiftedArrays
using Distributions, StructArrays, StatsBase

include("datadeps.jl")
include("loaddata.jl")
include("bouts.jl")
include("LogLikeliHood.jl")

greet() = print("Hello World!")

end # module
