
function extract_download(api, extract_id, collection; output_path = pwd(), codebook_name = nothing, table_data_name = nothing, gis_data_name = nothing, codebook = true, table_data = true, gis_data = true)
    info = extract_info(api, extract_id, collection, "2")
    links = info[1].downloadLinks
    #= 

    BUG: Parsing of extract info fails more or less.
    Need to find out why.

    =#
    if codebook
        link = links.codebookPreview |> JSON3.read |> x -> x["url"]
        codebook_name = isnothing(codebook_name) ? basename(link) : codebook_name
        dl(link, joinpath(output_path, codebook_name); headers = api.client.headers)
        @info "Codebook for Extract $(extract_id) downloaded to $(joinpath(output_path, codebook_name))."
    end
    if table_data 
        link = links.tableData |> JSON3.read |> x -> x["url"]
        table_data_name = isnothing(table_data_name) ? basename(link) : table_data_name
        dl(link, joinpath(output_path, table_data_name); headers = api.client.headers)
        @info "Table data for Extract $(extract_id) downloaded to $(joinpath(output_path, table_data_name))."
    end
    if gis_data 
        link = links.gisData |> JSON3.read |> x -> x["url"]
        gis_data_name = isnothing(gis_data_name) ? basename(link) : gis_data_name
        dl(link, joinpath(output_path, gis_data_name); headers = api.client.headers)
        @info "GIS data for Extract $(extract_id) downloaded to $(joinpath(output_path, table_data_name))."
    end
end
