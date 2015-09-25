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
gmapsdistance = function(origin, destination, mode, key = get.api.key()) {

    # If mode of transportation not recognized:
    if (!(mode %in% c("driving",  "walking",  "bicycling",  "transit"))) {
        stop(
            "Mode of transportation not recognized. Mode should be one of ",
            "'bicycling', 'transit', 'driving', 'walking' "
        )
    }

    # Set up URL
    url = paste0("maps.googleapis.com/maps/api/distancematrix/xml?origins=", origin,
                 "&destinations=", destination,
                 "&mode=", mode,
                 "&sensor=", "false",
                 "&units=", "metric")

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
    tc = textConnection(getURL(url))
    webpageXML = xmlParse(readLines(tc));
    close(tc)

    # Extract the results from webpageXML
    results = xmlChildren(xmlRoot(webpageXML))

    # Check the status of the request and throw an error if the request was denied
    request.status = as(unlist(results$status[[1]]), "character")

    if (request.status == "REQUEST_DENIED") {
        set.api.key(NULL)
        stop(as(results$error_message[1]$text, "character"))
    }

    # Extract results from results$row
    Status = as(xmlChildren(results$row[[1]])$status[1]$text, "character")

    if (Status == "ZERO_RESULTS") {
        stop("Google Maps is not able to find a route between origin and destination")
    }

    if (Status == "NOT_FOUND") {
        stop("Google Maps is not able to find the origin or destination")
    }

    Time = as(xmlChildren(results$row[[1]])$duration[1]$value[1]$text, "numeric")
    Distance = as(xmlChildren(results$row[[1]])$distance[1]$value[1]$text, "numeric")

    # Make a list with the results
    output = list(Time = Time,
                  Distance = Distance,
                  Status = Status)

    return(output)
}
