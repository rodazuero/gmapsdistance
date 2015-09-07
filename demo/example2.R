library(gmapsdistance)

#Compute the travel distance and 
#time between the city of  Marathon, Greece and
#Athens, Greece. This example shows that the 
#function is able to handle LAT-LONG coordinates

results=gmapsdistance("38.1621328+24.0029257","37.9908372,23.7383394","walking","INSERT-KEY-HERE")
results$Time
results$Distance
results$Status
