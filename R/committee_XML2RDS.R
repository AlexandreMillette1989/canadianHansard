#' @title committee_XML2RDS
#'
#' @description This function transforms an XML file from a predefine working directory to an RDS file in a selected working directory
#'
#' @usage Committee_XML2RDS(filenameXLM = "",
#'                          filenameRDS = "",
#'                          WD_PathXML = "",
#'                          WD_PathRDS = "")
#'
#' @param filenameXLM: filename of the XML file
#'
#' @param filenameRDS: filename of the RDS file
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

Committee_XML2RDS = function(filenameXLM, filenameRDS, WD_PathXML, WD_PathRDS){

  ### Import XML data
  setwd(WD_PathXML)
  base = read_xml(filenameXLM)
  Comm_Abbrev = str_sub(filenameXLM, -4, -1)
  if(Comm_Abbrev == "_CC2"){
    Comm_Abbrev = "CC2"
  }

  ### Check if the XML file is empty.
  if(xml_attr(base, "RecordsFound") == 0){

  }else{
    publication_nodes = xml_find_all(base, ".//Publications/Publication")
    nb_publication_nodes = length(publication_nodes)

    # Find number of rows to fill the array
    table_rows = 0
    for(nb_publication_nodes in 1:nb_publication_nodes){
      intervention = xml_find_all(publication_nodes[nb_publication_nodes], "PublicationItems/PublicationItem")
      length_intervention = length(intervention)
      for(length_intervention in 1:length_intervention){
        table_rows = table_rows + 1
      }
    }

    # Create table
    table_committee = array(0, dim = c(table_rows, 25))
    table_rows = 0

    for(nb_publication_nodes in 1:nb_publication_nodes){

      intervention = xml_find_all(publication_nodes[nb_publication_nodes], "PublicationItems/PublicationItem")
      title = xml_attr(publication_nodes[nb_publication_nodes], "Title")
      typeID = xml_attr(publication_nodes[nb_publication_nodes], "TypeId")
      date = xml_attr(publication_nodes[nb_publication_nodes], "Date")
      time = xml_attr(publication_nodes[nb_publication_nodes], "Time")
      parliament_legislature = xml_attr(publication_nodes[nb_publication_nodes], "Parliament")
      session = xml_attr(publication_nodes[nb_publication_nodes], "Session")
      organization = xml_attr(publication_nodes[nb_publication_nodes], "Organization")
      pdf_URL = xml_attr(publication_nodes[nb_publication_nodes], "PdfURL")
      pdf_URL = paste0("https://ourcommons.ca", pdf_URL)
      html_URL = xml_attr(publication_nodes[nb_publication_nodes], "HtmlURL")
      html_URL = paste0("https://ourcommons.ca", html_URL)
      isAudioOnly = xml_attr(publication_nodes[nb_publication_nodes], "IsAudioOnly")
      isTelevised = xml_attr(publication_nodes[nb_publication_nodes], "IsTelevised")
      meetingIsForSenateOrganization = xml_attr(publication_nodes[nb_publication_nodes], "MeetingIsForSenateOrganization")

      length_intervention = length(intervention)

      for(i in 1:length_intervention){

        videoURL = xml_attr(intervention[i], "VideoURL")

        ### Check if IsMember
        dummy = xml_find_all(intervention[i], "Person")

        if(xml_attr(dummy, "IsMember") == "0"){
          ### Witness Loop

          ### Get member info from nodes
          first_name = xml_find_all(intervention[i], "Person/FirstName")
          first_name = gsub("<.*?>", "", first_name)
          if(length(first_name) == 0){
            first_name = "NA"
          }

          last_name = xml_find_all(intervention[i], "Person/LastName")
          last_name = gsub("<.*?>", "", last_name)
          if(length(last_name) == 0){
            last_name = "NA"
          }

          content_intervention = xml_find_all(intervention[i], "XmlContent")

          content_list = gsub("<.*?>", "", content_intervention)

          content_remove_return = gsub("\\n", "", content_list)

          content_remove = gsub(" \\[English] ", "", content_remove_return)

          content_clean = gsub(" \\[Translation] ", "", content_remove)

          affiliation = xml_find_all(intervention[i], "XmlContent/Intervention/PersonSpeaking/Affiliation")

          affiliation = gsub("<.*?>", "", affiliation)

          type = affiliation[1]
          if(length(type) == 0){
            type = "NA"
          }

          keyword_subjects = xml_find_all(intervention[i], "IndexEntries/Term") # change ca

          keyword_list = NULL
          procedural_list = NULL
          keyword_subjects = xml_find_all(intervention[i], "IndexEntries/Term")
          if(length(keyword_subjects) == 0){
            keyword_list = NULL
            procedural_list = NULL
          }else{
            checkProcedural = xml_attr(keyword_subjects, "IsProceduralTerm") # check procedural
            for(i in 1:length(checkProcedural)){
              if(checkProcedural[i] == 0){
                temp = gsub("<.*?>", "", keyword_subjects[i])
                keyword_list = rbind(keyword_list, temp)
              }else{
                temp = gsub("<.*?>", "", keyword_subjects[i])
                procedural_list = rbind(procedural_list, temp)
              }
            }
          }

          for(i in 1:length(keyword_list)){
            if(i == 0){
              keyword_tags = "NA"
            }
            else if(i == 1){
              keyword_tags = paste0(keyword_list[i])
            }else{
              keyword_tags = paste0(keyword_tags, " # ", keyword_list[i])
            }
          }

          for(i in 1:length(procedural_list)){
            if(i == 0){
              procedural_tags = "NA"
            }
            else if(i == 1){
              procedural_tags = paste0(procedural_list[i])
            }else{
              procedural_tags = paste0(procedural_tags, " # ", procedural_list[i])
            }
          }

          table_rows = table_rows + 1

          # Filling the array
          table_committee[table_rows, 1] = table_rows
          table_committee[table_rows, 2] = date
          table_committee[table_rows, 3] = parliament_legislature
          table_committee[table_rows, 4] = session
          table_committee[table_rows, 5] = paste(first_name, last_name, sep = " ")
          table_committee[table_rows, 6] = type
          table_committee[table_rows, 7] = "NA" #province
          table_committee[table_rows, 8] = "Witness / Appearance" #caucus
          table_committee[table_rows, 9] = "NA" #riding
          table_committee[table_rows, 10] = paste(content_clean)
          table_committee[table_rows, 11] = title
          table_committee[table_rows, 12] = typeID
          table_committee[table_rows, 13] = time
          table_committee[table_rows, 14] = organization
          table_committee[table_rows, 15] = pdf_URL
          table_committee[table_rows, 16] = html_URL
          table_committee[table_rows, 17] = isAudioOnly
          table_committee[table_rows, 18] = isTelevised
          table_committee[table_rows, 19] = meetingIsForSenateOrganization
          table_committee[table_rows, 20] = videoURL
          table_committee[table_rows, 21] = "NA" #profileURL
          table_committee[table_rows, 22] = "NA" #image
          table_committee[table_rows, 23] = keyword_tags
          table_committee[table_rows, 24] = procedural_tags
          table_committee[table_rows, 25] = Comm_Abbrev
        }else{
          ### Member = 1 Loop
          profileURL = xml_find_all(intervention[i], "Person/ProfileUrl")
          profileURL = gsub("<.*?>", "", profileURL)

          image = xml_find_all(intervention[i], "Person/Image")
          image = gsub("<.*?>", "", image)

          ### Get member info from nodes
          first_name = xml_find_all(intervention[i], "Person/FirstName")
          first_name = gsub("<.*?>", "", first_name)
          if(length(first_name) == 0){
            first_name = "NA"
          }
          last_name = xml_find_all(intervention[i], "Person/LastName")
          last_name = gsub("<.*?>", "", last_name)
          if(length(last_name) == 0){
            last_name = "NA"
          }

          province = xml_find_all(intervention[i], "Person/Province")

          caucus = xml_find_all(intervention[i], "Person/Caucus")

          caucus = xml_contents(caucus)

          if(length(caucus) == 0 || caucus == ""){
            caucus = ""
          }

          riding = xml_find_all(intervention[i], "Person/Constituency")

          content_intervention = xml_find_all(intervention[i], "XmlContent")

          content_list = gsub("<.*?>", "", content_intervention)

          content_remove = gsub(".*]\n", "", content_list)

          content_clean = gsub("\\n", "", content_remove)

          affiliation = xml_find_all(intervention[i], "XmlContent/Intervention/PersonSpeaking/Affiliation")

          affiliation = gsub("<.*?>", "", affiliation)

          type = affiliation[1]
          if(length(type) == 0){
            type = "NA"
          }

          keyword_subjects = xml_find_all(intervention[i], "IndexEntries/Term")

          keyword_list = NULL
          procedural_list = NULL
          keyword_subjects = xml_find_all(intervention[i], "IndexEntries/Term")
          if(length(keyword_subjects) == 0){
            keyword_list = NULL
            procedural_list = NULL
          }else{
            checkProcedural = xml_attr(keyword_subjects, "IsProceduralTerm") # check procedural
            for(i in 1:length(checkProcedural)){
              if(checkProcedural[i] == 0){
                temp = gsub("<.*?>", "", keyword_subjects[i])
                keyword_list = rbind(keyword_list, temp)
              }else{
                temp = gsub("<.*?>", "", keyword_subjects[i])
                procedural_list = rbind(procedural_list, temp)
              }
            }
          }

          for(i in 1:length(keyword_list)){
            if(i == 0){
              keyword_tags = "NA"
            }
            else if(i == 1){
              keyword_tags = paste0(keyword_list[i])
            }else{
              keyword_tags = paste0(keyword_tags, " # ", keyword_list[i])
            }
          }

          for(i in 1:length(procedural_list)){
            if(i == 0){
              procedural_tags = "NA"
            }
            else if(i == 1){
              procedural_tags = paste0(procedural_list[i])
            }else{
              procedural_tags = paste0(procedural_tags, " # ", procedural_list[i])
            }
          }

          table_rows = table_rows + 1

          # Filling the array
          table_committee[table_rows, 1] = table_rows
          table_committee[table_rows, 2] = date
          table_committee[table_rows, 3] = parliament_legislature
          table_committee[table_rows, 4] = session
          table_committee[table_rows, 5] = paste(first_name, last_name, sep = " ")
          #table_committee[table_rows, 5] = paste(xml_contents(first_name), xml_contents(last_name), sep = " ")
          if(!identical(type, character(0))){
            table_committee[table_rows, 6] = paste(type)
          }
          table_committee[table_rows, 7] = paste(xml_contents(province))
          table_committee[table_rows, 8] = paste(caucus)
          table_committee[table_rows, 9] = paste(xml_contents(riding))
          table_committee[table_rows, 10] = paste(content_clean)
          table_committee[table_rows, 11] = title
          table_committee[table_rows, 12] = typeID
          table_committee[table_rows, 13] = time
          table_committee[table_rows, 14] = organization
          table_committee[table_rows, 15] = pdf_URL
          table_committee[table_rows, 16] = html_URL
          table_committee[table_rows, 17] = isAudioOnly
          table_committee[table_rows, 18] = isTelevised
          table_committee[table_rows, 19] = meetingIsForSenateOrganization
          table_committee[table_rows, 20] = videoURL
          table_committee[table_rows, 21] = profileURL
          table_committee[table_rows, 22] = image
          table_committee[table_rows, 23] = keyword_tags
          table_committee[table_rows, 24] = procedural_tags
          table_committee[table_rows, 25] = Comm_Abbrev
        }
      }
    }

    # Transform Array into Dataframe CHANGER
    table_committee_df = data.frame(table_committee)
    colnames(table_committee_df) = c("no", "date", "legislature", "session", "name", "type", "province", "caucus",
                                     "constituency", "intervention", "title", "typeID", "time", "organization",
                                     "pdf_URL", "html_URL", "isAudioOnly", "isTelevised", "meetingIsForSenateOrganization",
                                     "videoURL", "profileURL", "image", "keyword_tags", "procedural_tags", "Committee_Abbrv")
    setwd(WD_PathRDS)
    saveRDS(table_committee_df, file = paste0(filenameRDS, ".rds"))
  }
}
