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

@testset "NHGIS Parser" begin
    datafile = "testdata/nhgis0001_shapefile/US_state_1790.shp"
    df = load_ipums_nhgis(datafile)
    @test size(df) == (16, 8)

end