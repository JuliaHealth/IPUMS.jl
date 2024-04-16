# This file was generated by the Julia OpenAPI Code Generator
# Do not modify this file directly. Modify the OpenAPI specification instead.


@doc raw"""DataExtractPostResponse

    DataExtractPostResponse(;
        extractDefinition=nothing,
        number=nothing,
        status=nothing,
        downloadLinks=nothing,
    )

    - extractDefinition::DataExtractDefinition
    - number::Int64
    - status::String
    - downloadLinks::DataExtractDownloadLinks
"""
Base.@kwdef mutable struct DataExtractPostResponse <: OpenAPI.APIModel
    extractDefinition = nothing # spec type: Union{ Nothing, DataExtractDefinition }
    number::Union{Nothing, Int64} = nothing
    status::Union{Nothing, String} = nothing
    downloadLinks = nothing # spec type: Union{ Nothing, DataExtractDownloadLinks }

    function DataExtractPostResponse(extractDefinition, number, status, downloadLinks, )
        OpenAPI.validate_property(DataExtractPostResponse, Symbol("extractDefinition"), extractDefinition)
        OpenAPI.validate_property(DataExtractPostResponse, Symbol("number"), number)
        OpenAPI.validate_property(DataExtractPostResponse, Symbol("status"), status)
        OpenAPI.validate_property(DataExtractPostResponse, Symbol("downloadLinks"), downloadLinks)
        return new(extractDefinition, number, status, downloadLinks, )
    end
end # type DataExtractPostResponse

const _property_types_DataExtractPostResponse = Dict{Symbol,String}(Symbol("extractDefinition")=>"DataExtractDefinition", Symbol("number")=>"Int64", Symbol("status")=>"String", Symbol("downloadLinks")=>"DataExtractDownloadLinks", )
OpenAPI.property_type(::Type{ DataExtractPostResponse }, name::Symbol) = Union{Nothing,eval(Base.Meta.parse(_property_types_DataExtractPostResponse[name]))}

function check_required(o::DataExtractPostResponse)
    true
end

function OpenAPI.validate_property(::Type{ DataExtractPostResponse }, name::Symbol, val)
    if name === Symbol("number")
        OpenAPI.validate_param(name, "DataExtractPostResponse", :format, val, "int64")
    end
end
