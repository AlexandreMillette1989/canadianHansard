#' @title get_hansard
#'
#' @description This function fetches Hansard data from the House of Commons of Canada website
#'
#' @usage get_hansard(Working_Directory = "",
#'                    StartDate = "",
#'                    EndDate = "",
#'                    Language = "")
#'
#' @param Working_Directory: working directory where the XML files are going to be downloaded
#'
#' @param StartDate: date to start gathering data (YYYY-MM-DD)
#'
#' @param EndDate: date to stop gathering data (YYYY-MM-DD)
#'
#' @param Language: English or French ("en", "fr")
#'
#' @import stringi
#'
#' @import stringr
#'
#' @import xml2
#'
#' @export

get_hansard = function(Working_Directory, StartDate, EndDate, Language){

  data("hansard_sittings_list")

  temp_hansard = subset(hansard_sittings_list, hansard_sittings_list >= StartDate & hansard_sittings_list <= EndDate)

  for(i in 1:length(temp_hansard)){
    if(temp_hansard[i] == "2001-01-30" ||
       temp_hansard[i] == "2002-10-01" ||
       temp_hansard[i] == "2004-02-03" ||
       temp_hansard[i] == "2004-10-05" ||
       temp_hansard[i] == "2006-04-04" ||
       temp_hansard[i] == "2007-10-17" ||
       temp_hansard[i] == "2008-11-19" ||
       temp_hansard[i] == "2009-01-27" ||
       temp_hansard[i] == "2010-03-04" ||
       temp_hansard[i] == "2011-06-03" ||
       temp_hansard[i] == "2013-10-17" ||
       temp_hansard[i] == "2015-12-04" ||
       temp_hansard[i] == "2019-12-06" ||
       temp_hansard[i] == "2020-09-24" ||
       temp_hansard[i] == "2021-11-23"){
      temp_hansard_day1 = as.Date(temp_hansard)[i]-1
      print(paste0("Downloading File ", i, " of ", length(temp_hansard), " ( ", round(i/length(temp_hansard)*100,2), " % )"))
      url = paste0("https://www.ourcommons.ca/PublicationSearch/", tolower(Language), "/?View=D&Item=&ParlSes=from", temp_hansard_day1, "to", temp_hansard[i], "&oob=&Topic=&Proc=&Per=&Prov=&Cauc=&Text=&RPP=15&order=&targetLang=&SBS=0&MRR=150000&PubType=37&xml=1")
      download.file(url, paste0(Working_Directory, "can_hansard_", Language, "_", temp_hansard_day1, "_", temp_hansard[i]), quiet = TRUE)
    }else{
      print(paste0("Downloading File ", i, " of ", length(temp_hansard), " ( ", round(i/length(temp_hansard)*100,2), " % )"))
      url = paste0("https://www.ourcommons.ca/PublicationSearch/", tolower(Language), "/?View=D&Item=&ParlSes=from", temp_hansard[i], "to", temp_hansard[i], "&oob=&Topic=&Proc=&Per=&Prov=&Cauc=&Text=&RPP=15&order=&targetLang=&SBS=0&MRR=150000&PubType=37&xml=1")
      download.file(url, paste0(Working_Directory, "can_hansard_", Language, "_", temp_hansard[i]), quiet = TRUE)
    }
  }
  print("Downloads Completed!")
}
