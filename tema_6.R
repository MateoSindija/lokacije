library(raster)
library(ggplot2)
#remotes::install_github("garretrc/ggvoronoi", dependencies = TRUE, build_opts = c("--no-resave-data"))
library(ggvoronoi)
library(dplyr)

#setwd('C://Users//Mateo//Desktop//Fakultet//Lokacije//Finalni projekt')
setwd('C:/Users/Administrator/Documents/GitHub/lokacije')

cres <- raster("./combinedImg_cropped.tif")

points <- rasterToPoints(cres)
points <- as.data.frame(points)
points <- data.frame(x = points$x, y = points$y, elev = points$combinedImg_cropped)

set.seed(143)  # Set seed for reproducibility
sample_size <- 4000  # Adjust the sample size as needed
sampled_points <- points[sample(nrow(points), sample_size), ]

for (i in 1:sample_size) {
  if (sampled_points$elev[i] > 800) {
    sampled_points$elev[i] <- 0
  }
}
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
