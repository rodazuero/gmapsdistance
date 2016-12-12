#' Define package environment
#'
#' \code{pkg.env} is a package environment that contains the variable
#' \code{api.key} with the user's Google Maps API key
pkg.env = new.env()
assign("api.key", NULL, envir = pkg.env)

#' Get the Google Maps API key
#'
#' This function returns the user's Google Maps API key that was defined with
#' \code{set.api.key}.
#'
#' @return the user's api key
#' @examples
#' get.api.key()
get.api.key = function() {
    get("api.key", envir = pkg.env)
}

#' Set the Google Maps API key
#'
#' This function stores a user's Google Maps API key as the package's
#' environmental variable
#'
#' @param key is the user's Google Maps API key
#' @examples
#' #DONTRUN
#' set.api.key("MY-GOOGLE-MAPS-API-KEY")
set.api.key = function(key) {
    assign("api.key", key, envir = pkg.env)
}

#' Compute Distance with Google Maps
#'
#' The function gmapsdistance uses the Google Maps Distance Matrix API in order
#' to compute the distance between two points. In order to be able to use the
#' function you will need an API key and enable the Distance Matrix API in the
#' Google Developers Console For more information about how to get a key, go to
#' https://developers.google.com/maps/documentation/distance-matrix/get-api-key#key
#' For more information about the Google Maps Distance Matrix API go to
#' https://developers.google.com/maps/documentation/distance-matrix/intro?hl=en
#' @title gmapsdistance
#' @usage gmapsdistance(origin, destination, mode, key)
#' @param origin  A string containing the description of the starting point.
#'   Should be inside of quoutes (""). If more than one word is used, they
#'   should be separated by a plus sign e.g. "Bogota+Colombia". Coordinates in
#'   LAT-LONG format are also a valid input as long as they can be identified by
#'   Google Maps
#' @param destination A string containing the description of the end point.
#'   Should be the same format as the variable "origin".
#' @param mode A string containing the mode of transportation desired. Should be
#'   inside of double quotes (",") and one of the following: "bicycling",
#'   "walking", "transit" or "driving".
#' @param key In order to use the Google Maps Distance Matrix API it is
#'   necessary to have an API key. The key should be inside of quotes. Example:
#'   "THISISMYKEY". This key an also be set using \code{set.api.key("THISISMYKEY")}.
#' @return a list with the traveling time and distance between origin and
#'   destination and the status
#' @examples
#' results = gmapsdistance("Washington+DC", "New+York+City+NY", "driving")
#' results
gmapsdistance = function(origin, destination, combinations = "all", mode, key = get.api.key(), shape = "wide", 
                         avoid = "", 
                         departure = "now", dep_date = "", dep_time = "", 
                         traffic_model = "best_guess",
                         arrival = "", arr_date = "", arr_time = "") {

    # If mode of transportation not recognized:
    if (!(mode %in% c("driving",  "walking",  "bicycling",  "transit"))) {
        stop(
            "Mode of transportation not recognized. Mode should be one of ",
            "'bicycling', 'transit', 'driving', 'walking' "
        )
    }
    
    # If combinations not recognized:
    if (!(combinations %in% c("all",  "pairwise"))) {
      stop(
        "Combinations between origin and destination not recognized. Combinations should be one of ",
        "'all', 'pairwise' "
      )
    }

    # If 'avoid' parameter is not recognized:
    if (!(avoid %in% c("", "tolls",  "highways",  "ferries",  "indoor"))) {
      stop(
        "Avoid parameters not recognized. Avoid should be one of ",
        "'tolls', 'highways', 'ferries', 'indoor' "
      )
    }

    # If traffic_model is not recognized:
    if (!(traffic_model %in% c("best_guess",  "pessimistic", "optimistic"))) {
      stop(
        "Traffic model not recognized. Traffic model should be one of ",
        "'best_guess', 'pessimistic', 'optimistic'"
      )
    }
  
    seconds = "now"
    seconds_arrival = ""
    
    UTCtime = strptime("1970-01-01 00:00:00", "%Y-%m-%d %H:%M:%OS", tz="GMT")
    min_secs = round(as.numeric(difftime(as.POSIXlt(Sys.time(), "GMT"), UTCtime, units="secs")))
    
    # DEPARTURE TIMES:
    # Convert departure time from date and hour to seconds after Jan 1, 1970, 00:00:00 UCT
    if(dep_date != "" && dep_time != ""){
      depart = strptime(paste(dep_date, dep_time), "%Y-%m-%d %H:%M:%OS", tz="GMT")
      seconds = round(as.numeric(difftime(depart, UTCtime, units = "secs")))
    } 
    
    # Give priority to 'departure' time, over date and hour
    if(departure != "now"){
      seconds = departure
    }
    
    # Exceptions when inputs are incorrect
    if(departure != "now" && departure < min_secs){
      stop("The departure time has to be some time in the future!")
    }
    
    if(dep_date != "" && dep_time == ""){
      stop("You should also specify a departure time in the format HH:MM:SS UTC")
    }
    
    if(dep_date == "" && dep_time != ""){
      stop("You should also specify a departure date in the format YYYY-MM-DD UTC")
    }
    
    if(dep_date != "" && dep_time != "" && seconds < min_secs){
      stop("The departure time has to be some time in the future!")
    }
    
    
    # ARRIVAL TIMES:
    # Convert departure time from date and hour to seconds after Jan 1, 1970, 00:00:00 UCT
    if(arr_date != "" && arr_time != ""){
      arriv = strptime(paste(arr_date, arr_time), "%Y-%m-%d %H:%M:%OS", tz="GMT")
      seconds_arrival = round(as.numeric(difftime(arriv, UTCtime, units = "secs")))
    } 
    
    # Give priority to 'arrival' time, over date and hour
    if(arrival != ""){
      seconds_arrival = arrival
    }
    
    # Exceptions when inputs are incorrect
    if(arrival != "" && arrival < min_secs){
      stop("The arrival time has to be some time in the future!")
    }
    
    if(arr_date != "" && arr_time == ""){
      stop("You should also specify an arrival time in the format HH:MM:SS UTC")
    }
    
    if(arr_date == "" && arr_time != ""){
      stop("You should also specify an arrival date in the format YYYY-MM-DD UTC")
    }
    
    if(arr_date != "" && arr_time != "" && seconds_arrival < min_secs){
      stop("The arrival time has to be some time in the future!")
    }
    
    
    if((dep_date != "" || dep_time != "" || departure != "now") && (arr_date != "" || arr_time != "" || arrival != "")){
      stop("Cannot input departure and arrival times. Only one can be used at a time. ")
    }
    
    if(combinations == "pairwise" && length(origin) != length(destination)){
      stop("Size of origin and destination vectors must be the same when using the option: combinations == 'pairwise'")
    }
    
    if(combinations == "all"){
      data = expand.grid(or = origin, de = destination)
    } else if(combinations == "pairwise"){
      data = data.frame(or = origin, de = destination)
    }
  
    n = dim(data)
    n = n[1]
    
    data$Time = NA
    data$Distance = NA
    data$status = "OK"
    
    avoidmsg = ""
    
    if(avoid !=""){
      avoidmsg = paste0("&avoid=", avoid)
    }
    
    for (i in 1:1:n){
      
      # Set up URL
      url = paste0("maps.googleapis.com/maps/api/distancematrix/xml?origins=", data$or[i],
                   "&destinations=", data$de[i],
                   "&mode=", mode,
                   "&sensor=", "false",
                   "&units=metric",
                   "&departure_time=", seconds,
                   "&traffic_model=", traffic_model,
                   avoidmsg)
      
      # Add Google Maps API key if it exists
      if (!is.null(key)) {
        # use https and google maps key (after replacing spaces just in case)
        key = gsub(" ", "", key)
        url = paste0("https://", url, "&key=", key)
      } else {
        # use http otherwise
        url = paste0("http://", url)
      }
      
      # Call the Google Maps Webservice and store the XML output in webpageXML
      webpageXML = xmlParse(getURL(url));
      
      # Extract the results from webpageXML
      results = xmlChildren(xmlRoot(webpageXML))
      
      # Check the status of the request and throw an error if the request was denied
      request.status = as(unlist(results$status[[1]]), "character")
      
      # Check for google API errors
      if (!is.null(results$error_message)) {
        stop(paste(c("Google API returned an error: ", xmlValue(results$error_message)), sep = ""))
      }
      
      if (request.status == "REQUEST_DENIED") {
        set.api.key(NULL)
        data$status[i] = "REQUEST_DENIED"
        # stop(as(results$error_message[1]$text, "character"))
      }
      
      # Extract results from results$row
      rowXML = xmlChildren(results$row[[1L]])
      Status = as(rowXML$status[1]$text, "character")
      
      if (Status == "ZERO_RESULTS") {
        # stop(paste0("Google Maps is not able to find a route between ", data$or[i]," and ", data$de[i]))
        data$status[i] = "ROUTE_NOT_FOUND"
      }
      
      if (Status == "NOT_FOUND") {
        # stop("Google Maps is not able to find the origin (", data$or[i],") or destination (", data$de[i], ")")
        data$status[i] = "PLACE_NOT_FOUND"
      }
      
      # Check whether the user is over their query limit
      if (Status == "OVER_QUERY_LIMIT") {
        stop("You have exceeded your allocation of API requests for today.")
      }
      
      if(data$status[i] == "OK"){
        data$Distance[i] = as(rowXML$distance[1]$value[1]$text, "numeric")
        
        dur = grep("duration", names(rowXML), value = TRUE)
        data$Time[i] = as(rowXML[[dur]][1L]$value[1L]$text, "numeric")
      }
    }
    
    datadist = data[c("or", "de", "Distance")]
    datatime = data[c("or", "de", "Time")]
    datastat = data[c("or", "de", "status")]
    
    if(n > 1){
      if(shape == "wide" && combinations == "all"){
        Distance = reshape(datadist, 
                          timevar = "de",
                          idvar = c("or"),
                          direction = "wide")
        
        Time = reshape(datatime, 
                        timevar = "de",
                        idvar = c("or"),
                        direction = "wide")
        
        Stat = reshape(datastat, 
                       timevar = "de",
                       idvar = c("or"),
                       direction = "wide")
        
      } else{
        Distance = datadist
        Time = datatime
        Stat = datastat
      }
    } else{
      Distance = data$Distance[i]
      Time = data$Time[i]
      Stat = data$status[i]
    }
    
    # Make a list with the results
    output = list(Time = Time,
                  Distance = Distance,
                  Status = Stat)

    return(output)
}
