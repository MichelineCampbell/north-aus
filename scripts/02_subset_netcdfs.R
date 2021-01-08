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
library(rnaturalearth)
library(rnaturalearthdata)
library(raster) # package for raster manipulation
library(rgdal) # package for geospatial analysis
library(ggplot2)
library(rasterVis)



nc_data <- nc_open("D:/north_AUS_DATA/netcdf_data/1889.daily_rain.nc")


lon <- ncvar_get(nc_data, "lon")
lat <- ncvar_get(nc_data, "lat")
t <- ncvar_get(nc_data, "time")
tdate <- as.Date(t, origin=c('1889-01-01')) ## convert time (days since 18000101 to date)

rain.array <- ncvar_get(nc_data, "daily_rain") #extract temp anomaly data
fillvalue <- ncatt_get(nc_data, "daily_rain", "_FillValue") 
nc_close(nc_data)
rm(nc_data)

rain.array[rain.array == fillvalue$value] <- NA ## replace fill value with NA

r_brick <- brick(rain.array, xmn=min(lat), xmx=max(lat), ymn=min(lon), ymx=max(lon), crs=CRS("+proj=longlat +datum=WGS84 +no_defs"))
rm(rain.array)
r_brick <- t(r_brick)
r_brick <- flip(r_brick, direction = "y")


print(r_brick)
plot(r_brick$layer.1)
pr <- r_brickcorrect
pt <- cbind(c(100, 179), c(0, -55))
plot(pr[[1688]])
points(pt)

cropextent <- extent(c(100, 179, -55, 0))