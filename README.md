gmapsdistance
=======
[![R-CMD-check](https://github.com/jlacko/gmapsdistance/workflows/R-CMD-check/badge.svg)](https://github.com/jlacko/gmapsdistance/actions)
![](http://cranlogs.r-pkg.org/badges/gmapsdistance?color=brightgreen)
![](https://cranlogs.r-pkg.org/badges/grand-total/gmapsdistance?color=brightgreen)
![](https://img.shields.io/badge/license-GPL--3-brightgreen.svg?style=flat)
[![CRAN_Status_Badge](http://www.r-pkg.org/badges/version/gmapsdistance)](https://cran.r-project.org/package=gmapsdistance)

# Interface Between R and Google Maps

The function `gmapsdistance` uses the [Google Maps Distance Matrix API](https://developers.google.com/maps/documentation/distance-matrix/intro?hl=en) to compute the distance(s) and time(s) between two points or two vectors of points. An [API key](https://developers.google.com/maps/documentation/distance-matrix/get-api-key#key) is necessary to perform the query. Google maps must be able to find both the origin and the destination in order for the function to run. The distance is returned in meters and the time in seconds. 

While the R package is open source the Distance Matrix API itself is a paid service, requiring registration in all cases. 

A free tier is provided - $200 monthly credit. This is enough for 40,000 [Distance Matrix](https://developers.google.com/maps/documentation/distance-matrix/usage-and-billing?w#distance-matrix) calls or 20,000 [Distance Matrix Advanced](https://developers.google.com/maps/documentation/distance-matrix/usage-and-billing?w#distance-matrix-advanced) calls, more than sufficient in most individual user use cases.

Also note that using the API is subject to [Google Maps Platform Terms of Service](https://cloud.google.com/maps-platform/terms/).

Four different modes of transportation are allowed: `bicycling`, `walking`, `driving`, `transit`. 

## Installation

```r
# CRAN install / stable version 
install.packages("gmapsdistance")

# Github installation / current dev version
remotes::install_github("jlacko/gmapsdistance")
```

## Example 1
In this example we will compute the driving distance between Washington DC, and New York City. The code returns the `Time`, the `Distance` and the `Status` of the query (`OK` if it was successful).

``` r
results <- gmapsdistance(origin = "Washington DC", 
                        destination = "New York City NY", 
                        mode = "driving")
results
# $Time
# [1] 14523
# 
# $Distance
# [1] 367656
# 
# $Status
# [1] "OK"
```

## Example 2
In this example we will compute the driving distance between the Greek cities of 
Marathon and Athens. We show that the function is able to handle LAT-LONG coordinates. 
``` r
results <- gmapsdistance(origin = "38.1621328+24.0029257",
                        destination = "37.9908372+23.7383394",
                        mode = "walking")
results
# $Time
# [1] 30024
# 
# $Distance
# [1] 39459
# 
# $Status
# [1] "OK"
```

## Example 3
This example computes the travel distance and time matrices between two vectors of cities at a specific departure time.

``` r
results <- gmapsdistance(origin = c("Washington DC", "New York NY", "Seattle WA", "Miami FL"), 
                         destination = c("Los Angeles CA", "Austin TX", "Chicago IL", "Philadelphia PA"), 
                         mode = "bicycling",
                         dep_date = "2022-05-31", # provided as string in ISO 8601 format
                         dep_time = "12:00:00") # provided as string in HH:MM:SS format
                        
results
# $Time
#                 Washington DC New York NY Seattle WA Miami FL
# Los Angeles CA         843390      505496     243025    45679
# Austin TX              910636      601436     291173    31533
# Chicago IL             367313      664116     651979   914279
# Philadelphia PA        824229      420897     438436   396647
# 
# $Distance
#                 Washington DC New York NY Seattle WA Miami FL
# Los Angeles CA        4521993     2665897    1247092   229701
# Austin TX             4863932     3155049    1472650   159374
# Chicago IL            1973073     3611531    3515251  4848182
# Philadelphia PA       4548048     2316043    2354834  2139132
# 
# $Status
#                 Washington DC New York NY Seattle WA Miami FL
# Los Angeles CA  "OK"          "OK"        "OK"       "OK"    
# Austin TX       "OK"          "OK"        "OK"       "OK"    
# Chicago IL      "OK"          "OK"        "OK"       "OK"    
# Philadelphia PA "OK"          "OK"        "OK"       "OK"  
```
## Usage limits
There are a set of limits to the  number of calls that can be done. These limits are established by the [Google Maps Distance Matrix API](https://developers.google.com/maps/documentation/distance-matrix/usage-limits)

## License
[GNU General Public License v3.0](https://github.com/jlacko/gmapsdistance/blob/master/LICENSE.md)

## How to contribute
We encourage any kind of suggestions to improve the quality of this code. You can submit pull requests indicating clearly what is the purpose of the change and why we should accept such pull request. Although not necessary, we encourage you to verify that your suggestions are in accordance with the general guidelines established in the CRAN repository by running the R CMD check command.

## Code of conduct
Please see the file [CODE_OF_CONDUCT.md](https://github.com/jlacko/gmapsdistance/blob/master/CODE_OF_CONDUCT.md) for the Code of Conduct for the Contributor Covenant Code of Conduct. 


## Authors
This code was developed originally by [Rodrigo Azuero](http://rodrigoazuero.com/) and [David Zarruk](http://www.davidzarruk.com/).

It is currently maintained by [Jindra Lacko](mailto:jindra.lacko@gmail.com).

[AUTHORS.md](AUTHORS.md) have a list of everyone who have contributed to gmapsdistance.

## Where has gmapsdistance be used/mentioned.
We like to keep track of the projects where gmapsdistance has been used. This will help us identify how to better improve the code. Let us know if you use gmapsditance! Below you will find links to some of the projects and some of the references to gmapsdistance that we have found. 

1. Proximity to pediatric cardiac specialty care for adolescents with congenital heart defects. [Link to article](http://onlinelibrary.wiley.com/doi/10.1002/bdr2.1129/abstract?wol1URL=/doi/10.1002/bdr2.1129/abstract&regionCode=US-DC&identityKey=be6e5bc4-51c2-4785-aa77-110082fd5ad9). 

2. Measuring Accessibility to Rail Transit Stations in Scarborough: Subway vs. LRT. [Link to article](https://www.ryerson.ca/content/dam/tedrogersschool/documents/Measuring%20accessibility%20to%20rail%20transit%20stations%20in%20Scarborough-final.pdf)

3. Hyperlinear: Big Data Analytics with R. [Link](http://hyperlinear.com/big-data-analytics-r/)  

4. Social Data Science Course. University of Copenhagen. Department of Economics. [Link](https://sebastianbarfort.github.io/sds_summer/slides/gathering.pdf)

5. R-bloggers. The collaborative innovation landscape in data science. [Link](https://www.r-bloggers.com/the-collaborative-innovation-landscape-in-data-science/)

6. DataHubss. Google maps and R. [Link](https://www.datahubbs.com/google-maps-r/). This blog entry refers to gmapsdistance as the best package in to use Google Maps in R.  

7. Exegetic - Data Science on Demand. A review of gmapsdistance. [Link](http://www.exegetic.biz/blog/2017/08/map-route-direction-asymmetry/)

8. RPubs.  [Link](https://rpubs.com/mattdray/gmapsdistance-test) 

9. Identifying Partnership Opportunities at Air Force Installations: A Geographic Information Systems Approach [Link](https://scholar.afit.edu/cgi/viewcontent.cgi?article=1809&context=etd) 

10. DataWookie. Review of gmapsdistance. [Link](https://datawookie.netlify.com/blog/2017/08/route-asymmetry-in-google-maps/)


