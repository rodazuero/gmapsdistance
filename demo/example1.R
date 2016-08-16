library(gmapsdistance)

# Compute the travel distance and time between Washington DC and New York City
results = gmapsdistance(origin = "Washington+DC", 
                        destination = "New+York+City+NY", 
                        mode = "driving")
results
