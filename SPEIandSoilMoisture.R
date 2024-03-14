
library(ncdf4)
library(lubridate)


nc_file <- "C:/Users/88888/Desktop/Drought/spei01.nc"
nc_data <- nc_open(nc_file)

lon <- ncvar_get(nc_data, "lon")
lat <- ncvar_get(nc_data, "lat")

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

spei_data <-  ncvar_get(nc_data, "spei", start = c(lon_index, lat_index,time_indices[1]), count = c(1, 1,length(time_indices)))
time_data <-  ncvar_get(nc_data, "time", start = c(time_indices[1]), count = c(length(time_indices)))
print(time_data)
time_data <- as.POSIXct("1970-01-01") + as.difftime(time_data, units = "days")

spei_stettler <-  ncvar_get(nc_data, "spei", start = c(lon_index_stettler, lat_index_stettler,time_indices[1]), count = c(1, 1,length(time_indices)))
spei_oyen <-  ncvar_get(nc_data, "spei", start = c(lon_index_oyen, lat_index_oyen,time_indices[1]), count = c(1, 1,length(time_indices)))
spei_neir <-  ncvar_get(nc_data, "spei", start = c(lon_index_neir, lat_index_neir,time_indices[1]), count = c(1, 1,length(time_indices)))
spei_atmore <-  ncvar_get(nc_data, "spei", start = c(lon_index_atmore, lat_index_atmore,time_indices[1]), count = c(1, 1,length(time_indices)))
spei_barnwell <-  ncvar_get(nc_data, "spei", start = c(lon_index_barnwell, lat_index_barnwell,time_indices[1]), count = c(1, 1,length(time_indices)))
spei_hussar <-  ncvar_get(nc_data, "spei", start = c(lon_index_hussar, lat_index_hussar,time_indices[1]), count = c(1, 1,length(time_indices)))
spei_mundare <-  ncvar_get(nc_data, "spei", start = c(lon_index_mundare, lat_index_mundare,time_indices[1]), count = c(1, 1,length(time_indices)))


print(typeof(time_data))
col_spei <- c('time','spei_stettler','spei_oyen','spei_neir','spei_atmore','spei_barnwell','spei_hussar','spei_mundare')
spei_df <- as.data.frame(matrix(nrow = length(spei_atmore),ncol =length(col_spei) ))
colnames(spei_df) <- col_spei
spei_df$time<- time_data
spei_df$spei_stettler<- spei_stettler
spei_df$spei_oyen<- spei_oyen
spei_df$spei_neir<- spei_neir
spei_df$spei_atmore<- spei_atmore
spei_df$spei_barnwell <- spei_barnwell
spei_df$spei_hussar<- spei_hussar
spei_df$spei_mundare<- spei_mundare

write.csv(spei_df,"C:/Users/88888/Desktop/Drought/speiFor7Locations.csv", row.names = FALSE)

