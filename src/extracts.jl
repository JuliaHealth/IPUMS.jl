"""
```julia
function extract_download(
    api::IPUMSAPI, 
    extract_number::Int, 
    collection::String; 
    output_path::String = pwd(), 
    codebook_name::String = nothing, 
    table_data_name::String = nothing, 
    gis_data_name::String = nothing, 
    codebook::Bool = true, 
    table_data::Bool = true, 
    gis_data::Bool = true
)
```

Download files associated with a given IPUMS data extract.

### Arguments

- `api::IPUMSAPI` -- An `IPUMSAPI` object to establish connection details.

- `extract_number::Int` -- extract ID assigned to the IPUMS data extract.

- `collection::String` -- What IPUMS collection to be queried for the extract (options could include `"nhgis"`, `"usa"`, etc. corresponding to IPUMS NHGIS or NHGIS USA databases).

### Keyword Arguments

- `output_path::String` -- The path (location on computer) to output all downloaded files (Default: current working directory).

- `codebook_name::String` -- What the name of the codebook file should be (Default: `nothing).

- `table_data_name::String` -- What the name of the table data file should be (Default: `nothing).

- `gis_data_name::String` -- What the name of the GIS file should be (Default: `nothing).

- `codebook::Bool` -- `true` to download the codebook file for the extract; `false` to not download it (Default: `true`)

- `table_data::Bool` -- `true` to download the table data file for the extract; `false` to not download it (Default: `true`)

- `gis_data::Bool` -- `true` to download the GIS file for the extract; `false` to not download it (Default: `true`)

### Returns

The path (location on computer) where the files were downloaded to. 

# Examples

```julia-repl
julia> extract_download(api, 1, "nhgis"; output_path = "file_downloads/", codebook = false, gis_data_name = "GIS_1", table_data_name = "DATA_1")
[ Info: Table data for Extract 1 downloaded to file_downloads/DATA_1.zip.
[ Info: GIS data for Extract 1 downloaded to file_downloads/DATA_1.zip.
"file_downloads/"
```

"""
function extract_download(
    api, 
    extract_number, 
    collection; 
    output_path = pwd(), 
    codebook_name = nothing, 
    table_data_name = nothing, 
    gis_data_name = nothing, 
    codebook = true, 
    table_data = true, 
    gis_data = true
)
    
    metadata, defn, _ = extract_info(api, extract_number, collection)
    links = metadata["downloadUrls"]

    isempty(links) && return nothing

    if codebook
        link = links["codebookPreview"] 
        codebook_name = isnothing(codebook_name) ? basename(link) : codebook_name * ".zip"
        dl(link, joinpath(output_path, codebook_name); headers = api.client.headers)
        @info "Codebook for Extract $(extract_number) downloaded to $(joinpath(output_path, codebook_name))."
    end
    if table_data 
        link = links["tableData"] 
        table_data_name = isnothing(table_data_name) ? basename(link) : table_data_name * ".zip"
        dl(link, joinpath(output_path, table_data_name); headers = api.client.headers)
        @info "Table data for Extract $(extract_number) downloaded to $(joinpath(output_path, table_data_name))."
    end
    if gis_data 
        link = links["gisData"] 
        gis_data_name = isnothing(gis_data_name) ? basename(link) : gis_data_name * ".zip"
        dl(link, joinpath(output_path, gis_data_name); headers = api.client.headers)
        @info "GIS data for Extract $(extract_number) downloaded to $(joinpath(output_path, table_data_name))."
    end

    return output_path

end

export extract_download
