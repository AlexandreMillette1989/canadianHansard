#' @title hansard_XML2RDS_ListFiles
#'
#' @description This function transforms all XML files from a predefine working directory to RDS files in a selected working directory
#'
#' @usage hansard_XML2RDS_ListFiles(WD_PathXML = "",
#'                                  WD_PathRDS = "")
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

hansard_XML2RDS_ListFiles = function(WD_PathXML, WD_PathRDS){
hansard_list = list.files(WD_PathXML)
for(i in 1:length(hansard_list)){
  print(paste0(i, " / ", length(hansard_list), " (", round(i/length(hansard_list)*100,2), " %) filename: ", hansard_list[i]))
  filenameXLM = hansard_list[i]
  filenameRDS = paste0(hansard_list[i])
  hansard_XML2RDS(filenameXLM, filenameRDS, WD_PathXML, WD_PathRDS)
}
print("XML to RDS Files Conversion Completed!")
}
