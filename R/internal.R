#' Test if a charachter string represents a date
#'
#' Test if a charachter string represents a date
#'
#' @param string Character string with data to test if it is a Posixct date
#'
#' @return A boolean with TRUE if string contains a date and FALSE otherwise
#'
#' @examples
#' \dontrun{
#' # Returns TRUE
#' IsPosixct("2010-01-01")
#'
#' #Returns FALSE
#' IsPosixct("2010j01-xx")
#' }
IsPosixct = function(string){
  tryCatch(!is.na(as.POSIXct(string)),
           error = function(err) {FALSE})
}
