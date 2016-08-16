gmapsdistance
=======
[![Build Status](https://travis-ci.org/rodazuero/gmapsdistance.png)](https://travis-ci.org/rodazuero/gmapsdistance) 
![](http://cranlogs.r-pkg.org/badges/gmapsdistance?color=brightgreen)
[![CRAN_Status_Badge](http://www.r-pkg.org/badges/version/gmapsdistance)](https://cran.r-project.org/package=gmapsdistance)


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
# $Time
# [1] 13600
# 
# $Distance
# [1] 361713
# 
# $Status
# [1] "OK"
```

## Example 2
In this example we will compute the driving distance between the Greek cities of 
Marathon and Athens. We show that the function is able to handle LAT-LONG coordinates. 
``` r
results = gmapsdistance(origin = "38.1621328+24.0029257",
                        destination = "37.9908372+23.7383394",
                        mode = "walking")
results
# $Time
# [1] 30025
# 
# $Distance
# [1] 39507
# 
# $Status
# [1] "OK"
```

## Example 3
This example computes the travel distance and time matrices between two vectors of cities at a specific departure time
``` r
results = gmapsdistance(origin = c("Washington+DC", "New+York+NY", "Seattle+WA", "Miami+FL"), 
                        destination = c("Los+Angeles+CA", "Austin+TX", "Chicago+IL", "Philadelphia+PA"), 
                        mode = "bicycling", 
                        departure = 1514742000)
results
# $Time
#              or Time.Los+Angeles+CA Time.Austin+TX Time.Chicago+IL Time.Philadelphia+PA
# 1 Washington+DC              856621         535146          247765                54430
# 2   New+York+NY              917486         596011          308630                32215
# 3    Seattle+WA              374692         678959          674989               956702
# 4      Miami+FL              829039         416667          452035               411283
# 
# $Distance
#              or Distance.Los+Angeles+CA Distance.Austin+TX Distance.Chicago+IL Distance.Philadelphia+PA
# 1 Washington+DC                 4567470            2838519             1303067                   266508
# 2   New+York+NY                 4855086            3126136             1590684                   160917
# 3    Seattle+WA                 1982354            3562970             3588297                  5051951
# 4      Miami+FL                 4559205            2279966             2381610                  2169382
# 
# $Status
#              or status.Los+Angeles+CA status.Austin+TX status.Chicago+IL status.Philadelphia+PA
# 1 Washington+DC                    OK               OK                OK                     OK
# 2   New+York+NY                    OK               OK                OK                     OK
# 3    Seattle+WA                    OK               OK                OK                     OK
# 4      Miami+FL                    OK               OK                OK                     OK

# Equivalently 
results = gmapsdistance(origin = c("Washington+DC", "New+York+NY", "Seattle+WA", "Miami+FL"), 
                        destination = c("Los+Angeles+CA", "Austin+TX", "Chicago+IL", "Philadelphia+PA"), 
                        mode = "bicycling", 
                        dep_date = "2017-08-16", 
                        dep_time = "20:40:00")

results
# $Time
#              or Time.Los+Angeles+CA Time.Austin+TX Time.Chicago+IL Time.Philadelphia+PA
# 1 Washington+DC              856621         535146          247765                54430
# 2   New+York+NY              917486         596011          308630                32215
# 3    Seattle+WA              374692         678959          674989               956702
# 4      Miami+FL              829039         416667          452035               411283
# 
# $Distance
#              or Distance.Los+Angeles+CA Distance.Austin+TX Distance.Chicago+IL Distance.Philadelphia+PA
# 1 Washington+DC                 4567470            2838519             1303067                   266508
# 2   New+York+NY                 4855086            3126136             1590684                   160917
# 3    Seattle+WA                 1982354            3562970             3588297                  5051951
# 4      Miami+FL                 4559205            2279966             2381610                  2169382
# 
# $Status
#              or status.Los+Angeles+CA status.Austin+TX status.Chicago+IL status.Philadelphia+PA
# 1 Washington+DC                    OK               OK                OK                     OK
# 2   New+York+NY                    OK               OK                OK                     OK
# 3    Seattle+WA                    OK               OK                OK                     OK
# 4      Miami+FL                    OK               OK                OK                     OK
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

## Example 6
This example computes the travel distance and time between two vectors of cities using the 'combinations' option.

``` r
# 1. Pairwise 

or = c("Washington+DC", "New+York+NY", "Seattle+WA", "Miami+FL")
des = c("Los+Angeles+CA", "Austin+TX", "Chicago+IL", "Philadelphia+PA")

results = gmapsdistance(origin = or, destination = des, mode = "bicycling", combinations = "pairwise")
results
# $Time
#              or              de   Time
# 1 Washington+DC  Los+Angeles+CA 856621
# 2   New+York+NY       Austin+TX 596011
# 3    Seattle+WA      Chicago+IL 674989
# 4      Miami+FL Philadelphia+PA 411283
# 
# $Distance
#              or              de Distance
# 1 Washington+DC  Los+Angeles+CA  4567470
# 2   New+York+NY       Austin+TX  3126136
# 3    Seattle+WA      Chicago+IL  3588297
# 4      Miami+FL Philadelphia+PA  2169382
# 
# $Status
#              or              de status
# 1 Washington+DC  Los+Angeles+CA     OK
# 2   New+York+NY       Austin+TX     OK
# 3    Seattle+WA      Chicago+IL     OK
# 4      Miami+FL Philadelphia+PA     OK

# 2. All combinations of origins and destinations in wide format 
results = gmapsdistance(origin = or, destination = des, mode = "bicycling", combinations = "all", shape = "wide")
results
# $Time
#              or Time.Los+Angeles+CA Time.Austin+TX Time.Chicago+IL Time.Philadelphia+PA
# 1 Washington+DC              856621         535146          247765                54430
# 2   New+York+NY              917486         596011          308630                32215
# 3    Seattle+WA              374692         678959          674989               956702
# 4      Miami+FL              829039         416667          452035               411283
# 
# $Distance
#              or Distance.Los+Angeles+CA Distance.Austin+TX Distance.Chicago+IL Distance.Philadelphia+PA
# 1 Washington+DC                 4567470            2838519             1303067                   266508
# 2   New+York+NY                 4855086            3126136             1590684                   160917
# 3    Seattle+WA                 1982354            3562970             3588297                  5051951
# 4      Miami+FL                 4559205            2279966             2381610                  2169382
# 
# $Status
#              or status.Los+Angeles+CA status.Austin+TX status.Chicago+IL status.Philadelphia+PA
# 1 Washington+DC                    OK               OK                OK                     OK
# 2   New+York+NY                    OK               OK                OK                     OK
# 3    Seattle+WA                    OK               OK                OK                     OK
# 4      Miami+FL                    OK               OK                OK                     OK

results = gmapsdistance(origin = or, destination = des, mode = "bicycling", combinations = "all", shape = "long")
results
# $Time
#               or              de   Time
# 1  Washington+DC  Los+Angeles+CA 856621
# 2    New+York+NY  Los+Angeles+CA 917486
# 3     Seattle+WA  Los+Angeles+CA 374692
# 4       Miami+FL  Los+Angeles+CA 829039
# 5  Washington+DC       Austin+TX 535146
# 6    New+York+NY       Austin+TX 596011
# 7     Seattle+WA       Austin+TX 678959
# 8       Miami+FL       Austin+TX 416667
# 9  Washington+DC      Chicago+IL 247765
# 10   New+York+NY      Chicago+IL 308630
# 11    Seattle+WA      Chicago+IL 674989
# 12      Miami+FL      Chicago+IL 452035
# 13 Washington+DC Philadelphia+PA  54430
# 14   New+York+NY Philadelphia+PA  32215
# 15    Seattle+WA Philadelphia+PA 956702
# 16      Miami+FL Philadelphia+PA 411283
# 
# $Distance
#               or              de Distance
# 1  Washington+DC  Los+Angeles+CA  4567470
# 2    New+York+NY  Los+Angeles+CA  4855086
# 3     Seattle+WA  Los+Angeles+CA  1982354
# 4       Miami+FL  Los+Angeles+CA  4559205
# 5  Washington+DC       Austin+TX  2838519
# 6    New+York+NY       Austin+TX  3126136
# 7     Seattle+WA       Austin+TX  3562970
# 8       Miami+FL       Austin+TX  2279966
# 9  Washington+DC      Chicago+IL  1303067
# 10   New+York+NY      Chicago+IL  1590684
# 11    Seattle+WA      Chicago+IL  3588297
# 12      Miami+FL      Chicago+IL  2381610
# 13 Washington+DC Philadelphia+PA   266508
# 14   New+York+NY Philadelphia+PA   160917
# 15    Seattle+WA Philadelphia+PA  5051951
# 16      Miami+FL Philadelphia+PA  2169382
# 
# $Status
#               or              de status
# 1  Washington+DC  Los+Angeles+CA     OK
# 2    New+York+NY  Los+Angeles+CA     OK
# 3     Seattle+WA  Los+Angeles+CA     OK
# 4       Miami+FL  Los+Angeles+CA     OK
# 5  Washington+DC       Austin+TX     OK
# 6    New+York+NY       Austin+TX     OK
# 7     Seattle+WA       Austin+TX     OK
# 8       Miami+FL       Austin+TX     OK
# 9  Washington+DC      Chicago+IL     OK
# 10   New+York+NY      Chicago+IL     OK
# 11    Seattle+WA      Chicago+IL     OK
# 12      Miami+FL      Chicago+IL     OK
# 13 Washington+DC Philadelphia+PA     OK
# 14   New+York+NY Philadelphia+PA     OK
# 15    Seattle+WA Philadelphia+PA     OK
# 16      Miami+FL Philadelphia+PA     OK
```

## Example 7
This example computes the travel distance and time between two vectors of cities. This example shows that the function is able to handle LAT-LONG coordinates and a Google Maps API Key

``` r
# 
# Time and distance using a 'pessimistic' traffic model. ONLY works with a Google Maps API key
# 
# results = gmapsdistance(origin = c("Washington+DC", "New+York+NY"), 
#                         destination = c("Los+Angeles+CA", "Austin+TX"), 
#                         mode = "driving", 
#                         departure = 1514742000,
#                         traffic_model = "pessimistic", 
#                         shape = "long",
#                         key=APIkey)
# 
# results
# $Time
#             or             de   Time
# 1 Washington+DC Los+Angeles+CA 150785
# 2   New+York+NY Los+Angeles+CA 160471
# 3 Washington+DC      Austin+TX  87289
# 4   New+York+NY      Austin+TX 102781
# 
# $Distance
#             or             de Distance
# 1 Washington+DC Los+Angeles+CA  4295212
# 2   New+York+NY Los+Angeles+CA  4489460
# 3 Washington+DC      Austin+TX  2452391
# 4   New+York+NY      Austin+TX  2803691
# 
# $Status
#             or             de status
# 1 Washington+DC Los+Angeles+CA     OK
# 2   New+York+NY Los+Angeles+CA     OK
# 3 Washington+DC      Austin+TX     OK
# 4   New+York+NY      Austin+TX     OK

# 
# Time and distance avoiding 'tolls'. ONLY works with a Google Maps API key
# 
# results = gmapsdistance(origin = c("Washington+DC", "New+York+NY"), 
#                         destination = c("Los+Angeles+CA", "Austin+TX"), 
#                         mode = "driving", 
#                         avoid = "tolls",
#                         key=APIkey)
# 
# results
# 
# $Time
#               or Time.Los+Angeles+CA Time.Austin+TX
# 1 Washington+DC              142794          84658
# 2   New+York+NY              153684          95622
# 
# $Distance
#               or Distance.Los+Angeles+CA Distance.Austin+TX
# 1 Washington+DC                 4298169            2455348
# 2   New+York+NY                 4557011            2800556
# 
# $Status
#               or status.Los+Angeles+CA status.Austin+TX
# 1 Washington+DC                    OK               OK
# 2   New+York+NY                    OK               OK


```

## Google Maps API Key
You can use a Google Maps API Key (which allows you to make a larger volume of calls) by adding your key to the package environment:
```{r}
#set.api.key("your-google-maps-api-key")
```
