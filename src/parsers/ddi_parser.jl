

"""
    parse_ddi(filepath::String)

Parses a valid IPUMS DDI XML file and returns a `DDIInfo` object containing 
the IPUMS extract metadata. 

### Arguments

- `filepath::String` -- A string containing the path to the IPUMS DDI XML file. 

### Returns

A `DDIInfo` object that contains all of the file-level and variable-level 
metadata for the IPUMS extract.

Please check the documentation for `DDIInfo` for more information about this 
specific object.

# Examples

Let's assume we have an extract DDI file named `my_extract.xml`
```julia-repl
julia> typeof(parse_ddi("my_extract.xml"))
IPUMS.DDIInfo
```
"""
function parse_ddi(filepath::String)

    # check to make sure the provided file is an xml file.
    _check_that_file_is_xml(filepath)
    
    # check to make sure file exists
    _check_that_file_exists(filepath)
    
    # read xml file and parse extract level metadata
    
    ddifile = EzXML.readxml(filepath)
    ns = EzXML.namespace(ddifile.root)
    
    ddi = DDIInfo(filepath=filepath, _xml_doc=ddifile, _ns=ns)

    _read_ddi_and_parse_extract_level_metadata!(ddi)
    
    # get variables metadata from file
    _get_var_metadata_from_ddi!(ddi)
    
    return ddi;

end;


"""
    _check_that_file_is_xml(filepath::String)

This is an internal function and checks whether the provided file is an XML
    file. All DDI files should be in XML format.

### Arguments

- `filepath::String` - A file path that the user wishes to parse. The file must be
                    an XML file.

### Returns

The function returns nothing if the file is an XML file. If the file is not 
    an XML file, then the function raises an `ArgumentError`.
"""
function _check_that_file_is_xml(filepath::String)
    
    extension = filepath[findlast(==('.'), filepath)+1:end]

    if extension != "xml"
        throw(ArgumentError("The DDI file: $filepath should be an XML file."))
    else
        return true
    end

end


"""
    _check_that_file_is_dat(filepath::String)

This is an internal function and checks whether the provided file is a DAT
    file. All IPUMS extract data files should be in DAT format.

### Arguments

- `filepath::String` - A file path that the user wishes to import. The file must be
                    a DAT file.

### Returns

The function returns nothing if the file is a DAT file. If the file is not 
    a DAT file, then the function raises an `ArgumentError`.
"""
function _check_that_file_is_dat(filepath::String)
    
    extension = filepath[findlast(==('.'), filepath)+1:end]

    if extension != "dat"
        throw(ArgumentError("The IPUMS Extract File: $filepath should be an DAT file."))
    else
        return true
    end

end


"""
    _check_that_file_exists(filepath::String)

This is an internal function and checks whether the provided file exists or not. 

### Arguments

- `filepath::String` - A file path that the user wishes to parse. The file must be
                    an existing XML file.

### Returns

The function returns nothing if the file exists. If the file does not exist, 
    then the function raises an `ArgumentError`.
"""
function _check_that_file_exists(filepath::String)

    if !isfile(filepath)
        throw(ArgumentError("The specified file: $filepath does not exist."))
    else
        return true
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


"""
    load_ipums_extract(ddi::DDIInfo, extract_filepath::String)

    This file will take in a parsed DDIInfo object and file path to an IPUMS
    DAT extract file, and returns a dataframe containing all of the data. 

### Arguments

- `ddi::DDIInfo` - A DDIInfo object, which is the result of parsing a DDI metadata file.
- `extract_filepath::String` - The directory path to an IPUMS extract DAT file. 

### Returns

    This function outputs a Julia Dataframe that contains all of the data from 
    the IPUMS extract file. Further, the metadata fields of the Dataframe 
    contain the metadata parsed from the DDI file.  

# Examples

Let's assume we have an extract DDI file named `my_extract.xml`, and an extract
file called `my_extract.dat`.

```julia-repl
julia> ddi = parse_ddi("my_extract.xml");
julia> df = load_ipums_extract(ddi, "my_extract.dat");
```

"""
function load_ipums_extract(ddi::DDIInfo, extract_filepath::String)

    # Check that the extract file exists and is a DAT file.
    _check_that_file_is_dat(extract_filepath)
    _check_that_file_exists(extract_filepath)

    # Load ddi column-level metadata to local variables
    name_vec = [v.name for v in ddi.variable_info]
    range_vec = [v.position_start:v.position_end for v in ddi.variable_info]
    dtype_vec = [v.var_dtype[] for v in ddi.variable_info]
    dcml_vec = [v.dcml for v in ddi.variable_info]

    # Create empty dataframe

    df = DataFrame(dtype_vec, name_vec)

    # Save extract level metadata to dataframe. This data applies to the entire
    # file.

    metadata!(df, "conditions", ddi.conditions, style=:note);
    metadata!(df, "citation", ddi.citation, style=:note);
    metadata!(df, "ipums_project", ddi.ipums_project, style=:note);
    metadata!(df, "extract_notes", ddi.extract_notes, style=:note);
    metadata!(df, "extract_date", ddi.extract_date, style=:note);

    # Setup and write column level metadata to dataframe.
    fields = Dict("label" => :labl, 
                    "description" => :desc, 
                    "data type" => :var_dtype,
                    "numeric type" => :var_interval,
                    "coding instructions" => :coder_instructions,
                    "category labels" => :category_labels)

    # Iterate over each column in the dataset and save the corresponding metadata 
    # dictionary for that column to the dataframe.
    for i in eachindex(ddi.variable_info)
        for (k,v) in fields
            colmetadata!(df, 
                            ddi.variable_info[i].name, 
                            k, 
                            getfield(ddi.variable_info[i], v), 
                            style=:note);
        end
    end

    # Load extract data to the dataframe. The original ipums extract is a 
    # fixed width file with no delimiters. The original file saves float-valued 
    # variables as integers, hence we must to parse the file to correctly 
    # extract the float values from corresponding integers. 
    for line in eachline(extract_filepath)
        data = map((x,p,d) -> _parse_data(x, p, d), 
                        [strip(line[r]) for r in range_vec], 
                        [eltype(a) for a in dtype_vec],
                        [d for d in dcml_vec])
        push!(df, data)
    end

    return df;
end;


"""
    _parse_census_numbers_to_float(strnum::SubString{String}, decimals::Int64)

    This is an internal function, not for public use. The fixed width format
    of the IPUMS DAT files encodes all numbers as integers. For example, a 
    number like 1015.45 is encoded as "10545". This function parses string
    valued number into a floating point number, given the specified number of 
    decimals.  

### Arguments

- `strnum::SubString{String}` - A number that is coded as a string.
- `decimals::Int64` - An integer that indicates the number of decimal place in a floating point number.

### Returns

This function returns the numeric part of the string, coded as an Float64 datatype.

"""
function _parse_census_numbers_to_float(strnum::SubString{String}, decimals::Int64)
    return parse(Float64, chop(strnum, tail=decimals) * "." * last(strnum, decimals))
end


"""
    _parse_data(strnum::SubString{String}, dtype::DataType, decimals::Int64)

    This is an internal function to support the parsing of the fixed width 
    format of the IPUMS datafile. The file contains only numbers and absolutely
    no text. This function determines--based upon DDI metadata--whether a 
    specific text input is designated as an integer or floating point number,
    and then parses that value accordingly.
    
### Arguments

- `strnum::SubString{String}` - A string that may contain some numeric data encoded as text.
- `dtype::DataType` - The datatype that should be applied in the parsing of string number.
- `decimals::Int64` - The number of decimal values to include in a floating point number.
### Returns

This function returns the parsed number--integer or float--that corresponds to the input string.

"""
function _parse_data(strnum::SubString{String}, dtype::DataType, decimals::Int64)
    if dtype == Float64
        return _parse_census_numbers_to_float(strnum, decimals)
    elseif dtype == Int64
        return parse(dtype, strnum)
    else 
        return strnum
    end
end



"""
    load_ipums_extract_v2(ddi::DDIInfo, extract_filepath::String)

    This file will take in a parsed DDIInfo object and file path to an IPUMS
    DAT extract file, and returns a dataframe containing all of the data. 

### Arguments

- `ddi::DDIInfo` - A DDIInfo object, which is the result of parsing a DDI metadata file.
- `extract_filepath::String` - The directory path to an IPUMS extract DAT file. 

### Returns

    This function outputs a Julia Dataframe that contains all of the data from 
    the IPUMS extract file. Further, the metadata fields of the Dataframe 
    contain the metadata parsed from the DDI file.  

# Examples

Let's assume we have an extract DDI file named `my_extract.xml`, and an extract
file called `my_extract.dat`.

```julia-repl
julia> ddi = parse_ddi("my_extract.xml");
julia> df = load_ipums_extract_v2(ddi, "my_extract.dat");
```

"""
function load_ipums_extract_v2(ddi::DDIInfo, extract_filepath::String)

    # Check that the extract file exists and is a DAT file.
    _check_that_file_is_dat(extract_filepath)
    _check_that_file_exists(extract_filepath)

    # Load ddi column-level metadata to local variables
    name_vec = String[v.name for v in ddi.variable_info]
    range_vec = UnitRange{Int64}[v.position_start:v.position_end for v in ddi.variable_info]
    dtype_vec = Vector[v.var_dtype[] for v in ddi.variable_info]
    dcml_vec = Int64[v.dcml for v in ddi.variable_info]

    # Create empty dataframe

    df = DataFrame(dtype_vec, name_vec)

    # Save extract level metadata to dataframe. This data applies to the entire
    # file.

    metadata!(df, "conditions", ddi.conditions, style=:note);
    metadata!(df, "citation", ddi.citation, style=:note);
    metadata!(df, "ipums_project", ddi.ipums_project, style=:note);
    metadata!(df, "extract_notes", ddi.extract_notes, style=:note);
    metadata!(df, "extract_date", ddi.extract_date, style=:note);

    # Setup and write column level metadata to dataframe.
    fields = Dict("label" => :labl, 
                    "description" => :desc, 
                    "data type" => :var_dtype,
                    "numeric type" => :var_interval,
                    "coding instructions" => :coder_instructions,
                    "category labels" => :category_labels)

    # Iterate over each column in the dataset and save the corresponding metadata 
    # dictionary for that column to the dataframe.
    for i in eachindex(ddi.variable_info)
        for (k,v) in fields
            colmetadata!(df, 
                            ddi.variable_info[i].name, 
                            k, 
                            getfield(ddi.variable_info[i], v), 
                            style=:note);
        end
    end

    # Load extract data to the dataframe. The original ipums extract is a 
    # fixed width file with no delimiters. The original file saves float-valued 
    # variables as integers, hence we must to parse the file to correctly 
    # extract the float values from corresponding integers. 
    arr_dtype = DataType[eltype(a) for a in dtype_vec]
    arr_dcml = Int64[d for d in dcml_vec]
    arr_cache = Array{Number}(undef, length(name_vec))
    arr_cache .= 0

    _df_loader_inplace_svector!(df, extract_filepath, arr_cache, range_vec, arr_dtype, arr_dcml)
    
    return df;
end;


"""
    _df_loader_inplace_svector!(df, extract_filepath, array_cache, range_vec, p_dtype, p_dcml)

    This is an internal function to support the parsing of the fixed width 
    format of the IPUMS datafile. The file contains only numbers and absolutely
    no text. This function determines--based upon DDI metadata--whether a 
    specific text input is designated as an integer or floating point number,
    and then parses that value accordingly.
    
### Arguments

- `df::DataFrame` - An empty dataframe to hold the output of the parsing operation.
- `extract_filepath::String` - The string path location for the IPUMS data file.
- `array_cache::Array{Number}` - A cache array to hold the parsed data from a line of the data file. 
- `range_vec::Array{UnitRange{Int64}}` - A vector of ranges that correspond to the variables in a line of the data file.
- `p_dtype::Array{DataType}` - An array of datatypes for each variable in a line of the data file.
- `p_dcml::Array{Int64}` - An array of integers corresponding to the number of decimal values in a parsed variable.

### Returns

    This function does not return any output. Instead this variable modifies the 
    provided dataframe in-place.

"""
function _df_loader_inplace_svector!(df, extract_filepath, array_cache, range_vec, p_dtype, p_dcml)
    for line in eachline(extract_filepath)
        lvec = SubString{String}[strip(line[r]) for r in range_vec]
        map!((x, p, d) -> _parse_data_v2(x, p, d),
                array_cache, 
                lvec, 
                p_dtype, 
                p_dcml)
    push!(df, array_cache)
    end
end


"""
    _parse_data_v2(strnum::SubString{String}, dtype::Type{T}, decimals::Int64) where {T <: AbstractFloat}

    This is an internal function to support the parsing of the fixed width 
    format of the IPUMS datafile. The file contains only numbers and absolutely
    no text. This function determines--based upon DDI metadata--whether a 
    specific text input is designated as an integer or floating point number,
    and then parses that value accordingly.

    This function is specialized to work on float values. Float values in this
    file type are coded as integers. However, the DDI information also contains
    the number of decimals for the float fields. This function will parse a 
    float number from the integer string in the data file.

### Arguments

- `strnum::SubString{String}` - A string that may contain some numeric data encoded as text.
- `dtype::Type{T}` - The datatype that should be applied in the parsing of string number.
- `decimals::Int64` - The number of decimal values to include in a floating point number.

### Returns

    This function returns the parsed float number that corresponds to the input string.

"""
function _parse_data_v2(strnum::SubString{String}, dtype::Type{T}, decimals::Int64) where {T <: AbstractFloat}
        @. parse(dtype, chop(strnum, tail=decimals) * "." * last(strnum, decimals))
end


"""
    _parse_data_v2(strnum::SubString{String}, dtype::Type{T}, decimals::Int64) where {T <: Integer}

    This is an internal function to support the parsing of the fixed width 
    format of the IPUMS datafile. The file contains only numbers and absolutely
    no text. This function determines--based upon DDI metadata--whether a 
    specific text input is designated as an integer or floating point number,
    and then parses that value accordingly.

    This function is specialized for integer values. As the fixed width data
    format encodes both floats and integers as strings, the parsing function 
    must first determine the datatype of each entry and parse that entry accordingly.
    This function parses string values into their corresponding integer values.

### Arguments

- `strnum::SubString{String}` - A string that may contain some numeric data encoded as text.
- `dtype::Type{T}` - The datatype that should be applied in the parsing of string number.
- `decimals::Int64` - The number of decimal values to include in a floating point number.
                        Integers do not have any decimal values, hence this field is 
                        ignored for this function.

### Returns

    This function returns the parsed integer value that corresponds to the input string.

"""
function _parse_data_v2(strnum::SubString{String}, dtype::Type{T}, decimals::Int64) where {T <: Integer}
        @. parse(dtype, strnum)
end

