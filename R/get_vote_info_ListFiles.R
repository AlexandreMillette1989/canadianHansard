#' @title get_vote_info_ListFiles
#'
#' @description Loops over the vote directory to download all vote details in a single command
#'
#' @usage get_vote_info_ListFiles(Working_Directory_Vote = "",
#'                                Working_Directory_voteInfo = "",
#'                                Language = "")
#'
#' @param Working_Directory_Vote: working directory where the XML files are located
#'
#' @param Working_Directory_voteInfo: working directory where the XML files for vote details are going to be downloaded
#'
#' @param Language: French or English ("fr" or "en")
#'
#' @import stringi
#'
#' @import stringr
#'
#' @import xml2
#'
#' @export

get_vote_info_ListFiles = function(Working_Directory_Vote, Working_Directory_voteInfo, Language){
  base_vote_list = list.files(Working_Directory_Vote)
  for(k in 1:length(base_vote_list)){
    setwd(Working_Directory_Vote)
    base_vote = vote_cleaning(xml_database = read_xml(base_vote_list[k]))
    for(i in 1:dim(base_vote)[1]){
      get_vote_info(Working_Directory = Working_Directory_voteInfo,
                    Language = Language,
                    ParliamentNumber = base_vote$ParliamentNumber[i],
                    SessionNumber = base_vote$SessionNumber[i],
                    DecisionDivisionNumber = base_vote$DecisionDivisionNumber[i])
    }
  }
}
