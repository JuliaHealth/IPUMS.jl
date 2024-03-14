"""
```julia
IPUMSSource(
    proj_name::String, 
    url_name::String, 
    collection_type::String, 
    code_for_api::String = "", 
    api_support::Bool = false, 
    home_url::String = ""
)
```

A struct representing sources that IPUMS provides.

# Arguments

- `proj_name::String` - Name of the IPUMS project.
- `url_name::String` - Name of the project as used in that project's website URL.
- `collection_type::String` - Either `"microdata"` or `"aggregate data"` indicating the type of data this collection provides.

# Keyword Arguments

- `code_for_api::String` - The name of the project used when interacting with the IPUMS API (for collections that are supported by the API). (Default: `""`)
- `api_support::Bool` - Logical indicating whether the collection is supported by the IPUMS API. (Default: `false`)
- `home_url::String` - URL for the project's homepage. (Default: `""`)

# Returns

- `IPUMSSource` object specifying the previous parameters

# Example

```julia-repl
julia> IPUMSSource(
    proj_name = "IPUMS USA",
    url_name = "usa",
    collection_type = "microdata",
    api_support = true
)

IPUMS.IPUMSSource("IPUMS USA", "usa", "microdata", "", true, "")
```
"""
@kwdef struct IPUMSSource
        proj_name::String
        url_name::String
        collection_type::String
        code_for_api::String = ""
        api_support::Bool = false
        home_url::String = ""
        IPUMSSource(proj_name::String, url_name::String, collection_type::String, code_for_api::String, api_support::Bool, home_url::String) = new(proj_name, url_name, collection_type, code_for_api, api_support, home_url)
end
