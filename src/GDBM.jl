module GDBM

export DBM

using Gdbm_jll

include("types.jl")
include("low_level.jl")
include("dict.jl")

end
