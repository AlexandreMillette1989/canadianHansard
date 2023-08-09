#' @title committee_XML2RDS_ListFiles
#'
#' @description This function transforms all XML files from a predefine working directory to RDS files in a selected working directory
#'
#' @usage committee_XML2RDS_ListFiles(WD_PathXML = "",
#'                                    WD_PathRDS = "")
#'
#' @param WD_PathXML: working directory where the XML file is located
#'
#' @param WD_PathRDS: working directory where the RDS file will be saved
#'
#' @import stringi
#'
#' @import stringr
#'
#' @import xml2
#'
#' @export

committee_XML2RDS_ListFiles = function(WD_PathXML, WD_PathRDS){
  committee_list = list.files(WD_PathXML)
  for(i in 1:length(committee_list)){
    print(paste0(i, " / ", length(committee_list), " (", round(i/length(committee_list)*100,2), " %) filename: ", committee_list[i]))
    filenameXML = committee_list[i]
    filenameRDS = committee_list[i]
    committee_XML2RDS(filenameXML, filenameRDS, WD_PathXML, WD_PathRDS)
  }
  print("XML to RDS Files Conversion Completed!")
}
