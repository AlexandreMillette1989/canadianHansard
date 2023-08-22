# canadianHansard (English Instructions - Demo)

 This package offers functions to gather datasets from the House of Commons of Canada.
 
To install this package, you must first install the devtools package.

```
install.packages("devtools")
  
library(devtools)
```

Next, you will be able to import the package directly from GitHub.

```
install_github("AlexandreMillette1989/canadianHansard",
               force = TRUE,
               dependencies = TRUE,
               upgrade = TRUE)
  
library(canadianHansard)
```

## Gathering Hansard

First, it is recommended that you create a new folder or setup a working directory to collect the downloaded files. In our example, we created a demo_hansard folder to dump all the files. We then proceeded to create two folders inside the demo_hansard folder: (1) xml and (2) rds.

Since the data from the House of Commons are in the xml format, we will download them inside the xml folder as follows:

```
get_hansard(Working_Directory = "~/demo_hansard/xml/",
            StartDate = "2023-01-01",
            EndDate = "2023-06-30",
            Language = "en")
```

There should be 70 xml files inside that folder. Afterwards, we need to convert those xml files into rds files. To speed up the process, we created a looping function to convert all the files within a directory. We need to identify the path to the xml files and then the path to where we want our converted files to be dumped into. In this case, the rds folder we precreated.

```
hansard_XML2RDS_ListFiles(WD_PathXML = "~/demo_hansard/xml/",
                          WD_PathRDS = "~/demo_hansard/rds/")
```

Ultimately, we can merge the data of each file to create a compiled file withholding all our data. This time, we identified our rds files folder and gave a name to our future file. Once compiled, the file will be located in the rds folder.

```
compile_RDS_ListFiles(WD_PathRDS = "~/demo_hansard/rds/",
                      filename = "compiled_data")
```

Upon those manipulations, we can load the file to validate everything worked. There should be 25,086 interventions and 27 variables. 

```
df = readRDS("~/demo_hansard/rds/compiled_data.rds")
head(df, 5)
```

## Gathering Committees

To begin, it is recommended that you create a new folder or setup a working directory to collect the downloaded files. In our example, we created a demo_committee folder to dump all the files. We then proceeded to create two folders inside the demo_committee folder: (1) xml and (2) rds.

To identify committees and committees abbreviations, you can use the following code:

```
unique(committees_sittings_list[c("organization", "Committee_Abbrv")])
```

In this example, we chose to download the data for the Standing Committee on Industry, Science and Technology (INDU) Since the data from the House of Commons are in the xml format, we will download them inside the xml folder as follows:

```
get_committee(Working_Directory = "~/demo_committee/xml/",
              StartDate = "2023-01-01",
              EndDate = "2023-06-30",
              Language = "en",
              CommitteeAbbrev = "INDU")
```

There should be 26 xml files inside that folder. Afterwards, we need to convert those xml files into rds files. To speed up the process, we created a looping function to convert all the files within a directory. We need to identify the path to the xml files and then the path to where we want our converted files to be dumped into. In this case, the rds folder we precreated. as the xml structure is slightly different for the Hansard and the committees, we had to create another function to preceed: 

```
committee_XML2RDS_ListFiles(WD_PathXML = "~/demo_committee/xml/",
                            WD_PathRDS = "~/demo_committee/rds/")
```

Ultimately, we can merge the data of each file to create a compiled file withholding all our data. This time, we identified our rds files folder and gave a name to our future file. Once compiled, the file will be located in the rds folder.

```
compile_RDS_ListFiles(WD_PathRDS = "~/demo_committee/rds/",
                      filename = "compiled_data")
```

Upon those manipulations, we can load the file to validate everything worked. There should be 4,188 interventions and 25 variables. 

```
df = readRDS("~/demo_committee/rds/compiled_data.rds")
head(df, 5)
```

## Gathering Votes
Before you start gathering the votes, it is recommended that you create a new folder or setup a working directory to collect the downloaded files. In our example, we created a demo_vote folder to dump all the files. We then proceeded to create two folders inside the demo_committee folder: (1) xml and (2) rds. We then proceeded to extract all the votes that took place in the 44th Parliament 1st session using the code below.

```
get_vote(Working_Directory = "~/demo_vote/xml/",
         Language = "en",
         ParliamentNumber = "44",
         SessionNumber = "1")
```

If you need to extract all the votes available on the House of Commons website (38th Parliament 1st session to 44th Parliament 1st session), you can use the votes_parliament_session_list dataframe that is built into the package:

```
for(i in 1:dim(votes_parliament_session_list)[1]){
  get_vote(Working_Directory = "~/demo_vote/xml/",
           Language = "en",
           ParliamentNumber = votes_parliament_session_list$parliament[i],
           SessionNumber = votes_parliament_session_list$session[i])
}
```

Next, we can convert those xml files into rds files using the following method: 

```
vote_XML2RDS(XML_WD = "~/demo_vote/xml/",
             RDS_WD = "~/demo_vote/rds/")
```

Then, we can merge the data of each file to create a compiled file withholding all our data. This time, we identified our rds files folder and gave a name to our future file. Once compiled, the file will be located in the rds folder.

```
compile_RDS_ListFiles(WD_PathRDS = "~/demo_vote/rds/",
                      filename = "compiled_data")
```

Upon those manipulations, we can load the file to validate everything worked. There should be 4,158 interventions and 11 variables for the complete data set. 

```
df = readRDS("~/demo_vote/rds/compiled_data.rds")
head(df, 5)
```

## Gathering Vote Detailed Informations
Before you start gathering the vote detailed informations, it is recommended that you create a new folder or setup a working directory to collect the downloaded files. In our example, we created a demo_vote_info folder to dump all the files. We then proceeded to create two folders inside the demo_committee folder: (1) xml and (2) rds. In the example below, we are fetching the details for vote #407 of the 44th Parliament 1st session. 

get_vote_info(Working_Directory = "~/demo_vote_info/xml/",
              Language = "en",
              ParliamentNumber = "44",
              SessionNumber = "1",
              DecisionDivisionNumber = "407")

This is great if you need to target a specific vote, but if you want to gather the detailed informations for all votes in all available Parliament and session this gets relatively tedious. To alleviate this problematic, we offer a loop that will enable users to download everything at once using our votes_parliament_session_list dataframe. It is also possible to subset a portion of that dataframe.

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

Next, we can convert those xml files into rds files: 

```
vote_info_XML2RDS(XML_WD = "~/demo_vote_info/xml/",
                  RDS_WD = "~/demo_vote_info/rds/")
```

Finally, we can compile all those files together into one rds document. There should be 4,158 files, corresponding to the 4,158 votes that occured between the 38th Parliament 1st session and the 44th Parliament 1st session.

```
compile_RDS_ListFiles(WD_PathRDS = "~/demo_vote_info/rds/",
                      filename = "compiled_data")
```

Once compiled, we can load the file to validate our data. 

```
df = readRDS("~/demo_vote/rds/compiled_data.rds")
head(df, 5)
```
# canadianHansard (Instructions françaises - Démo)
**Bientôt disponible**