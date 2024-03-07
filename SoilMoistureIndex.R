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

sm_data <- ncvar_get(first_nc, "sm", start = c(lon_index, lat_index,1), count = c(1, 1,1))
time_data <- ncvar_get(first_nc, "time")

smlist <- list()
smbreton <- data.frame(row.names = c('year','month','sm'))
# Loop through each file and add to the raster stack
for (file in nc_files) {
  nc <- nc_open(file)
  moisture_data <-  ncvar_get(nc, "sm", start = c(lon_index, lat_index,1), count = c(1, 1,1))
  time <- ncvar_get(nc, "time")
  time <- as.POSIXct("1970-01-01") + as.difftime(time, units = "days")
  y <- year(time)
  m <- month(time)
  smbreton <- rbind(smbreton,c(y,m,moisture_data))
  nc_close(nc)
}

write.csv(smbreton,"C:/Users/88888/Desktop/Drought/satellitesmdata.csv", row.names = FALSE)

print(typeof(time))
print(year(time))









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


