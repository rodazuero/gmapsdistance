library(gmapsdistance)

#Compute the travel distance and time between Washington DC and New York City:
results=gmapsdistance("Washington+DC","New+York+City+NY","driving","INSERT-KEY-HERE")
results$Time
results$Distance
results$Status
