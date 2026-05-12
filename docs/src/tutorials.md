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

## Setting up your API key

To use the IPUMS API you need two things: an IPUMS account on each project you'll
extract data from, and a personal API key.

1. **Register an account** with the IPUMS project(s) you want to use. Each project has
   its own registration page — e.g. [IPUMS CPS](https://cps.ipums.org/cps/),
   [IPUMS USA](https://usa.ipums.org/usa/), [IPUMS International](https://international.ipums.org/international/), [IPUMS NHGIS](https://www.nhgisorg/). Registration is free; usage is governed by each project's [terms of use](https://www.ipums.org/about/terms).

2. **Generate an API key** at [account.ipums.org/api_keys](https://account.ipums.org/api_keys).
   A single key works across every IPUMS project your account is registered with. Treat it like a password — anyone with the key can submit extract requests on your behalf.

### Store the key in an environment variable

Hard-coding the key in a script is the easiest way to inadvertently leak it. The conventional pattern is to put it in an environment variable named `IPUMS_API_KEY` and read it from `ENV` in Julia:

```bash
# in your shell profile (.zshrc, .bashrc, etc.)
export IPUMS_API_KEY="paste-your-key-here"
```

```julia
julia> ENV["IPUMS_API_KEY"]
"paste-your-key-here"
```

For a one-off session you can set it directly at the Julia REPL:

```julia
ENV["IPUMS_API_KEY"] = "paste-your-key-here"
```

!!! warning "Don't commit your API key"
    Never paste your key into a script, notebook, or `.jl` file that you commit to version control. If you accidentally do, [revoke it](https://account.ipums.org/api_keys) and generate a new one.

### Construct the API client

With your key in `ENV`, build an `IPUMSAPI` client. Every subsequent call in this
tutorial — submitting extracts, checking status, downloading files — takes this client as its first argument.

```julia
using IPUMS

api = IPUMSAPI(
    "https://api.ipums.org/",
    Dict("Authorization" => ENV["IPUMS_API_KEY"]),
)
```

The first argument is the API base URL (always `"https://api.ipums.org/"` for the v2 API). The second is the request headers; the IPUMS API authenticates by reading the raw key out of the `Authorization` header — there is no `Bearer ` prefix.

That's all the setup. The next section assumes you have obtained an API key and stored it in the IPUMS_API_KEY environment variable. 

