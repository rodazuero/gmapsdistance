library(gmapsdistance)

# Compute the travel distance and time matrices between two vectors of cities

origin = c("Washington+DC", "New+York+NY", "Seattle+WA", "Miami+FL")
destination = c("Los+Angeles+CA", "Austin+TX", "Chicago+IL")

results = gmapsdistance(origin, destination, "bicycling")
results$Time
results$Distance
results$Status
