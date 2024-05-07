# This file was generated by the Julia OpenAPI Code Generator
# Do not modify this file directly. Modify the OpenAPI specification instead.


@doc raw"""TimeSeriesTable

    TimeSeriesTable(;
        geogLevels=nothing,
        years=nothing,
    )

    - geogLevels::Vector{String}
    - years::Vector{String}
"""
Base.@kwdef mutable struct TimeSeriesTable <: OpenAPI.APIModel
    geogLevels::Union{Nothing, Vector{String}} = nothing
    years::Union{Nothing, Vector{String}} = nothing

    function TimeSeriesTable(geogLevels, years, )
        OpenAPI.validate_property(TimeSeriesTable, Symbol("geogLevels"), geogLevels)
        OpenAPI.validate_property(TimeSeriesTable, Symbol("years"), years)
        return new(geogLevels, years, )
    end
end # type TimeSeriesTable

const _property_types_TimeSeriesTable = Dict{Symbol,String}(Symbol("geogLevels")=>"Vector{String}", Symbol("years")=>"Vector{String}", )
OpenAPI.property_type(::Type{ TimeSeriesTable }, name::Symbol) = Union{Nothing,eval(Base.Meta.parse(_property_types_TimeSeriesTable[name]))}

function check_required(o::TimeSeriesTable)
    o.geogLevels === nothing && (return false)
    true
end

function OpenAPI.validate_property(::Type{ TimeSeriesTable }, name::Symbol, val)
end
