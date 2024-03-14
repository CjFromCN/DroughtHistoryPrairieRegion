

library(raster)
library(ncdf4)
library(sf)
library(ggplot2)
library(dplyr)
install.packages("rnaturalearth")
install.packages("rnaturalearthdata")
library(ggplot2)
library(rnaturalearth)
library(rnaturalearthdata)








nc_file <- "C:/Users/88888/Desktop/Drought/spei01.nc"
nc_data <- nc_open(nc_file)


print(nc_data)
print(nc_data_raster)

lon <- ncvar_get(nc_data, "lon")
lat <- ncvar_get(nc_data, "lat")

prairie_shape <- st_read("C:/Users/88888/Documents/canadian_prairie_shapefile.shp")


validity <- st_is_valid(prairie_shape)
print(validity)
prairie_shape <- st_make_valid(prairie_shape)



# Generate all combinations of lon and lat
data_df <- expand.grid(lon = lon, lat = lat)

# Convert data_df to an sf object
data_sf <- st_as_sf(data_df, coords = c("lon", "lat"), crs = st_crs(prairie_shape))

# Use st_within with sf objects
points_within <- st_within(data_sf,prairie_shape)
points_within <- as.logical(points_within)


# Filter the original data_st based on the result
points_within_prairie <- data_sf[points_within,]


# Extract indices for points within the polygon
indices_within <- which(!is.na(points_within))
print(indices_within)


# Extract the coordinates within the polygon
coordinates_within <- data_df[indices_within, ]



# Convert the data frame to an sf object
data_sf_prairie <- st_as_sf(coordinates_within, coords = c("lon", "lat"), crs = st_crs(prairie_shape))

# Get world borders data
world <- ne_countries(scale = "medium", returnclass = "sf")

# Filter data for the Canadian prairie province (e.g., Alberta, Manitoba, Saskatchewan)
prairie_province <- world[world$admin %in% c("Alberta", "Manitoba", "Saskatchewan"), ]
print(prairie_province)
prairie_province_names <- c("Alberta", "Manitoba", "Saskatchewan")
prairie_province <- world[world$ADMIN %in% prairie_province_names, ]
install.packages("maps")
install.packages("sf")

library(ggplot2)
library(maps)
library(sf)


canada <- ne_countries(country = "Canada", scale = "medium", returnclass = "sf")
prairie_provinces <- canada[canada$admin %in% c("Alberta", "Saskatchewan", "Manitoba"), ]

ggplot() +
  geom_sf(data = prairie_provinces, fill = "lightblue", color = "black", size = 0.5) +
  coord_sf(xlim = c(-120, -80), ylim = c(45, 60), expand = FALSE) +
  theme_minimal() +
  ggtitle("Canadian Prairie Provinces Map")


# Plot
ggplot() +
  geom_sf(data = prairie_province, fill = "lightgrey", color = "black") +
  
  # Prairie region layer
  geom_sf(data = prairie_shape, fill = "lightgrey", color = "black") +
  
  # Points layer
  geom_point(data = coordinates_within, aes(x = lon, y = lat), color = "red", size = 2) +
  
  # Minimal theme
  theme_minimal()


# Plot the shapefile
ggplot() +
  geom_sf(data = prairie_shape, fill = "lightgrey", color = "black") +
  geom_point(data = coordinates_within, aes(x = lon, y = lat), color = "red", size = 2) +
  theme_minimal()


nc_data_raster <- stack(nc_file)
print(nc_data_raster)

spei_values <- extract(nc_data_raster, data_sf_prairie)
print(spei_values)
print(typeof(spei_values))
print(nlayers(nc_data_raster))


# Convert the result to a data frame
df_spei <- as.data.frame(spei_values)
count_less_than_1 <- sum(df_spei[, 1] < -1.5, na.rm = TRUE)
# Merge the extracted SPEI values with the original sf object
data_sf_prairie <- cbind(data_sf_prairie, df_spei)

count_grids_under_drought <- apply(df_spei,2, function(x) sum(x < -1.5))
pecentages_under_drought <- count_grids_under_drought/3.1


# Create a sequence of dates from January 1901
dates <- seq(as.Date("1901-01-01"), by = "1 month", length.out = 1464)

# Plot the line graph
plot(dates,pecentages_under_drought, type = "l", xlab = "Date", ylab = "Percentages of grids under drought", main = "Perentanges of grids with SPEI less than -1.5 in Canadian Prairie Region")




time_values <- ncvar_get(nc_data, "time")

# Assume time is in POSIXct format
data_sf_prairie$time <- as.POSIXct(time_values, origin = "1921-01-01")

start_date <- as.POSIXct("1921-01-01")
end_date <- as.POSIXct("2021-12-31")

sf_object_filtered <- subset(sf_object, time >= start_date & time <= end_date)


nc_close(nc_data)



# Extract time dimension
time <- ncvar_get(nc_data, "time")

# Convert time to a more manageable format (e.g., POSIXct)
time <- as.POSIXct("1970-01-01") + as.difftime(time, units = "days")

# Define the time range from 2010-01-01 to 2020-12-31
start_date <- as.POSIXct("2010-01-01")
end_date <- as.POSIXct("2020-12-31")

# Find the indices of time within the specified range
time_indices <- which(time >= start_date & time <= end_date)

# Extract SPEI data for Canada for the specified time range
# Assuming 'spei' is the variable name, replace it with the actual variable name
spei_data <- ncvar_get(ncfile, "spei", start = c(1, 1, time_indices[1]), count = c(-1, -1, length(time_indices)))

# Calculate the percentage of grids with SPEI smaller than -0.4
percentage_below_threshold <- mean(spei_data < -0.4, na.rm = TRUE) * 100

