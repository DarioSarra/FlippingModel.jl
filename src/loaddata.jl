using CSV
include("datadeps.jl")

function loaddep(dir)
    fn = first(readdir(dir))
    return CSV.read(joinpath(dir, fn))
end

pokes = loaddep(PokesDatasetPath)
streaks = loaddep(StreaksDatasetPath)
