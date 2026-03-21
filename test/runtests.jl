using DataFrames
using IPUMS
using Test


@testset "Helpers" begin
    res = ipums_data_collections()
    @test DataFrame == typeof(res)
    @test (14, 4) == size(res)
end

@testset "DDI Parser" begin
    ddi = parse_ddi("testdata/cps_00157.xml")
    datafile = "testdata/cps_00157.dat"
    df = load_ipums_extract(ddi, datafile)
    @test ddi.extract_date == "2023-07-10"
    @test ddi.variable_info[1].position_end == 4
    @test ddi._ns == "ddi:codebook:2_5"
    @test size(ddi.data_summary) == (8,6)
    @test_throws ArgumentError parse_ddi("testdata/cps_00157.dat.gz")
    @test_throws ArgumentError parse_ddi("testdata/cps_00156.xml")
    @test isa(metadata(df), Dict)
    @test isa(colmetadata(df, :YEAR), Dict)
end

@testset "Internal Byte Parsing" begin
    @test IPUMS._parse_int_bytes(Vector{UInt8}("  123  "), 1, 7) == 123
    @test IPUMS._parse_int_bytes(Vector{UInt8}(" -42 "), 1, 5) == -42
    @test IPUMS._parse_int_bytes(Vector{UInt8}("0"), 1, 1) == 0
    @test ismissing(IPUMS._parse_int_bytes(Vector{UInt8}("     "), 1, 5))
    @test IPUMS._parse_int_bytes(Vector{UInt8}("99999"), 1, 5) == 99999
    @test IPUMS._parse_int_bytes(Vector{UInt8}("00080"), 1, 5) == 80
end

@testset "Column Parser Correctness" begin
    line1 = " 123045600\n"
    line2 = "  -7000100\n"
    line3 = "   0999900\n"
    data = Vector{UInt8}(line1 * line2 * line3)
    line_len = 11

    col_int = Vector{Union{Missing, Int64}}(undef, 3)
    IPUMS._parse_column_int!(col_int, data, 1, 4, line_len)
    @test col_int[1] == 123
    @test col_int[2] == -7
    @test col_int[3] == 0

    col_float = Vector{Union{Missing, Float64}}(undef, 3)
    IPUMS._parse_column_float!(col_float, data, 5, 10, line_len, 2)
    @test col_float[1] ≈ 456.0
    @test col_float[2] ≈ 1.0
    @test col_float[3] ≈ 9999.0

    str_data = Vector{UInt8}(" AB \n CD \n    \n")
    str_line_len = 5
    col_str = Vector{Union{Missing, String}}(undef, 3)
    IPUMS._parse_column_string!(col_str, str_data, 1, 4, str_line_len)
    @test col_str[1] == "AB"
    @test col_str[2] == "CD"
    @test ismissing(col_str[3])
end

@testset "Parser Data Values" begin
    ddi = parse_ddi("testdata/cps_00157.xml")
    df = load_ipums_extract(ddi, "testdata/cps_00157.dat")
    lines = readlines("testdata/cps_00157.dat")

    @test size(df) == (length(lines), length(ddi.variable_info))

    for row_idx in eachindex(lines)
        line = lines[row_idx]
        for v in ddi.variable_info
            raw = strip(line[v.position_start:v.position_end])
            parsed = df[row_idx, v.name]
            if isempty(raw)
                @test ismissing(parsed)
            elseif v.var_dtype === Float64
                expected = parse(Float64, chop(raw; tail=v.dcml) * "." * last(raw, v.dcml))
                @test parsed ≈ expected
            elseif v.var_dtype === Int64
                expected = parse(Int64, raw)
                @test parsed == expected
            end
        end
    end

    for v in ddi.variable_info
        @test nonmissingtype(eltype(df[!, v.name])) == v.var_dtype
    end

    @test metadata(df, "extract_date") == "2023-07-10"
    @test metadata(df, "ipums_project") == "IPUMS CPS"
    @test !isempty(metadata(df, "conditions"))
    @test !isempty(metadata(df, "citation"))

    for col in names(df)
        cmd = colmetadata(df, col)
        @test haskey(cmd, "label")
        @test haskey(cmd, "description")
        @test haskey(cmd, "data type")
    end
end
