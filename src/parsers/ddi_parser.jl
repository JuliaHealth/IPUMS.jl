

"""
    parse_ddi(filepath::String)

Parses a valid IPUMs DDI XML file and returns a `DDIInfo` object containing 
the IPUMs extract metadata. 

### Arguments

- `filepath::String` -- A string containing the path to the IPUMS DDI XML file. 

### Returns

A `DDIInfo` object that contains all of the file-level and variable-level 
metadata for the IPUMs extract.

# Examples

Let's assume we have an extract DDI file named `my_extract.xml`
```julia-repl
julia> typeof(parse_ddi("my_extract.xml"))
IPUMS.DDIInfo
```
"""
function parse_ddi(filepath::String)

    # check to make sure the provided file is an xml file.
    splitext(filepath)[2] != ".xml" && throw(ArgumentError("The DDI file: $filepath should be an XML file."))
    
    # check to make sure file exists
    !isfile(filepath) && throw(ArgumentError("The specified file: $filepath does not exist."))
    
    # QUESTION: check if file has multiple files -- then have to handle that
    
    # read xml file and parse extract level metadata
    
    ddifile = EzXML.readxml(filepath)
    ns = EzXML.namespace(ddifile.root)
    
    ddi = DDIInfo(filepath=filepath, _xml_doc=ddifile, _ns=ns)

    _read_ddi_and_parse_extract_level_metadata!(ddi)
    
    # get variables metadata from file
    _get_var_metadata_from_ddi!(ddi)
    
    return ddi

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


    # This loop iterates over each variable and identifies its datatype. 
    # The notations coded in the original DDI file are somewhat ambiguous,
    # and hence the datatype must be manually identified before data import.

    var_dtype_vec = DataType[]
    for i in eachindex(name_nodes)
        if (vartype_vec[i] == "numeric") && (dcml_vec[i] == 0)
            push!(var_dtype_vec, Int64)
        elseif vartype_vec[i] == "numeric"
            push!(var_dtype_vec, Float64)
        else
            push!(var_dtype_vec, String)
        end
    end
    # This loop iterates over all variables to find variables that are 
    # categorically coded, such as (1 => "Female", 2 => "Male"). For variables 
    # that are categorically coded, the `<catgry>` tag includes information on 
    # the categories and their corresponding numerical indices. 
    # The loop saves this coding information to a vector of key, value pairs.

    varnodes =  EzXML.findall(VAR_NODE_LOCATION, xmlroot, ["x" => ns])   
    category_vec = Union{Vector{@NamedTuple{val::Int64, labl::String}}, Nothing}[]
    for i in eachindex(varnodes)
        n = EzXML.findall("x:catgry", varnodes[i], ["x" => ns])
        if length(n) > 0
            catvalue_nodes = EzXML.findall("x:catgry/x:catValu", varnodes[i], ["x" => ns])
            l_nodes = EzXML.findall("x:catgry/x:labl", varnodes[i], ["x" => ns])
            
            # QUESTION: does this parse statement need a try...catch?
            catvalue_vec = parse.(Int64, [v.content for v in catvalue_nodes])
            l_vec = [v.content for v in l_nodes]
            push!(category_vec, [(val = catvalue_vec[i], labl = l_vec[i]) for i=1:length(catvalue_vec)])
        
        else
            push!(category_vec, nothing)
        end
    end

    # The `coder instructions <codInstr>` tag contains additional information 
    # on how a variable is coded and used. Not all variables have this tag. 
    # This loop iterates over all variables and saves the contents of the coder
    # instructions tag to the array if it exists. If a variable is missing the 
    # coder instructions tag, then `nothing` is saved to the array.

    regex = r"^(?<val>[[:graph:]]+)(([[:blank:]]+[[:punct:]|=]+[[:blank:]])+)(?<lbl>.+)$"m
    regex2 = r"^(?<val>[[:graph:]]+)(([[:blank:]]+[[:punct:]|=]+[[:blank:]])+)(?<lbl>.+)$"m
    
    coder_instr_vec = Union{String, Nothing}[]
    for i in eachindex(varnodes)
        n = EzXML.findall("x:codInstr", varnodes[i], ["x" => ns])
        if length(n) > 0
            coder_instr_nodes = EzXML.findall("x:codInstr", varnodes[i], ["x" => ns])
            push!(coder_instr_vec, coder_instr_nodes[1].content)
            
            # These 2 regex statements are taken directly from the IPUMSR R 
            # package, starting on line 911 of the ddi_read.R file. There
            # are 2 different regex statements that might match the unstructured 
            # text, hence we match on both statements. If the first match succeeds
            # we privilege it, otherwise we consider the second match.
            
            matches = [(val=_string_to_num(m[:val]), labl=m[:lbl]) for m in eachmatch(regex, coder_instr_nodes[1].content)]
            matches2 = [(val=_string_to_num(m[:val]), labl=m[:lbl]) for m in eachmatch(regex2, coder_instr_nodes[1].content)]
            if (length(matches) > 0) && (!isnothing(category_vec[i]))
                append!(category_vec[i], matches)
            elseif (length(matches) > 0) && (isnothing(category_vec[i]))
                category_vec[i] = matches
            elseif (length(matches2) > 0) && (!isnothing(category_vec[i]))
                append!(category_vec[i], matches2) 
            elseif (length(matches2) > 0) && (isnothing(category_vec[i]))
                category_vec[i] = matches2
            end
        else 
            push!(coder_instr_vec, nothing)
        end
    end

    # Prepare the metadata summary dataframe, to help display the results.
    # Save that data summary to the DDIInfo object.
    
    categorical_vec = [ifelse(isnothing(r), "No" , "Yes") for r in category_vec]
    summary_df = DataFrame([name_vec, labl_vec, var_dtype_vec, startpos_vec, 
                            endpos_vec, categorical_vec], 
                            [:name, :description, :datatype, :start_pos, 
                            :end_pos, :categorical])
    ddi.data_summary = summary_df

    # This loop creates DDIVariable objects for each variable in the dataset, 
    # and pushes those objects into a vector. We will later use this information
    # when configuring the dataframe column names, datatypes, metadata, etc.
    var_vector = DDIVariable[]
    for i in eachindex(name_nodes)
        dv = DDIVariable(name=name_vec[i],
                            position_start=startpos_vec[i],
                            position_end=endpos_vec[i],
                            position_width=width_vec[i],
                            labl=labl_vec[i],
                            desc=txt_vec[i],
                            dcml=dcml_vec[i],
                            var_dtype=var_dtype_vec[i],
                            var_interval=varinterval_vec[i],
                            category_labels=category_vec[i],
                            coder_instructions=coder_instr_vec[i])
        push!(var_vector, dv)
    end

    ddi.variable_info = var_vector

end


"""
    _string_to_num(x::SubString{String})

This is an internal function and not meant for the public API. This function
    takes a text string and returns only the numeric portion of the string. 
    For example in the input is "Codes999999", the function will return an
    Int64 with the value 999999.

### Arguments

- `x::SubString{String}` - A string that may contain some numeric data mixed with text.

### Returns

This function returns the numeric part of the string, coded as an Int64 datatype.

"""
function _string_to_num(x::SubString{String})
    n = [v.match for v in eachmatch(r"[0-9]+", x)][1]
    return parse(Int64, n)
end

