## Name: 02_subset_netcdfs
## Purpose: Subset netcdf data for northern AUs
## Author: Micheline Campbell
## Date created: 20200108
  ## Last edited: 20200108
  ## Edited by: MC
## Contact info: michelineleecampbell@gmail.com
## Notes: 


# packages ----------------------------------------------------------------

library(ncdf4)
# library(rnaturalearth)
# library(rnaturalearthdata)
library(raster) # package for raster manipulation
library(rgdal) # package for geospatial analysis
# library(ggplot2)
library(rasterVis)
library(lubridate)

files=list.files("D:/north_AUS_DATA/netcdf_data",full.names = TRUE, pattern="nc")

for (j in seq_along(files)){
  
  outname <- stringr::str_remove_all(files[j], "D:/north_AUS_DATA/netcdf_data/")
  #setting wd containing netcdf files in the loop

  b<-brick(files[j])
  
  nc<-nc_open(files[j])
  
  #variable
  varname<-names(nc[['var']])[[1]]
  varunits <- ncatt_get(nc,varname,"units")[[2]]
  
  lon<-ncvar_get(nc,"lon")
  
  lat<-ncvar_get(nc,"lat", verbose = F)
  
  time<-ncvar_get(nc, "time")
  
  tunits <- ncatt_get(nc, "time", "units")[[2]]
  
  dlname <- ncatt_get(nc, varname,"long_name")[[2]]
  
  nc_close(nc)
  
  #assigning a crs
  proj4string(b)<-"+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0"
  
  #setting time as.Date 
  tm<-ymd(getZ(b))
  
  #setting time to rasterBrick
  b<-setZ(b, tm)
  
  # subsetting
  cropextent <- extent(c( 113, 153,-26, -10))
  
  b2 <- crop(b, cropextent)

  #setting wd where I want to save the "new" netcdf files
  # setwd(outdir)
  
  writeRaster(b2, filename = paste0("D:/north_AUS_DATA/netcdf_data/subset/",outname),
              format="CDF", varname=varname, varunit=varunits, longname=dlname,
              xname="lon", yname="lat", zname="time", zunit=tunits, overwrite=TRUE)
}
