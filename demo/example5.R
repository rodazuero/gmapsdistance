library(gmapsdistance)

# Compute the travel distance and time between two vectors of cities. 
# This example shows that the function is able to handle
# LAT-LONG coordinates and a Google Maps API Key

origin = c("40.431478+-80.0505401", "33.7678359+-84.4906438")
destination = c("43.0995629+-79.0437609", "41.7096483+-86.9093986")

results = gmapsdistance(origin, destination, mode = "bicycling", shape="long")
results$Time
results$Distance
results$Status
