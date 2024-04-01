# This file was generated by the Julia OpenAPI Code Generator
# Do not modify this file directly. Modify the OpenAPI specification instead.

struct DefaultApi <: OpenAPI.APIClientImpl
    client::OpenAPI.Clients.Client
end

"""
The default API base path for APIs in `DefaultApi`.
This can be used to construct the `OpenAPI.Clients.Client` instance.
"""
basepath(::Type{ DefaultApi }) = "https://api.ipums.org"

const _returntypes_extracts_extract_number_get_DefaultApi = Dict{Regex,Type}(
    Regex("^" * replace("200", "x"=>".") * "\$") => DataExtract,
)

function _oacinternal_extracts_extract_number_get(_api::DefaultApi, extract_number::Int64, collection::String, version::String; _mediaType=nothing)
    _ctx = OpenAPI.Clients.Ctx(_api.client, "GET", _returntypes_extracts_extract_number_get_DefaultApi, "/extracts/{extractNumber}", ["APIKeyHeader", ])
    OpenAPI.Clients.set_param(_ctx.path, "extractNumber", extract_number)  # type Int64
    OpenAPI.Clients.set_param(_ctx.query, "collection", collection)  # type String
    OpenAPI.Clients.set_param(_ctx.query, "version", version)  # type String
    OpenAPI.Clients.set_header_accept(_ctx, ["application/json", ])
    OpenAPI.Clients.set_header_content_type(_ctx, (_mediaType === nothing) ? [] : [_mediaType])
    return _ctx
end

@doc raw"""Get a specific data extract.

Params:
- extract_number::Int64 (required)
- collection::String (required)
- version::String (required)

Return: DataExtract, OpenAPI.Clients.ApiResponse
"""
function extracts_extract_number_get(_api::DefaultApi, extract_number::Int64, collection::String, version::String; _mediaType=nothing)
    _ctx = _oacinternal_extracts_extract_number_get(_api, extract_number, collection, version; _mediaType=_mediaType)
    return OpenAPI.Clients.exec(_ctx)
end

function extracts_extract_number_get(_api::DefaultApi, response_stream::Channel, extract_number::Int64, collection::String, version::String; _mediaType=nothing)
    _ctx = _oacinternal_extracts_extract_number_get(_api, extract_number, collection, version; _mediaType=_mediaType)
    return OpenAPI.Clients.exec(_ctx, response_stream)
end

const _returntypes_extracts_get_DefaultApi = Dict{Regex,Type}(
    Regex("^" * replace("200", "x"=>".") * "\$") => Vector{DataExtract},
)

function _oacinternal_extracts_get(_api::DefaultApi, collection::String, version::String; page_number=nothing, page_size=nothing, _mediaType=nothing)
    _ctx = OpenAPI.Clients.Ctx(_api.client, "GET", _returntypes_extracts_get_DefaultApi, "/extracts", ["APIKeyHeader", ])
    OpenAPI.Clients.set_param(_ctx.query, "collection", collection)  # type String
    OpenAPI.Clients.set_param(_ctx.query, "version", version)  # type String
    OpenAPI.Clients.set_param(_ctx.query, "pageNumber", page_number)  # type Int64
    OpenAPI.Clients.set_param(_ctx.query, "pageSize", page_size)  # type Int64
    OpenAPI.Clients.set_header_accept(_ctx, ["application/json", ])
    OpenAPI.Clients.set_header_content_type(_ctx, (_mediaType === nothing) ? [] : [_mediaType])
    return _ctx
end

@doc raw"""Get a list of recent data extracts.

Params:
- collection::String (required)
- version::String (required)
- page_number::Int64
- page_size::Int64

Return: Vector{DataExtract}, OpenAPI.Clients.ApiResponse
"""
function extracts_get(_api::DefaultApi, collection::String, version::String; page_number=nothing, page_size=nothing, _mediaType=nothing)
    _ctx = _oacinternal_extracts_get(_api, collection, version; page_number=page_number, page_size=page_size, _mediaType=_mediaType)
    return OpenAPI.Clients.exec(_ctx)
end

function extracts_get(_api::DefaultApi, response_stream::Channel, collection::String, version::String; page_number=nothing, page_size=nothing, _mediaType=nothing)
    _ctx = _oacinternal_extracts_get(_api, collection, version; page_number=page_number, page_size=page_size, _mediaType=_mediaType)
    return OpenAPI.Clients.exec(_ctx, response_stream)
end

const _returntypes_extracts_post_DefaultApi = Dict{Regex,Type}(
    Regex("^" * replace("200", "x"=>".") * "\$") => DataExtractPostResponse,
)

function _oacinternal_extracts_post(_api::DefaultApi, collection::String, version::String; data_extract_post=nothing, _mediaType=nothing)
    _ctx = OpenAPI.Clients.Ctx(_api.client, "POST", _returntypes_extracts_post_DefaultApi, "/extracts", ["APIKeyHeader", ], data_extract_post)
    OpenAPI.Clients.set_param(_ctx.query, "collection", collection)  # type String
    OpenAPI.Clients.set_param(_ctx.query, "version", version)  # type String
    OpenAPI.Clients.set_header_accept(_ctx, ["application/json", ])
    OpenAPI.Clients.set_header_content_type(_ctx, (_mediaType === nothing) ? ["application/json", ] : [_mediaType])
    return _ctx
end

@doc raw"""Create a data extract

Params:
- collection::String (required)
- version::String (required)
- data_extract_post::DataExtractPost

Return: DataExtractPostResponse, OpenAPI.Clients.ApiResponse
"""
function extracts_post(_api::DefaultApi, collection::String, version::String; data_extract_post=nothing, _mediaType=nothing)
    _ctx = _oacinternal_extracts_post(_api, collection, version; data_extract_post=data_extract_post, _mediaType=_mediaType)
    return OpenAPI.Clients.exec(_ctx)
end

function extracts_post(_api::DefaultApi, response_stream::Channel, collection::String, version::String; data_extract_post=nothing, _mediaType=nothing)
    _ctx = _oacinternal_extracts_post(_api, collection, version; data_extract_post=data_extract_post, _mediaType=_mediaType)
    return OpenAPI.Clients.exec(_ctx, response_stream)
end

const _returntypes_metadata_nhgis_data_tables_get_DefaultApi = Dict{Regex,Type}(
    Regex("^" * replace("200", "x"=>".") * "\$") => DataTableFull,
)

function _oacinternal_metadata_nhgis_data_tables_get(_api::DefaultApi, version::String; page_number=nothing, page_size=nothing, _mediaType=nothing)
    _ctx = OpenAPI.Clients.Ctx(_api.client, "GET", _returntypes_metadata_nhgis_data_tables_get_DefaultApi, "/metadata/nhgis/data_tables", ["APIKeyHeader", ])
    OpenAPI.Clients.set_param(_ctx.query, "version", version)  # type String
    OpenAPI.Clients.set_param(_ctx.query, "pageNumber", page_number)  # type Int64
    OpenAPI.Clients.set_param(_ctx.query, "pageSize", page_size)  # type Int64
    OpenAPI.Clients.set_header_accept(_ctx, ["application/json", ])
    OpenAPI.Clients.set_header_content_type(_ctx, (_mediaType === nothing) ? [] : [_mediaType])
    return _ctx
end

@doc raw"""List all data_tables

Params:
- version::String (required)
- page_number::Int64
- page_size::Int64

Return: DataTableFull, OpenAPI.Clients.ApiResponse
"""
function metadata_nhgis_data_tables_get(_api::DefaultApi, version::String; page_number=nothing, page_size=nothing, _mediaType=nothing)
    _ctx = _oacinternal_metadata_nhgis_data_tables_get(_api, version; page_number=page_number, page_size=page_size, _mediaType=_mediaType)
    intermediate = OpenAPI.Clients.exec(_ctx)[2]
    HTTP.request(_ctx.method, intermediate.raw.url, _ctx.header) |>
        x -> String(x.body) |> 
        JSON3.read |> 
        x -> [DataTableFull(d.name, 
                            d.nhgisCode,
                            d.description,
                            d.universe,
                            d.sequence,
                            d.datasetName,
                            [d.nVariables])
              for d in x[:data]]

    # NOTE: I had to manually do a hack here to get this working
end

function metadata_nhgis_data_tables_get(_api::DefaultApi, response_stream::Channel, version::String; page_number=nothing, page_size=nothing, _mediaType=nothing)
    _ctx = _oacinternal_metadata_nhgis_data_tables_get(_api, version; page_number=page_number, page_size=page_size, _mediaType=_mediaType)
    return OpenAPI.Clients.exec(_ctx, response_stream)
end

const _returntypes_metadata_nhgis_datasets_dataset_data_tables_data_table_get_DefaultApi = Dict{Regex,Type}(
    Regex("^" * replace("200", "x"=>".") * "\$") => DataTableFull,
)

function _oacinternal_metadata_nhgis_datasets_dataset_data_tables_data_table_get(_api::DefaultApi, dataset::String, data_table::String, version::String; _mediaType=nothing)
    _ctx = OpenAPI.Clients.Ctx(_api.client, "GET", _returntypes_metadata_nhgis_datasets_dataset_data_tables_data_table_get_DefaultApi, "/metadata/nhgis/datasets/{dataset}/data_tables/{dataTable}", ["APIKeyHeader", ])
    OpenAPI.Clients.set_param(_ctx.path, "dataset", dataset)  # type String
    OpenAPI.Clients.set_param(_ctx.path, "dataTable", data_table)  # type String
    OpenAPI.Clients.set_param(_ctx.query, "version", version)  # type String
    OpenAPI.Clients.set_header_accept(_ctx, ["application/json", ])
    OpenAPI.Clients.set_header_content_type(_ctx, (_mediaType === nothing) ? [] : [_mediaType])
    return _ctx
end

@doc raw"""Detailed data table view

Params:
- dataset::String (required)
- data_table::String (required)
- version::String (required)

Return: DataTableFull, OpenAPI.Clients.ApiResponse
"""
function metadata_nhgis_datasets_dataset_data_tables_data_table_get(_api::DefaultApi, dataset::String, data_table::String, version::String; _mediaType=nothing)
    _ctx = _oacinternal_metadata_nhgis_datasets_dataset_data_tables_data_table_get(_api, dataset, data_table, version; _mediaType=_mediaType)
    return OpenAPI.Clients.exec(_ctx)
end

function metadata_nhgis_datasets_dataset_data_tables_data_table_get(_api::DefaultApi, response_stream::Channel, dataset::String, data_table::String, version::String; _mediaType=nothing)
    _ctx = _oacinternal_metadata_nhgis_datasets_dataset_data_tables_data_table_get(_api, dataset, data_table, version; _mediaType=_mediaType)
    return OpenAPI.Clients.exec(_ctx, response_stream)
end

const _returntypes_metadata_nhgis_datasets_dataset_get_DefaultApi = Dict{Regex,Type}(
    Regex("^" * replace("200", "x"=>".") * "\$") => DatasetFull,
)

function _oacinternal_metadata_nhgis_datasets_dataset_get(_api::DefaultApi, dataset::String, version::String; _mediaType=nothing)
    _ctx = OpenAPI.Clients.Ctx(_api.client, "GET", _returntypes_metadata_nhgis_datasets_dataset_get_DefaultApi, "/metadata/nhgis/datasets/{dataset}", ["APIKeyHeader", ])
    OpenAPI.Clients.set_param(_ctx.path, "dataset", dataset)  # type String
    OpenAPI.Clients.set_param(_ctx.query, "version", version)  # type String
    OpenAPI.Clients.set_header_accept(_ctx, ["application/json", ])
    OpenAPI.Clients.set_header_content_type(_ctx, (_mediaType === nothing) ? [] : [_mediaType])
    return _ctx
end

@doc raw"""Detailed dataset view

Params:
- dataset::String (required)
- version::String (required)

Return: DatasetFull, OpenAPI.Clients.ApiResponse
"""
function metadata_nhgis_datasets_dataset_get(_api::DefaultApi, dataset::String, version::String; _mediaType=nothing)
    _ctx = _oacinternal_metadata_nhgis_datasets_dataset_get(_api, dataset, version; _mediaType=_mediaType)
    println(_ctx |> OpenAPI.Clients.prep_args)
    println(_ctx)
    resource_path = replace(_ctx.resource, "{format}"=>"json")
    for (k,v) in _ctx.path
        esc_v = _ctx.escape_path_params ? escapeuri(v) : v
        resource_path = replace(resource_path, "{$k}"=>esc_v)
    end
    # append query params if needed
    if !isempty(_ctx.query)
        resource_path = string(URIs.URI(URIs.URI(resource_path); query=escapeuri(_ctx.query)))
    end
    HTTP.request(_ctx.method, resource_path, _ctx.header)
    # return OpenAPI.Clients.exec(_ctx)
end

function metadata_nhgis_datasets_dataset_get(_api::DefaultApi, response_stream::Channel, dataset::String, version::String; _mediaType=nothing)
    _ctx = _oacinternal_metadata_nhgis_datasets_dataset_get(_api, dataset, version; _mediaType=_mediaType)
    return OpenAPI.Clients.exec(_ctx, response_stream)
end

const _returntypes_metadata_nhgis_datasets_get_DefaultApi = Dict{Regex,Type}(
    Regex("^" * replace("200", "x"=>".") * "\$") => Vector{DatasetSimple},
)

function _oacinternal_metadata_nhgis_datasets_get(_api::DefaultApi, version::String; page_number=nothing, page_size=nothing, _mediaType=nothing)
    _ctx = OpenAPI.Clients.Ctx(_api.client, "GET", _returntypes_metadata_nhgis_datasets_get_DefaultApi, "/metadata/nhgis/datasets", ["APIKeyHeader", ])
    OpenAPI.Clients.set_param(_ctx.query, "version", version)  # type String
    OpenAPI.Clients.set_param(_ctx.query, "pageNumber", page_number)  # type Int64
    OpenAPI.Clients.set_param(_ctx.query, "pageSize", page_size)  # type Int64
    OpenAPI.Clients.set_header_accept(_ctx, ["application/json", ])
    OpenAPI.Clients.set_header_content_type(_ctx, (_mediaType === nothing) ? [] : [_mediaType])
    return _ctx
end

@doc raw"""List all datasets

Params:
- version::String (required)
- page_number::Int64
- page_size::Int64

Return: Vector{DatasetSimple}, OpenAPI.Clients.ApiResponse
"""
function metadata_nhgis_datasets_get(_api::DefaultApi, version::String; page_number=nothing, page_size=nothing, _mediaType=nothing)
    _ctx = _oacinternal_metadata_nhgis_datasets_get(_api, version; page_number=page_number, page_size=page_size, _mediaType=_mediaType)
    return OpenAPI.Clients.exec(_ctx)
end

function metadata_nhgis_datasets_get(_api::DefaultApi, response_stream::Channel, version::String; page_number=nothing, page_size=nothing, _mediaType=nothing)
    _ctx = _oacinternal_metadata_nhgis_datasets_get(_api, version; page_number=page_number, page_size=page_size, _mediaType=_mediaType)
    return OpenAPI.Clients.exec(_ctx, response_stream)
end

const _returntypes_metadata_nhgis_shapefiles_get_DefaultApi = Dict{Regex,Type}(
    Regex("^" * replace("200", "x"=>".") * "\$") => Vector{Shapefile},
)

function _oacinternal_metadata_nhgis_shapefiles_get(_api::DefaultApi, version::String; page_number=nothing, page_size=nothing, _mediaType=nothing)
    _ctx = OpenAPI.Clients.Ctx(_api.client, "GET", _returntypes_metadata_nhgis_shapefiles_get_DefaultApi, "/metadata/nhgis/shapefiles", ["APIKeyHeader", ])
    OpenAPI.Clients.set_param(_ctx.query, "version", version)  # type String
    OpenAPI.Clients.set_param(_ctx.query, "pageNumber", page_number)  # type Int64
    OpenAPI.Clients.set_param(_ctx.query, "pageSize", page_size)  # type Int64
    OpenAPI.Clients.set_header_accept(_ctx, ["application/json", ])
    OpenAPI.Clients.set_header_content_type(_ctx, (_mediaType === nothing) ? [] : [_mediaType])
    return _ctx
end

@doc raw"""List all the shapefiles.

Params:
- version::String (required)
- page_number::Int64
- page_size::Int64

Return: Vector{Shapefile}, OpenAPI.Clients.ApiResponse
"""
function metadata_nhgis_shapefiles_get(_api::DefaultApi, version::String; page_number=nothing, page_size=nothing, _mediaType=nothing)
    _ctx = _oacinternal_metadata_nhgis_shapefiles_get(_api, version; page_number=page_number, page_size=page_size, _mediaType=_mediaType)
    return OpenAPI.Clients.exec(_ctx)
end

function metadata_nhgis_shapefiles_get(_api::DefaultApi, response_stream::Channel, version::String; page_number=nothing, page_size=nothing, _mediaType=nothing)
    _ctx = _oacinternal_metadata_nhgis_shapefiles_get(_api, version; page_number=page_number, page_size=page_size, _mediaType=_mediaType)
    return OpenAPI.Clients.exec(_ctx, response_stream)
end

const _returntypes_metadata_nhgis_time_series_tables_get_DefaultApi = Dict{Regex,Type}(
    Regex("^" * replace("200", "x"=>".") * "\$") => Vector{TimeSeriesTableSimple},
)

function _oacinternal_metadata_nhgis_time_series_tables_get(_api::DefaultApi, version::String; page_number=nothing, page_size=nothing, _mediaType=nothing)
    _ctx = OpenAPI.Clients.Ctx(_api.client, "GET", _returntypes_metadata_nhgis_time_series_tables_get_DefaultApi, "/metadata/nhgis/time_series_tables", ["APIKeyHeader", ])
    OpenAPI.Clients.set_param(_ctx.query, "version", version)  # type String
    OpenAPI.Clients.set_param(_ctx.query, "pageNumber", page_number)  # type Int64
    OpenAPI.Clients.set_param(_ctx.query, "pageSize", page_size)  # type Int64
    OpenAPI.Clients.set_header_accept(_ctx, ["application/json", ])
    OpenAPI.Clients.set_header_content_type(_ctx, (_mediaType === nothing) ? [] : [_mediaType])
    return _ctx
end

@doc raw"""List all time series tables

Params:
- version::String (required)
- page_number::Int64
- page_size::Int64

Return: Vector{TimeSeriesTableSimple}, OpenAPI.Clients.ApiResponse
"""
function metadata_nhgis_time_series_tables_get(_api::DefaultApi, version::String; page_number=nothing, page_size=nothing, _mediaType=nothing)
    _ctx = _oacinternal_metadata_nhgis_time_series_tables_get(_api, version; page_number=page_number, page_size=page_size, _mediaType=_mediaType)
    return OpenAPI.Clients.exec(_ctx)
end

function metadata_nhgis_time_series_tables_get(_api::DefaultApi, response_stream::Channel, version::String; page_number=nothing, page_size=nothing, _mediaType=nothing)
    _ctx = _oacinternal_metadata_nhgis_time_series_tables_get(_api, version; page_number=page_number, page_size=page_size, _mediaType=_mediaType)
    return OpenAPI.Clients.exec(_ctx, response_stream)
end

const _returntypes_metadata_nhgis_time_series_tables_time_series_table_get_DefaultApi = Dict{Regex,Type}(
    Regex("^" * replace("200", "x"=>".") * "\$") => Vector{TimeSeriesTableFull},
)

function _oacinternal_metadata_nhgis_time_series_tables_time_series_table_get(_api::DefaultApi, time_series_table::String, version::String; _mediaType=nothing)
    _ctx = OpenAPI.Clients.Ctx(_api.client, "GET", _returntypes_metadata_nhgis_time_series_tables_time_series_table_get_DefaultApi, "/metadata/nhgis/time_series_tables/{timeSeriesTable}", ["APIKeyHeader", ])
    OpenAPI.Clients.set_param(_ctx.path, "timeSeriesTable", time_series_table)  # type String
    OpenAPI.Clients.set_param(_ctx.query, "version", version)  # type String
    OpenAPI.Clients.set_header_accept(_ctx, ["application/json", ])
    OpenAPI.Clients.set_header_content_type(_ctx, (_mediaType === nothing) ? [] : [_mediaType])
    return _ctx
end

@doc raw"""Detailed time series table view

Params:
- time_series_table::String (required)
- version::String (required)

Return: Vector{TimeSeriesTableFull}, OpenAPI.Clients.ApiResponse
"""
function metadata_nhgis_time_series_tables_time_series_table_get(_api::DefaultApi, time_series_table::String, version::String; _mediaType=nothing)
    _ctx = _oacinternal_metadata_nhgis_time_series_tables_time_series_table_get(_api, time_series_table, version; _mediaType=_mediaType)
    return OpenAPI.Clients.exec(_ctx)
end

function metadata_nhgis_time_series_tables_time_series_table_get(_api::DefaultApi, response_stream::Channel, time_series_table::String, version::String; _mediaType=nothing)
    _ctx = _oacinternal_metadata_nhgis_time_series_tables_time_series_table_get(_api, time_series_table, version; _mediaType=_mediaType)
    return OpenAPI.Clients.exec(_ctx, response_stream)
end

export extracts_extract_number_get
export extracts_get
export extracts_post
export metadata_nhgis_data_tables_get
export metadata_nhgis_datasets_dataset_data_tables_data_table_get
export metadata_nhgis_datasets_dataset_get
export metadata_nhgis_datasets_get
export metadata_nhgis_shapefiles_get
export metadata_nhgis_time_series_tables_get
export metadata_nhgis_time_series_tables_time_series_table_get
