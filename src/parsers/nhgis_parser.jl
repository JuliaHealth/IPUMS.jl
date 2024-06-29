

"""
    load_ipums_nhgis(filepath::String)

    This function will take in the filename for an NHGIS Shapefile, and will 
        return a GeoDataFrame object containing the shapefile data.

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
julia> gdf = load_ipums_nhgis("test/testdata/nhgis0001_shapefile/US_state_1790.shp");
```

"""
function load_ipums_nhgis(filepath::String)
    
    gdf = read(filepath)
    md = metadata(gdf)
    crs = metadata(gdf)["crs"]
    #nhgis_object = NHGISInfo(filepath, "NHGIS", md, crs)

    return gdf

end






