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
               upgrade = FALSE)
  
library(canadianHansard)
```

**Gathering Hansard**

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

# canadianHansard (Instructions françaises - Démo)
Ce package offre des fonctions pour télécharger des ensembles de données de la Chambre des communes du Canada.

Pour installer ce package, vous devrez d'abord installer le package devtools.
```
install.packages("devtools")
  
library(devtools)
```

Par la suite, vous serez en mesure d'importer le package à partir de GitHub.
```
install_github("AlexandreMillette1989/canadianHansard",
               force = TRUE,
               dependencies = TRUE,
               upgrade = TRUE)
  
library(canadianHansard)
```