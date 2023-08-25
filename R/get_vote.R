#' @title get_vote
#'
#' @description This gathers all the votes for a specific Parliament and Session into an XML file
#'
#' @usage
#' get_vote(Working_Directory = "~/demo_vote/xml/",
#'        	Language = "en",
#'         	ParliamentNumber = "44",
#'         	SessionNumber = "1")
#'
#' @param Working_Directory: working directory where the XML files are being download
#'
#' @param Language: French or English ("fr", "en")
#'
#' @param ParliamentNumber: Parliament number
#'
#' @param SessionNumber: Session number
#'
#' @examples
#' get_vote(Working_Directory = "~/demo_vote/xml/",
#'        	Language = "en",
#'         	ParliamentNumber = "44",
#'         	SessionNumber = "1")
#'
#' @import stringi
#'
#' @import stringr
#'
#' @import xml2
#'
#' @export

get_vote = function(Working_Directory, Language, ParliamentNumber, SessionNumber){

  # Select language
  url = paste0("https://www.ourcommons.ca/members/", tolower(Language), "/votes/xml?parlSession=", ParliamentNumber, "-", SessionNumber)

  ### Download Hansard
  download.file(url, paste0(Working_Directory, "can_vote_", ParliamentNumber, "-", SessionNumber, "_", Language))
}
