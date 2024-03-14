module IPUMS

import Base:
    @kwdef

using DataFrames
using HTTP

include("structs.jl")
include("constants.jl")
include("helpers.jl")

end
