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
get.api.key = function() {
    get("api.key", envir = pkg.env)
}

#' Set the Google Maps API key
#'
#' This function stores a user's Google Maps API key as the package's
#' environmental variable
#'
#' @param key is the user's Google Maps API key
set.api.key = function(key) {
    assign("api.key", key, envir = pkg.env)
}

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
#'   "THISISMYKEY". This key an also be set using \code{set.api.key("my key")}.
#' @return a list with the traveling time and distance between origin and
#'   destination and the status
gmapsdistance = function(origin, destination, mode, key = get.api.key()) {
    # If mode of transportation not recognized:
    if (mode != "driving" &
        mode != "walking" &
        mode != "bicycling" & mode != "transit") {
        stop(
            "Mode of transportation not recognized. Mode should be one of ",
            "'bicycling', 'transit', 'driving', 'walking' "
        )
    }

    if (is.null(key)) {
        url0 = "http://maps.googleapis.com/maps/api/distancematrix/xml?origins="
        modeT = paste0("|&mode=",mode,"&language=fr-FR&sensor=false")
        urlfin = paste0(url0, origin, "|&destinations=", destination, modeT, "&units=metric")
    } else {
        # Extracting type of key
        typeKEY = class(key)
        if (typeKEY != "character") {
            stop("Key should be string")
        }

        # Now going to do the query in google maps. The first step is
        # to generate the necessary url concatenating the corresopnding
        # inputs
        url0 = "https://maps.googleapis.com/maps/api/distancematrix/xml?origins="
        modeT = paste0("|&mode=",mode,"&language=fr-FR")
        urlfin = paste0(url0, origin, "|&destinations=", destination, modeT, "&key=",key)
    }

    # Read lines
    webpageXML = getURL(urlfin)
    tc = textConnection(webpageXML)
    webpageXML2 = readLines(tc);
    close(tc)
    # XMLparse
    webpageXMLA = xmlParse(webpageXML2)
    # And extract the necessary values
    root = xmlRoot(webpageXMLA)
    child = xmlChildren(root)
    initstat = as(child$status[[1]], "character")

    if (initstat == "REQUEST_DENIED") {
        message = (child$error_message[1]$text)
        message = as(message, "character")
        stop(message)
    }

    two = child[[4]]

    Status = as(xmlChildren(two[[1]])$status[1]$text, "character")

    if (Status == "ZERO_RESULTS") {
        stop("Google maps is not able to find a route between origin and destination")
    }

    if (Status == "NOT_FOUND") {
        stop("Google maps is not able to find the origin or destination")
    }

    Time = as(xmlChildren(two[[1]])$duration[1]$value[1]$text, "numeric")
    Distance = as(xmlChildren(two[[1]])$distance[1]$value[1]$text, "numeric")

    output = list(Time = Time,
                  Distance = Distance,
                  Status = Status)

    return(output)
}
