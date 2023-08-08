#' @title get_committee
#'
#' @description This function fetches committees data from the House of Commons of Canada website
#'
#' @usage get_committee(Working_Directory = "",
#'                      StartDate = "",
#'                      EndDate = "",
#'                      Language = "",
#'                      CommitteeAbbrev = "")
#'
#' @param Working_Directory: working directory where the XML files are going to be downloaded
#'
#' @param StartDate: date to start gathering data (YYYY-MM-DD)
#'
#' @param EndDate: date to stop gathering data (YYYY-MM-DD)
#'
#' @param Language: English or French ("en", "fr")
#'
#' @param CommitteeAbbrev: Committee abbreviation (4 letters)
#'
#' @import stringi
#'
#' @import stringr
#'
#' @import xml2
#'
#' @export

get_committee = function(Working_Directory, StartDate, EndDate, Language, CommitteeAbbrev){

  data("committees_sittings_list")

  temp_committee = subset(committees_sittings_list, committees_sittings_list$Committee_Abbrv == CommitteeAbbrev)

  temp_committee = subset(temp_committee, temp_committee >= StartDate & temp_committee <= EndDate)

  for(i in 1:dim(temp_committee)[1]){
    print(paste0("Downloading File ", i, " of ", dim(temp_committee)[1], " ( ", round(i/dim(temp_committee)[1]*100,2), " % )"))
    url = paste0("https://www.ourcommons.ca/PublicationSearch/", tolower(Language),"/?View=L&Item=&ParlSes=from", temp_committee$date[i], "to", temp_committee$date[i], "&Topic=&Proc=&com=", toupper(temp_committee$Committee_Abbrv[i]), "&Per=&Prov=&Cauc=&PartType=&Text=&RPP=15&order=&targetLang=&SBS=0&MRR=150000&PubType=40017&xml=1")
    download.file(url, paste0(Working_Directory, "can_committee_", Language, "_", temp_committee$date[i], "_", temp_committee$Committee_Abbrv[i]), quiet = TRUE)
  }
  print("Downloads Completed!")
}
