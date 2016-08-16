library(gmapsdistance)


results = gmapsdistance(origin = c("Seattle+WA", "Miami+FL"), 
                        destination = c("Chicago+IL", "Philadelphia+PA"), 
                        mode = "bicycling", 
                        dep_date = "2017-08-16", 
                        dep_time = "20:40:00")

results

