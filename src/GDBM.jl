module GDBM

export DBM

include(joinpath("..", "deps", "deps.jl")

__init__() = check_deps()

include("types.jl")
include("low_level.jl")
include("dict.jl")

end
