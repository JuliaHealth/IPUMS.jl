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

The `code_for_api` column is the short identifier you'll pass to functions like `extract_submit` and `extract_download`. When the column is blank, the API code is the same as the lowercased project name (`"usa"`, `"cps"`, `"nhgis"`). When it's populated (e.g. `ipumsi` for IPUMS International), use that string instead.

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

With your key in `ENV`, build an `IPUMSAPI` client. Every subsequent call in this tutorial  takes this client as its first argument.

```julia
using IPUMS

api = IPUMSAPI(
    "https://api.ipums.org/",
    Dict("Authorization" => ENV["IPUMS_API_KEY"]),
)
```

The first argument is the API base URL (always `"https://api.ipums.org/"` for the v2 API). The second is the request headers; the IPUMS API authenticates by reading the raw key out of the `Authorization` header — there is no `Bearer ` prefix.

That's all the setup. The next section assumes you have obtained an API key and stored it in the IPUMS_API_KEY environment variable. 

## Defining a microdata extract (IPUMS USA / CPS)

An extract definition is a JSON document that tells the IPUMS API what samples and variables you want. Unlike in R, in Julia you write the JSON yourself — either by hand as a `.json` file, or by constructing a Julia `Dict` and serializing it with `JSON3`. `extract_submit` takes the path to that file.

### Anatomy of a microdata extract

The top-level keys for a microdata extract are:

| Key | Required | What it specifies |
|---|---|---|
| `description` | yes | A human-readable label for your own bookkeeping |
| `dataStructure` | yes | Whether the output is rectangular (one row per chosen unit) or hierarchical |
| `dataFormat` | yes | File format — `"fixed_width"` for microdata |
| `samples` | yes | Which samples (years/supplements) to draw from |
| `variables` | yes | Which variables to include, plus per-variable options |

`dataStructure` is itself an object. Rectangular layouts pick one record type via `on`
(`"P"` for person-level, `"H"` for household-level); hierarchical layouts take no
sub-fields:

```json
"dataStructure": { "rectangular": { "on": "P" } }
```

```json
"dataStructure": { "hierarchical": {} }
```

`samples` and `variables` are both dictionaries keyed by the IPUMS code. Sample codes look like `cps2019_03s` (the CPS March 2019 ASEC supplement) or `us2019a` (IPUMS USA 2019 ACS 1-year). You can look them up in each project's web portal — there is no API endpoint listing microdata samples programmatically.

### A worked CPS example

```json
{
  "description": "CPS ASEC 2018-2019: demographics and income",
  "dataStructure": { "rectangular": { "on": "P" } },
  "dataFormat": "fixed_width",
  "samples": {
    "cps2018_03s": {},
    "cps2019_03s": {}
  },
  "variables": {
    "AGE": {},
    "SEX": {},
    "STATEFIP": {},
    "INCTOT": {},
    "ASECWT": {}
  }
}
```

Save this as e.g. `cps_extract.json`. The next section shows how to submit it.

### Weights are just variables

The issue checklist for this tutorial mentions "selecting weights." In the IPUMS API weights are just regular variables whose values happen to encode sampling weights. The relevant ones depend on the collection:

| Collection | Common weight variables |
|---|---|
| IPUMS USA | `PERWT` (person), `HHWT` (household) |
| IPUMS CPS (basic monthly) | `WTFINL` (person), `HWTFINL` (household) |
| IPUMS CPS (ASEC) | `ASECWT` (person), `ASECWTH` (household) |
| IPUMS International | `PERWT`, `HHWT` |

Add them to `variables` the same way you'd add any other variable.

### Data quality flags ("quality scores")

Many IPUMS variables have a companion variable that records whether the value was
edited, imputed, or allocated by the source agency — IPUMS calls these **data quality flags**. To include the quality flag for a given variable, set `dataQualityFlags: true` on the variable entry:

```json
"variables": {
  "INCTOT": { "dataQualityFlags": true },
  "EDUC":   { "dataQualityFlags": true }
}
```

Each variable with `dataQualityFlags: true` adds a companion column to the extract
(e.g. `QINCTOT` next to `INCTOT`).

### Per-variable options at a glance

A few other per-variable options come up often enough to mention:

- **`caseSelections`** — restrict the extract to specific category codes. The codes are
  passed as **strings**, not integers:

  ```json
  "MARST": { "caseSelections": { "general": ["1", "2"] } }
  ```

- **`attachedCharacteristics`** — attach values from a related person to each record
  (e.g. parents' education on each child's row):

  ```json
  "EDUC": { "attachedCharacteristics": ["mother", "father", "spouse"] }
  ```

- **`adjustMonetaryValues`** — for income variables, ask the API to convert dollars to a
  common base year:

  ```json
  "INCTOT": { "adjustMonetaryValues": true }
  ```

A full list of per-variable options is in the
[IPUMS API microdata reference](https://developer.ipums.org/docs/v2/workflows/create_extracts/microdata/).

### Building the JSON from Julia instead of a file

If you'd rather construct the extract in Julia, build a `Dict` and serialize it. Note that `extract_submit` always reads from a **file path on disk**, so you still need to write it out:

```julia
using JSON3

extract = Dict(
    "description"   => "CPS ASEC 2018-2019: demographics and income",
    "dataStructure" => Dict("rectangular" => Dict("on" => "P")),
    "dataFormat"    => "fixed_width",
    "samples"       => Dict(
        "cps2018_03s" => Dict(),
        "cps2019_03s" => Dict(),
    ),
    "variables"     => Dict(
        "AGE"      => Dict(),
        "SEX"      => Dict(),
        "STATEFIP" => Dict(),
        "INCTOT"   => Dict("dataQualityFlags" => true),
        "ASECWT"   => Dict(),
    ),
)

open("cps_extract.json", "w") do io
    JSON3.pretty(io, extract)
end
```

Either form — hand-written `.json` or Julia-serialized — produces the same file on disk, which is what we'll feed to `extract_submit` next.

!!! note "Sharing or revising an extract"
    Because an IPUMS.jl extract definition is just a JSON file, *sharing* a definition
    is the file itself — commit it to your repo or paste it into an email. *Revising*
    an extract means editing the file and submitting it again, which produces a new
    extract number. There is no `revise_extract` helper. 

## Submitting and waiting for completion

`extract_submit` takes the JSON file path and returns a `DataExtractPostResponse` with the assigned extract number and an initial status:

```julia
res = extract_submit(api, "cps", "cps_extract.json")
res.number   # e.g. 142
res.status   # "queued"
```

Extracts run asynchronously on IPUMS servers. To poll, call `extract_info`, which returns a `(metadata, defn, msg)` tuple where `metadata["status"]` is the live status:

```julia
metadata, _, _ = extract_info(api, res.number, "cps")
while metadata["status"] ∉ ("completed", "failed", "canceled")
    sleep(30)
    metadata, _, _ = extract_info(api, res.number, "cps")
end
```

| Status | Meaning |
|---|---|
| `queued` | Accepted, not yet started |
| `started` | Running |
| `produced` | Files generated, finalizing |
| `completed` | Ready to download |
| `failed` / `canceled` | Terminal error states |

!!! warning "Extracts expire"
    Microdata extracts are removed from IPUMS servers **72 hours** after completion;
    NHGIS extracts after **2 weeks**. Download promptly or you'll need to resubmit.

