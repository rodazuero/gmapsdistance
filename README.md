gmapsdistance
=======

The function `gmapsdistance` uses the [Google Maps Distance Matrix API](https://developers.google.com/maps/documentation/distance-matrix/intro?hl=en) to compute the distance and time between two points. In order to be able to use the function you will need an [API key](https://developers.google.com/maps/documentation/distance-matrix/get-api-key#key) and enable the Distance Matrix API in the Google Developers Console. Google maps should be able to find both, the origin and the destination in order for the function to run. If the origin or destination contains mulptile words, they should be separated by a plus sign (+). The distance is returned in meters and the time in seconds. 

Four different modes of transportation are allowed: "bicycling", "walking", "driving", "transport". 

## Example

In this example we will compute the driving distance between Washington DC, and New York City. 

```{r}
# load package
library("gmapsdistance")

results=gmapsdistance("Washington+DC","New+York+City+NY","driving","INSERT-KEY-HERE")


``` 
The code returns the Time, the Distance and the Status of the query (OK if it was successful)
```
> results$Time
[1] 13906


> results$Distance
[1] 361710


> results$Status
[1] OK
Levels: OK
