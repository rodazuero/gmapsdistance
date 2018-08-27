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
#' to compute the distance(s) and time(s) between two points. In order to be able to use the
#' function you will need an API key and enable the Distance Matrix API in the
#' Google Developers Console For more information about how to get a key, go to
#' https://developers.google.com/maps/documentation/distance-matrix/get-api-key#key
#' For more information about the Google Maps Distance Matrix API go to
#' https://developers.google.com/maps/documentation/distance-matrix/intro?hl=en
#' @title gmapsdistance
#' @usage
#' gmapsdistance(
#'     origin,
#'     destination,
#'     combinations = "all",
#'     mode,
#'     key = get.api.key(),
#'     shape = "wide",
#'     avoid = "",
#'     departure = "now",
#'     dep_date = "",
#'     dep_time = "",
#'     traffic_model = "None",
#'     arrival = "",
#'     arr_date = "",
#'     arr_time = ""
#' )
#'
#' @param origin A string or vector of strings containing the description of the
#'     starting point(s). Should be inside of quoutes (""). If more than one word
#'     for a same location is used, they should be separated by a plus sign e.g.
#'     "Bogota+Colombia". Coordinates in LAT-LONG format are also a valid input
#'     as long as they can be identified by Google Maps.
#'
#' @param destination A string or vector of strings containing the description of
#'     the end point(s). Should be the same format as the variable "origin".
#'
#' @param combinations When the origin and destination entries are vectors, the
#'     user can specify if the function computes all possible combinations
#'     between origins and destinations, or only pairwise distance and times.
#'     Should be inside of double quotes (",") and one of the following: "all",
#'     "pairwise".
#'
#'     If the combinations is set to "pairwise", the origin and destination vectors
#'     must have the same lenght.
#'
#' @param mode A string containing the mode of transportation desired. Should be
#'     inside of double quotes (",") and one of the following: "bicycling",
#'     "walking", "transit" or "driving".
#'
#' @param key In order to use the Google Maps Distance Matrix API it is necessary
#'     to have an API key. The key should be inside of quotes. Example:
#'     "THISISMYKEY". This key an also be set using
#'     \code{set.api.key("THISISMYKEY")}.
#'
#' @param shape A string that specifies the shape of the distance and time
#'     matrices to be returned. Should be inside of double quotes (",") and one
#'     of the following: "long" or "wide".
#'
#'     If the function is used to find the distance/time for one origin and one
#'     destination, the shape does not matter. If there is more than one city as
#'     origin or destination, "long" will return a matrix in long format and
#'     "wide" will return a matrix in wide format. The shape is set as wide be
#'     default.
#'
#'
#' @param avoid When the mode is set to "driving", the user can find the time and
#'     distance of the route by avoiding tolls, highways, indoor and ferries.
#'     Should be inside of double quotes (",") and one of the following: "tolls",
#'     "highways", "ferries", "indoor".
#'
#'     ONLY works with a Google Maps API key.
#'
#' @param departure The time and distance can be comptued at the desired time of
#'         departure. The option departure is the number of seconds since January
#'         1, 1970 00:00:00 UCT. Alternatively, the user can use the dep_date and
#'         dep_time options to set the departure date and time.
#'
#'         If no value is set for departure, dep_date and dep_time, the departure time is
#'         set to the present.
#'
#'         ONLY works with a Google Maps API key AND MUST be according to UCT time.
#'
#' @param dep_date Instead of using the departure option, the user can set the
#'     departure date and time using dep_date and dep_time options.
#'
#'     If no value is set for departure, dep_date and dep_time, the departure time is
#'     set to the present.
#'
#'     ONLY works with a Google Maps API key AND MUST be according to UCT time.
#'
#' @param dep_time Instead of using the departure option, the user can set the
#'     departure date and time using dep_date and dep_time options.
#'
#'     If no value is set for departure, dep_date and dep_time, the departure time is
#'     set to the present.
#'
#'     ONLY works with a Google Maps API key AND MUST be according to UCT time.
#'
#' @param traffic_model When the mode is set to "driving", the user can find the
#'     times and distances using different traffic models. Should be a string and
#'     one of the following: "optimistic", "pessimistic", "best_guess" or "None"
#'     (default).
#'
#'     ONLY works with a Google Maps API key and with a departure time.
#'
#' @param arrival The time and distance can be comptued to arrive at a
#'         predetermined time. The option arrival is the number of seconds since
#'         January 1, 1970 00:00:00 UCT. Alternatively, the user can use the
#'         arr_date and arr_time options to set the arrival date and time.
#'
#'     The user cannot input both departure and arrival times.
#'
#'     ONLY works with a Google Maps API key AND MUST be according to UCT time.
#'
#' @param arr_date Instead of using the arrival option, the user can set the
#'     arrival date and time using arr_date and arr_time options.
#'
#'     The user cannot input both departure and arrival times.
#'
#'     ONLY works with a Google Maps API key AND MUST be according to UCT time.
#'
#' @param arr_time Instead of using the arrival option, the user can set the
#'     arrival date and time using arr_date and arr_time options.
#'
#'     The user cannot input both departure and arrival times.
#'
#'     ONLY works with a Google Maps API key AND MUST be according to UCT time.
#' @return A list with the traveling time(s) and distance(s) between origin(s) and
#' destination(s) and the status
#' #' @examples
#' # Example 1
#' results = gmapsdistance(origin = "Washington+DC",
#'                         destination = "New+York+City+NY",
#'                         mode = "driving")
#' results
#'
#' # Example 2
#' results = gmapsdistance(origin = "38.1621328+24.0029257",
#'                         destination = "37.9908372+23.7383394",
#'                         mode = "walking")
#' results
#'
#' # Example 3
#' results = gmapsdistance(origin = c("Seattle+WA", "Miami+FL"),
#'                         destination = c("Chicago+IL", "Philadelphia+PA"),
#'                         mode = "bicycling",
#'                         dep_date = "2022-08-16",
#'                         dep_time = "20:40:00")
#'
#' results
#'
#' # Example 4
#' origin = c("Washington+DC", "Miami+FL")
#' destination = c("Los+Angeles+CA", "Austin+TX", "Chicago+IL")
#' results = gmapsdistance(origin, destination, mode = "driving", shape = "long")
#' results
#'
#' # Example 5
#' origin = c("40.431478+-80.0505401", "33.7678359+-84.4906438")
#' destination = c("43.0995629+-79.0437609", "41.7096483+-86.9093986")
#' results = gmapsdistance(origin, destination, mode = "bicycling", shape="long")
#' results
#'
#' # Example 6 (do not run -- needs an API key)
#' # results = gmapsdistance(origin = c("Washington+DC", "New+York+NY"),
#' #                         destination = c("Los+Angeles+CA", "Austin+TX"),
#' #                         mode = "driving",
#' #                         departure = 1514742000,
#' #                         traffic_model = "pessimistic",
#' #                         shape = "long",
#' #                         key=APIkey)
#' #
#' # results
#'
#' # EXAMPLE 7  (do not run -- needs an API key)
#' # results = gmapsdistance(origin = c("Washington+DC", "New+York+NY"),
#' #                         destination = c("Los+Angeles+CA", "Austin+TX"),
#' #                         mode = "driving",
#' #                         avoid = "tolls",
#' #                         key=APIkey)
#' #
#' # results
gmapsdistance = function(origin, destination, combinations = "all", mode, key = get.api.key(), shape = "wide",
                         avoid = "",
                         departure = "now", dep_date = "", dep_time = "",
                         traffic_model = "None",
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
  if (!(traffic_model %in% c("best_guess",  "pessimistic", "optimistic", "None"))) {
    stop(
      "Traffic model not recognized. Traffic model should be one of ",
      "'best_guess', 'pessimistic', 'optimistic'"
    )
  } else if (traffic_model == "None") {
    traffic_model_string = ''
    duration_key = 'duration'
  } else {
    if (is.null(key)){
        stop('You need to provide a Google Maps API key if you want to use `traffic_model`. Use: `set.api.key(YOUR_KEY)`.')
    }
    traffic_model_string = paste0("&traffic_model=", traffic_model)
    duration_key = 'duration_in_traffic'
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
                   traffic_model_string,
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
      data$Time[i] = as(rowXML[[duration_key]][1L]$value[1L]$text, "numeric")
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
  output = list(
    Time = Time,
    Distance = Distance,
    Status = Stat
  )

  return(output)
}

