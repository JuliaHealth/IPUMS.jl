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
This function prepares a POST object for delivery to an IPUMS POST endpoint.

# Arguments

- `datasets::Dict{String, Dataset}` - **(Optional)** A dictionary containing a `Dataset` object
- `timeSeriesTables::Dict{String, TimeSeriesTable}` - **(Optional)** A dictionary containing a `TimeSeriesTable` object
- `dataFormat::String` - **(Optional)** a specified data format
- `timeSeriesTableLayout::String` - **(Optional)** The layout of your time series table data.
- `breakdownAndDataTypeLayout::String` - **(Optional)** The layout of your dataset data when multiple data types or breakdown combos are present
- `shapefiles::Vector{String}` - **(Optional)** A list of selected shapefiles
- `geographicExtents::Vector{String}` - **(Optional)** A list of geographic_instances to use as extents for all datasets on this request
- `description::String` - **(Optional)** A short description of the extract.

# Returns

This function returns a `DataExtractPost` object for delivery to an IPUMS POST endpoint.

# Examples

```julia-repl
julia> IPUMS.DataExtractPost(datasets = Dict("1790_cPop" => IPUMS.Dataset(dataTables = ["NT1"],
                                                                        geogLevels = ["place_00498"]),
                                                   "1800_cPop" => IPUMS.Dataset(dataTables = ["NT3"],
                                                                        geogLevels = ["state"])),
                           timeSeriesTables = Dict("A00" => IPUMS.TimeSeriesTable(geogLevels = ["state"]),
                                                   "A03" => IPUMS.TimeSeriesTable(geogLevels = ["state"]) ),
                           dataFormat = "csv_no_header",
                           timeSeriesTableLayout = "time_by_row_layout",
                           shapefiles = ["https://api.ipums.org/downloads/nhgis/api/v1/extracts/1234567/nhgis0007_shape.zip"] ,
                           geographicExtents = ["united states"],
                           description = "abc")

# Output

{                                                                                                                                                  
  "datasets": {                                                                                                                                    
    "1790_cPop": {                                                                                                                                 
      "dataTables": [                                                                                                                              
        "NT1"                                                                                                                                      
      ],                                                                                                                                           
      "geogLevels": [                                                                                                                              
        "place_00498"                                                                                                                              
      ]                                                                                                                                            
    },                                                                                                                                             
    "1800_cPop": {                                                                                                                                 
      "dataTables": [                                                                                                                              
        "NT3"                                                                                                                                      
      ],                                                                                                                                           
      "geogLevels": [
        "state"
      ]
    }
  },
  "timeSeriesTables": {
    "A00": {
      "geogLevels": [
        "state"
      ]
    },
    "A03": {
      "geogLevels": [
        "state"
      ]
    }
  },
  "dataFormat": "csv_no_header",
  "timeSeriesTableLayout": "time_by_row_layout",
  "shapefiles": [
    "https://api.ipums.org/downloads/nhgis/api/v1/extracts/1234567/nhgis0007_shape.zip"
  ],
  "geographicExtents": [
    "united states"
  ],
  "description": "abc"
}

```

# Reference

For additional information on the `DataExtractPost` object, please refer to the [IPUMS Developer Docs](https://developer.ipums.org/docs/v2/workflows/create_extracts/microdata)
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
