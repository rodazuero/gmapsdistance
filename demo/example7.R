library(gmapsdistance)

# EXAMPLE 7:
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

# EXAMPLE 8:
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

