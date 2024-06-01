module IPUMS

    import Base:
        @kwdef
    import Downloads:
        download as dl
    import OpenAPI.Clients: 
        Client

    using DataFrames: 
        DataFrames, 
        DataFrame, 
        colmetadata!, 
        metadata, 
        metadata!
    using EzXML: 
        EzXML
    using HTTP: 
        HTTP
    using JSON3: 
        JSON3
    using OpenAPI: 
        OpenAPI
    using StaticArrays:
        @SVector, SVector
    #= 

    Scripts used across whole of package

    =#
    
    include("structs.jl")
    include("constants.jl")
    include("helpers.jl")

    #=
    
    This information was auto-generated by the OpenAPI spec and 
    subsequently better incorporated into the whole of the package

    =# 

    const API_VERSION = "v2"

    include("modelincludes.jl")
    include("apis/api_IPUMSAPI.jl")
    include("piracy.jl")


    include("extracts.jl")

    #= 
    
    Parsers

    =#

    include("parsers/ddi_parser.jl")

    #=
    
    Exports

    =#

    export IPUMSAPI
    export parse_ddi
    export extract_download
    export load_ipums_extract
    export load_ipums_extract_v2
end
