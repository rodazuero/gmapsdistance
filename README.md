gmapsdistance
=======
[![Build Status](https://travis-ci.org/rodazuero/gmapsdistance.png)](https://travis-ci.org/rodazuero/gmapsdistance) 
[![CRAN_Status_Badge](http://www.r-pkg.org/badges/version/gmapsdistance)](http://cran.r-project.org/web/packages/gmapsdistance)


The function `gmapsdistance` uses the [Google Maps Distance Matrix API](https://developers.google.com/maps/documentation/distance-matrix/intro?hl=en) to compute the distance(s) and time(s) between two points or two vectors of points. An [API key](https://developers.google.com/maps/documentation/distance-matrix/get-api-key#key) is not necessary to perform the query but the function supports its usage. If an API key is being used the Distance Matrix API should be enabled in the Google Developers Console. Google maps must be able to find both the origin and the destination in order for the function to run. If the origin or destination contains multiple words, they should be separated by a plus sign (+). The distance is returned in meters and the time in seconds. 

Four different modes of transportation are allowed: `bicycling`, `walking`, `driving`, `transit`. 

## Installation

```{r}
# CRAN install
install.packages("gmapsdistance")

# Github installation
# install.packages("devtools")
devtools::install_github("rodazuero/gmapsdistance")
```


## Example 1
In this example we will compute the driving distance between Washington DC, and New York City. The code returns the `Time`, the `Distance` and the `Status` of the query (`OK` if it was successful).

``` r
results = gmapsdistance(origin = "Washington+DC", 
                        destination = "New+York+City+NY", 
                        mode = "driving")
results
#> $Time
#> [1] 13875
#> 
#> $Distance
#> [1] 361716
#> 
#> $Status
#> [1] "OK"
```

## Example 2
In this example we will compute the driving distance between the Greek cities of 
Marathon and Athens. We show that the function is able to handle LAT-LONG coordinates. 
``` r
results = gmapsdistance(origin = "38.1621328+24.0029257",
                        destination = "37.9908372+23.7383394",
                        mode = "walking")
results
#> $Time
#> [1] 30024
#> 
#> $Distance
#> [1] 39507
#> 
#> $Status
#> [1] "OK"
```

## Example 3
This example computes the travel distance and time matrices between two vectors of cities
``` r
origin = c("Washington+DC", "New+York+NY", "Seattle+WA", "Miami+FL")
destination = c("Los+Angeles+CA", "Austin+TX", "Chicago+IL")

results = gmapsdistance(origin, destination, "bicycling")

results
# $Time
#              or Time.Los+Angeles+CA Time.Austin+TX Time.Chicago+IL
# 1 Washington+DC              856668         535273          247763
# 2   New+York+NY              917531         596136          308626
# 3    Seattle+WA              374692         678961          675029
# 4      Miami+FL              829037         416667          452040
# 
# $Distance
#              or Distance.Los+Angeles+CA Distance.Austin+TX Distance.Chicago+IL
# 1 Washington+DC                 4567516            2838779             1303075
# 2   New+York+NY                 4855134            3126397             1590693
# 3    Seattle+WA                 1982354            3562970             3588297
# 4      Miami+FL                 4559205            2279966             2381636
# 
# $Status
# [1] "OK"
```

## Example 4
This example computes the travel distance and time matrices between two vectors of cities and return the results in long format
``` r 
origin = c("Washington+DC", "New+York+NY", "Seattle+WA", "Miami+FL")
destination = c("Los+Angeles+CA", "Austin+TX", "Chicago+IL")

results = gmapsdistance(origin, destination, "driving", shape = "long")

results
# $Time
#               or             de   Time
# 1  Washington+DC Los+Angeles+CA 137727
# 2    New+York+NY Los+Angeles+CA 144653
# 3     Seattle+WA Los+Angeles+CA  60913
# 4       Miami+FL Los+Angeles+CA 137344
# 5  Washington+DC      Austin+TX  79783
# 6    New+York+NY      Austin+TX  91593
# 7     Seattle+WA      Austin+TX 115428
# 8       Miami+FL      Austin+TX  68841
# 9  Washington+DC     Chicago+IL  38523
# 10   New+York+NY     Chicago+IL  43268
# 11    Seattle+WA     Chicago+IL 106111
# 12      Miami+FL     Chicago+IL  71280
# 
# $Distance
#               or             de Distance
# 1  Washington+DC Los+Angeles+CA  4295212
# 2    New+York+NY Los+Angeles+CA  4493003
# 3     Seattle+WA Los+Angeles+CA  1829511
# 4       Miami+FL Los+Angeles+CA  4397978
# 5  Washington+DC      Austin+TX  2452391
# 6    New+York+NY      Austin+TX  2803734
# 7     Seattle+WA      Austin+TX  3412576
# 8       Miami+FL      Austin+TX  2175962
# 9  Washington+DC     Chicago+IL  1123788
# 10   New+York+NY     Chicago+IL  1270086
# 11    Seattle+WA     Chicago+IL  3321732
# 12      Miami+FL     Chicago+IL  2219991
# 
# $Status
# [1] "OK"
``` 

## Example 5
This example computes the travel distance and time between two vectors of cities. This example shows that the function is able to handle LAT-LONG coordinates and a Google Maps API Key

``` r
#set.api.key("Your Google Maps API Key")

origin = c("40.431478+-80.0505401", "33.7678359+-84.4906438")
destination = c("43.0995629+-79.0437609", "41.7096483+-86.9093986")

results = gmapsdistance(origin, destination, "bicycling", shape="long")

results
# $Time
#                       or                     de   Time
# 1  40.431478+-80.0505401 43.0995629+-79.0437609  85140
# 2 33.7678359+-84.4906438 43.0995629+-79.0437609 326680
# 3  40.431478+-80.0505401 41.7096483+-86.9093986 130073
# 4 33.7678359+-84.4906438 41.7096483+-86.9093986 228792
# 
# $Distance
#                       or                     de Distance
# 1  40.431478+-80.0505401 43.0995629+-79.0437609   440075
# 2 33.7678359+-84.4906438 43.0995629+-79.0437609  1611588
# 3  40.431478+-80.0505401 41.7096483+-86.9093986   688508
# 4 33.7678359+-84.4906438 41.7096483+-86.9093986  1135876
# 
# $Status
# [1] "OK"

```

## Google Maps API Key
You can use a Google Maps API Key (which allows you to make a larger volume of calls) by adding your key to the package environment:
```{r}
#set.api.key("your-google-maps-api-key")
```
