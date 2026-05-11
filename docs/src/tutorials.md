# Introduction to the IPUMS API for Julia Users

[IPUMS](https://www.ipums.org/) hosts dozens of population, health, and geospatial data collections. There are two ways to pull data out of them:

1. **Through the IPUMS website**, by browsing samples and variables in a project's web portal, building an extract interactively, and downloading the result by hand.
2. **Through the IPUMS API**, by defining the same extract programmatically. This is what `IPUMS.jl` does.

The API approach is the right one when you want your data extract to be **reproducible** (the request lives in code, not in a forgotten browser tab), **shareable** with collaborators, or **integrated into a script** that downloads and loads the data in one go.

This tutorial walks through the full end-to-end workflow with `IPUMS.jl`:

- Setting up your API key and an `IPUMSAPI` client
- Writing an extract definition (microdata and aggregate-data variants)
- Submitting the extract, waiting for it to finish, and downloading the files
- Reading the result into a Julia `DataFrame`

It's modelled on the corresponding [ipumsr R article](https://tech.popdata.org/ipumsr/articles/ipums-api.html); where IPUMS.jl works differently from ipumsr, the relevant section calls it out.

## Supported collections

`IPUMS.jl` exposes the IPUMS v2 API. Not every IPUMS collection is reachable through that API yet — some are still web-only. To see which collections you can currently use from Julia, call `ipums_data_collections()`:

```julia
using IPUMS

ipums_data_collections()
```

The `code_for_api` column is the short identifier you'll pass to functions like
`extract_submit` and `extract_download`. When the column is blank, the API code is the same as the lowercased project name (`"usa"`, `"cps"`, `"nhgis"`). When it's populated (e.g. `ipumsi` for IPUMS International), use that string instead.

The rest of this tutorial uses **IPUMS CPS** as the microdata example and **IPUMS NHGIS** as the aggregate-data example, but the same pattern works for IPUMS USA and IPUMS International.

!!! note "Collections without API support"
    Collections with `api_support = false` (IPUMS ATUS, DHS, NHIS, MEPS, etc.) can still
    be downloaded manually from each project's website. Once those projects gain v2 API
    support, `IPUMS.jl` should be able to reach them with no code changes on your side.

