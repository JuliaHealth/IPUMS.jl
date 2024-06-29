# This file was generated by the Julia OpenAPI Code Generator
# Do not modify this file directly. Modify the OpenAPI specification instead.


"""

```
DataExtract(;
    extractDefinition=nothing,
    number=nothing,
    status=nothing,
    downloadLinks=nothing,
)
```
This function  extracts data given the 
# Arguments

- `extractDefinition::DataExtractDefinition`- Definition of the extracted data
- `number::Int64`-
- `status::String`- Status of the data extraction
- `downloadLinks::DataExtractDownloadLinks`- Download link for the extracted data

# Return
It returns the definition and the data with their download status and the link

# Example
 OrderedMap { "extractDefinition": OrderedMap { "datasets": OrderedMap { "1790_cPop": OrderedMap { "dataTables": List [ "NT1" ], "geogLevels": List [ "place_00498" ] }, "1800_cPop": OrderedMap { "dataTables": List [ "NT3" ], "geogLevels": List [ "state" ] } }, "timeSeriesTables": OrderedMap { "A00": OrderedMap { "geogLevels": List [ "state" ] } }, "timeSeriesTableLayout": "time_by_row_layout", "dataFormat": "csv_no_header", "description": "abc", "version": 2, "collection": "nhgis" },
  "number": 2, "status": "complete", "downloadLinks": OrderedMap { "codebookPreview": "https://api.ipums.org/downloads/nhgis/api/v1/extracts/1234567/nhgis0007_csv_PREVIEW.zip", "tableData": "https://api.ipums.org/downloads/nhgis/api/v1/extracts/1234567/nhgis0007_csv.zip",
  "gisData": "https://api.ipums.org/downloads/nhgis/api/v1/extracts/1234567/nhgis0007_shape.zip" } }
# Reference
To find out more about the DataExtract type visit the [Reference page of IPUMS API DataExtract](https://developer.ipums.org/docs/v2/workflows/create_extracts/microdata)
"""
Base.@kwdef mutable struct DataExtract <: OpenAPI.APIModel
    extractDefinition = nothing # spec type: Union{ Nothing, DataExtractDefinition }
    number::Union{Nothing, Int64} = nothing
    status::Union{Nothing, String} = nothing
    downloadLinks = nothing # spec type: Union{ Nothing, DataExtractDownloadLinks }

    function DataExtract(extractDefinition, number, status, downloadLinks, )
        OpenAPI.validate_property(DataExtract, Symbol("extractDefinition"), extractDefinition)
        OpenAPI.validate_property(DataExtract, Symbol("number"), number)
        OpenAPI.validate_property(DataExtract, Symbol("status"), status)
        OpenAPI.validate_property(DataExtract, Symbol("downloadLinks"), downloadLinks)
        return new(extractDefinition, number, status, downloadLinks, )
    end
end # type DataExtract

const _property_types_DataExtract = Dict{Symbol,String}(Symbol("extractDefinition")=>"DataExtractDefinition", Symbol("number")=>"Int64", Symbol("status")=>"String", Symbol("downloadLinks")=>"DataExtractDownloadLinks", )
OpenAPI.property_type(::Type{ DataExtract }, name::Symbol) = Union{Nothing,eval(Base.Meta.parse(_property_types_DataExtract[name]))}

function check_required(o::DataExtract)
    true
end

function OpenAPI.validate_property(::Type{ DataExtract }, name::Symbol, val)
    if name === Symbol("number")
        OpenAPI.validate_param(name, "DataExtract", :format, val, "int64")
    end
end
