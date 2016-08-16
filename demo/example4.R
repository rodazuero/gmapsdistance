library(gmapsdistance)

# Compute the travel distance and time matrices between two vectors of cities and return the results in long format

origin = c("Washington+DC", "Miami+FL")
destination = c("Los+Angeles+CA", "Austin+TX", "Chicago+IL")

results = gmapsdistance(origin, destination, mode = "driving", shape = "long")
results$Time
results$Distance
results$Status