library(ncdf4)
library(raster)
library(ggplot2)
install.packages("lubridate")
library(lubridate)
#set the working folder
setwd("C:/Users/88888/Desktop/Drought/dataset-satellite-soil-moisture")
# List all .nc files in the current directory
nc_files <- list.files(pattern = "\\.nc$")

# Load the first file to get the dimensions
first_nc <- nc_open(nc_files[1])
lon <- ncvar_get(first_nc, "lon")
lat <- ncvar_get(first_nc, "lat")
time <- ncvar_get(first_nc, "time")
time <- as.POSIXct("1970-01-01") + as.difftime(time, units = "days")


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


sm_data <- ncvar_get(first_nc, "sm", start = c(lon_index, lat_index,1), count = c(1, 1,1))
time_data <- ncvar_get(first_nc, "time")

smlist <- list()
smbreton <- data.frame(row.names = c('year','month','sm'))
sm_stettler <- data.frame(row.names = c('year','month','sm'))
sm_oyen <- data.frame(row.names = c('year','month','sm'))
sm_neir <- data.frame(row.names = c('year','month','sm'))
sm_atmore <- data.frame(row.names = c('year','month','sm'))
sm_barnwell <- data.frame(row.names = c('year','month','sm'))
sm_hussar <- data.frame(row.names = c('year','month','sm'))
sm_mundare <- data.frame(row.names = c('year','month','sm'))
# Loop through each file and add to the raster stack
for (file in nc_files) {
  nc <- nc_open(file)
  moisture_data <-  ncvar_get(nc, "sm", start = c(lon_index, lat_index,1), count = c(1, 1,1))
  moisture_data_stettler <-  ncvar_get(nc, "sm", start = c(lon_index_stettler, lat_index_stettler,1), count = c(1, 1,1))
  moisture_data_oyen <-  ncvar_get(nc, "sm", start = c(lon_index_oyen, lat_index_oyen,1), count = c(1, 1,1))
  moisture_data_neir <-  ncvar_get(nc, "sm", start = c(lon_index_neir, lat_index_neir,1), count = c(1, 1,1))
  moisture_data_atmore <-  ncvar_get(nc, "sm", start = c(lon_index_atmore, lat_index_atmore,1), count = c(1, 1,1))
  moisture_data_barnwell <-  ncvar_get(nc, "sm", start = c(lon_index_barnwell, lat_index_barnwell,1), count = c(1, 1,1))
  moisture_data_hussar <-  ncvar_get(nc, "sm", start = c(lon_index_hussar, lat_index_hussar,1), count = c(1, 1,1))
  moisture_data_mundare <-  ncvar_get(nc, "sm", start = c(lon_index_mundare, lat_index_mundare,1), count = c(1, 1,1))
  time <- ncvar_get(nc, "time")
  time <- as.POSIXct("1970-01-01") + as.difftime(time, units = "days")
  y <- year(time)
  m <- month(time)
  smbreton <- rbind(smbreton,c(y,m,moisture_data))
  sm_stettler <- rbind(sm_stettler,c(y,m,moisture_data_stettler))
  sm_oyen <- rbind(sm_oyen,c(y,m,moisture_data_oyen))
  sm_neir <- rbind(sm_neir,c(y,m,moisture_data_neir))
  sm_atmore <- rbind(sm_atmore,c(y,m,moisture_data_atmore))
  sm_barnwell <- rbind(sm_barnwell,c(y,m,moisture_data_barnwell))
  sm_hussar <- rbind(sm_hussar,c(y,m,moisture_data_hussar))
  sm_mundare <- rbind(sm_mundare,c(y,m,moisture_data_mundare))
  nc_close(nc)
}
for (file in nc_files) {
  nc <- nc_open(file)
 
  
  moisture_data_oyen <-  ncvar_get(nc, "sm", start = c(lon_index_oyen, lat_index_oyen,1), count = c(1, 1,1))
  
  
  time <- ncvar_get(nc, "time")
  time <- as.POSIXct("1970-01-01") + as.difftime(time, units = "days")
  y <- year(time)
  m <- month(time)
 
  
  sm_oyen <- rbind(sm_oyen,c(y,m,moisture_data_oyen))
 
  
  nc_close(nc)
}

for (file in nc_files) {
  nc <- nc_open(file)

  
  moisture_data_neir <-  ncvar_get(nc, "sm", start = c(lon_index_neir, lat_index_neir,1), count = c(1, 1,1))
 
  
  time <- ncvar_get(nc, "time")
  time <- as.POSIXct("1970-01-01") + as.difftime(time, units = "days")
  y <- year(time)
  m <- month(time)

  
  sm_neir <- rbind(sm_neir,c(y,m,moisture_data_neir))

  
  nc_close(nc)
}

for (file in nc_files) {
  nc <- nc_open(file)

  
  moisture_data_atmore <-  ncvar_get(nc, "sm", start = c(lon_index_atmore, lat_index_atmore,1), count = c(1, 1,1))
  
  
  time <- ncvar_get(nc, "time")
  time <- as.POSIXct("1970-01-01") + as.difftime(time, units = "days")
  y <- year(time)
  m <- month(time)

  
  sm_atmore <- rbind(sm_atmore,c(y,m,moisture_data_atmore))
 
  
  nc_close(nc)
}

for (file in nc_files) {
  nc <- nc_open(file)
  
  
  moisture_data_barnwell <-  ncvar_get(nc, "sm", start = c(lon_index_barnwell, lat_index_barnwell,1), count = c(1, 1,1))
  
  
  time <- ncvar_get(nc, "time")
  time <- as.POSIXct("1970-01-01") + as.difftime(time, units = "days")
  y <- year(time)
  m <- month(time)
 
  
  sm_barnwell <- rbind(sm_barnwell,c(y,m,moisture_data_barnwell))
 
  
  nc_close(nc)
}

for (file in nc_files) {
  nc <- nc_open(file)
 
  
  moisture_data_hussar <-  ncvar_get(nc, "sm", start = c(lon_index_hussar, lat_index_hussar,1), count = c(1, 1,1))
  
  
  time <- ncvar_get(nc, "time")
  time <- as.POSIXct("1970-01-01") + as.difftime(time, units = "days")
  y <- year(time)
  m <- month(time)
 
  
  sm_hussar <- rbind(sm_hussar,c(y,m,moisture_data_hussar))

  
  nc_close(nc)
}

for (file in nc_files) {
  nc <- nc_open(file)
 
  
  moisture_data_mundare <-  ncvar_get(nc, "sm", start = c(lon_index_mundare, lat_index_mundare,1), count = c(1, 1,1))
  time <- ncvar_get(nc, "time")
  time <- as.POSIXct("1970-01-01") + as.difftime(time, units = "days")
  y <- year(time)
  m <- month(time)
  
  
  sm_mundare <- rbind(sm_mundare,c(y,m,moisture_data_mundare))
  nc_close(nc)
}
write.csv(smbreton,"C:/Users/88888/Desktop/Drought/satellitesmdata.csv", row.names = FALSE)
write.csv(sm_stettler,"C:/Users/88888/Desktop/Drought/satellitesmdatasm_stettler.csv", row.names = FALSE)
write.csv(sm_oyen,"C:/Users/88888/Desktop/Drought/satellitesmdatasm_oyen.csv", row.names = FALSE)
write.csv(sm_neir,"C:/Users/88888/Desktop/Drought/satellitesmdatasm_neir.csv", row.names = FALSE)
write.csv(sm_atmore,"C:/Users/88888/Desktop/Drought/satellitesmdatasm_atmore.csv", row.names = FALSE)
write.csv(sm_barnwell,"C:/Users/88888/Desktop/Drought/satellitesmdatasm_barnwell.csv", row.names = FALSE)
write.csv(sm_hussar,"C:/Users/88888/Desktop/Drought/satellitesmdatasm_hussar.csv", row.names = FALSE)
write.csv(sm_mundare,"C:/Users/88888/Desktop/Drought/satellitesmdatasm_mundare.csv", row.names = FALSE)

for (file in nc_files) {
  nc <- nc_open(file)
  moisture_data_stettler <-  ncvar_get(nc, "sm", start = c(lon_index_stettler, lat_index_stettler,1), count = c(1, 1,1))
  time <- ncvar_get(nc, "time")
  time <- as.POSIXct("1970-01-01") + as.difftime(time, units = "days")
  y <- year(time)
  m <- month(time)
  sm_stettler <- rbind(sm_stettler,c(y,m,moisture_data_stettler))
  nc_close(nc)
}


write.csv(sm_stettler,"C:/Users/88888/Desktop/Drought/satellitesmdatasm_stettler.csv", row.names = FALSE)





# Create a data frame for plotting
plot_data <- data.frame(date = rep(time[time_indices]),
                        percentage = as.vector(percentage_matrix))


# Plot the results


ggplot(plot_data, aes(x = date, y = percentage*100)) +
  geom_col(fill = "grey", color = "black", size = 0.25) +  # Use a specific color palette
  labs(title = "Percentage of Grids with SPEI < -1.4 in Alberta, Canada (2010-2021)",
       x = "Date",
       y = "Percentage") +
  theme_minimal(base_size = 14) +  # Adjust base font size
  theme(
    plot.title = element_text(size = 16, hjust = 0.5, face = "bold"),
    axis.title = element_text(size = 12),
    axis.text = element_text(size = 12),
    legend.title = element_text(size = 12),
    legend.text = element_text(size = 12),
    legend.position = "right",  # Adjust legend position
    panel.grid.major = element_blank(),  # Remove major gridlines
    panel.grid.minor = element_blank(),  # Remove minor gridlines
    panel.border = element_blank(),  # Remove panel border
    axis.line = element_line(),  # Adjust axis line thickness
    plot.margin = margin(1, 1, 1, 1, "cm")  # Adjust plot margins
  ) 


