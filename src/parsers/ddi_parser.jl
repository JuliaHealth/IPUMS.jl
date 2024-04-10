

#=

Set of XPaths for variables in DDI (.xml) files

=#

EXTRACT_CONDITIONS = "/x:codeBook/x:stdyDscr/x:dataAccs/x:useStmt/x:conditions"
EXTRACT_CITATION = "/x:codeBook/x:stdyDscr/x:dataAccs/x:useStmt/x:citReq"
EXTRACT_IPUMS_PROJECT = "/x:codeBook/x:stdyDscr/x:citation/x:serStmt/x:serName"
EXTRACT_NOTES = "/x:codeBook/x:stdyDscr/x:notes"
EXTRACT_DATE = "/x:codeBook/x:stdyDscr/x:citation/x:prodStmt/x:prodDate/@date"

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

"""
    parse_ddi(filepath::String)

Parses a valid IPUMs DDI XML file and returns a DDIInfo object containing 
the IPUMs extract metadata. 

### Arguments

- `filepath::String` -- A string containing the path to the IPUMS DDI XML file. 

### Returns

A DDIInfo object that contains all of the file-level and variable-level 
metadata for the IPUMs extract.

# Examples

Let's assume we have an extract DDI file named `my_extract.xml`
```julia-repl
julia> typeof(parse_ddi("my_extract.xml"))
IPUMS.DDIInfo
```
"""
function parse_ddi(filepath::String)

    # check to make sure file is xml and not zip
    
    _check_that_file_is_xml(filepath)

    # check to make sure file exists

    _check_that_file_exists(filepath)
    
    # QUESTION: check if file has multiple files -- then have to handle that
    
    # check_if_multiple_files_in_extract() # needed or not ?
    
    # read xml file and parse extract level metadata
    
    ddifile = EzXML.readxml(filepath)
    ns = EzXML.namespace(ddifile.root)
    
    ddi = DDIInfo(filepath=filepath, _xml_doc=ddifile, _ns=ns)

    _read_ddi_and_parse_extract_level_metadata!(ddi)
    
    # get variables metadata from file
    _get_var_metadata_from_ddi!(ddi)
    
    # TODO determine final output format. For now I return the object.    

    return ddi

end


function _check_that_file_is_xml(fname::String)
    
    extension = fname[findlast(==('.'), fname)+1:end]

    if extension == "xml"
        return true
    else
        ArgumentError("The DDI file should be in XML format.")
    end

end


function _check_that_file_exists(fname::String)

    if isfile(fname)
        return true
    else
        ArgumentError("The specified file does not exist.")
    end
end

"""
    _read_ddi_and_parse_extract_level_metadata!(ddi::DDIInfo)

This is an internal function and not meant for the public API. This function 
parses the DDI XML file and captures the file-level metadata.

### Arguments

- `ddi::DDIInfo` - A `DDIInfo` object that will retain all of the parsed metadata.

### Returns

The function return the original `DDIInfo` object with updated data in the 
attributes.

"""
function _read_ddi_and_parse_extract_level_metadata!(ddi::DDIInfo)

    xmlroot = ddi._xml_doc.root
    ns = ddi._ns

    ddi.conditions = EzXML.findall(EXTRACT_CONDITIONS, xmlroot, ["x" => ns])[1].content
    ddi.citation = EzXML.findall(EXTRACT_CITATION, xmlroot, ["x" => ns])[1].content
    ddi.ipums_project = EzXML.findall(EXTRACT_IPUMS_PROJECT, xmlroot, ["x" => ns])[1].content
    ddi.extract_notes = EzXML.findall(EXTRACT_NOTES, xmlroot, ["x" => ns])[1].content
    ddi.extract_date = EzXML.findall(EXTRACT_DATE, xmlroot, ["x" => ns])[1].content

end

"""
    _get_var_metadata_from_ddi!(ddi::DDIInfo)

This is an internal function and not meant for the public API. This function
    iterates over the variable nodes in the DDI XML file nodes. The data
    from each variable node is collected in a `DDIVariable` object, and a 
    vector of those `DDIVariable` object is save in the `DDIInfo` object.

### Arguments

- `ddi::DDIInfo` - A `DDIInfo` object that will retain all of the parsed metadata.

### Returns

The function return the original `DDIInfo` object with updated data in the 
attributes.

"""
function _get_var_metadata_from_ddi!(ddi::DDIInfo)

    xmlroot = ddi._xml_doc.root
    ns = ddi._ns
    
    name_nodes = EzXML.findall(VAR_NAME_XPATH, xmlroot, ["x" => ns])
    startpos_nodes = EzXML.findall(VAR_STARTPOS_XPATH, xmlroot, ["x" => ns])
    endpos_nodes = EzXML.findall(VAR_ENDPOS_XPATH, xmlroot, ["x" => ns])
    width_nodes = EzXML.findall(VAR_WIDTH_XPATH, xmlroot, ["x" => ns])
    labl_nodes = EzXML.findall(VAR_LABL_XPATH, xmlroot, ["x" => ns])
    txt_nodes = EzXML.findall(VAR_TXT_XPATH, xmlroot, ["x" => ns])
    dcml_nodes = EzXML.findall(VAR_DCML_XPATH, xmlroot, ["x" => ns])
    vartype_nodes = EzXML.findall(VAR_TYPE_XPATH, xmlroot, ["x" => ns])
    varinterval_nodes = EzXML.findall(VAR_INTERVAL_XPATH, xmlroot, ["x" => ns])

    name_vec = [v.content for v in name_nodes] 
    startpos_vec = parse.(Int64, [v.content for v in startpos_nodes])
    endpos_vec = parse.(Int64, [v.content for v in endpos_nodes])
    width_vec = parse.(Int64, [v.content for v in width_nodes])
    labl_vec = [v.content for v in labl_nodes]
    txt_vec = [v.content for v in txt_nodes]
    dcml_vec = parse.(Int64, [v.content for v in dcml_nodes])
    vartype_vec = [v.content for v in vartype_nodes]
    varinterval_vec = [v.content for v in varinterval_nodes]

    for i=1:length(name_nodes)
        
        if (vartype_vec[i] == "numeric") && (varinterval_vec[i] == "discrete") && (width_vec[i] < 10)
            vartype_vec[i] = "integer"
        elseif vartype_vec[i] == "numeric"
            vartype_vec[i] = "numeric"
        else 
            vartype_vec[i] = "character"
        end
    end

    # TODO get the Categorical Variable assignments to work
    catgry_nodes = EzXML.findall(VAR_CATEGORY_XPATH, xmlroot, ["x" => ns])
    catgry_vec = [v.content for v in catgry_nodes]
    #@show catgry_vec

    var_vector = DDIVariable[]
    for i in 1:length(name_nodes)
        dv = DDIVariable(name=name_vec[i],
                            position_start=startpos_vec[i],
                            position_end=endpos_vec[i],
                            position_width=width_vec[i],
                            labl=labl_vec[i],
                            desc=txt_vec[i],
                            dcml=dcml_vec[i],
                            vartype=vartype_vec[i],
                            varinterval=varinterval_vec[i])
        push!(var_vector, dv)
    end

    ddi.variable_info = var_vector

end