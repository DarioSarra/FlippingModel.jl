
include("datalinks.jl")
register(DataDep("PokesWildTypes",
    """
    Dataset: Hidden state foraging task, interleaved barrier, pokes WT.
    Author: Sarra et. al. (Champalimaud Research)
    """,
    pokespath,
    "a5ef1b92cd5593811e3a89a2304e7d7662056c4c1b5890b8522d218b2bf0ee15",
    post_fetch_method = x -> mv(x, x*".csv")
));

const PokesDatasetFolder = datadep"PokesWildTypes"

register(DataDep("StreaksWildTypes",
    """
    Dataset: Hidden state foraging task, interleaved barrier, streaks WT.
    Author: Sarra et. al. (Champalimaud Research)
    """,
    streakspath,
    "9693c801d5069c8c09ea3836b17e0003b207c5dd9a16bf339cb05cad71024026",
    post_fetch_method = x -> mv(x, x*".csv")
));

const StreaksDatasetFolder = datadep"StreaksWildTypes"
