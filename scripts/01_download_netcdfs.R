## Name: 01_download_netcdfs
## Purpose: Download netcdf data from SILO 
## Author: Micheline Campbell
## Date created: 20210108
  ## Last edited: 20210108
  ## Edited by: MC
## Contact info: michelineleecampbell@gmail.com
## Notes:


year <- read.csv("data/year_index.csv")
index <- unique(year$Year)
for(i in 1:length(index)){
 
iyear <- index[i]
filename <- paste0("https://s3-ap-southeast-2.amazonaws.com/silo-open-data/annual/monthly_rain/", iyear, ".monthly_rain.nc")
destname <- paste0("D:/north_AUS_DATA/netcdf_data/",iyear, ".monthly_rain.nc")

curl::curl_download(url = filename, destfile = destname)

}
