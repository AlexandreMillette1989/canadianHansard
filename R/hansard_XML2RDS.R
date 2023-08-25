#' @import stringi
#'
#' @import stringr
#'
#' @import xml2
#'
#' @export

hansard_XML2RDS = function(filenameXLM, filenameRDS, WD_PathXML, WD_PathRDS){

  ### Import XML data
  setwd(WD_PathXML)
  base = read_xml(filenameXLM)

  ### Check if the XML file is empty. If empty, set Bool flag to false
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
    table_hansard = array(0, dim = c(xml_attr(base, "RecordsFound"), 26)) # revoir ça en fonction des nouveaux trucs ajouté
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
      isAudioOnly = xml_attr(publication_nodes[nb_publication_nodes], "IsAudioOnly")
      isTelevised = xml_attr(publication_nodes[nb_publication_nodes], "IsTelevised")
      meetingIsForSenateOrganization = xml_attr(publication_nodes[nb_publication_nodes], "MeetingIsForSenateOrganization")

      length_intervention = length(intervention)

      for(a in 1:length_intervention){

        videoURL = xml_attr(intervention[a], "VideoURL")

        ### Check if IsMember
        dummy = xml_find_all(intervention[a], "Person")

        if(xml_attr(dummy, "IsMember") == "0"){
          next
        }

        profileURL = xml_find_all(intervention[a], "Person/ProfileUrl")
        profileURL = gsub("<.*?>", "", profileURL)

        image = xml_find_all(intervention[a], "Person/Image")
        image = gsub("<.*?>", "", image)

        ### Get member info from nodes
        first_name = xml_find_all(intervention[a], "Person/FirstName")

        last_name = xml_find_all(intervention[a], "Person/LastName")

        province = xml_find_all(intervention[a], "Person/Province")

        caucus = xml_find_all(intervention[a], "Person/Caucus")

        caucus = xml_contents(caucus)

        if(length(caucus) == 0 || caucus == ""){
          caucus = "NA"
        }

        riding = xml_find_all(intervention[a], "Person/Constituency")

        order = xml_find_all(intervention[a], "OrderOfBusiness")

        order = gsub("<.*?>", "", order)

        subject_business = xml_find_all(intervention[a], "SubjectOfBusiness")

        subject_business = gsub("<.*?>", "", subject_business)

        content_intervention = xml_find_all(intervention[a], "XmlContent")

        content_list = gsub("<.*?>", "", content_intervention)

        content_remove = gsub(".*]\n", "", content_list)

        content_clean = gsub("\\n", "", content_remove)

        affiliation = xml_find_all(intervention[a], "XmlContent/Intervention/PersonSpeaking/Affiliation")

        type = xml_attr(affiliation[1], "Type")

        if(is.na(type) || length(type) == 0){
          type = gsub("<.*?>", "", affiliation[1])
          if(length(type) == 0 || type == ""){
            type = as.character("NA")
          }
        }
        keyword_list = NULL
        procedural_list = NULL
        keyword_subjects = xml_find_all(intervention[a], "IndexEntries/Term")
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
        table_hansard[table_rows, 1] = table_rows
        table_hansard[table_rows, 2] = date
        table_hansard[table_rows, 3] = parliament_legislature
        table_hansard[table_rows, 4] = session
        table_hansard[table_rows, 5] = paste(xml_contents(first_name), xml_contents(last_name), sep = " ")
        if(!identical(type, character(0))){
          table_hansard[table_rows, 6] = paste(type)
        }
        table_hansard[table_rows, 7] = paste(xml_contents(province))
        table_hansard[table_rows, 8] = paste(caucus)
        table_hansard[table_rows, 9] = paste(xml_contents(riding))
        if(!identical(order, character(0))){
          table_hansard[table_rows, 10] = paste(order)
        }
        table_hansard[table_rows, 11] = paste(content_clean)
        table_hansard[table_rows, 12] = keyword_tags
        table_hansard[table_rows, 13] = procedural_tags
        if(!identical(order, character(0))){
          table_hansard[table_rows, 14] = paste(subject_business)
        }
        table_hansard[table_rows, 15] = title
        table_hansard[table_rows, 16] = typeID
        table_hansard[table_rows, 17] = time
        table_hansard[table_rows, 18] = organization
        table_hansard[table_rows, 19] = pdf_URL
        table_hansard[table_rows, 20] = html_URL
        table_hansard[table_rows, 21] = isAudioOnly
        table_hansard[table_rows, 22] = isTelevised
        table_hansard[table_rows, 23] = meetingIsForSenateOrganization
        table_hansard[table_rows, 24] = videoURL
        table_hansard[table_rows, 25] = profileURL
        table_hansard[table_rows, 26] = image
      }
    }

    # Transform Array into Dataframe
    hansard_df = data.frame(table_hansard)
    colnames(hansard_df) = c("no", "date", "legislature", "session", "nom", "type", "province", "caucus",
                             "circonscription", "ordre", "intervention", "keyword_tags", "procedural_tags","subject_business",
                             "title", "typeID", "time", "organization", "pdf_URL", "html_URL", "isAudioOnly",
                             "isTelevised", "meetingIsForSenateOrganization", "videoURL", "profileURL", "image")
    hansard_df$legi_session = paste(hansard_df$legislature, hansard_df$session, sep = "")
    setwd(WD_PathRDS)
    saveRDS(hansard_df, file = paste0(filenameRDS, ".rds"))
  }
}
