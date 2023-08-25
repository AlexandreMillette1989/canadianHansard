#' @import stringi
#'
#' @import stringr
#'
#' @import xml2
#'
#' @export

vote_info_cleaning = function(xml_database){

  # Splitting each vote
  vote_info_nodes = xml_find_all(xml_database, "//ArrayOfVoteParticipant/VoteParticipant")

  vote_info_df = data.frame(matrix("NA", nrow = length(vote_info_nodes), ncol = 16))
  colnames(vote_info_df) = c("ParliamentNumber",
                             "SessionNumber",
                             "DecisionEventDateTime",
                             "DecisionDivisionNumber",
                             "PersonShortSalutation",
                             "ConstituencyName",
                             "VoteValueName",
                             "PersonOfficialFirstName",
                             "PersonOfficialLastName",
                             "ConstituencyProvinceTerritoryName",
                             "CaucusShortName",
                             "IsVoteYea",
                             "IsVoteNay",
                             "IsVotePaired",
                             "DecisionResultName",
                             "PersonId")

  for(i in 1:length(vote_info_nodes)){
    # Getting nodes for each vote
    ParliamentNumber = xml_find_all(vote_info_nodes[[i]], "ParliamentNumber")
    SessionNumber = xml_find_all(vote_info_nodes[[i]], "SessionNumber")
    DecisionEventDateTime = xml_find_all(vote_info_nodes[[i]], "DecisionEventDateTime")
    DecisionDivisionNumber = xml_find_all(vote_info_nodes[[i]], "DecisionDivisionNumber")
    PersonShortSalutation = xml_find_all(vote_info_nodes[[i]], "PersonShortSalutation")
    ConstituencyName = xml_find_all(vote_info_nodes[[i]], "ConstituencyName")
    VoteValueName = xml_find_all(vote_info_nodes[[i]], "VoteValueName")
    PersonOfficialFirstName = xml_find_all(vote_info_nodes[[i]], "PersonOfficialFirstName")
    PersonOfficialLastName = xml_find_all(vote_info_nodes[[i]], "PersonOfficialLastName")
    ConstituencyProvinceTerritoryName = xml_find_all(vote_info_nodes[[i]], "ConstituencyProvinceTerritoryName")
    CaucusShortName = xml_find_all(vote_info_nodes[[i]], "CaucusShortName")
    IsVoteYea = xml_find_all(vote_info_nodes[[i]], "IsVoteYea")
    IsVoteNay = xml_find_all(vote_info_nodes[[i]], "IsVoteNay")
    IsVotePaired = xml_find_all(vote_info_nodes[[i]], "IsVotePaired")
    DecisionResultName = xml_find_all(vote_info_nodes[[i]], "DecisionResultName")
    PersonId = xml_find_all(vote_info_nodes[[i]], "PersonId")

    # Cleaning nodes + Dumping into Data frame
    vote_info_df$ParliamentNumber[i] = gsub("<.*?>", "", ParliamentNumber)
    vote_info_df$SessionNumber[i] = gsub("<.*?>", "", SessionNumber)
    DecisionEventDateTime = gsub("<.*?>", "", DecisionEventDateTime)
    vote_info_df$DecisionEventDateTime[i] = substr(DecisionEventDateTime, 1, 10)
    vote_info_df$DecisionDivisionNumber[i] = gsub("<.*?>", "", DecisionDivisionNumber)
    vote_info_df$PersonShortSalutation[i] = gsub("<.*?>", "", PersonShortSalutation)
    vote_info_df$ConstituencyName[i] = gsub("<.*?>", "", ConstituencyName)
    vote_info_df$VoteValueName[i] = gsub("<.*?>", "", VoteValueName)
    vote_info_df$PersonOfficialFirstName[i] = gsub("<.*?>", "", PersonOfficialFirstName)
    vote_info_df$PersonOfficialLastName[i] = gsub("<.*?>", "", PersonOfficialLastName)
    vote_info_df$ConstituencyProvinceTerritoryName[i] = gsub("<.*?>", "", ConstituencyProvinceTerritoryName)
    vote_info_df$CaucusShortName[i] = gsub("<.*?>", "", CaucusShortName)
    vote_info_df$IsVoteYea[i] = gsub("<.*?>", "", IsVoteYea)
    vote_info_df$IsVoteNay[i] = gsub("<.*?>", "", IsVoteNay)
    vote_info_df$IsVotePaired[i] = gsub("<.*?>", "", IsVotePaired)
    vote_info_df$DecisionResultName[i] = gsub("<.*?>", "", DecisionResultName)
    vote_info_df$PersonId[i] = gsub("<.*?>", "", PersonId)
  }
  return(vote_info_df)
}
