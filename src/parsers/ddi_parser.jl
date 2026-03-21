

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

    ddi = DDIInfo(; filepath=filepath, _xml_doc=ddifile, _ns=ns)

    _read_ddi_and_parse_extract_level_metadata!(ddi)

    # get variables metadata from file
    _get_var_metadata_from_ddi!(ddi)

    return ddi
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
    extension = filepath[(findlast(==('.'), filepath) + 1):end]

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
    extension = filepath[(findlast(==('.'), filepath) + 1):end]

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
    ddi.ipums_project =
        EzXML.findall(EXTRACT_IPUMS_PROJECT, xmlroot, ["x" => ns])[1].content
    ddi.extract_notes = EzXML.findall(EXTRACT_NOTES, xmlroot, ["x" => ns])[1].content
    return ddi.extract_date = EzXML.findall(EXTRACT_DATE, xmlroot, ["x" => ns])[1].content
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

    varnodes = EzXML.findall(VAR_NODE_LOCATION, xmlroot, ["x" => ns])
    category_vec = Union{Vector{@NamedTuple{val::Int64, labl::String}},Nothing}[]
    for i in eachindex(varnodes)
        n = EzXML.findall("x:catgry", varnodes[i], ["x" => ns])
        if length(n) > 0
            catvalue_nodes = EzXML.findall("x:catgry/x:catValu", varnodes[i], ["x" => ns])
            l_nodes = EzXML.findall("x:catgry/x:labl", varnodes[i], ["x" => ns])

            # QUESTION: does this parse statement need a try...catch?
            catvalue_vec = parse.(Int64, [v.content for v in catvalue_nodes])
            l_vec = [v.content for v in l_nodes]
            push!(
                category_vec,
                [(val=catvalue_vec[i], labl=l_vec[i]) for i in 1:length(catvalue_vec)],
            )

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

    coder_instr_vec = Union{String,Nothing}[]
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

            matches = [
                (val=_string_to_num(m[:val]), labl=m[:lbl]) for
                m in eachmatch(regex, coder_instr_nodes[1].content)
            ]
            matches2 = [
                (val=_string_to_num(m[:val]), labl=m[:lbl]) for
                m in eachmatch(regex2, coder_instr_nodes[1].content)
            ]
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

    categorical_vec = [ifelse(isnothing(r), "No", "Yes") for r in category_vec]
    summary_df = DataFrame(
        [name_vec, labl_vec, var_dtype_vec, startpos_vec, endpos_vec, categorical_vec],
        [:name, :description, :datatype, :start_pos, :end_pos, :categorical],
    )
    ddi.data_summary = summary_df

    # This loop creates DDIVariable objects for each variable in the dataset, 
    # and pushes those objects into a vector. We will later use this information
    # when configuring the dataframe column names, datatypes, metadata, etc.
    var_vector = DDIVariable[]
    for i in eachindex(name_nodes)
        dv = DDIVariable(;
            name=name_vec[i],
            position_start=startpos_vec[i],
            position_end=endpos_vec[i],
            position_width=width_vec[i],
            labl=labl_vec[i],
            desc=txt_vec[i],
            dcml=dcml_vec[i],
            var_dtype=var_dtype_vec[i],
            var_interval=varinterval_vec[i],
            category_labels=category_vec[i],
            coder_instructions=coder_instr_vec[i],
        )
        push!(var_vector, dv)
    end

    return ddi.variable_info = var_vector
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

    # Load variable metadata from the DDI object.
    varinfo = ddi.variable_info
    ncols = length(varinfo)
    name_vec = String[v.name for v in varinfo]

    # Memory-map the file as raw bytes and determine the line length.
    # Fixed-width files have uniform line lengths so we can use arithmetic
    # offsets to locate any field in the file without allocating Strings.
    data = open(io -> Mmap.mmap(io), extract_filepath)
    line_len = findfirst(==(UInt8('\n')), data)
    nrows = count(==(UInt8('\n')), data)
    if !isempty(data) && data[end] != UInt8('\n')
        nrows += 1
    end

    # Pre-allocate typed column vectors and parse each column from the
    # memory-mapped byte array using type-stable function barriers.
    columns = Vector{AbstractVector}(undef, ncols)
    for j in 1:ncols
        v = varinfo[j]
        if v.var_dtype === Int64
            col = Vector{Union{Missing, Int64}}(undef, nrows)
            _parse_column_int!(col, data, v.position_start, v.position_end, line_len)
            columns[j] = col
        elseif v.var_dtype === Float64
            col = Vector{Union{Missing, Float64}}(undef, nrows)
            _parse_column_float!(col, data, v.position_start, v.position_end, line_len, v.dcml)
            columns[j] = col
        else
            col = Vector{Union{Missing, String}}(undef, nrows)
            _parse_column_string!(col, data, v.position_start, v.position_end, line_len)
            columns[j] = col
        end
    end

    # Build the DataFrame from pre-allocated columns without copying.
    df = DataFrame(columns, name_vec; copycols=false)

    # Save extract level metadata to the dataframe.
    metadata!(df, "conditions", ddi.conditions; style=:note)
    metadata!(df, "citation", ddi.citation; style=:note)
    metadata!(df, "ipums_project", ddi.ipums_project; style=:note)
    metadata!(df, "extract_notes", ddi.extract_notes; style=:note)
    metadata!(df, "extract_date", ddi.extract_date; style=:note)

    # Setup the column level metadata mapping.
    fields = Dict(
        "label" => :labl,
        "description" => :desc,
        "data type" => :var_dtype,
        "numeric type" => :var_interval,
        "coding instructions" => :coder_instructions,
        "category labels" => :category_labels,
    )

    # Iterate over each column and save the corresponding metadata
    # dictionary for that column to the dataframe.
    for i in eachindex(varinfo)
        for (k, fld) in fields
            colmetadata!(
                df,
                varinfo[i].name,
                k,
                getfield(varinfo[i], fld);
                style=:note,
            )
        end
    end

    return df
end;


"""
    _parse_int_bytes(data, start, stop)

Internal function that parses an integer value directly from a range of
bytes in a memory-mapped file. This avoids allocating any String or
SubString objects during parsing.

### Arguments

- `data::Vector{UInt8}` - The memory-mapped file contents as a byte array.
- `start::Int` - The starting byte position of the field.
- `stop::Int` - The ending byte position of the field.

### Returns

Returns the parsed `Int64` value, or `missing` if the field contains
only whitespace.
"""
function _parse_int_bytes(data::Vector{UInt8}, start::Int, stop::Int)
    # Skip leading spaces.
    i = start
    j = stop
    @inbounds while i <= j && data[i] == 0x20
        i += 1
    end
    # Skip trailing spaces.
    @inbounds while j >= i && data[j] == 0x20
        j -= 1
    end
    # Return missing if the field is empty after stripping spaces.
    if i > j
        return missing
    end
    # Check for a negative sign.
    neg = false
    @inbounds if data[i] == 0x2d
        neg = true
        i += 1
    end
    # Accumulate digits into an integer.
    result = Int64(0)
    @inbounds while i <= j
        result = result * 10 + Int64(data[i] - 0x30)
        i += 1
    end
    return neg ? -result : result
end


"""
    _parse_column_int!(col, data, col_start, col_end, line_len)

Internal function that parses a single integer column from all rows of a
memory-mapped fixed-width IPUMS data file. Each field is located using
arithmetic byte offsets and parsed directly from the raw bytes.

### Arguments

- `col::Vector{Union{Missing, Int64}}` - A pre-allocated column vector to hold the parsed integer values.
- `data::Vector{UInt8}` - The memory-mapped file contents as a byte array.
- `col_start::Int` - The starting byte position of the field within a line.
- `col_end::Int` - The ending byte position of the field within a line.
- `line_len::Int` - The number of bytes per line (including the newline character).

### Returns

This function does not return any output. Instead it modifies the
provided column vector in-place.
"""
function _parse_column_int!(
    col::Vector{Union{Missing, Int64}},
    data::Vector{UInt8},
    col_start::Int,
    col_end::Int,
    line_len::Int
)
    # Parse each row by computing the byte offset for this field.
    @inbounds for i in eachindex(col)
        offset = (i - 1) * line_len
        col[i] = _parse_int_bytes(data, offset + col_start, offset + col_end)
    end
end


"""
    _parse_column_float!(col, data, col_start, col_end, line_len, decimals)

Internal function that parses a single floating-point column from all rows
of a memory-mapped fixed-width IPUMS data file. Float values in IPUMS files
are encoded as integers (e.g. "12345" with decimals=2 represents 123.45).
This function parses the integer from raw bytes and divides by 10^decimals
to recover the float value.

### Arguments

- `col::Vector{Union{Missing, Float64}}` - A pre-allocated column vector to hold the parsed float values.
- `data::Vector{UInt8}` - The memory-mapped file contents as a byte array.
- `col_start::Int` - The starting byte position of the field within a line.
- `col_end::Int` - The ending byte position of the field within a line.
- `line_len::Int` - The number of bytes per line (including the newline character).
- `decimals::Int` - The number of implied decimal places in the encoded integer.

### Returns

This function does not return any output. Instead it modifies the
provided column vector in-place.
"""
function _parse_column_float!(
    col::Vector{Union{Missing, Float64}},
    data::Vector{UInt8},
    col_start::Int,
    col_end::Int,
    line_len::Int,
    decimals::Int
)
    # Pre-compute the divisor to convert the integer to a float.
    divisor = 10.0^decimals
    # Parse each row and divide by the divisor to recover the float value.
    @inbounds for i in eachindex(col)
        offset = (i - 1) * line_len
        val = _parse_int_bytes(data, offset + col_start, offset + col_end)
        col[i] = val === missing ? missing : val / divisor
    end
end


"""
    _parse_column_string!(col, data, col_start, col_end, line_len)

Internal function that parses a single string column from all rows of a
memory-mapped fixed-width IPUMS data file. Each field is located using
arithmetic byte offsets, stripped of leading and trailing spaces, and
converted to a Julia String.

### Arguments

- `col::Vector{Union{Missing, String}}` - A pre-allocated column vector to hold the parsed string values.
- `data::Vector{UInt8}` - The memory-mapped file contents as a byte array.
- `col_start::Int` - The starting byte position of the field within a line.
- `col_end::Int` - The ending byte position of the field within a line.
- `line_len::Int` - The number of bytes per line (including the newline character).

### Returns

This function does not return any output. Instead it modifies the
provided column vector in-place.
"""
function _parse_column_string!(
    col::Vector{Union{Missing, String}},
    data::Vector{UInt8},
    col_start::Int,
    col_end::Int,
    line_len::Int
)
    # Parse each row by computing byte offsets and stripping spaces.
    @inbounds for i in eachindex(col)
        offset = (i - 1) * line_len
        s_start = offset + col_start
        s_end = offset + col_end
        # Skip leading spaces.
        while s_start <= s_end && data[s_start] == 0x20
            s_start += 1
        end
        # Skip trailing spaces.
        while s_end >= s_start && data[s_end] == 0x20
            s_end -= 1
        end
        # Return missing if the field is empty after stripping.
        if s_start > s_end
            col[i] = missing
        else
            col[i] = String(data[s_start:s_end])
        end
    end
end

