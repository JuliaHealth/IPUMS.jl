#=

Behold you Julians, the sins of a blasphemer.

=# 

function OpenAPI.from_json(a::Vector{DatasetSimple}, b)
    convert.(DatasetSimple, b["data"])
end

function OpenAPI.from_json(a::Vector{TimeSeriesTableSimple}, b)
    convert.(TimeSeriesTableSimple, b["data"])
end

function OpenAPI.from_json(a::Vector{TimeSeriesTableFull}, b)
    [convert(TimeSeriesTableFull, b)]
end

function OpenAPI.from_json(a::Vector{IPUMS.Shapefile}, b)
    [IPUMS.Shapefile(s["name"], s["year"], s["geographicLevel"], s["extent"], s["basis"], s["sequence"]) for s in b["data"]]
end

function OpenAPI.from_json(a::IPUMS.DatasetFull, b::Dict{String, Any})
    DatasetFull(
        b["name"], 
        b["description"],
        b["group"],
        b["sequence"],
        convert.(IPUMS.DataTableSimple, b["dataTables"]),
        convert.(IPUMS.DatasetFullGeogLevelsInner, b["geogLevels"]),
        b["hasMultipleDataTypes"],
        convert.(DatasetFullBreakdowns, b["breakdowns"])
    )
end
