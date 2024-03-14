"""
`ipums_data_collections()`

List IPUMS data collections with their corresponding codes used by the IPUMS API. 
Unlisted data collections are not yet supported by the IPUMS API. 

# Returns

- `DataFrame` with four columns containing the full collection name, the type of data the collection provides, the collection code used by the IPUMS API, and the status of API support for the collection.

# Example

```julia-repl
julia> ipums_data_collections()

 Row │ collection_name      collection_type  code_for_api  api_support 
     │ String               String           String        Bool        
─────┼─────────────────────────────────────────────────────────────────
   1 │ IPUMS USA            microdata                             true
   2 │ IPUMS CPS            microdata                             true
   3 │ IPUMS International  microdata        ipumsi               true
   ...
```
"""
function ipums_data_collections() 
    DataFrame(
        :collection_name => [s.proj_name for s in ipums_sources],
        :collection_type => [s.collection_type for s in ipums_sources],
        :code_for_api => [s.code_for_api for s in ipums_sources],
        :api_support => [s.api_support for s in ipums_sources],
    )
end

export ipums_data_collections
