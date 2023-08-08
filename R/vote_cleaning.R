#' @title vote_cleaning
#'
#' @description Cleans the XML nodes in preparation to RDS conversion
#'
#' @usage vote_cleaning(xml_database = "")
#'
#' @param xml_database: XML file
#'
#' @import stringi
#'
#' @import stringr
#'
#' @import xml2
#'
#' @export

vote_cleaning = function(xml_database){
  # Splitting each vote
  vote_nodes = xml_find_all(xml_database, "//ArrayOfVote/Vote")

  vote_df = data.frame(matrix("NA", nrow = length(vote_nodes), ncol = 11))
  colnames(vote_df) = c("ParliamentNumber",
                        "SessionNumber",
                        "DecisionEventDateTime",
                        "DecisionDivisionNumber",
                        "DecisionDivisionSubject",
                        "DecisionResultName",
                        "DecisionDivisionNumberOfYeas",
                        "DecisionDivisionNumberOfNays",
                        "DecisionDivisionNumberOfPaired",
                        "DecisionDivisionDocumentTypeName",
                        "DecisionDivisionDocumentTypeId")

  for(i in 1:length(vote_nodes)){
    # Getting nodes for each vote
    ParliamentNumber = xml_find_all(vote_nodes[[i]], "ParliamentNumber")
    SessionNumber = xml_find_all(vote_nodes[[i]], "SessionNumber")
    DecisionEventDateTime = xml_find_all(vote_nodes[[i]], "DecisionEventDateTime")
    DecisionDivisionNumber = xml_find_all(vote_nodes[[i]], "DecisionDivisionNumber")
    DecisionDivisionSubject = xml_find_all(vote_nodes[[i]], "DecisionDivisionSubject")
    DecisionResultName = xml_find_all(vote_nodes[[i]], "DecisionResultName")
    DecisionDivisionNumberOfYeas = xml_find_all(vote_nodes[[i]], "DecisionDivisionNumberOfYeas")
    DecisionDivisionNumberOfNays = xml_find_all(vote_nodes[[i]], "DecisionDivisionNumberOfNays")
    DecisionDivisionNumberOfPaired = xml_find_all(vote_nodes[[i]], "DecisionDivisionNumberOfPaired")
    DecisionDivisionDocumentTypeName = xml_find_all(vote_nodes[[i]], "DecisionDivisionDocumentTypeName")
    DecisionDivisionDocumentTypeId = xml_find_all(vote_nodes[[i]], "DecisionDivisionDocumentTypeId")

    # Cleaning nodes + Dumping into Data frame
    vote_df$ParliamentNumber[i] = gsub("<.*?>", "", ParliamentNumber)
    vote_df$SessionNumber[i] = gsub("<.*?>", "", SessionNumber)
    DecisionEventDateTime = gsub("<.*?>", "", DecisionEventDateTime)
    vote_df$DecisionEventDateTime[i] = substr(DecisionEventDateTime, 1, 10)
    vote_df$DecisionDivisionNumber[i] = gsub("<.*?>", "", DecisionDivisionNumber)
    vote_df$DecisionDivisionSubject[i] = gsub("<.*?>", "", DecisionDivisionSubject)
    vote_df$DecisionResultName[i] = gsub("<.*?>", "", DecisionResultName)
    vote_df$DecisionDivisionNumberOfYeas[i] = gsub("<.*?>", "", DecisionDivisionNumberOfYeas)
    vote_df$DecisionDivisionNumberOfNays[i] = gsub("<.*?>", "", DecisionDivisionNumberOfNays)
    vote_df$DecisionDivisionNumberOfPaired[i] = gsub("<.*?>", "", DecisionDivisionNumberOfPaired)
    vote_df$DecisionDivisionDocumentTypeName[i] = gsub("<.*?>", "", DecisionDivisionDocumentTypeName)
    vote_df$DecisionDivisionDocumentTypeId[i] = gsub("<.*?>", "", DecisionDivisionDocumentTypeId)
  }
  return(vote_df)
}
