#= 

A list of IPUMS sources with associated metadata for use 
across the package.

=# 
const global ipums_sources = [
    IPUMSSource(
        proj_name = "IPUMS USA",
        url_name = "usa",
        collection_type = "microdata",
        api_support = true
    ),
    IPUMSSource(
        proj_name = "IPUMS CPS",
        url_name = "cps",
        collection_type = "microdata",
        api_support = true
    ),
    IPUMSSource(
        proj_name = "IPUMS International",
        url_name = "international",
        collection_type = "microdata",
        code_for_api = "ipumsi",
        api_support = true
    ),
    IPUMSSource(
        proj_name = "IPUMS NHGIS",
        url_name = "nhgis",
        collection_type = "aggregate data",
        api_support = true,
        home_url = "https://nhgis.org/",
    ),
    IPUMSSource(
        proj_name = "IPUMS IHGIS",
        url_name = "ihgis",
        collection_type = "aggregate data",
        home_url = "https://ihgis.ipums.org/",
    ),
    IPUMSSource(
        proj_name = "IPUMS ATUS",
        url_name = "atus",
        collection_type = "microdata",
        home_url = "https://www.atusdata.org/atus/",
    ),
    IPUMSSource(
        proj_name = "IPUMS AHTUS",
        url_name = "ahtus",
        collection_type = "microdata",
        home_url = "https://www.ahtusdata.org/ahtus/",
    ),
    IPUMSSource(
        proj_name = "IPUMS MTUS",
        url_name = "mtus",
        collection_type = "microdata",
        home_url = "https://www.mtusdata.org/mtus/",
    ),
    IPUMSSource(
        proj_name = "IPUMS DHS",
        url_name = "idhs",
        collection_type = "microdata",
        code_for_api = "dhs",
        home_url = "https://www.idhsdata.org/",
    ),
    IPUMSSource(
        proj_name = "IPUMS PMA",
        url_name = "pma",
        collection_type = "microdata"
    ),
    IPUMSSource(
        proj_name = "IPUMS MICS",
        url_name = "mics",
        collection_type = "microdata"
    ),
    IPUMSSource(
        proj_name = "IPUMS NHIS",
        url_name = "nhis",
        collection_type = "microdata"
    ),
    IPUMSSource(
        proj_name = "IPUMS MEPS",
        url_name = "meps",
        collection_type = "microdata"
    ),
    IPUMSSource(
        proj_name = "IPUMS Higher Ed",
        url_name = "highered",
        collection_type = "microdata"
    )
]
