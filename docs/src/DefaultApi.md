# DefaultApi

All URIs are relative to *https://api.ipums.org*

Method | HTTP request | Description
------------- | ------------- | -------------
[**extracts_extract_number_get**](DefaultApi.md#extracts_extract_number_get) | **GET** /extracts/{extractNumber} | Get a specific data extract.
[**extracts_get**](DefaultApi.md#extracts_get) | **GET** /extracts | Get a list of recent data extracts.
[**extracts_post**](DefaultApi.md#extracts_post) | **POST** /extracts | Create a data extract
[**metadata_nhgis_data_tables_get**](DefaultApi.md#metadata_nhgis_data_tables_get) | **GET** /metadata/nhgis/data_tables | List all data_tables
[**metadata_nhgis_datasets_dataset_data_tables_data_table_get**](DefaultApi.md#metadata_nhgis_datasets_dataset_data_tables_data_table_get) | **GET** /metadata/nhgis/datasets/{dataset}/data_tables/{dataTable} | Detailed data table view
[**metadata_nhgis_datasets_dataset_get**](DefaultApi.md#metadata_nhgis_datasets_dataset_get) | **GET** /metadata/nhgis/datasets/{dataset} | Detailed dataset view
[**metadata_nhgis_datasets_get**](DefaultApi.md#metadata_nhgis_datasets_get) | **GET** /metadata/nhgis/datasets | List all datasets
[**metadata_nhgis_shapefiles_get**](DefaultApi.md#metadata_nhgis_shapefiles_get) | **GET** /metadata/nhgis/shapefiles | List all the shapefiles.
[**metadata_nhgis_time_series_tables_get**](DefaultApi.md#metadata_nhgis_time_series_tables_get) | **GET** /metadata/nhgis/time_series_tables | List all time series tables
[**metadata_nhgis_time_series_tables_time_series_table_get**](DefaultApi.md#metadata_nhgis_time_series_tables_time_series_table_get) | **GET** /metadata/nhgis/time_series_tables/{timeSeriesTable} | Detailed time series table view


# **extracts_extract_number_get**
> extracts_extract_number_get(_api::DefaultApi, extract_number::Int64, collection::String, version::String; _mediaType=nothing) -> DataExtract, OpenAPI.Clients.ApiResponse <br/>
> extracts_extract_number_get(_api::DefaultApi, response_stream::Channel, extract_number::Int64, collection::String, version::String; _mediaType=nothing) -> Channel{ DataExtract }, OpenAPI.Clients.ApiResponse

Get a specific data extract.

### Required Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **_api** | **DefaultApi** | API context | 
**extract_number** | **Int64**| Number of extract to get. | [default to nothing]
**collection** | **String**| The data collection. This parameter was previously called \&quot;product\&quot;. Using \&quot;product\&quot; as an alias for \&quot;collection\&quot; is still valid but may be deprecated in a future version of the API. | [default to nothing]
**version** | **String**| The api version. | [default to nothing]

### Return type

[**DataExtract**](DataExtract.md)

### Authorization

[APIKeyHeader](../README.md#APIKeyHeader)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)

# **extracts_get**
> extracts_get(_api::DefaultApi, collection::String, version::String; page_number=nothing, page_size=nothing, _mediaType=nothing) -> Vector{DataExtract}, OpenAPI.Clients.ApiResponse <br/>
> extracts_get(_api::DefaultApi, response_stream::Channel, collection::String, version::String; page_number=nothing, page_size=nothing, _mediaType=nothing) -> Channel{ Vector{DataExtract} }, OpenAPI.Clients.ApiResponse

Get a list of recent data extracts.

### Required Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **_api** | **DefaultApi** | API context | 
**collection** | **String**| The data collection. This parameter was previously called \&quot;product\&quot;. Using \&quot;product\&quot; as an alias for \&quot;collection\&quot; is still valid but may be deprecated in a future version of the API. | [default to nothing]
**version** | **String**| The api version. | [default to nothing]

### Optional Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **page_number** | **Int64**| The page number. | [default to nothing]
 **page_size** | **Int64**| The number of records to return per page. | [default to nothing]

### Return type

[**Vector{DataExtract}**](DataExtract.md)

### Authorization

[APIKeyHeader](../README.md#APIKeyHeader)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)

# **extracts_post**
> extracts_post(_api::DefaultApi, collection::String, version::String; data_extract_post=nothing, _mediaType=nothing) -> DataExtractPostResponse, OpenAPI.Clients.ApiResponse <br/>
> extracts_post(_api::DefaultApi, response_stream::Channel, collection::String, version::String; data_extract_post=nothing, _mediaType=nothing) -> Channel{ DataExtractPostResponse }, OpenAPI.Clients.ApiResponse

Create a data extract

### Required Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **_api** | **DefaultApi** | API context | 
**collection** | **String**| The data collection. This parameter was previously called \&quot;product\&quot;. Using \&quot;product\&quot; as an alias for \&quot;collection\&quot; is still valid but may be deprecated in a future version of the API. | [default to nothing]
**version** | **String**| The api version. | [default to nothing]

### Optional Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **data_extract_post** | [**DataExtractPost**](DataExtractPost.md)|  | 

### Return type

[**DataExtractPostResponse**](DataExtractPostResponse.md)

### Authorization

[APIKeyHeader](../README.md#APIKeyHeader)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)

# **metadata_nhgis_data_tables_get**
> metadata_nhgis_data_tables_get(_api::DefaultApi, version::String; page_number=nothing, page_size=nothing, _mediaType=nothing) -> DataTableFull, OpenAPI.Clients.ApiResponse <br/>
> metadata_nhgis_data_tables_get(_api::DefaultApi, response_stream::Channel, version::String; page_number=nothing, page_size=nothing, _mediaType=nothing) -> Channel{ DataTableFull }, OpenAPI.Clients.ApiResponse

List all data_tables

### Required Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **_api** | **DefaultApi** | API context | 
**version** | **String**| The api version. | [default to nothing]

### Optional Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **page_number** | **Int64**| The page number. | [default to nothing]
 **page_size** | **Int64**| The number of records to return per page. | [default to nothing]

### Return type

[**DataTableFull**](DataTableFull.md)

### Authorization

[APIKeyHeader](../README.md#APIKeyHeader)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)

# **metadata_nhgis_datasets_dataset_data_tables_data_table_get**
> metadata_nhgis_datasets_dataset_data_tables_data_table_get(_api::DefaultApi, dataset::String, data_table::String, version::String; _mediaType=nothing) -> DataTableFull, OpenAPI.Clients.ApiResponse <br/>
> metadata_nhgis_datasets_dataset_data_tables_data_table_get(_api::DefaultApi, response_stream::Channel, dataset::String, data_table::String, version::String; _mediaType=nothing) -> Channel{ DataTableFull }, OpenAPI.Clients.ApiResponse

Detailed data table view

### Required Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **_api** | **DefaultApi** | API context | 
**dataset** | **String**| The name of the dataset. | [default to nothing]
**data_table** | **String**| The name of the data table. | [default to nothing]
**version** | **String**| The api version. | [default to nothing]

### Return type

[**DataTableFull**](DataTableFull.md)

### Authorization

[APIKeyHeader](../README.md#APIKeyHeader)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)

# **metadata_nhgis_datasets_dataset_get**
> metadata_nhgis_datasets_dataset_get(_api::DefaultApi, dataset::String, version::String; _mediaType=nothing) -> DatasetFull, OpenAPI.Clients.ApiResponse <br/>
> metadata_nhgis_datasets_dataset_get(_api::DefaultApi, response_stream::Channel, dataset::String, version::String; _mediaType=nothing) -> Channel{ DatasetFull }, OpenAPI.Clients.ApiResponse

Detailed dataset view

### Required Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **_api** | **DefaultApi** | API context | 
**dataset** | **String**| The name of the dataset. | [default to nothing]
**version** | **String**| The api version. | [default to nothing]

### Return type

[**DatasetFull**](DatasetFull.md)

### Authorization

[APIKeyHeader](../README.md#APIKeyHeader)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)

# **metadata_nhgis_datasets_get**
> metadata_nhgis_datasets_get(_api::DefaultApi, version::String; page_number=nothing, page_size=nothing, _mediaType=nothing) -> Vector{DatasetSimple}, OpenAPI.Clients.ApiResponse <br/>
> metadata_nhgis_datasets_get(_api::DefaultApi, response_stream::Channel, version::String; page_number=nothing, page_size=nothing, _mediaType=nothing) -> Channel{ Vector{DatasetSimple} }, OpenAPI.Clients.ApiResponse

List all datasets

### Required Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **_api** | **DefaultApi** | API context | 
**version** | **String**| The api version. | [default to nothing]

### Optional Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **page_number** | **Int64**| The page number. | [default to nothing]
 **page_size** | **Int64**| The number of records to return per page. | [default to nothing]

### Return type

[**Vector{DatasetSimple}**](DatasetSimple.md)

### Authorization

[APIKeyHeader](../README.md#APIKeyHeader)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)

# **metadata_nhgis_shapefiles_get**
> metadata_nhgis_shapefiles_get(_api::DefaultApi, version::String; page_number=nothing, page_size=nothing, _mediaType=nothing) -> Vector{Shapefile}, OpenAPI.Clients.ApiResponse <br/>
> metadata_nhgis_shapefiles_get(_api::DefaultApi, response_stream::Channel, version::String; page_number=nothing, page_size=nothing, _mediaType=nothing) -> Channel{ Vector{Shapefile} }, OpenAPI.Clients.ApiResponse

List all the shapefiles.

### Required Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **_api** | **DefaultApi** | API context | 
**version** | **String**| The api version. | [default to nothing]

### Optional Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **page_number** | **Int64**| The page number. | [default to nothing]
 **page_size** | **Int64**| The number of records to return per page. | [default to nothing]

### Return type

[**Vector{Shapefile}**](Shapefile.md)

### Authorization

[APIKeyHeader](../README.md#APIKeyHeader)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)

# **metadata_nhgis_time_series_tables_get**
> metadata_nhgis_time_series_tables_get(_api::DefaultApi, version::String; page_number=nothing, page_size=nothing, _mediaType=nothing) -> Vector{TimeSeriesTableSimple}, OpenAPI.Clients.ApiResponse <br/>
> metadata_nhgis_time_series_tables_get(_api::DefaultApi, response_stream::Channel, version::String; page_number=nothing, page_size=nothing, _mediaType=nothing) -> Channel{ Vector{TimeSeriesTableSimple} }, OpenAPI.Clients.ApiResponse

List all time series tables

### Required Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **_api** | **DefaultApi** | API context | 
**version** | **String**| The api version. | [default to nothing]

### Optional Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **page_number** | **Int64**| The page number. | [default to nothing]
 **page_size** | **Int64**| The number of records to return per page. | [default to nothing]

### Return type

[**Vector{TimeSeriesTableSimple}**](TimeSeriesTableSimple.md)

### Authorization

[APIKeyHeader](../README.md#APIKeyHeader)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)

# **metadata_nhgis_time_series_tables_time_series_table_get**
> metadata_nhgis_time_series_tables_time_series_table_get(_api::DefaultApi, time_series_table::String, version::String; _mediaType=nothing) -> Vector{TimeSeriesTableFull}, OpenAPI.Clients.ApiResponse <br/>
> metadata_nhgis_time_series_tables_time_series_table_get(_api::DefaultApi, response_stream::Channel, time_series_table::String, version::String; _mediaType=nothing) -> Channel{ Vector{TimeSeriesTableFull} }, OpenAPI.Clients.ApiResponse

Detailed time series table view

### Required Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **_api** | **DefaultApi** | API context | 
**time_series_table** | **String**| The name of the time series table. | [default to nothing]
**version** | **String**| The api version. | [default to nothing]

### Return type

[**Vector{TimeSeriesTableFull}**](TimeSeriesTableFull.md)

### Authorization

[APIKeyHeader](../README.md#APIKeyHeader)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)

