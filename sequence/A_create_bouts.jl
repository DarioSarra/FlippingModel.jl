using Revise
using FlippingModel
using DataFrames, Optim
# using BrowseTables
using Test
import Distributions: pdf


pokes
names(pokes)
pokes[!,:Leave] = Vector{Union{Missing,Bool}}(missing,length(pokes.Side))
pokes[!,:Bout] .= 0
bouts = by(pokes, :Session) do dd
    process_bouts(dd)
end

b = filter(bouts) do row
    !ismissing(row.Leave) &&
    row.Correct_start &&
    row.Start_Reward &&
    row.Streak > 10 &&
    3 < row.Streak_within_Block < 23 &&
    row.ReverseStreak > 20 &&
    (ismissing(row.Pre_Interpoke) || row.Pre_Interpoke < 1) &&
    !ismissing(row.Leave) &&
    row.Protocol_Day > 1 &&
    row.Day > 20191215
end
disallowmissing!(b, :Leave)
# open_html_table(b[end-100:end,:])
