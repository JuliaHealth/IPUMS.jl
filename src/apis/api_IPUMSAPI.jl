# This file was generated by the Julia OpenAPI Code Generator
# Do not modify this file directly. Modify the OpenAPI specification instead.

struct IPUMSAPI <: OpenAPI.APIClientImpl
    client::OpenAPI.Clients.Client
end

"""
The default API base path for APIs in `IPUMSAPI`.
This can be used to construct the `OpenAPI.Clients.Client` instance.
"""
basepath(::Type{ IPUMSAPI }) = "https://api.ipums.org"

const _returntypes_extract_info_IPUMSAPI = Dict{Regex,Type}(
    Regex("^" * replace("200", "x"=>".") * "\$") => DataExtract,
)

function _oacinternal_extract_info(_api::IPUMSAPI, extract_number::Int64, collection::String, version::String; _mediaType=nothing)
    _ctx = OpenAPI.Clients.Ctx(_api.client, "GET", _returntypes_extract_info_IPUMSAPI, "/extracts/{extractNumber}", ["APIKeyHeader", ])
    OpenAPI.Clients.set_param(_ctx.path, "extractNumber", extract_number)  # type Int64
    OpenAPI.Clients.set_param(_ctx.query, "collection", collection)  # type String
    OpenAPI.Clients.set_param(_ctx.query, "version", version)  # type String
    OpenAPI.Clients.set_header_accept(_ctx, ["application/json", ])
    OpenAPI.Clients.set_header_content_type(_ctx, (_mediaType === nothing) ? [] : [_mediaType])
    return _ctx
end

@doc raw"""

```julia
extract_info(
    api::IPUMSAPI,
    extract_number::Int,
    collection::String;
    version::String = "2"
)
```

Get information about a specific data extract.

### Arguments

- `api::IPUMSAPI` -- An `IPUMSAPI` object to establish connection details.

- `extract_number::Int` -- extract ID assigned to the IPUMS data extract.

- `collection::String` -- What IPUMS collection to be queried for the extract (options could include `"nhgis"`, `"usa"`, etc. corresponding to IPUMS NHGIS or NHGIS USA databases).

### Keyword Arguments

- `version::String` -- What version of the IPUMS API to use (Default: `"2"`)

### Returns

`metadata::{String, Any}` -- A dictionary containing metadata about the queried data extract:

- `number` -- The IPUMS data extract ID

- `timeSeriesTableLayout` -- Layout of the the time series tables. Can be one of the following:

    - `"time_by_column_layout"` (wide format, default): rows correspond to geographic units, columns correspond to different times in the time series

    - `"time_by_row_layout"` (long format): rows correspond to a single geographic unit at a single point in time

    - `"time_by_file_layout"`: data for different times are provided in separate files

- `geographicExtents` -- Vector of geographic extents to use for all of the datasets in the extract definition.

- `status` -- The current status of the IPUMS data extract (such as `"completed"` for a request being done). Potential results include:

    - `"queued"`

    - `"started"`

    - `"produced"`

    - `"canceled"`

    - `"failed"`

    - `"completed"`

- `description` -- The associated description about the data extract.

- `timeSeriesTables` -- Vector of time series tables for use in the extract definition.


- `version` -- What version of the API is being used for handling this request.

- `dataFormat` -- The desired format of the extract data file.

    - `"csv_no_header"` (default) includes only a minimal header in the first row

    - `"csv_header"` includes a second, more descriptive header row.

    - `"fixed_width"` provides data in a fixed width format

- `breakdownAndDataTypeLayout` -- The desired layout of any datasets that have multiple data types or breakdown values. Potential values can be:

    - `"single_file"` (default) keeps all data types and breakdown values in one file

    - `"separate_files"` splits each data type or breakdown value into its own file

- `shapefiles` -- Report what shapefiles were requested and used in this extract.

- `downloadUrls` -- URLs to download the data from the requested extract.

- `datasets` -- What datasets were used in this extract.

- `collection` -- What collection is being queried.

> NOTE: To be ready to download, an extract must have a `completed` status. However, some requests that are `completed` may still be unavailable for download, as extracts expire and are removed from IPUMS servers after a set period of time (72 hours for microdata collections, 2 weeks for IPUMS NHGIS).

`defn::IPUMS.DataExtractDefinition` -- The associated data extract definition that was used to generate this extract.

`msg::OpenAPI.Clients.ApiResponse` -- The response message from the IPUMS API.


### Examples

```julia-repl
julia> metadata, defn, msg = extract_info(api, 1, "nhgis", "2");

julia> metadata
Dict{String, Any} with 13 entries:
  "number"        => 1
  "timeSeriesTab… => "time_by_file_layout"
  "geographicExt… => ["010"]
  "status"        => "completed"
  "description"   => "example extract request"
  "timeSeriesTab… => Dict{String, TimeSeriesTable}…
  "version"       => 2
  "dataFormat"    => "csv_no_header"
  "breakdownAndD… => "single_file"
  "shapefiles"    => ["us_state_1790_tl2000"]
  "downloadUrls"  => Dict("codebookPreview"=>"http…
  "datasets"      => Dict{String, Dataset}("2000_S…
  "collection"    => "nhgis"
```
"""
function extract_info(_api::IPUMSAPI, extract_number::Int64, collection::String; version::String = "2")
    _ctx = _oacinternal_extract_info(_api, extract_number, collection, version; _mediaType = nothing)
    res, msg = OpenAPI.Clients.exec(_ctx)
    defn = res.extractDefinition

    urls = Dict(
        link => JSON3.read(getfield(res.downloadLinks, idx)).url 
        for (idx, link) in enumerate(["codebookPreview", "tableData", "gisData"])
    )

    info = [
        "collection",
        "number", 
        "status",
        "description",
        "datasets",
        "dataFormat",
        "shapefiles",
        "geographicExtents",
        "timeSeriesTables",
        "timeSeriesTableLayout",
        "downloadUrls",
        "breakdownAndDataTypeLayout",
        "version"
    ]

    values = [
        defn.collection,
        res.number,
        res.status,
        defn.description,
        defn.datasets,
        defn.dataFormat,
        defn.shapefiles,
        defn.geographicExtents,
        defn.timeSeriesTables,
        defn.timeSeriesTableLayout,
        urls, 
        defn.breakdownAndDataTypeLayout,
        defn.version
    ]

    if isempty(urls)
        @info "This extract has expired and associated data cannot be downloaded. Please resubmit this extract request again to prepare the data."
    end

    metadata = Dict(info .=> values)

    return metadata, defn, msg

end

function extract_info(_api::IPUMSAPI, response_stream::Channel, extract_number::Int64, collection::String; version::String = "2", _mediaType=nothing)
    _ctx = _oacinternal_extract_info(_api, extract_number, collection, version; _mediaType=_mediaType)
    return OpenAPI.Clients.exec(_ctx, response_stream)
end

const _returntypes_extract_list_IPUMSAPI = Dict{Regex,Type}(
    Regex("^" * replace("200", "x"=>".") * "\$") => Vector{DataExtract},
)

function _oacinternal_extract_list(_api::IPUMSAPI, collection::String, version::String; page_number=nothing, page_size=nothing, _mediaType=nothing)
    _ctx = OpenAPI.Clients.Ctx(_api.client, "GET", _returntypes_extract_list_IPUMSAPI, "/extracts", ["APIKeyHeader", ])
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
function extract_list(_api::IPUMSAPI, collection::String, version::String; page_number=nothing, page_size=nothing, _mediaType=nothing)
    _ctx = _oacinternal_extract_list(_api, collection, version; page_number=page_number, page_size=page_size, _mediaType=_mediaType)
    return OpenAPI.Clients.exec(_ctx)
end

function extract_list(_api::IPUMSAPI, response_stream::Channel, collection::String, version::String; page_number=nothing, page_size=nothing, _mediaType=nothing)
    _ctx = _oacinternal_extract_list(_api, collection, version; page_number=page_number, page_size=page_size, _mediaType=_mediaType)
    return OpenAPI.Clients.exec(_ctx, response_stream)
end

const _returntypes_extract_submit_IPUMSAPI = Dict{Regex,Type}(
    Regex("^" * replace("200", "x"=>".") * "\$") => DataExtractPostResponse,
)

function _oacinternal_extract_submit(_api::IPUMSAPI, collection::String, version::String; data_extract_post=nothing, _mediaType=nothing)
    _ctx = OpenAPI.Clients.Ctx(_api.client, "POST", _returntypes_extract_submit_IPUMSAPI, "/extracts", ["APIKeyHeader", ], data_extract_post)
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
function extract_submit(_api::IPUMSAPI, collection::String, version::String; data_extract_post=nothing, _mediaType=nothing)
    _ctx = _oacinternal_extract_submit(_api, collection, version; data_extract_post=data_extract_post, _mediaType=_mediaType)
    return OpenAPI.Clients.exec(_ctx)
end

function extract_submit(_api::IPUMSAPI, response_stream::Channel, collection::String, version::String; data_extract_post=nothing, _mediaType=nothing)
    _ctx = _oacinternal_extract_submit(_api, collection, version; data_extract_post=data_extract_post, _mediaType=_mediaType)
    return OpenAPI.Clients.exec(_ctx, response_stream)
end

const _returntypes_metadata_nhgis_data_tables_get_IPUMSAPI = Dict{Regex,Type}(
    Regex("^" * replace("200", "x"=>".") * "\$") => DataTableFull,
)

function _oacinternal_metadata_nhgis_data_tables_get(_api::IPUMSAPI, version::String; page_number=nothing, page_size=nothing, _mediaType=nothing)
    _ctx = OpenAPI.Clients.Ctx(_api.client, "GET", _returntypes_metadata_nhgis_data_tables_get_IPUMSAPI, "/metadata/nhgis/data_tables", ["APIKeyHeader", ])
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
function metadata_nhgis_data_tables_get(_api::IPUMSAPI, version::String; page_number=nothing, page_size=nothing, _mediaType=nothing)
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

function metadata_nhgis_data_tables_get(_api::IPUMSAPI, response_stream::Channel, version::String; page_number=nothing, page_size=nothing, _mediaType=nothing)
    _ctx = _oacinternal_metadata_nhgis_data_tables_get(_api, version; page_number=page_number, page_size=page_size, _mediaType=_mediaType)
    return OpenAPI.Clients.exec(_ctx, response_stream)
end

const _returntypes_metadata_nhgis_datasets_dataset_data_tables_data_table_get_IPUMSAPI = Dict{Regex,Type}(
    Regex("^" * replace("200", "x"=>".") * "\$") => DataTableFull,
)

function _oacinternal_metadata_nhgis_datasets_dataset_data_tables_data_table_get(_api::IPUMSAPI, dataset::String, data_table::String, version::String; _mediaType=nothing)
    _ctx = OpenAPI.Clients.Ctx(_api.client, "GET", _returntypes_metadata_nhgis_datasets_dataset_data_tables_data_table_get_IPUMSAPI, "/metadata/nhgis/datasets/{dataset}/data_tables/{dataTable}", ["APIKeyHeader", ])
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
function metadata_nhgis_datasets_dataset_data_tables_data_table_get(_api::IPUMSAPI, dataset::String, data_table::String, version::String; _mediaType=nothing)
    _ctx = _oacinternal_metadata_nhgis_datasets_dataset_data_tables_data_table_get(_api, dataset, data_table, version; _mediaType=_mediaType)
    return OpenAPI.Clients.exec(_ctx)
end

function metadata_nhgis_datasets_dataset_data_tables_data_table_get(_api::IPUMSAPI, response_stream::Channel, dataset::String, data_table::String, version::String; _mediaType=nothing)
    _ctx = _oacinternal_metadata_nhgis_datasets_dataset_data_tables_data_table_get(_api, dataset, data_table, version; _mediaType=_mediaType)
    return OpenAPI.Clients.exec(_ctx, response_stream)
end

const _returntypes_metadata_nhgis_datasets_dataset_get_IPUMSAPI = Dict{Regex,Type}(
    Regex("^" * replace("200", "x"=>".") * "\$") => DatasetFull,
)

function _oacinternal_metadata_nhgis_datasets_dataset_get(_api::IPUMSAPI, dataset::String, version::String; _mediaType=nothing)
    _ctx = OpenAPI.Clients.Ctx(_api.client, "GET", _returntypes_metadata_nhgis_datasets_dataset_get_IPUMSAPI, "/metadata/nhgis/datasets/{dataset}", ["APIKeyHeader", ])
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
function metadata_nhgis_datasets_dataset_get(_api::IPUMSAPI, dataset::String, version::String; _mediaType=nothing)
    _ctx = _oacinternal_metadata_nhgis_datasets_dataset_get(_api, dataset, version; _mediaType=_mediaType)
    return OpenAPI.Clients.exec(_ctx)
end

function metadata_nhgis_datasets_dataset_get(_api::IPUMSAPI, response_stream::Channel, dataset::String, version::String; _mediaType=nothing)
    _ctx = _oacinternal_metadata_nhgis_datasets_dataset_get(_api, dataset, version; _mediaType=_mediaType)
    return OpenAPI.Clients.exec(_ctx, response_stream)
end

const _returntypes_metadata_nhgis_datasets_get_IPUMSAPI = Dict{Regex,Type}(
    Regex("^" * replace("200", "x"=>".") * "\$") => Vector{DatasetSimple},
)

function _oacinternal_metadata_nhgis_datasets_get(_api::IPUMSAPI, version::String; page_number=nothing, page_size=nothing, _mediaType=nothing)
    _ctx = OpenAPI.Clients.Ctx(_api.client, "GET", _returntypes_metadata_nhgis_datasets_get_IPUMSAPI, "/metadata/nhgis/datasets", ["APIKeyHeader", ])
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
function metadata_nhgis_datasets_get(_api::IPUMSAPI, version::String; page_number=nothing, page_size=nothing, _mediaType=nothing)
    _ctx = _oacinternal_metadata_nhgis_datasets_get(_api, version; page_number=page_number, page_size=page_size, _mediaType=_mediaType)
    return OpenAPI.Clients.exec(_ctx)
end

function metadata_nhgis_datasets_get(_api::IPUMSAPI, response_stream::Channel, version::String; page_number=nothing, page_size=nothing, _mediaType=nothing)
    _ctx = _oacinternal_metadata_nhgis_datasets_get(_api, version; page_number=page_number, page_size=page_size, _mediaType=_mediaType)
    return OpenAPI.Clients.exec(_ctx, response_stream)
end

const _returntypes_metadata_nhgis_shapefiles_get_IPUMSAPI = Dict{Regex,Type}(
    Regex("^" * replace("200", "x"=>".") * "\$") => Vector{Shapefile},
)

function _oacinternal_metadata_nhgis_shapefiles_get(_api::IPUMSAPI, version::String; page_number=nothing, page_size=nothing, _mediaType=nothing)
    _ctx = OpenAPI.Clients.Ctx(_api.client, "GET", _returntypes_metadata_nhgis_shapefiles_get_IPUMSAPI, "/metadata/nhgis/shapefiles", ["APIKeyHeader", ])
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
function metadata_nhgis_shapefiles_get(_api::IPUMSAPI, version::String; page_number=nothing, page_size=nothing, _mediaType=nothing)
    _ctx = _oacinternal_metadata_nhgis_shapefiles_get(_api, version; page_number=page_number, page_size=page_size, _mediaType=_mediaType)
    return OpenAPI.Clients.exec(_ctx)
end

function metadata_nhgis_shapefiles_get(_api::IPUMSAPI, response_stream::Channel, version::String; page_number=nothing, page_size=nothing, _mediaType=nothing)
    _ctx = _oacinternal_metadata_nhgis_shapefiles_get(_api, version; page_number=page_number, page_size=page_size, _mediaType=_mediaType)
    return OpenAPI.Clients.exec(_ctx, response_stream)
end

const _returntypes_metadata_nhgis_time_series_tables_get_IPUMSAPI = Dict{Regex,Type}(
    Regex("^" * replace("200", "x"=>".") * "\$") => Vector{TimeSeriesTableSimple},
)

function _oacinternal_metadata_nhgis_time_series_tables_get(_api::IPUMSAPI, version::String; page_number=nothing, page_size=nothing, _mediaType=nothing)
    _ctx = OpenAPI.Clients.Ctx(_api.client, "GET", _returntypes_metadata_nhgis_time_series_tables_get_IPUMSAPI, "/metadata/nhgis/time_series_tables", ["APIKeyHeader", ])
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
function metadata_nhgis_time_series_tables_get(_api::IPUMSAPI, version::String; page_number=nothing, page_size=nothing, _mediaType=nothing)
    _ctx = _oacinternal_metadata_nhgis_time_series_tables_get(_api, version; page_number=page_number, page_size=page_size, _mediaType=_mediaType)
    return OpenAPI.Clients.exec(_ctx)
end

function metadata_nhgis_time_series_tables_get(_api::IPUMSAPI, response_stream::Channel, version::String; page_number=nothing, page_size=nothing, _mediaType=nothing)
    _ctx = _oacinternal_metadata_nhgis_time_series_tables_get(_api, version; page_number=page_number, page_size=page_size, _mediaType=_mediaType)
    return OpenAPI.Clients.exec(_ctx, response_stream)
end

const _returntypes_metadata_nhgis_time_series_tables_time_series_table_get_IPUMSAPI = Dict{Regex,Type}(
    Regex("^" * replace("200", "x"=>".") * "\$") => Vector{TimeSeriesTableFull},
)

function _oacinternal_metadata_nhgis_time_series_tables_time_series_table_get(_api::IPUMSAPI, time_series_table::String, version::String; _mediaType=nothing)
    _ctx = OpenAPI.Clients.Ctx(_api.client, "GET", _returntypes_metadata_nhgis_time_series_tables_time_series_table_get_IPUMSAPI, "/metadata/nhgis/time_series_tables/{timeSeriesTable}", ["APIKeyHeader", ])
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
function metadata_nhgis_time_series_tables_time_series_table_get(_api::IPUMSAPI, time_series_table::String, version::String; _mediaType=nothing)
    _ctx = _oacinternal_metadata_nhgis_time_series_tables_time_series_table_get(_api, time_series_table, version; _mediaType=_mediaType)
    return OpenAPI.Clients.exec(_ctx)
end

function metadata_nhgis_time_series_tables_time_series_table_get(_api::IPUMSAPI, response_stream::Channel, time_series_table::String, version::String; _mediaType=nothing)
    _ctx = _oacinternal_metadata_nhgis_time_series_tables_time_series_table_get(_api, time_series_table, version; _mediaType=_mediaType)
    return OpenAPI.Clients.exec(_ctx, response_stream)
end

export extract_info
export extract_list
export extract_submit
export metadata_nhgis_data_tables_get
export metadata_nhgis_datasets_dataset_data_tables_data_table_get
export metadata_nhgis_datasets_dataset_get
export metadata_nhgis_datasets_get
export metadata_nhgis_shapefiles_get
export metadata_nhgis_time_series_tables_get
export metadata_nhgis_time_series_tables_time_series_table_get