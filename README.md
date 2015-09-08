gmapsdistance
=======
[![Build Status](https://travis-ci.org/rodazuero/gmapsdistance.png)](https://travis-ci.org/rodazuero/gmapsdistance) 


The function `gmapsdistance` uses the [Google Maps Distance Matrix API](https://developers.google.com/maps/documentation/distance-matrix/intro?hl=en) to compute the distance and time between two points. In order to be able to use the function you will need an [API key](https://developers.google.com/maps/documentation/distance-matrix/get-api-key#key) and enable the Distance Matrix API in the Google Developers Console. Google maps should be able to find both, the origin and the destination in order for the function to run. If the origin or destination contains mulptile words, they should be separated by a plus sign (+). The distance is returned in meters and the time in seconds. 

Four different modes of transportation are allowed: "bicycling", "walking", "driving", "transit". 

### Installation


```{r}
install.packages("devtools")
library("devtools")
install_github("rodazuero/gmapsdistance")
library("gmapsdistance")
```


## Example 1

In this example we will compute the driving distance between Washington DC, and New York City. 

```{r}
# load package
library("gmapsdistance")

results=gmapsdistance("Washington+DC","New+York+City+NY","driving","INSERT-KEY-HERE")


``` 
The code returns the Time, the Distance and the Status of the query (OK if it was successful)
```{r}
> results$Time
[1] 13906


> results$Distance
[1] 361710


> results$Status
[1] OK
Levels: OK

``` 
## Example 2

In this example we will compute the driving distance between the Greek cities of 
Marathon and Athens. We show that the function is able to handle LAT-LONG coordinates. 
```{r} 
# load package
library("gmapsdistance")
results=gmapsdistance("38.1621328+24.0029257","37.9908372+23.7383394","walking","INSERT-KEY-HERE")

> results$Time
[1] 30024


> results$Distance
[1] 39507


> results$Status
[1] OK
Levels: OK

