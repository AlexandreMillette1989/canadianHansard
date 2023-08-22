#' @title vote_XML2RDS
#'
#' @description Transform vote list from XML files to RDS files
#'
#' @usage vote_XML2RDS(XML_WD = "",
#'              RDS_WD = "")
#'
#' @param XML_WD: working directory where the XML files are located
#'
#' @param RDS_WD: working directory where the RDS files are going to be exported
#'
#' @import stringi
#'
#' @import stringr
#'
#' @import xml2
#'
#' @export

vote_XML2RDS = function(XML_WD, RDS_WD){
  vote_list_files = list.files(XML_WD)
  for(i in 1:length(vote_list_files)){
    print(paste0(i, " / ", length(vote_list_files), " (", round(i/length(vote_list_files)*100,2), " %) filename: ", vote_list_files[i]))
    setwd(XML_WD)
    vote_df = vote_cleaning(xml_database = read_xml(paste0(vote_list_files[i])))
    setwd(RDS_WD)
    saveRDS(vote_df, paste0(vote_list_files[i], ".rds"))
  }
  print("XML to RDS Files Conversion Completed!")
}
