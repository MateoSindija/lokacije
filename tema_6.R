library(raster)
library(ggplot2)
#remotes::install_github("garretrc/ggvoronoi", dependencies = TRUE, build_opts = c("--no-resave-data"))
library(ggvoronoi)
library(dplyr)

#setwd('C://Users//Mateo//Desktop//Fakultet//Lokacije//Finalni projekt')
setwd('C:/Users/Administrator/Documents/GitHub/lokacije')

cres <- raster("./cres_donji_SRTM.tif")

x_min_lower <- 14.2
x_max_lower <- 14.6
y_min_lower <- 44.6
y_max_lower <- 45 

# Crop the raster to the specified extent
cres_cropped <- crop(cres, extent(x_min_lower, x_max_lower, y_min_lower, y_max_lower))

points <- rasterToPoints(cres_cropped)
points <- as.data.frame(points)
points <- data.frame(x = points$x, y = points$y, elev = points$cres_donji_SRTM)

set.seed(143)  # Set seed for reproducibility
sample_size <- 3000  # Adjust the sample size as needed
sampled_points <- points[sample(nrow(points), sample_size), ]

# Create ggplot with Voronoi tessellation
voronoi_plot <- ggplot(sampled_points) +
  geom_voronoi(aes(x, y, fill = elev)) +
  scale_fill_gradientn("Elevation", colors = c("cornflowerblue","lightblue", "darkgreen", "green1", "yellow", "gold4", "sienna"),
                       values = scales::rescale(c(-10, 5, 50, 100, 150, 200, 250))) +
  scale_color_gradientn("Elevation", colors = c("cornflowerblue","lightblue", "darkgreen", "green1", "yellow", "gold4", "sienna"),
                        values = scales::rescale(c(-10, 5, 50, 100, 150, 200, 250))) +
  coord_quickmap() +
  theme_minimal() +
  theme(axis.text = element_blank(), axis.title = element_blank())
  
# Filter out points with elevation 0
filtered_points <- sampled_points %>%
  filter(elev != 0)

# Add text labels for elevation values within each Voronoi cell (excluding elevation 0)
label_plot <- voronoi_plot +
  geom_text(data = filtered_points, aes(x = x, y = y, label = elev),
            color = "black", size = 0.25, alpha = 0.7)

print(label_plot)
# Save the plot at a higher resolution (adjust width and height accordingly)
ggsave("high_resolution_plot.png", label_plot, width = 10, height = 8, dpi = 900)
