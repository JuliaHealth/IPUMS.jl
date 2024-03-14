using DataFrames
using IPUMS
using Test

@testset "Helpers" begin
    res = ipums_data_collections()
    @test DataFrame == typeof(res)
    @test (14, 4) == size(res)
end
