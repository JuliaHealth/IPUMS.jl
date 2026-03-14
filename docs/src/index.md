# IPUMS

Documentation for [IPUMS](https://github.com/TheCedarPrince/IPUMS.jl).

# IPUMS.jl Demo

IPUMS.jl is an in-development package built on OpenAPI.jl for accessing IPUMS data via their API.

## Downloading Data from NHGIS

Set up the API client using your key from the NHGIS IPUMS website, then point to an extract definition file.

```julia
using IPUMS

api = IPUMSAPI("https://api.ipums.org/", Dict("Authorization" => "Your_Key"))
```

Submit an extract request:

```julia
test_extract_definition = "test/testdata/example_extract_request.json"
```

Check the extract's status:

```julia
res = extract_submit(api, "nhgis", test_extract_definition)
metadata, defn, msg = extract_info(api, res.number, "nhgis")
```

List all previously submitted extracts:

```julia
extract_list(api, "nhgis")
```

Download the result to a local path.

```julia
extract_download(api, res.number, "nhgis"; output_path = "file_downloads/")
```

## Loading CPS Extract Data

Parse the DDI metadata file and load the extract into a DataFrame using sample data from the IPUMS.jl repo.

```julia
ddi = parse_ddi("test/testdata/cps_00157.xml")
df = load_ipums_extract(ddi, "test/testdata/cps_00157.dat")
```

The resulting DataFrame looks like this:

```julia
3×8 DataFrame
 Row │ YEAR   SERIAL  MONTH  ASECWTH  STATEFIP  PERNUM  ASECWT   INCTOT
     │ Int64  Int64   Int64  Float64  Int64     Int64   Float64  Int64
─────┼─────────────────────────────────────────────────────────────────────
   1 │  1962      80      3  1475.59        55       1  1475.59       4883
   2 │  1962      80      3  1475.59        55       2  1470.72       5800
   3 │  1962      80      3  1475.59        55       3  1578.75  999999998
```

```@autodocs
Modules = [IPUMS]
```
