#' @title get_vote_info
#'
#' @description This gathers vote details for a specific vote into an XML file
#'
#' @usage
#' get_vote_info(Working_Directory = "",
#'               Language = "",
#'               ParliamentNumber = "",
#'               SessionNumber = "",
#'               DecisionDivisionNumber = "")
#'
#' @param Working_Directory: working directory where the XML files are being download
#'
#' @param Language: French or English ("fr", "en")
#'
#' @param ParliamentNumber: Parliament number
#'
#' @param SessionNumber: Session number
#'
#' @param DecisionDivisionNumber: vote number
#'
#' @import stringi
#'
#' @import stringr
#'
#' @import xml2
#'
#' @examples
#' get_vote_info(Working_Directory = "~/",
#'               Language = "en",
#'               ParliamentNumber = "44",
#'               SessionNumber = "1",
#'               DecisionDivisionNumber = "400")
#'
#' @export

get_vote_info = function(Working_Directory, Language, ParliamentNumber, SessionNumber, DecisionDivisionNumber){

  # Select language
  url = paste0("https://www.ourcommons.ca/members/", tolower(Language), "/votes/", ParliamentNumber, "/", SessionNumber, "/", DecisionDivisionNumber, "/xml")

  ### Download Hansard
  download.file(url, paste0(Working_Directory, "can_vote_info_", ParliamentNumber, "-", SessionNumber, "_", DecisionDivisionNumber, "_", Language))
}




