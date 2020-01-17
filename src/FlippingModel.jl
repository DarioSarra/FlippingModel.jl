module FlippingModel

using DataDeps, CSV
using DataFrames, ShiftedArrays

include("datadeps.jl")
include("loaddata.jl")
include("bouts.jl")

greet() = print("Hello World!")

end # module
