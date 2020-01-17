function detect_leave(x,tipo)
    if tipo == :has_left
        v = x .!= lag(x)
        v[1] = false
    elseif tipo == :will_leave
        v = lead(x) .!= x
    end
    return v
end

function count_bout(rewards,side)
    sidechanges = detect_leave(side,:has_left)
    v = Vector{Int64}(undef,length(rewards))
    c = 1
    for i =1:length(rewards)
        if  rewards[i] || sidechanges[i]
            c = c+1
        end
        v[i] = c
    end
    return v
end


function process_bouts(df::DataFrames.AbstractDataFrame)
    #df[!,:sidechange] = df.Side .!= lag(df.Side)
    df[:,:Leave] = lead(df.Side) .!= df.Side
    #df.sidechange[1] = false
    df[:,:Bout] = count_bout(df.Reward,df.Side)
    #df[!,:Omissions_plus_one].=0
    dayly_vars_list = [:Session, :MouseID, :Day, :Daily_Session, :Box,:Protocol];
    bout_table = by(df, :Bout) do dd
        dt = DataFrame(
        Omissions_plus_one = size(dd,1),
        Leave = dd[end,:Leave],
        Start_Reward = dd[1,:Reward],
        Side = dd[1,:Side],
        Trial_duration = (dd[end,:PokeOut]-dd[1,:PokeIn]),
        Pre_Interpoke = size(dd,1) > 1 ? maximum(skipmissing(dd[!,:Pre_Interpoke])) : missing,
        Post_Interpoke = size(dd,1) > 1 ? maximum(skipmissing(dd[!,:Post_Interpoke])) : missing,
        Wall = dd[1,:Wall],
        Correct_start = dd[1,:Correct],
        Correct_leave = !dd[end,:Correct],
        Block = dd[1,:Block],
        Streak_within_Block = dd[1,:Streak_within_Block],
        Streak = dd[1,:Streak],
        ReverseStreak = dd[1,:ReverseStreak]
        )
        for s in dayly_vars_list
            if s in names(df)
                dt[!,s] .= df[1, s]
            end
        end
        return dt
    end
    return bout_table
end
