# The dataset for the demonstration can be found [here](https://figshare.com/articles/dataset/demonstration_dataset_rds/25431736)
# The code to replicate the demonstration can be found [here](https://github.com/AlexandreMillette1989/canadianHansard/blob/main/demonstration_code.R)

# canadianHansard (English Instructions - Demo)

## Installing the Package and Creating the Folders and Subfolders Structure
To install our package, users must first install the devtools package using the following code:

```
install.packages("remotes")
  
library(remotes)
```
 
The devtools package allows us to access the install_github function which grants us the ability to import our package straight from the GitHub repository using the subsequent lines:
 
```
install_github("AlexandreMillette1989/canadianHansard",
               force = TRUE,
               dependencies = TRUE,
               upgrade = TRUE)
  
library(canadianHansard)
```

Before proceeding with the demonstrations, we will create folders and subfolder structures that will receive our gathered datasets in the working directory as illustrated below in Figure 1. 

![image](https://github.com/AlexandreMillette1989/canadianHansard/assets/68613987/f97e238c-a355-4a99-a270-5067afd5f741)
Figure 1 – Folders and subfolders structure

## Gathering Hansard
From there, we can begin our showcase with the Hansard dataset. We gathered all the Hansard between January 1, 2023, and June 30, 2023, in the English language and stored them in the relevant subfolder with the code below.

```
get_hansard(Working_Directory = "~/demo_hansard/xml/",
            	      StartDate = "2023-01-01",
           	      EndDate = "2023-06-30",
            	      Language = "en")
```

As a result, we ended up with 70 XML files inside that dedicated subfolder. Afterward, we need to convert those XML files into data frames in the RDS format. While we could transform those files individually, we created a lopping function to convert all the files within a directory. Therefore, we need to identify the path to the XML files and then the path to where we want our converted files to be stored as shown below.

```
hansard_XML2RDS_ListFiles(WD_PathXML = "~/demo_hansard/xml/",
                          		   WD_PathRDS = "~/demo_hansard/rds/")
```

Then, we can merge the information of each file to create a compiled file withholding all our data. Once compiled, this new file is created in the RDS subfolder.

```
compile_RDS_ListFiles(WD_PathRDS = "~/demo_hansard/rds/",
                     		    filename = "compiled_data")
```

As a last step, we can validate that every manipulation worked as intended by loading the compiled file. It should encompass 25,086 interventions and 27 variables in a data frame ready to be used. 

```
df = readRDS("~/demo_hansard/rds/compiled_data.rds")
head(df, 5)
```

## Gathering Committee

Previously, we mentioned there are 63 unique committees identified in the dataset of the House of Commons of Canada. Since we needed a committee abbreviation to process our query, we had to implement a way for users to identify the various committees. As some data are pre-loaded with our package, we can call the committee data frame that contains the information we’re looking for using the code below. 

```
unique(committees_sittings_list[c("organization", "Committee_Abbrv")])
```

In our example, we chose to download the data for the Standing Committee on Industry, Science, and Technology (INDU) between January 1, 2023, and June 30, 2023, in the English language and to store the gathered XML files in the subfolder we created previously. 

```
get_committee(Working_Directory = "~/demo_committee/xml/",
              	  StartDate = "2023-01-01",
              	  EndDate = "2023-06-30",
              	  Language = "en",
             	  CommitteeAbbrev = "INDU")
```

Following our query, we were left with 26 XML files inside our subfolder. As the XML structure of the committee dataset is slightly different from that of the Hansard dataset, we had to create another function to convert the files while maintaining the same logic. 

```
committee_XML2RDS_ListFiles(WD_PathXML = "~/demo_committee/xml/",
                            		       WD_PathRDS = "~/demo_committee/rds/")
```

Subsequently, we can combine data from those 26 XML files to generate a consolidated file containing our complete demonstration dataset. Upon compiling, that new file will be available in the RDS subfolder. 

```
compile_RDS_ListFiles(WD_PathRDS = "~/demo_committee/rds/",
                     	                filename = "compiled_data")
```

To validate our manipulation, we can load the compiled file. It should be comprised of 4,188 interventions and 25 variables.

```
df = readRDS("~/demo_committee/rds/compiled_data.rds")
head(df, 5)
```

## Gathering Votes

In our demonstration, we could download the votes from the 44th Parliament 1st session in the English language and direct them toward the subfolder we created earlier as exemplified below. 

```
get_vote(Working_Directory = "~/demo_vote/xml/",
        	Language = "en",
         	ParliamentNumber = "44",
         	SessionNumber = "1")
```
However, we chose to continue our demonstration with a more complete example. Indeed, gathering every vote available on the House of Commons of Canada website would require users to know information about Parliament and sessions, but it would also force them to execute multiple inputs. To solve this, we created a data frame that is loaded with the package which encompasses all the necessary information to query all the votes available, from the 38th Parliament 1st session to the 44th Parliament 1st session. 

```
for(i in 1:dim(votes_parliament_session_list)[1]){
  get_vote(Working_Directory = "~/demo_vote/xml/",
           	      Language = "en",
           	      ParliamentNumber = votes_parliament_session_list$parliament[i],
          	      SessionNumber = votes_parliament_session_list$session[i])
}
```

Next, we can convert those XML files into RDS files using the following method.

```
vote_XML2RDS(XML_WD = "~/demo_vote/xml/",
             	              RDS_WD = "~/demo_vote/rds/")
```

Thereafter, we can integrate the data from each file and compile them into a single file retaining our entire dataset. The resulting file will be situated within the designated RDS folder.

```
compile_RDS_ListFiles(WD_PathRDS = "~/demo_vote/rds/",
                      	          filename = "compiled_data")
```

To confirm we followed the protocol properly, we can load the compiled file. There should be 4,158 votes and 11 variables in the complete dataset. 

```
df = readRDS("~/demo_vote/rds/compiled_data.rds")
head(df, 5)
```

## Gathering Vote Detailed Information

Building upon the logic of the vote function, we could gather detailed information for a specific vote, like the 44th Parliament 1st session vote no 407 as depicted below.

```
get_vote_info(Working_Directory = "~/demo_vote_info/xml/",
Language = "en",
ParliamentNumber = "44",
SessionNumber = "1", 
DecisionDivisionNumber = "407")
```

This is great if users need to target specific votes. However, if they want to gather detailed information for all the votes available across the House of Commons of Canada website, this process is relatively tedious. To alleviate this problem, we once again rely on a pre-loaded data frame through two loops. It is worth noting that is it also possible to subset a portion of that pre-loaded data frame. 

```
for(i in 1:dim(votes_parliament_session_list)[1]){
  for(k in 1:votes_parliament_session_list$nb_votes[i]){
    get_vote_info(Working_Directory = "~/demo_vote_info/xml/",
                             Language = "en",
                             ParliamentNumber = votes_parliament_session_list$parliament[i],
                             SessionNumber = votes_parliament_session_list$session[i],
                             DecisionDivisionNumber = k)
  }
}
```

Following this, we are left with 4,158 XML files, corresponding to the vote detailed information of the 4,158 votes that occurred between the 38th Parliament 1st session and the 44th Parliament 1st session. Those files are then converted into RDS files as indicated below.

```
vote_info_XML2RDS(XML_WD = "~/demo_vote_info/xml/",
                  	       RDS_WD = "~/demo_vote_info/rds/")
```

Ensuing the conversion, we can compile all those files into a singular document that will be in the predefined subfolder. 

```
compile_RDS_ListFiles(WD_PathRDS = "~/demo_vote_info/rds/",
                      		    filename = "compiled_data")
```

Finally, we can load our newly created file to validate our data.

```
df = readRDS("~/demo_vote/rds/compiled_data.rds")
head(df, 5)
```

The complete vote detailed information dataset contains 1,119,784 observations and 16 variables covering the 4,158 votes that occurred between the 38th Parliament 1st session and the 44th Parliament 1st session. 

# canadianHansard (Instructions françaises - Démo)
**Bientôt disponible**
