#' Define package environment
#'
#' \code{pkg.env} is a package environment that contains the variable
#' \code{api.key} with the user's Google Maps API key
#'
#' @keywords internal
#'
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
#' @export
#'
#' @param key is the user's Google Maps API key
#' @examples
#' #DONTRUN
#' set.api.key("MY-GOOGLE-MAPS-API-KEY")
set.api.key = function(key) {
  assign("api.key", key, envir = pkg.env)
}
