# This file was generated by the Julia OpenAPI Code Generator
# Do not modify this file directly. Modify the OpenAPI specification instead.


"""
```
DatasetFullGeogLevelsInner(;
    name=nothing,
    description=nothing,
    hasGeogExtentSelection=nothing,
)
```
This function gives the geographical information about data and its description.

# Arguments

- `name::String` - **(Optional)** The dataset identifier 
- `description::String` - **(Optional)** A short description of the dataset
- `hasGeogExtentSelection::Bool` - **(Optional)** boolean indicating if the dataset has geogrphical extent

# Returns

The function returns a `DatasetFullGeogLevelsInner` object with geographic information related to a dataset.
    
# Examples

```julia-repl
julia> IPUMS.DatasetFullGeogLevelsInner(name = "1790_cPop",
                                        description = "1790 Census: Population Data [US, States & Counties]",
                                        hasGeogExtentSelection = 1)

# Output

{
  "name": "1790_cPop",
  "description": "1790 Census: Population Data [US, States & Counties]",
  "hasGeogExtentSelection": true
}

```

# References

To learn more about the `DatasetFullGeogLevelsInner` visit the [IPUMS Developer Docs](https://developer.ipums.org/docs/v2/workflows/explore_metadata/nhgis/datasets )

"""
Base.@kwdef mutable struct DatasetFullGeogLevelsInner <: OpenAPI.APIModel
    name::Union{Nothing, String} = nothing
    description::Union{Nothing, String} = nothing
    hasGeogExtentSelection::Union{Nothing, Bool} = nothing

    function DatasetFullGeogLevelsInner(name, description, hasGeogExtentSelection, )
        OpenAPI.validate_property(DatasetFullGeogLevelsInner, Symbol("name"), name)
        OpenAPI.validate_property(DatasetFullGeogLevelsInner, Symbol("description"), description)
        OpenAPI.validate_property(DatasetFullGeogLevelsInner, Symbol("hasGeogExtentSelection"), hasGeogExtentSelection)
        return new(name, description, hasGeogExtentSelection, )
    end
end # type DatasetFullGeogLevelsInner

const _property_types_DatasetFullGeogLevelsInner = Dict{Symbol,String}(Symbol("name")=>"String", Symbol("description")=>"String", Symbol("hasGeogExtentSelection")=>"Bool", )
OpenAPI.property_type(::Type{ DatasetFullGeogLevelsInner }, name::Symbol) = Union{Nothing,eval(Base.Meta.parse(_property_types_DatasetFullGeogLevelsInner[name]))}

function check_required(o::DatasetFullGeogLevelsInner)
    true
end

function OpenAPI.validate_property(::Type{ DatasetFullGeogLevelsInner }, name::Symbol, val)
end
