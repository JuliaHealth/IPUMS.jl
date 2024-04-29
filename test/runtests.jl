using DataFrames
using IPUMS
using JSON3
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
    @test ddi._ns == "ddi:codebook:2_5"
    @test size(ddi.data_summary) == (8,6)
    @test_throws ArgumentError parse_ddi("testdata/cps_00157.dat.gz")
    @test_throws ArgumentError parse_ddi("testdata/cps_00156.xml")
end

@testset "Extract API" begin

    @testset "extract_info" begin
        res = JSON3.read("testdata/extract_info_reference.json") |> x -> IPUMS.DataExtract(values(x)...)
        test_metadata, test_defn = IPUMS._extract_info(2, res, res.extractDefinition)

        @test test_metadata["number"] == 2
        @test test_metadata["timeSeriesTableLayout"] == "time_by_file_layout"
        @test test_metadata["geographicExtents"] == ["010"]
        @test test_metadata["status"] == "completed"
        @test test_metadata["description"] == "example extract request"
        @test test_metadata["timeSeriesTables"] |> keys |> only == :A00
        @test test_metadata["version"] == 2
        @test test_metadata["dataFormat"] == "csv_no_header"
        @test test_metadata["breakdownAndDataTypeLayout"] == "single_file"
        @test test_metadata["shapefiles"] == ["us_state_1790_tl2000"]
        @test test_metadata["downloadUrls"] == Any[]
        @test !isempty(test_metadata["datasets"])
        @test test_metadata["collection"] == "nhgis"

        @test test_defn == res.extractDefinition
    end

#=
 =     TODO: Create a playback for extract_submit
 =     TODO: Create a playback for extract_download
 =
 =     TODO: Add a test for extract_list using a reference
 =     extract_list(api, "nhgis", "2")
 =#

end

