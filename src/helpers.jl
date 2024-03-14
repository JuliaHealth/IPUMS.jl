using HTTP

# Project-specific configurations ------

function proj_config()
    return [
        new_proj_config(
            "IPUMS USA",
            url_name = "usa",
            collection_type = "microdata",
            api_support = true
        ),
        new_proj_config(
            "IPUMS CPS",
            url_name = "cps",
            collection_type = "microdata",
            api_support = true
        ),
        new_proj_config(
            "IPUMS International",
            url_name = "international",
            collection_type = "microdata",
            code_for_api = "ipumsi",
            api_support = true
        ),
        new_proj_config(
            "IPUMS NHGIS",
            url_name = "nhgis",
            collection_type = "aggregate data",
            api_support = true,
            has_var_url = false,
            home_url = "https://nhgis.org/",
            var_url = var -> "https://data2.nhgis.org/main/"
        ),
        new_proj_config(
            "IPUMS IHGIS",
            url_name = "ihgis",
            collection_type = "aggregate data",
            has_var_url = false,
            home_url = "https://ihgis.ipums.org/",
            var_url = var -> "https://data.ihgis.ipums.org/main"
        ),
        new_proj_config(
            "IPUMS ATUS",
            url_name = "atus",
            collection_type = "microdata",
            home_url = "https://www.atusdata.org/atus/",
            var_url = var -> get_var_url("atusdata", "atus", var; ipums_domain = false)
        ),
        new_proj_config(
            "IPUMS AHTUS",
            url_name = "ahtus",
            collection_type = "microdata",
            home_url = "https://www.ahtusdata.org/ahtus/",
            var_url = var -> get_var_url("ahtusdata", "ahtus", var; ipums_domain = false)
        ),
        new_proj_config(
            "IPUMS MTUS",
            url_name = "mtus",
            collection_type = "microdata",
            home_url = "https://www.mtusdata.org/mtus/",
            var_url = var -> get_var_url("mtusdata", "mtus", var; ipums_domain = false)
        ),
        new_proj_config(
            "IPUMS DHS",
            url_name = "idhs",
            collection_type = "microdata",
            code_for_api = "dhs",
            home_url = "https://www.idhsdata.org/",
            var_url = var -> get_var_url("idhsdata", "idhs", var; ipums_domain = false)
        ),
        new_proj_config(
            "IPUMS PMA",
            url_name = "pma",
            collection_type = "microdata"
        ),
        new_proj_config(
            "IPUMS MICS",
            url_name = "mics",
            collection_type = "microdata"
        ),
        new_proj_config(
            "IPUMS NHIS",
            url_name = "nhis",
            collection_type = "microdata"
        ),
        new_proj_config(
            "IPUMS MEPS",
            url_name = "meps",
            collection_type = "microdata"
        ),
        new_proj_config(
            "IPUMS Higher Ed",
            url_name = "highered",
            collection_type = "microdata"
        )
    ]
end

function default_config()
    return new_proj_config(
        proj_name = "IPUMS",
        url_name = nothing,
        collection_type = nothing,
        code_for_api = nothing,
        api_support = nothing,
        has_var_url = false,
        home_url = "https://www.ipums.org",
        var_url = var -> "https://www.ipums.org"
    )
end

function new_proj_config(proj_name; url_name=nothing, collection_type=nothing, code_for_api=url_name, api_support=nothing, has_var_url=true, home_url=nothing, var_url=nothing)
    return Dict(
        :proj_name => proj_name,
        :url_name => url_name,
        :collection_type => collection_type,
        :code_for_api => code_for_api,
        :api_support => api_support,
        :has_var_url => has_var_url,
        :home_url => home_url != nothing ? home_url : "https://$url_name.ipums.org/",
        :var_url => var_url != nothing ? var_url : var -> get_var_url(url_name, var)
    )
end

function get_proj_config(proj; default_if_missing=true, verbose=true)
    proj = get_proj_name(proj)

    config = filter(x -> lowercase(x["proj_name"]) == lowercase(proj), proj_config())

    if isempty(config)
        if !default_if_missing
            error("Project not found. Available projects: $(join(ipums_data_collections()[:collection_name], ", "))")
        else
            if verbose
                println("Project not found. Redirecting to IPUMS homepage.")
            end
            config = [default_config()]
        end
    end

    return config[1]
end

function get_var_url(domain_proj, path_proj=domain_proj, var=nothing, ipums_domain=true)
    var = var != nothing ? var : "group"

    if ipums_domain
        ipums_path = ".ipums.org/"
    else
        ipums_path = ".org/"
    end

    return "https://$domain_proj$ipums_path$path_proj-action/variables/$var"
end

function get_proj_name(proj)
    collections = ipums_data_collections()

    proj = lowercase(proj)

    if proj in collections[:code_for_api]
        proj = collections[:collection_name][collections[:code_for_api] .== proj]
    else
        proj = replace(proj, "-" => " ")
    end

    return uppercase(proj)
end

# Example usage:

config = get_proj_config("IPUMS USA")
println(config)

# Now you can use HTTP.jl to fetch URLs as needed.
# For example:
response = HTTP.get(config[:home_url])
println(response)

