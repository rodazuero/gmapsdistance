#' The function gmapsdistance uses the Google Maps Distance Matrix
#' API in order to compute the distance between two points. 
#' In order to be able to use the function you will need an API 
#' key and enable the Distance Matrix API in the Google Developers Console
#' For more information about how to get a key, go to 
#' https://developers.google.com/maps/documentation/distance-matrix/get-api-key#key
#' For more information about the Google Maps Distance Matrix API go to
#' https://developers.google.com/maps/documentation/distance-matrix/intro?hl=en 
#' @title gmapsdistance
#' @usage gmapsdistance(origin,destination,mode,key)
#' @param origin  A string containing the description of the 
#' starting point. Should be inside of quoutes (""). If 
#' more than one word is used, they should be separated by a plus 
#' sign e.g. "Bogota+Colombia". Coordinates in LAT-LONG format 
#' are also a valid input as long as they can be identified by Google Maps
#' @param destination A string containing the description of the 
#' end point. Should be the same format as the variable "origin". 
#' @param mode A string containing the mode of transportation desired. Should be 
#' inside of double quotes (",") and one of the following: "bicycling", "walking",
#' "transit" or "driving". 
#' @param key In order to use the Google Maps Distance Matrix API
#' it is necessary to have an API key. The key should be inside of quotes. Example: "THISISMYKEY".
#' @export
gmapsdistance<-function(origin,destination,mode,key){
  
  #Extracting type of key
  typeKEY=class(key)
  if (typeKEY!="character"){
    stop("Key should be string")
  }
  
  #If mode of transportation not recognized:
  if (mode!="driving" & mode!="walking" & mode!="bicycling" & mode!="transit"){
    stop("Mode of transportation not recognized. Mode should be one of 'bicycling', 'transit', 'driving', 'walking' ")
  }
  
  #Now going to do the query in google maps. The first step is 
  #to generate the necessary url concatenating the corresopnding 
  #inputs
  url0="https://maps.googleapis.com/maps/api/distancematrix/xml?origins="
  modeT=paste0("|&mode=",mode,"&language=fr-FR")
  urlfin=paste0(url0,origin,"|&destinations=",destination,modeT,"&key=",key)
  webpageXML <- getURL(urlfin)
  #Read lines
  webpageXML2 <- readLines(tc <- textConnection(webpageXML)); 
  close(tc)
  #XMLparse
  webpageXMLA<-xmlParse(webpageXML2)
  #And extract the necessary values
  root=xmlRoot(webpageXMLA)
  first=xmlChildren(root)
  initstatus=first$status[[1]]
  initstat=as(initstatus,"character")
  
  
  if (initstat=="REQUEST_DENIED"){
    message=(first$error_message[1]$text)
    message=as(message,"character")
    stop(message)
  }
  
  
  
  two = first[[4]]
  
  
  Status=xmlChildren(two[[1]])
  Status=Status$status[1]
  Status=Status$text
  Status=as(Status, "character")
  
  if (Status=="ZERO_RESULTS"){
    stop("Google maps is not able to find a route between origin and destination")
  }
  
  if (Status=="NOT_FOUND"){
    stop("Google maps is not able to find the origin or destination")
  }
  
  Time=xmlChildren(two[[1]])
  Time=Time$duration[1]
  Time=Time$value[1]$text
  Time=as(Time,"numeric")
  
  Distance=xmlChildren(two[[1]])
  Distance=Distance$distance[1]
  Distance=Distance$value[1]$text
  Distance=as(Distance,"numeric")
  
  
  
  output=data.frame(Time,Distance,Status)
  return(output)
}
