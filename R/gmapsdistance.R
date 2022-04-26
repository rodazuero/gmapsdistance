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
#'     mode = "driving",
#'     key = get.api.key(),
#'     shape = "wide",
#'     avoid = "",
#'     departure = "",
#'     dep_date = "",
#'     dep_time = "",
#'     traffic_model = "None",
#'     arrival = "",
#'     arr_date = "",
#'     arr_time = ""
#' )
#'
#' @export
#'
#' @param origin A string or vector of strings containing the description of the
#'  starting point(s). Should be inside of quotes ("").
#'
#'  Coordinates in LAT-LONG format are also a valid input as long as they
#'  can be identified by Google Maps.
#'
#' @param destination A string or vector of strings containing the description of
#'  the end point(s). Should be the same format as the variable "origin".
#'
#' @param combinations When the origin and destination entries are vectors, the
#'  user can specify if the function computes all possible combinations
#'  between origins and destinations, or only pairwise distance and times.
#'  Should be inside of double quotes (",") and one of the following: "all",
#'  "pairwise".
#'
#'  If the combinations is set to "pairwise", the origin and destination vectors
#'  must have the same length.
#'
#' @param mode A string containing the mode of transportation desired. Should be
#'  inside of double quotes (",") and one of the following: "bicycling",
#'  "walking", "transit" or "driving".
#'
#' @param key In order to use the Google Maps Distance Matrix API it is necessary
#'  to have an API key. The key should be inside of quotes. Example:
#'  "THISISMYKEY". This key an also be set using \code{set.api.key("THISISMYKEY")}.
#'
#' @param shape A string that specifies the shape of the distance and time
#'  matrices to be returned. Should be inside of double quotes (",") and one
#'  of the following: "long" or "wide".
#'
#'  If the function is used to find the distance/time for one origin and one
#'  destination, the shape does not matter. If there is more than one city as
#'  origin or destination, "long" will return a matrix in long format and
#'  "wide" will return a matrix in wide format. The shape is set as wide be
#'  default.
#'
#'
#' @param avoid When the mode is set to "driving", the user can find the time and
#'  distance of the route by avoiding tolls, highways, indoor and ferries.
#'  Should be inside of double quotes (",") and one of the following: "tolls",
#'  "highways", "ferries", "indoor".
#'
#'
#' @param departure The time and distance can be computed at the desired time of
#'  departure. The option departure is the number of seconds since January
#'  1, 1970 00:00:00 UTC. Alternatively, the user can use the dep_date and
#'  dep_time options to set the departure date and time.
#'
#'  If no value is set for departure, dep_date and dep_time, the departure time is
#'  set to the present.
#'
#'  Note that API calls that satisfy both of these conditions: 1) departure time
#'  is specified and  2) travel mode equals "driving" (either directly or via
#'  fallback to default) incur higher cost.
#'
#' @param dep_date Instead of using the departure option, the user can set the
#'  departure date and time using dep_date and dep_time options.
#'
#'  If no value is set for departure, dep_date and dep_time, the departure time is
#'  set to the present.
#'
#' @param dep_time Instead of using the departure option, the user can set the
#'  departure date and time using dep_date and dep_time options.
#'
#'  If no value is set for departure, dep_date and dep_time, the departure time is
#'  set to the present.
#'
#' @param traffic_model When the mode is set to "driving" and a departure time
#'  is provided the user can find the times and distances using different traffic
#'  models. Should be a string and one of the following: "optimistic",
#'  "pessimistic", "best_guess" or "None".
#'
#'  Default is "None". The traffic model is not defined for other modes
#'  of transport than driving, and providing it for e.g. mode = "walking" is illegal.
#'
#'
#' @param arrival For transportation mode "transit" the time and distance can
#'  be computed to arrive at a predetermined time. The option arrival is the
#'  number of seconds since January 1, 1970 00:00:00 UTC. Alternatively, the
#'  user can use the arr_date and arr_time options to set the arrival date and time.
#'
#'  For transport modes other than "transit" the use of arrival (and arr_date
#'   + arr_time) is illegal.
#'
#'  The user cannot input both departure and arrival times.
#'
#' @param arr_date Instead of using the arrival option, the user can set the
#'  arrival date and time using arr_date and arr_time options.
#'
#'  The user cannot input both departure and arrival times.
#'
#' @param arr_time Instead of using the arrival option, the user can set the
#'  arrival date and time using arr_date and arr_time options.
#'
#'  The user cannot input both departure and arrival times.
#'
#' @return A list with 3 named elements:
#' \itemize{
#'    \item{\strong{Distance}: distance between the points provided, taking into
#'    account mode of transport.}
#'    \item{\strong{Time}: time of travel, taking into account mode of transport.
#'
#'    In case departure time was specified, and mode was set to "driving" (either
#'    directly or via fallback default) the travel time includes delays due to traffic.}
#'    \item{\strong{Status}: status of the API call.}
#'  }
#'
#' @examples
#' \dontshow{set.api.key(Sys.getenv("GOOGLE_API_KEY"))}
#' \dontrun{
#' # distance from Washington DC to NYC
#' gmapsdistance(origin = "Washington DC",
#'               destination = "New York City NY")
#'
#' # distance matrix between 3 US cities
#' gmapsdistance(origin = c("Washington DC", "New York NY", "Seattle WA"),
#'               destination = c("Washington DC", "New York NY", "Seattle WA"))$Distance
#' }

gmapsdistance = function(origin,
                         destination,
                         combinations = "all",
                         mode = "driving",
                         key = get.api.key(),
                         shape = "wide",
                         avoid = "",
                         departure = "",
                         dep_date = "",
                         dep_time = "",
                         traffic_model = "None",
                         arrival = "",
                         arr_date = "",
                         arr_time = "") {


  ## INPUT VALIDATION ----


  # one departure only
  if (length(departure)>1 | length(dep_date)>1  | length(dep_time)>1 ) {
    stop(
      "A single departure time is expected."
    )
  }

  # one arrival only
  if (length(arrival)>1 | length(arr_date)>1  | length(arr_time)>1 ) {
    stop(
      "A single arrival time is expected."
    )
  }

  # If mode of transportation not recognized:
  if (!all(mode %in% c("driving",  "walking",  "bicycling",  "transit") & length(mode) == 1)) {
    stop(
      "Mode of transportation not recognized. Mode should be one of ",
      "'bicycling', 'transit', 'driving', 'walking' "
    )
  }

  # If combinations not recognized:
  if (!all(combinations %in% c("all",  "pairwise") & length(combinations) == 1)) {
    stop(
      "Combinations between origin and destination not recognized. Combinations should be one of ",
      "'all', 'pairwise' "
    )
  }

  # If 'avoid' parameter is not recognized:
  if (!all(avoid %in% c("", "tolls",  "highways",  "ferries",  "indoor"))) {
    stop(
      "Avoid parameters not recognized. Avoid should be one of ",
      "'tolls', 'highways', 'ferries', 'indoor' "
    )
  }

  # If traffic_model is not recognized:
  if (!all(traffic_model %in% c("best_guess",  "pessimistic", "optimistic", "None") & length(traffic_model) == 1)) {
    stop(
      "Traffic model not recognized. Traffic model should be one of ",
      "'best_guess', 'pessimistic', 'optimistic'"
    )
  }

  # If traffic_model is not paired with mode drivning and a specific departure time:
  if (traffic_model %in% c("best_guess",  "pessimistic", "optimistic")
        & mode != "driving" & all(departure != "" || dep_date != "")) {
    stop(
      "Traffic models are defined only form mode = 'driving' and a specific departure time."
    )
  }

  # If arrival time is paired with other mode than "transit"
  if (mode != "transit" & all(arrival != "" || arr_date != "" || arr_time != "")) {
    stop(
      "Arrival times are defined only form mode = 'transit'."
    )
  }

  # if multiple avoidance was selected collapse to single string
  if (length(avoid) > 1) {
    avoid <- paste(avoid, collapse = "|")
  }

  seconds <- "now"
  seconds_arrival <- ""

  min_secs <- round(as.numeric(Sys.time()))

  # DEPARTURE TIMES ----
  # Convert departure time from date and hour to epoch seconds
  if(nzchar(dep_date) && nzchar(dep_time)){
    depart <- strptime(paste(dep_date, dep_time), "%F %H:%M:%OS", tz="UTC")
    seconds <- round(as.numeric(depart))
  }

  # Give priority to 'departure' time, over date and hour
  if(!departure %in% c("now", "")){
    seconds = departure
  }

  # Exceptions when inputs are incorrect
  if(dep_date != "" && dep_time == ""){
    stop("You should also specify a departure time in the format HH:MM:SS UTC")
  }

  if(dep_date == "" && dep_time != ""){
    stop("You should also specify a departure date in the format YYYY-MM-DD UTC")
  }

  if(dep_date != "" && dep_time != "" && seconds < min_secs){
    stop("The departure time has to be some time in the future!")
  }

  if((dep_date != "" || dep_time != "" || !departure %in% c("now", "")) && (arr_date != "" || arr_time != "" || arrival != "")){
    stop("Cannot input departure and arrival times. Only one can be used at a time. ")
  }

  if(combinations == "pairwise" && length(origin) != length(destination)){
    stop("Size of origin and destination vectors must be the same when using the option: combinations == 'pairwise'")
  }


  # ARRIVAL TIMES ----
  # Convert arrrival time from date and hour to seconds after Jan 1, 1970, 00:00:00 UTC
  if(arr_date != "" && arr_time != ""){
    arriv = strptime(paste(arr_date, arr_time), "%F %H:%M:%OS", tz="UTC")
    seconds_arrival = round(as.numeric(arriv))
  }

  # Give priority to 'arrival' time, over date and hour
  if(arrival != ""){
    seconds_arrival = arrival
  }

  # Exceptions when inputs are incorrect
  if(seconds_arrival != "" & seconds_arrival < min_secs){
    stop("The arrival time has to be some time in the future!")
  }

  if(arr_date != "" && arr_time == ""){
    stop("You should also specify an arrival time in the format HH:MM:SS UTC")
  }

  if(arr_date == "" && arr_time != ""){
    stop("You should also specify an arrival date in the format YYYY-MM-DD UTC")
  }

  if(combinations == "all"){
    data <- expand.grid(or = origin, de = destination)
  } else {
    data <- data.frame(or = origin, de = destination)
  }

  n <- dim(data)
  n <- n[1]

  data$Time <- NA
  data$Distance <- NA
  data$status <- "OK"

  # QUERY STRING OPTIMIZATION ----

  # avoid when required
  if(avoid !=""){
    avoidmsg = paste0("&avoid=", avoid)
  } else {
    avoidmsg <- ""
  }


  # if model was specified - update string & check duration with traffic
  if (traffic_model == "None") {
    traffic_model_string <- ''
    duration_key <- 'duration'
  } else {
    traffic_model_string = paste0("&traffic_model=", traffic_model)
    duration_key <- 'duration_in_traffic'
  }

  # if model = driving (which is the default) no need to pass it to Google (& incur costs)
  if (mode == "driving" ) {
    mode_string <- ''
  } else {
    mode_string <- paste0("&mode=", mode)
  }

  # if no departure time was specified = no need to pass it to  Google (& incur costs)
  if (departure == "" & dep_date == "" & dep_time == "") {
    departure_string <- ''
  } else {
    departure_string <- paste0("&departure_time=", seconds)
  }

  # ACTION!!! ----
  for (i in 1:n) {

  # Set up URL
    url = paste0("maps.googleapis.com/maps/api/distancematrix/xml?origins=", data$or[i],
                 "&destinations=", data$de[i],
                 mode_string,
                 "&units=metric",
                 departure_string,
                 traffic_model_string,
                 avoidmsg)

    # use https and google maps key (after replacing spaces just in case)
    key = gsub(" ", "", key)
    url = utils::URLencode(paste0("https://", url, "&key=", key))

    # Call the Google Maps Webservice, catching errors along the way
    url_result <- tryCatch(

      RCurl::getURL(url),
      # nocov start
      warning = function(e) {
        return(NULL)
      },
      error = function(e) {
        return(NULL)
      }
      # nocov end
    )

    # if the API call failed >> fail the function, but gracefully
    if(is.null(url_result)) {

      # nocov start
      message("Google API call failed; check your internet connection")
      return(NA)
      # nocov end

    }

    # all is well - proceed as planned
    webpageXML = XML::xmlParse(url_result)

    # Extract the results from webpageXML
    results = XML::xmlChildren(XML::xmlRoot(webpageXML))

    # Check the status of the request and throw an error if the request was denied
    request.status = methods::as(unlist(results$status[[1]]), "character")

    # Check for google API errors
    if (!is.null(results$error_message)) {
      stop(paste(c("Google API returned an error: ", XML::xmlValue(results$error_message)), sep = ""))
    }

    if (request.status == "REQUEST_DENIED") {
      data$status[i] <- "REQUEST_DENIED"
     }

    # Extract results from results$row
    rowXML <- XML::xmlChildren(results$row[[1L]])
    Status <- methods::as(rowXML$status[1]$text, "character")

    if (Status == "ZERO_RESULTS") {
      data$status[i] <- "ROUTE_NOT_FOUND"
    }

    if (Status == "NOT_FOUND") {
      data$status[i] <- "PLACE_NOT_FOUND"
    }

    # Check whether the user is over their query limit / likely
    if (Status == "OVER_QUERY_LIMIT") {
      stop("You have exceeded your allocation of API requests for today.")
    }

    if(data$status[i] == "OK"){

      # distance = always provided
      data$Distance[i] <- methods::as(rowXML$distance[1]$value[1]$text, "numeric")

      # duration = try what was reqested, if not possible = fallback to default (plain vanilla duration)
      if(length(methods::as(rowXML[[duration_key]][1L]$value[1L]$text, "numeric"))>0) {

        data$Time[i] <- methods::as(rowXML[[duration_key]][1L]$value[1L]$text, "numeric")

      } else {

        data$Time[i] <-methods::as(rowXML[["duration"]][1L]$value[1L]$text, "numeric")

      } # / end if duration


    } # / end if status OK
  } # / end for cycle


  # PROCESS RESULTS ---

  datadist = data[c("or", "de", "Distance")]
  datatime = data[c("or", "de", "Time")]
  datastat = data[c("or", "de", "status")]

  if(n > 1){
    if (shape == "wide" && combinations == "all") {
      Distance <- matrix(
        datadist$Distance,
        nrow = sqrt(n),
        dimnames = list(origin,
                        destination)
        )

      Time <- matrix(
        datatime$Time,
        nrow = sqrt(n),
        dimnames = list(origin,
                        destination)
      )

      Stat <- matrix(
        datastat$status,
        nrow = sqrt(n),
        dimnames = list(origin,
                        destination)
      )


    } else{
      Distance = datadist
      Time = datatime
      Stat = datastat
    } # end if wide output

  } else {
    Distance = data$Distance
    Time = data$Time
    Stat = data$status
  } # end if single pair of points

  # Make a list with the results
  output = list(
    Distance = Distance,
    Time = Time,
    Status = Stat
  )

  return(output)
}

