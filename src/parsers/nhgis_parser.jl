

"""
    load_ipums_nhgis(filepath::String)

    This function will take in the filename for an NHGIS Shapefile, and will 
        return an `NHGISInfo` object that contains a `GeoDataFrame` with the 
        file data, as well as additional metadata.

### Arguments

- `filepath::String` - The directory path to an IPUMS NHGIS extracted shapefile. 

### Returns

    This function outputs a Julia GeoDataframe that contains all of the data from 
    the IPUMS NHGIS extract file. Further, the metadata fields of the Dataframe 
    contain the metadata parsed from the Shapefile. 

# Examples

Let's assume we have an extract NHGIS file named `US_state_1790.shp` in a folder
that contains the other shapefile files. The user can open this Shapefile using 
the following code. 

```julia-repl
julia> datafile = "US_state_1790.shp"
julia> load_ipums_nhgis(datafile)
IPUMS.NHGISInfo("US_state_1790.shp", "NHGIS",
        0×0 DataFrame, 
        GeoFormatTypes.WellKnownText{GeoFormatTypes.CRS}(GeoFormatTypes.CRS(), 
        "PROJCS[\"USA_Contiguous_Albers_Equal_Area_Conic\",GEOGCS[\"NAD83\",
            DATUM[\"North_American_Datum_1983\",SPHEROID[\"GRS 1980\",6378137,
            298.257222101,AUTHORITY[\"EPSG\",\"7019\"]],AUTHORITY[\"EPSG\",
            \"6269\"]],PRIMEM[\"Greenwich\",0,AUTHORITY[\"EPSG\",\"8901\"]],
            UNIT[\"degree\",0.0174532925199433,AUTHORITY[\"EPSG\",\"9122\"]],
            AUTHORITY[\"EPSG\",\"4269\"]],PROJECTION[\"Albers_Conic_Equal_Area\"],
            PARAMETER[\"latitude_of_center\",37.5],PARAMETER[\"longitude_of_center\"
            ,-96],PARAMETER[\"standard_parallel_1\",29.5],
            PARAMETER[\"standard_parallel_2\",45.5],PARAMETER[\"false_easting\"
            ,0],PARAMETER[\"false_northing\",0],UNIT[\"metre\",1,
            AUTHORITY[\"EPSG\",\"9001\"]],AXIS[\"Easting\",EAST],
            AXIS[\"Northing\",NORTH],AUTHORITY[\"ESRI\",\"102003\"]]"), 
            16×8 DataFrame ....
```

"""
function load_ipums_nhgis(filepath::String)
    
    gdf = read(filepath)
    md = DataFrame(geometrycolumns = metadata(gdf)["geometrycolumns"])
    crs = metadata(gdf)["crs"]
    nhgis_object = NHGISInfo(filepath, "NHGIS", DataFrame(), crs, gdf)

    return nhgis_object

end






