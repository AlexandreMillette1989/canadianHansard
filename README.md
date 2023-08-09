# canadianHansard
 This package offers functions to gather datasets from the House of Commons of Canada.
 
Ce package offre des fonctions pour télécharger des ensembles de données de la Chambre des communes du Canada.

To install this package, you must first install the devtools package.

Pour installer ce package, vous devrez d'abord installer le package devtools.
```
install.packages("devtools")
  
library(devtools)
```

Next, you will be able to import the package directly from GitHub.

Par la suite, vous serez en mesure d'importer le package à partir de GitHub.
```
install_github("AlexandreMillette1989/canadianHansard",
               force = TRUE,
               dependencies = TRUE,
               upgrade = TRUE)
  
library(canadianHansard)
```
