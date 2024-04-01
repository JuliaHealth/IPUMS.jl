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
