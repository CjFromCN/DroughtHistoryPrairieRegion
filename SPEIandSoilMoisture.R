

library(raster)
library(ncdf4)
library(sf)
library(ggplot2)
library(dplyr)
library(ggplot2)
library(rnaturalearth)
library(rnaturalearthdata)



nc_file <- "C:/Users/88888/Desktop/Drought/spei01.nc"
nc_data <- nc_open(nc_file)

lon_breton <- -114.5
lat_breton <- 53
lat_index <- which.min(abs(lat - lat_breton))
lon_index <- which.min(abs(lon - lon_breton))

lon_stettler <- -112.596
lat_stettler <- 52.347
lat_index_stettler <- which.min(abs(lat - lat_stettler))
lon_index_stettler <- which.min(abs(lon - lon_stettler))

lon_oyen <- -110.355
lat_oyen <- 51.3797
lat_index_oyen <- which.min(abs(lat - lat_oyen))
lon_index_oyen <- which.min(abs(lon - lon_oyen))


lon_neir <- -114.1
lat_neir <- 51.37
lat_index_neir <- which.min(abs(lat - lat_neir))
lon_index_neir <- which.min(abs(lon - lon_neir))

lon_atmore <- -112.825
lat_atmore <- 54.78
lat_index_atmore <- which.min(abs(lat - lat_atmore))

lon_index_atmore <- which.min(abs(lon - lon_atmore))

lon_barnwell <- -112.302

lat_barnwell <- 49.8017
lat_index_barnwell <- which.min(abs(lat - lat_barnwell))
lon_index_barnwell <- which.min(abs(lon - lon_barnwell))

lon_hussar <- -112.503
lat_hussar <- 51.1911
lat_index_hussar <- which.min(abs(lat - lat_hussar))
lon_index_hussar <- which.min(abs(lon - lon_hussar))

lon_mundare <- -112.2961
lat_mundare<- 53.5606
lat_index_mundare <- which.min(abs(lat - lat_mundare))
lon_index_mundare <- which.min(abs(lon - lon_mundare))




time_values <- ncvar_get(nc_data, "time")

# Assume time is in POSIXct format
data_sf_prairie$time <- as.POSIXct(time_values, origin = "1921-01-01")

start_date <- as.POSIXct("1921-01-01")
end_date <- as.POSIXct("2021-12-31")

sf_object_filtered <- subset(sf_object, time >= start_date & time <= end_date)


# Extract time dimension
time <- ncvar_get(nc_data, "time")

# Convert time to a more manageable format (e.g., POSIXct)
time <- as.POSIXct("1970-01-01") + as.difftime(time, units = "days")

# Define the time range from 2009-01-01 to 2022-12-31
start_date <- as.POSIXct("2009-01-01")
end_date <- as.POSIXct("2022-12-31")

# Find the indices of time within the specified range
time_indices <- which(time >= start_date & time <= end_date)

# Extract SPEI data

spei_data <- ncvar_get(ncfile, "spei", start = c(1, 1, time_indices[1]), count = c(-1, -1, length(time_indices)))

