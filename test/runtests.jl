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
    @test ddi.extract_date == "2023-07-10"
    @test ddi.variable_info[1].position_end == 4
    @test size(ddi.data_summary) == (8,6)
    @test_throws ArgumentError parse_ddi("testdata/cps_00157.dat.gz")
    @test_throws ArgumentError parse_ddi("testdata/cps_00156.xml")
end
