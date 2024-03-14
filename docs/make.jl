using IPUMS
using Documenter

DocMeta.setdocmeta!(IPUMS, :DocTestSetup, :(using IPUMS); recursive=true)

makedocs(;
    modules=[IPUMS],
    authors="TheCedarPrince <jacobszelko@gmail.com> and contributors",
    sitename="IPUMS.jl",
    format=Documenter.HTML(;
        canonical="https://TheCedarPrince.github.io/IPUMS.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/TheCedarPrince/IPUMS.jl",
    devbranch="main",
)
