"""
```julia
IPUMSSource(
    proj_name::String, 
    url_name::String, 
    collection_type::String, 
    code_for_api::String = "", 
    api_support::Bool = false, 
    home_url::String = ""
)
```

A struct representing sources that IPUMS provides.

# Arguments

- `proj_name::String` - Name of the IPUMS project.
- `url_name::String` - Name of the project as used in that project's website URL.
- `collection_type::String` - Either `"microdata"` or `"aggregate data"` indicating the type of data this collection provides.

# Keyword Arguments

- `code_for_api::String` - The name of the project used when interacting with the IPUMS API (for collections that are supported by the API). (Default: `""`)
- `api_support::Bool` - Logical indicating whether the collection is supported by the IPUMS API. (Default: `false`)
- `home_url::String` - URL for the project's homepage. (Default: `""`)

# Returns

- `IPUMSSource` object specifying the previous parameters

# Example

```julia-repl
julia> IPUMSSource(
    proj_name = "IPUMS USA",
    url_name = "usa",
    collection_type = "microdata",
    api_support = true
)

IPUMS.IPUMSSource("IPUMS USA", "usa", "microdata", "", true, "")
```
"""
@kwdef struct IPUMSSource
        proj_name::String
        url_name::String
        collection_type::String
        code_for_api::String = ""
        api_support::Bool = false
        home_url::String = ""
        IPUMSSource(proj_name::String, url_name::String, collection_type::String, code_for_api::String, api_support::Bool, home_url::String) = new(proj_name, url_name, collection_type, code_for_api, api_support, home_url)
end


"""
```julia
DDIVariable(
    name::String = "", 
    position_start::Int64 = 9999,
    position_end::Int64 = 9999,
    position_width::Int64 = 9999,
    labl::String = "", 
    desc::String = "", 
    dcml::Int64 = 9999, 
    var_dtype::DataType = String,
    var_interval::String = "",
    category_labels::Union{Vector{Pair{Int64, String}}, Nothing} = nothing
    coder_instructions::Union{String, Nothing} = nothing
)
```

A struct representing individual variable/column metadata from an IPUMS extract
file. This stuct is used for parsing the IPUMS datafile, which may be of fixed 
width format, hence the `position_` fields. The default value for missing 
strings is an empty string `""`, while the default value for missing integer values 
is 9999.


# Keyword Arguments

- `name::String` - Name of the variable, as per the column name of the IPUMs 
                    extract file. This name is limited to 8 characters.
- `position_start::Int64` - The starting position (in columns) of a variable 
                            in a fixed width file format.
- `position_end::Int64` - The ending position (in columns) of a variable 
                            in a fixed width file format.
- `position_width::Int64` - The length (in columns) of a variable in a fixed 
                            width file format. 
- `labl::String` - A short description of the variable. Often the `labl` is 
                    used to display a description of the variable in a 
                    dataframe or display.
- `desc::String` - A longer description of the variable, including information 
                    about the use of the variable. 
- `dcml::Int64` - Identifies the number of decimal points in the variable.
- `var_dtype::DataType` - Indentifies the Julia data type of the variable.
- `var_interval::String` - Identifies if a numeric variable is discrete or 
                    continuous. 
- `category_labels::Union{Vector{Pair{Int64, String}}, Nothing}` - If a variable is 
                    categorical, then this is a vector of (key, value) pairs, where 
                    the `key` is a numerical index and the `value` is the category 
                    label, for example (1 => "category 1"). If a variable is not 
                    categorical, then this attribute has a value of `nothing`.
- `coder_instructions::Union{String, Nothing}` - Contains any additional 
                    information about how the variable was coded and how it 
                    should be treated.

# Returns

- `DDIVariable` object specifying the metadata for each variable.

# Example

```julia-repl
julia> DDIVariable(
    name = "YEAR",
    position_start = 1,
    position_end = 4,
    position_width = 4, 
    labl = "Survey year",
    desc = "YEAR reports the year in which the survey was conducted.  YEARP is repeated on person records.",
    dcml = 0,
    var_dtype = String,
    var_interval = "continuous",
    category_labels = nothing,
    coder_instructions = nothing
    )

IPUMS.DDIVariable("YEAR", 1, 4, 4, "Survey year", "YEAR reports the year in which the survey was conducted.  YEARP is repeated on person records.", 0, Int64, "continuous", nothing, nothing)
```

# References

Information about each variable field is taken from: 

https://ddialliance.org/Specification/DDI-Codebook/2.5/XMLSchema/field_level_documentation_files/schemas/codebook_xsd/elements/stdyDscr.html
"""
@kwdef mutable struct DDIVariable
    name::String = ""
    position_start::Int64 = 9999
    position_end::Int64 = 9999
    position_width::Int64 = 9999 
    labl::String = ""
    desc::String = ""
    dcml::Int64 = 9999
    var_dtype::DataType = String
    var_interval::String = ""
    category_labels::Union{Vector{@NamedTuple{val::Int64, labl::String}}, Nothing} = nothing
    coder_instructions::Union{String, Nothing} = nothing
end


"""
```julia
DDIInfo(
    filepath::String, 
    conditions::String = "", 
    citation::String = "", 
    ipums_project::String = "",
    extract_notes::Sring = "", 
    extract_date::String = "",
    variable_info::Vector{DDIVariable} = DDIVariable[]
    _xml_doc::EzXML.Document = EzXML.XMLDocument()
    _ns::String = ""
    data_summary::DataFrame = DataFrame()
)
```

A struct representing the metadata taken from an IPUMs extract. An IPUMs 
extract contains both file-level metadata \-\- such as the date of export \-\- as well
as variable level metadata \-\- such as the name and data type of a variable. 

The `DDIInfo` object is not generally called directly. The `parse_ddi()` 
function creates a `DDIinfo` object after successfully parsing a DDI 
file from an IPUMs extract. 

The `DDIInfo`
object contain file level metadata. The `variable_info` field of the `DDIInfo` 
object contains a vector of `DDIVariable` objects. `DDIVariable` objects contain
metadata information about individual IPUMs variables.   

# Keyword Arguments

- `filepath::String` -  File system path to the DDI (`.xml``) file.
- `conditions::String` - IPUMs legal specification on the proper use of IPUMs 
                            data.
- `citation::String` - Information for the citation of IPUMs data.
- `ipums_project::String` - Identifier for the IPUMs source of the extract 
                            data, such as `IPUMS CPS`, or `IPUMS USA`, etc. 
- `extract_notes::String` - Additional clarifying information or user nodes 
                            about the extract. 
- `extract_date::String` - Date on which the extract was produced.
- `variable_info::Vector{DDIVariable}` - a vector of `DDIVariable` objects,
                                        which contain metadata on each variable
                                        or column in the data file.
- `_xml_doc::EzXML.Document` - An internal attribute that contains an internal 
                                representation of the DDI DOM for parsing.
- `_ns::String` - An internal attribute to hold any namespaces used in the 
                    XML DOM.
- `data_summary::DataFrame` - Contains a dataframe that holds summary information
                    about the variables in the dataset, including variable names,
                    data types, variable descriptions, and categorical information.

# Returns

- `DDIInfo` object that contains both file-level and variable-level metadata
extracted from an IPUMs DDI (.xml) file. 

# Example

```julia-repl
julia> DDIInfo(filepath = "test_ddi.xml")

IPUMS.DDIInfo("test_ddi.xml", "", "", "", "", "", DDIVariable[], EzXML.Document(EzXML.Node(<DOCUMENT_NODE@0x0000000003583590>)), "", DataFrame)
```

# References

Information about each variable field is taken from: 

https://ddialliance.org/Specification/DDI-Codebook/2.5/XMLSchema/field_level_documentation_files/schemas/codebook_xsd/elements/var.html
"""
@kwdef mutable struct DDIInfo
    filepath::String
    conditions::String = ""
    citation::String = ""
    ipums_project::String = ""
    extract_notes::String = ""
    extract_date::String = ""
    variable_info::Vector{DDIVariable} = DDIVariable[]
    _xml_doc::EzXML.Document = EzXML.XMLDocument()
    _ns::String = ""
    data_summary::DataFrame = DataFrame()
end






