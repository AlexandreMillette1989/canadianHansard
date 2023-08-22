#' @title compile_RDS_ListFiles
#'
#' @description This function compiles all RDS file in a selected working directory to a singular RDS file.
#'
#' @usage compile_RDS_ListFiles(WD_PathRDS = "",
#'                       filename = "")
#'
#' @param WD_PathRDS: working directory where the RDS files are located
#'
#' @param filename: output filename (singular file)
#'
#' @import stringi
#'
#' @import stringr
#'
#' @import xml2
#'
#' @export

compile_RDS_ListFiles = function(WD_PathRDS, filename){
  rds_list = list.files(WD_PathRDS)
  setwd(WD_PathRDS)
  base = readRDS(rds_list[1])
  print(paste0(1, " / ", length(rds_list), " (", round(1/length(rds_list)*100,2), " %) filename: ", rds_list[1]))
  for(i in 2:length(rds_list)){
    print(paste0(i, " / ", length(rds_list), " (", round(i/length(rds_list)*100,2), " %) filename: ", rds_list[i]))
    temp = readRDS(rds_list[i])
    base = rbind(base, temp)
  }
  print("Compiling Completed!")
  saveRDS(base, paste0(filename, ".rds"))
}
