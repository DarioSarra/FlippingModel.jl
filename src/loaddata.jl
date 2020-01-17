function loaddep(dir)
    fn = first(readdir(dir))
    return CSV.read(joinpath(dir, fn), missingstring="NA")
end

pokes = loaddep(PokesDatasetFolder)
streaks = loaddep(StreaksDatasetFolder)
#
# println(names(pokes))
# t = pokes[1,:Session]
# pokes.Reward
# sort(pokes, :Poke)
#
# function minibout(sides)
#     # check if animal changed side and count consecutive omissions
#     s = findfirst(t -> t != sides[1], sides)
#     return if isnothing(s)
#         (omissionsplusone = length(sides), leaves = false)
#     else
#         # we discard the rest of the data which are the beginning of the next streak (if doesn't start with a reward)
#         (omissionsplusone = s-1, leaves = true)
#     end
# end
#
# function only(v)
#     s = first(v)
#     @assert all(==(s), v)
#     return s
# end
#
# function bouts(session, carry = [:MouseID]; IPIthreshold = 1)
#     sorted = sort(session, :Poke)
#     sorted.RewardCount = cumsum(sorted.Reward)
#     sorted.IPI = sorted.PokeIn .- lag(sorted.PokeOut)
#     fs = filter(row -> row.RewardCount >= 1, sorted) #discard omissions before first reward
#     bts = by(fs, :RewardCount, :Side => minibout)
#     extra_vars = Dict{Symbol, Any}(c => c => only for c in carry)
#     extra_vars[:MaxIPI] = (:Pre_Interpoke, :Side) => function (nt)
#         ipis, sides = nt.Pre_Interpoke, nt.Side
#         acc = missing
#         t = first(sides)
#         for (ipi, side) in zip(ipis, sides)
#             side != t && break
#             if ismissing(acc) && !isi || !ismis
#         findfirst(t -> !ismissing(t) && t > IPIthreshold, ipis)
#     extra_info = by(fs, :RewardCount; extra_vars...) # add info from columns in carry
#     data = join(bts, extra_info, on = :RewardCount)
#     filter(row -> isnothing(row.LongIPI) || row.LongIPI)
# end
#
# by(pokes, :Session) do dd
#     bouts(dd, [:MouseID, :Protocol, :Wall, :Streak, :Date])
# end
#
# bouts(filter(row -> row.Session == t, pokes), [:MouseID])
# extra_info = Dict(c => c => first for c in [:MouseID])
# by(pokes, :Session; extra_info...)
#
# pokes.Pre_Interpoke
