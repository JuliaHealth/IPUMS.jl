using IPUMS
using Documenter

DocMeta.setdocmeta!(IPUMS, :DocTestSetup, :(using IPUMS); recursive=true)

makedocs(;
    modules=[IPUMS],
    authors="TheCedarPrince <jacobszelko@gmail.com> and contributors",
    sitename="IPUMS.jl",
    repo = "https://github.com/JuliaHealth/IPUMS.jl/blob/{commit}{path}#L{line}",
    format=Documenter.HTML(;
        prettyurls = get(ENV, "CI", "false") == "true",
        canonical = "https://JuliaHealth.github.io/IPUMS.jl",
        edit_link="dev",
        assets=String[],
        footer = "Created by [Jacob Zelko](https://jacobzelko.com). [License](https://github.com/JuliaHealth/OMOPCDMCohortCreator.jl/blob/main/LICENSE)",
    ),
    pages=[
        "Home" => "index.md",
        "Tutorials" => "tutorials.md",
        "HowTo" => "howto.md",
        "Workflow" => "workflow.md",
        "Examples" => "examples.md",
        "Mission" => "mission.md",
        "Contributing" => "contributing.md"
    ],
)

deploydocs(;
    repo="github.com/JuliaHealth/IPUMS.jl",
    push_preview = true,
    devbranch="main"
)


# I'm working here!
