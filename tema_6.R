rm(list=ls())

library(raster)
library(ggplot2)
library(ggvoronoi)

x_min_lower <- 14.2
x_max_lower <- 14.6
y_min_lower <- 44.6
y_max_lower <- 45 

setwd('C://Users//Mateo//Desktop//Fakultet//Lokacije//Finalni projekt')
cres_lower <- raster(".//cres_donji_SRTM.tif")
cres_upper <- raster(".//cres_gornji_SRTM.tif")
#plot(cres_lower, xlim=c(14.2, 14.6), ylim=c(44.6, 45), ylab='latitude', xlab ='longitude')
#plot(cres_upper, xlim=c(14.25, 14.45), ylim=c(45, 45.18), ylab='latitude', xlab ='longitude')

points_lower <- rasterToPoints(cres_lower)
points_lower <- as.data.frame(points_lower)

filtered_points <- points_lower[(points_lower$x >= x_min_lower & points_lower$x <= x_max_lower) & (points_lower$y >= y_min_lower & points_lower$y <= y_max_lower), ]
plot(filtered_points$x, filtered_points$y, col='red', pch = 16, cex = 0.1)

