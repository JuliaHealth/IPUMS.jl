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


#=

XPaths for parsing DDI XML files

This is a list of XPATHs for locating file-level and variable-level metadata 
in a DDI XML file. The constants are stored here, but used in the `ddi_parser.jl`
file.

Extract level XPATHs:

EXTRACT_CONDITIONS - IPUMs conditions for fair and legal use of public data.
EXTRACT_CITATION - Citation information for referencing IPUMs data
EXTRACT_IPUMS_PROJECT - Name of the IPUMs project from which the data is taken, such as CPS, or DHS, etc.
EXTRACT_NOTES - User provided notes or additional miscellaneous information provided about the extract.
EXTRACT_DATE - The date that the extract was generated.

Variable level XPATHs:

VAR_NAME_XPATH = The name of the IPUMs variable.
VAR_STARTPOS_XPATH = The start position (in text columns) of the variable in a fixed width file specification.
VAR_ENDPOS_XPATH = The end position (in text columns) of the variable in a fixed width file specification.
VAR_WIDTH_XPATH = The width postion (in text columns) of variable in a fixed width file specification. 
VAR_LABL_XPATH = A short description for the data contained in a variable.
VAR_TXT_XPATH = A longer and more complete description of the data contained in a variable.
VAR_DCML_XPATH = The number of decimal points contained in a variable.
VAR_TYPE_XPATH = An indicator of whether the variable is either a string or numeric data type.
VAR_INTERVAL_XPATH = An indicator of whether a numeric variable is continuous or discrete.
VAR_CATEGORY_XPATH = A description of the category levels and corresponding numerical values for a categorical variable, such as 
                        "Women => 0, Men => 1"

=#

EXTRACT_CONDITIONS = "/x:codeBook/x:stdyDscr/x:dataAccs/x:useStmt/x:conditions"
EXTRACT_CITATION = "/x:codeBook/x:stdyDscr/x:dataAccs/x:useStmt/x:citReq"
EXTRACT_IPUMS_PROJECT = "/x:codeBook/x:stdyDscr/x:citation/x:serStmt/x:serName"
EXTRACT_NOTES = "/x:codeBook/x:stdyDscr/x:notes"
EXTRACT_DATE = "/x:codeBook/x:stdyDscr/x:citation/x:prodStmt/x:prodDate/@date"

VAR_NODE_LOCATION = "/x:codeBook/x:dataDscr/x:var"
VAR_NAME_XPATH = "/x:codeBook/x:dataDscr/x:var/@name"
VAR_STARTPOS_XPATH = "/x:codeBook/x:dataDscr/x:var/x:location/@StartPos"
VAR_ENDPOS_XPATH = "/x:codeBook/x:dataDscr/x:var/x:location/@EndPos"
VAR_WIDTH_XPATH = "/x:codeBook/x:dataDscr/x:var/x:location/@width"
VAR_LABL_XPATH = "/x:codeBook/x:dataDscr/x:var/x:labl"
VAR_TXT_XPATH = "/x:codeBook/x:dataDscr/x:var/x:txt"
VAR_DCML_XPATH = "/x:codeBook/x:dataDscr/x:var/@dcml"
VAR_TYPE_XPATH = "/x:codeBook/x:dataDscr/x:var/x:varFormat/@type"
VAR_INTERVAL_XPATH = "/x:codeBook/x:dataDscr/x:var/@intrvl"
VAR_CATEGORY_XPATH = "/x:codeBook/x:dataDscr/x:var/x:catgry"




