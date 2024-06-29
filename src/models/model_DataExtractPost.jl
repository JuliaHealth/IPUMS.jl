# This file was generated by the Julia OpenAPI Code Generator
# Do not modify this file directly. Modify the OpenAPI specification instead.


"""
``` 
DataExtractPost(;
    datasets=nothing,
    timeSeriesTables=nothing,
    dataFormat=nothing,
    timeSeriesTableLayout=nothing,
    breakdownAndDataTypeLayout=nothing,
    shapefiles=nothing,
    geographicExtents=nothing,
    description=nothing,
)
```
This function extracts data giving the time series table,the format of the data, the table layout, the shape of the file, its geographic extent and the description 

# Arguments
- `datasets::Dict{String, Dataset}`- An object where each key is the name of the requested dataset and each value is another object describing your selections for that datase
- `timeSeriesTables::Dict{String, TimeSeriesTable}`-An object where each key is the name of the requested time series table and each value is another object describing your selections for that time series table.
- `dataFormat::String`- The requested format of your data
-` timeSeriesTableLayout::String`-  The layout of your time series table data.
- `breakdownAndDataTypeLayout::String`- The layout of your dataset data when multiple data types or breakdown combos are present
- `shapefiles::Vector{String}`- A list of selected shapefiles.
- `geographicExtents::Vector{String}`- A list of geographic_instances to use as extents for all datasets on this request
- `description::String`- A short description of your extract.
# Return 

# Example
OrderedMap { "datasets": OrderedMap { "1790_cPop": OrderedMap { "dataTables": List [ "NT1" ], "geogLevels": List [ "state" ] } }, "timeSeriesTables": OrderedMap { "A00": OrderedMap { "geogLevels": List [ "state" ], "years": List [ "1990" ] } },
  "dataFormat": "csv_no_header","timeSeriesTableLayout": "time_by_row_layout","breakdownAndDataTypeLayout": "","shapefiles": "","geographicExtents": "", "description": "abc" }

# Reference
https://developer.ipums.org/docs/v2/workflows/create_extracts/microdata)
"""
Base.@kwdef mutable struct DataExtractPost <: OpenAPI.APIModel
    datasets::Union{Nothing, Dict} = nothing # spec type: Union{ Nothing, Dict{String, Dataset} }
    timeSeriesTables::Union{Nothing, Dict} = nothing # spec type: Union{ Nothing, Dict{String, TimeSeriesTable} }
    dataFormat::Union{Nothing, String} = nothing
    timeSeriesTableLayout::Union{Nothing, String} = nothing
    breakdownAndDataTypeLayout::Union{Nothing, String} = nothing
    shapefiles::Union{Nothing, Vector{String}} = nothing
    geographicExtents::Union{Nothing, Vector{String}} = nothing
    description::Union{Nothing, String} = nothing

    function DataExtractPost(datasets, timeSeriesTables, dataFormat, timeSeriesTableLayout, breakdownAndDataTypeLayout, shapefiles, geographicExtents, description, )
        OpenAPI.validate_property(DataExtractPost, Symbol("datasets"), datasets)
        OpenAPI.validate_property(DataExtractPost, Symbol("timeSeriesTables"), timeSeriesTables)
        OpenAPI.validate_property(DataExtractPost, Symbol("dataFormat"), dataFormat)
        OpenAPI.validate_property(DataExtractPost, Symbol("timeSeriesTableLayout"), timeSeriesTableLayout)
        OpenAPI.validate_property(DataExtractPost, Symbol("breakdownAndDataTypeLayout"), breakdownAndDataTypeLayout)
        OpenAPI.validate_property(DataExtractPost, Symbol("shapefiles"), shapefiles)
        OpenAPI.validate_property(DataExtractPost, Symbol("geographicExtents"), geographicExtents)
        OpenAPI.validate_property(DataExtractPost, Symbol("description"), description)
        return new(datasets, timeSeriesTables, dataFormat, timeSeriesTableLayout, breakdownAndDataTypeLayout, shapefiles, geographicExtents, description, )
    end
end # type DataExtractPost

const _property_types_DataExtractPost = Dict{Symbol,String}(Symbol("datasets")=>"Dict{String, Dataset}", Symbol("timeSeriesTables")=>"Dict{String, TimeSeriesTable}", Symbol("dataFormat")=>"String", Symbol("timeSeriesTableLayout")=>"String", Symbol("breakdownAndDataTypeLayout")=>"String", Symbol("shapefiles")=>"Vector{String}", Symbol("geographicExtents")=>"Vector{String}", Symbol("description")=>"String", )
OpenAPI.property_type(::Type{ DataExtractPost }, name::Symbol) = Union{Nothing,eval(Base.Meta.parse(_property_types_DataExtractPost[name]))}

function check_required(o::DataExtractPost)
    true
end

function OpenAPI.validate_property(::Type{ DataExtractPost }, name::Symbol, val)
    if name === Symbol("dataFormat")
        OpenAPI.validate_param(name, "DataExtractPost", :enum, val, ["csv_no_header", "csv_header", "fixed_width"])
    end
    if name === Symbol("timeSeriesTableLayout")
        OpenAPI.validate_param(name, "DataExtractPost", :enum, val, ["time_by_column_layout", "time_by_row_layout", "time_by_file_layout"])
    end
    if name === Symbol("breakdownAndDataTypeLayout")
        OpenAPI.validate_param(name, "DataExtractPost", :enum, val, ["separate_files", "single_file"])
    end
end
