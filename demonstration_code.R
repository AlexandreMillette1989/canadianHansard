# You can skip this part (Refine dataset) and go straight to the second part (Transform dataset) if you are using the file provided on GitHub. 
# This section is only relevant if you downloaded data from 2006-02-13 to 2023-06-30.
# 
#install.packages("remotes") # uncomment to install
library(remotes)
# Uncomment line 7-10 to install canadianHansard
#install_github("AlexandreMillette1989/canadianHansard", 
#               force = TRUE,
#               dependencies = TRUE,
#               upgrade = TRUE)

library(canadianHansard)


# make sure you setup the folders in your working directory
# you can use getwd() to find your working directory or setwd() to change it
get_hansard(Working_Directory = "~/environment_xml/", # 
            StartDate = "2006-02-13",
            EndDate = "2023-06-30",
            Language = "en")
hansard_XML2RDS_ListFiles(WD_PathXML = "~/environment_xml /",
                          WD_PathRDS = "~/ environment_rds/")
compile_RDS_ListFiles(WD_PathRDS = "~/ environment_rds/",
                      filename = "environment_data")


# 1. Refine dataset
base = readRDS(file.choose()) # select the environment_data file that is in the ~/environment_rds/ folder
base = subset(base, base$legislature >= 39)
# 74 tags to sort interventions
keywords = c("Oil and gas",
             "Carbon tax",
             "Bay du Nord Project",
             "Carbon pricing",
             "Pipeline transportation",
             "Trans Mountain pipeline",
             "Climate change and global warming",
             "Environmental assessment",
             "Greenhouse gases",
             "Environmental health",
             "Environmental protection",
             "Sustainable development",
             "Oil tankers",
             "Coastal areas",
             "Energy East Pipeline Project",
             "Agriculture, environment and natural resources",
             "Marine protected areas",
             "Renewable energy and fuel",
             "Water quality",
             "National, provincial and territorial parks and reserves",
             "Nature conservation",
             "Green economy",
             "Federal Sustainable Development Strategy",
             "Gas tax fund",
             "Oceans",
             "Environmental law",
             "Climate Action Incentive",
             "Low Carbon Economy Fund",
             "Wildlife conservation",
             "Energy and fuel",
             "Habitat conservation",
             "Greenhouse gas emissions inventories",
             "Keystone Pipeline Project",
             "Pollution",
             "Biodiversity",
             "Hazardous material spills",
             "Green buildings",
             "Ecology and ecologists",
             "Environmental non-governmental organizations",
             "Carbon capture, utilization and storage",
             "Endangered species",
             "Ecotechnology",
             "Brush, prairie and forest fires",
             "Cruelty to animals",
             "Floods",
             "Coal",
             "Oil spills",
             "Oil and gas wells",
             "Bituminous sands",
             "Marine conservation",
             "Fisheries quotas",
             "Mining industry",
             "Environmental clean-up",
             "Ecosystems",
             "Natural gas",
             "Energy conservation",
             "Air safety",
             "Air quality",
             "Diesel fuel",
             "Carbon credits",
             "Solar energy",
             "Fossil fuels",
             "Fuel oil",
             "petroleum",
             "Canada’s Oceans Protection Plan",
             "Environmental contamination",
             "Natural disasters",
             "Coastal GasLink Pipeline Project",
             "Incentives for Zero-Emission Vehicles", 
             "Zero-Emission Vehicles",
             "Zero emission vehicles",
             "Carbon neutrality",
             "Emissions Reduction Fund",
             "Coastal erosion and protection")

base$keyword_found = grepl(paste(keywords, collapse = "|"), base$keyword_tags) # Look for string TRUE / FALSE
base = subset(base, base$keyword_found == "TRUE") # only keep interventions with at least one tag
# only keep interventions from the 5 main caucuses
base = subset(base, base$caucus == "Bloc Québécois Caucus" | base$caucus == "Conservative Caucus" | base$caucus == "Green Party Caucus" | base$caucus == "Liberal Caucus" | base$caucus == "New Democratic Party Caucus")
#########################################################################################################################################################################################################################

# 2. Transform dataset
#install.packages("quanteda") # Uncomment to install
#install.packages("quanteda.sentiment") # Uncomment to install
library(quanteda)
library(quanteda.sentiment)
# tokenize and remove stopwords
baseTokens = tokens_remove(tokens(tolower(base$intervention), remove_punct = TRUE, remove_symbols = TRUE, remove_numbers = TRUE), stopwords("english"))
# add word count variable
base$words = ntoken(baseTokens)
# create custom dictionary
custom_dictionary = dictionary(list(
  energy = c("barrel*",
             "bitumen*",
             "coal",
             "crude",
             "diesel",
             "drilling",
             "energy",
             "electric",
             "electricity",
             "fossil",
             "fuel*",
             "gas",
             "gases",
             "gasoline",
             "hydro",
             "hydroelectricity",
             "hydrogen",
             "hydropower",
             "keystone",
             "newfoundland",
             "nuclear",
             "offshore",
             "oil",
             "petroleum",
             "pipeline*",
             "propane",
             "renewable",
             "sands",
             "solar",
             "tanker*",
             "tmx",
             "wind",
             "power",
             "powers"),
  climate_change = c("air",
                     "ban",
                     "car",
                     "carbon",
                     "cars",
                     "change",
                     "changes",
                     "climate",
                     "cop26",
                     "disaster*",
                     "earth",
                     "emitter*",
                     "emission*",
                     "environment*",
                     "fertilizer*",
                     "fire",
                     "fires",
                     "flood*",
                     "footprint*",
                     "ghg",
                     "greenhouse",
                     "heat",
                     "heating",
                     "ipcc",
                     "low-carbon",
                     "mercury",
                     "net-zero",
                     "paris",
                     "planet",
                     "polluter*",
                     "pollution",
                     "reduction*",
                     "spill",
                     "spills",
                     "sustainability",
                     "sustainable",
                     "target",
                     "targets",
                     "temperature*",
                     "toxic",
                     "traffic",
                     "transition",
                     "vehicule*",
                     "warming",
                     "wildfire*",
                     "zero"),
  economy = c("affordability",
              "affordable",
              "agricultural",
              "agriculture",
              "bank",
              "banks",
              "billion*",
              "budget*",
              "build",
              "business",
              "businesses",
              "commercial",
              "company",
              "companies",
              "construction",
              "consumer*",
              "consumption",
              "corporat*",
              "cost",
              "costs",
              "debt",
              "deficit*",
              "development",
              "economic",
              "economy",
              "employ*",
              "export*",
              "farm",
              "farming",
              "farms",
              "farmers",
              "fiscal",
              "finance",
              "financial*",
              "fisheries",
              "fund",
              "funds",
              "funding",
              "g7",
              "g20",
              "gdp",
              "growth",
              "gst",
              "income*",
              "industr*",
              "inflation*",
              "infrastructure",
              "innovation*",
              "invest",
              "investing",
              "investment*",
              "investor*",
              "job",
              "jobs",
              "loan",
              "loans",
              "low-income",
              "manufacturing",
              "market",
              "markets",
              "million*",
              "mine",
              "mining",
              "money",
              "nafta",
              "paying",
              "price*",
              "pricing",
              "producer*",
              "profit*",
              "prosperity",
              "recession",
              "resource*",
              "revenue*",
              "spend",
              "spent",
              "subsid*",
              "tax",
              "taxation*",
              "taxes",
              "taxpayer*",
              "tariff*",
              "trade",
              "unemployment",
              "wealth",
              "workers"),
  nature_fauna = c("animal",
                   "animals",
                   "biodiversity",
                   "coast",
                   "coastal",
                   "conservation",
                   "ecolog*",
                   "ecosystem*",
                   "endangered",
                   "fauna",
                   "fish",
                   "fishery",
                   "fishes",
                   "fishing",
                   "forest*",
                   "lake",
                   "lakes",
                   "marine",
                   "nature",
                   "ocean*",
                   "park*",
                   "plastic",
                   "plastics",
                   "preservation",
                   "preserve",
                   "river*",
                   "salmon",
                   "sea",
                   "seas",
                   "species",
                   "tidewater*",
                   "tree",
                   "trees",
                   "vessel*",
                   "water",
                   "waters",
                   "waterway*",
                   "whale",
                   "whales",
                   "wildlife*"),
  first_nations = c("arctic",
                    "abitibiwinnik",
                    "aboriginal*",
                    "akeeagok",
                    "algonquin",
                    "anishinabe",
                    "atikamekw",
                    "carmacks",
                    "cree",
                    "dogrib",
                    "gwich'in",
                    "gwitchin",
                    "indigenous",
                    "innu",
                    "inuit",
                    "inuinnaqtun",
                    "inuk",
                    "inuktitut",
                    "inuvik",
                    "itk",
                    "lyackson",
                    "listuguj",
                    "katzie",
                    "kinanaskomtinawaw",
                    "kwantlen",
                    "manawan",
                    "matsqui",
                    "métis",
                    "mi'kmaq",
                    "nations",
                    "nanisivik",
                    "nasittuq",
                    "northerner*",
                    "nunavummiut",
                    "nunavut",
                    "nunavik",
                    "okanagan",
                    "packchi-wanis",
                    "pauingassi",
                    "peguis",
                    "pikogan",
                    "reconciliation",
                    "saanich",
                    "semiahmoo",
                    "shamattawa",
                    "snaw-naw-as",
                    "snuneymuxw",
                    "stz'uminus",
                    "tadoule",
                    "territories",
                    "territory",
                    "tlingit",
                    "uashat-maliotenam",
                    "uqaqtittiji",
                    "wela'lin",
                    "wet'suwet'en",
                    "wiiliideh",
                    "yukon")
))

# create dfm based on token
baseDFM = dfm(baseTokens)
# run custom dictionary through the dfm
baseThemes=convert(dfm_lookup(baseDFM, custom_dictionary), "data.frame")
# bind theme results to original data
base = cbind(base, baseThemes)
# add sentiment lsd + afinn
sent_pol <- base$intervention |>
  textstat_polarity(dictionary = data_dictionary_LSD2015)
sent_pol <- dplyr::mutate(sent_pol, polarity = sentiment)
sent_val <- base$intervention |>
  textstat_valence(dictionary = data_dictionary_AFINN)
base$sent_pol = sent_pol$polarity
base$sent_val = sent_val$sentiment

# create a variable for paired t-test # governing_party
base$governing_party = NULL
for(i in 1:dim(base)[1]){
  if(base$legislature[i] <= 41){
    base$governing_party[i] = "CPC"
  }else if(base$legislature[i] >= 42){
    base$governing_party[i] = "LPC"
  }
}

# account for Bruce Hyer party swap
for(i in 1:dim(base)[1]){
  if(base$nom[i] == "Bruce Hyer" && base$caucus[i] == "Green Party Caucus"){
    base$nom[i] = "Bruce Hyer - GPC"
  }else if(base$nom[i] == "Bruce Hyer" && base$caucus[i] == "New Democratic Party Caucus"){
    base$nom[i] = "Bruce Hyer - NDP"
  }
}

# subset the CPC governing timeline
base_CPC = subset(base, base$governing_party == "CPC")

# list the mp
mp_namelist = table(base_CPC$nom)

# create an empty array based on mp_namelist length
mp_ID = array("placeholder", dim=c(length(mp_namelist),10))

# loop through the list
for(i in 1:length(mp_namelist)){
  tableauTemporaire=subset(base,base$nom==names(mp_namelist[i]))
  mp_ID[i,1]=names(table(droplevels(tableauTemporaire)$nom))
  mp_ID[i,2]=names(table(droplevels(tableauTemporaire)$caucus))
  mp_ID[i,3]=round(sum(tableauTemporaire$sent_pol)/dim(tableauTemporaire)[1],2)
  mp_ID[i,4]=round(sum(tableauTemporaire$sent_val)/dim(tableauTemporaire)[1],2)
  mp_ID[i,5]=sum(tableauTemporaire$words) 
  mp_ID[i,6]=round(sum(tableauTemporaire$energy)/sum(tableauTemporaire$words)*100,2)
  mp_ID[i,7]=round(sum(tableauTemporaire$climate_change)/sum(tableauTemporaire$words)*100,2)
  mp_ID[i,8]=round(sum(tableauTemporaire$economy)/sum(tableauTemporaire$words)*100,2)
  mp_ID[i,9]=round(sum(tableauTemporaire$nature_fauna)/sum(tableauTemporaire$words)*100,2)
  mp_ID[i,10]=round(sum(tableauTemporaire$first_nations)/sum(tableauTemporaire$words)*100,2)
}

# create a dataframe from the loop
cpc_gov_mp_ID = data.frame(mp_ID)
# rename cols
colnames(cpc_gov_mp_ID)=c("nom","caucus", "sent_pol", "sent_val", "words", "energy", "climate_change", "economy", "nature_fauna", "indigenous_peoples")
# set variable as numeric
cpc_gov_mp_ID$sent_pol = as.numeric(cpc_gov_mp_ID$sent_pol)
cpc_gov_mp_ID$sent_val = as.numeric(cpc_gov_mp_ID$sent_val)
cpc_gov_mp_ID$energy = as.numeric(cpc_gov_mp_ID$energy)
cpc_gov_mp_ID$climate_change = as.numeric(cpc_gov_mp_ID$climate_change)
cpc_gov_mp_ID$economy = as.numeric(cpc_gov_mp_ID$economy)
cpc_gov_mp_ID$nature_fauna = as.numeric(cpc_gov_mp_ID$nature_fauna)
cpc_gov_mp_ID$indigenous_peoples = as.numeric(cpc_gov_mp_ID$indigenous_peoples)

# subset the LPC governing timeline
base_LPC = subset(base, base$governing_party == "LPC")

# list the mp
mp_namelist = table(base_LPC$nom)

# create an empty array based on mp_namelist length
mp_ID = array("placeholder", dim=c(length(mp_namelist),10))

# loop through the list
for(i in 1:length(mp_namelist)){
  tableauTemporaire=subset(base,base$nom==names(mp_namelist[i]))
  mp_ID[i,1]=names(table(droplevels(tableauTemporaire)$nom))
  mp_ID[i,2]=names(table(droplevels(tableauTemporaire)$caucus))
  mp_ID[i,3]=round(sum(tableauTemporaire$sent_pol)/dim(tableauTemporaire)[1],2)
  mp_ID[i,4]=round(sum(tableauTemporaire$sent_val)/dim(tableauTemporaire)[1],2)
  mp_ID[i,5]=sum(tableauTemporaire$words) 
  mp_ID[i,6]=round(sum(tableauTemporaire$energy)/sum(tableauTemporaire$words)*100,2)
  mp_ID[i,7]=round(sum(tableauTemporaire$climate_change)/sum(tableauTemporaire$words)*100,2)
  mp_ID[i,8]=round(sum(tableauTemporaire$economy)/sum(tableauTemporaire$words)*100,2)
  mp_ID[i,9]=round(sum(tableauTemporaire$nature_fauna)/sum(tableauTemporaire$words)*100,2)
  mp_ID[i,10]=round(sum(tableauTemporaire$first_nations)/sum(tableauTemporaire$words)*100,2)
}

# create a dataframe from the loop
lpc_gov_mp_ID = data.frame(mp_ID)
# rename cols
colnames(lpc_gov_mp_ID)=c("nom","caucus", "sent_pol", "sent_val", "words", "energy", "climate_change", "economy", "nature_fauna", "indigenous_peoples")
# set variable as numeric
lpc_gov_mp_ID$sent_pol = as.numeric(lpc_gov_mp_ID$sent_pol)
lpc_gov_mp_ID$sent_val = as.numeric(lpc_gov_mp_ID$sent_val)
lpc_gov_mp_ID$energy = as.numeric(lpc_gov_mp_ID$energy)
lpc_gov_mp_ID$climate_change = as.numeric(lpc_gov_mp_ID$climate_change)
lpc_gov_mp_ID$economy = as.numeric(lpc_gov_mp_ID$economy)
lpc_gov_mp_ID$nature_fauna = as.numeric(lpc_gov_mp_ID$nature_fauna)
lpc_gov_mp_ID$indigenous_peoples = as.numeric(lpc_gov_mp_ID$indigenous_peoples)

# Sentiment analysis 
# install.packages("ggplot2") # uncomment to install the package
library(ggplot2)

# cpc governing
ggplot(cpc_gov_mp_ID, aes(x=as.numeric(sent_pol), y=as.numeric(sent_val), group=caucus)) +
  geom_point(aes(shape = caucus, color = caucus), size = 4) +
  scale_color_manual(values = c("cyan", "blue", "green","red", "orange")) +
  scale_shape_manual(values=c(15,16,8,17,18))+
  ggtitle("") +
  theme(plot.title = element_text(hjust = 0.5)) +
  theme(text = element_text(size = 18)) +
  theme(axis.text = element_text(angle = 0, vjust = 1, hjust =1)) +
  xlab("Polarity of Interventions") +
  ylab("Valence of Interventions") +
  theme(legend.position = "bottom") +
  theme(legend.title = element_blank())
# cpc governing
round(tapply(cpc_gov_mp_ID$sent_pol, cpc_gov_mp_ID$caucus, mean),2)
round(tapply(cpc_gov_mp_ID$sent_val, cpc_gov_mp_ID$caucus, mean),2)


# lpc governing
ggplot(lpc_gov_mp_ID, aes(x=as.numeric(sent_pol), y=as.numeric(sent_val), group=caucus)) +
  geom_point(aes(shape = caucus, color = caucus), size = 4) +
  scale_color_manual(values = c("cyan", "blue", "green","red", "orange")) +
  scale_shape_manual(values=c(15,16,8,17,18))+
  ggtitle("") +
  theme(plot.title = element_text(hjust = 0.5)) +
  theme(text = element_text(size = 18)) +
  theme(axis.text = element_text(angle = 0, vjust = 1, hjust =1)) +
  xlab("Polarity of Interventions") +
  ylab("Valence of Interventions") +
  theme(legend.position = "bottom") +
  theme(legend.title = element_blank())

# lpc governing
round(tapply(lpc_gov_mp_ID$sent_pol, lpc_gov_mp_ID$caucus, mean),2)
round(tapply(lpc_gov_mp_ID$sent_val, lpc_gov_mp_ID$caucus, mean),2)

# list the mp
mp_namelist = table(base$nom)

# create an empty array based on mp_namelist length
mp_ID = array("placeholder", dim=c(length(mp_namelist),10))

# loop through the list
for(i in 1:length(mp_namelist)){
  tableauTemporaire=subset(base,base$nom==names(mp_namelist[i]))
  mp_ID[i,1]=names(table(droplevels(tableauTemporaire)$nom))
  mp_ID[i,2]=names(table(droplevels(tableauTemporaire)$caucus))
  mp_ID[i,3]=round(sum(tableauTemporaire$sent_pol)/dim(tableauTemporaire)[1],2)
  mp_ID[i,4]=round(sum(tableauTemporaire$sent_val)/dim(tableauTemporaire)[1],2)
  mp_ID[i,5]=sum(tableauTemporaire$words) 
  mp_ID[i,6]=round(sum(tableauTemporaire$energy)/sum(tableauTemporaire$words)*100,2)
  mp_ID[i,7]=round(sum(tableauTemporaire$climate_change)/sum(tableauTemporaire$words)*100,2)
  mp_ID[i,8]=round(sum(tableauTemporaire$economy)/sum(tableauTemporaire$words)*100,2)
  mp_ID[i,9]=round(sum(tableauTemporaire$nature_fauna)/sum(tableauTemporaire$words)*100,2)
  mp_ID[i,10]=round(sum(tableauTemporaire$first_nations)/sum(tableauTemporaire$words)*100,2)
}

# create a dataframe from the loop
complete_mp_ID = data.frame(mp_ID)
# rename cols
colnames(complete_mp_ID)=c("nom","caucus", "sent_pol", "sent_val", "words", "energy", "climate_change", "economy", "nature_fauna", "indigenous_peoples")
# set variable as numeric
complete_mp_ID$sent_pol = as.numeric(complete_mp_ID$sent_pol)
complete_mp_ID$sent_val = as.numeric(complete_mp_ID$sent_val)
complete_mp_ID$energy = as.numeric(complete_mp_ID$energy)
complete_mp_ID$climate_change = as.numeric(complete_mp_ID$climate_change)
complete_mp_ID$economy = as.numeric(complete_mp_ID$economy)
complete_mp_ID$nature_fauna = as.numeric(complete_mp_ID$nature_fauna)
complete_mp_ID$indigenous_peoples = as.numeric(complete_mp_ID$indigenous_peoples)

# mean of all themes from 2006-2023
round(tapply(complete_mp_ID$energy, complete_mp_ID$caucus, mean),2)
round(tapply(complete_mp_ID$climate_change, complete_mp_ID$caucus, mean),2)
round(tapply(complete_mp_ID$economy, complete_mp_ID$caucus, mean),2)
round(tapply(complete_mp_ID$nature_fauna, complete_mp_ID$caucus, mean),2)
round(tapply(complete_mp_ID$indigenous_peoples, complete_mp_ID$caucus, mean),2)

# PCA 
# install.packages("ade4") # uncomment to install
# install.packages("factoextra") # uncomment to install
library(ade4)
library(factoextra)

groupes <- as.factor(complete_mp_ID$caucus)
res.pca <- dudi.pca(complete_mp_ID[,c(6:10)],
                    scannf = FALSE,
                    nf = 5)
pca_plot = fviz_pca_biplot(res.pca, repel = TRUE,
                           col.var = "black",
                           col.ind = groupes,
                           palette = c("cyan", "blue","green", "red", "orange"),
                           ellipse.type = "confidence",
                           label="var",
                           labelsize = 5)
    
pca_plot +
  ggtitle("") +
  scale_shape_manual(values=c(15,16,8,17,18))+
  theme(text = element_text(size = 15)) +
  theme(legend.title = element_blank()) +
  theme(legend.position = "bottom")


#install.packages("rstatix") # uncomment to install
library(rstatix)

t1 = pairwise.t.test(complete_mp_ID$energy,complete_mp_ID$caucus,pool=F,p.adj="none")
round(t1$p.value, 2)
complete_mp_ID %>% cohens_d(energy ~ caucus) #rstatix

t2 = pairwise.t.test(as.numeric(complete_mp_ID$climate_change),complete_mp_ID$caucus,pool=F,p.adj="none")
round(t2$p.value, 2)
complete_mp_ID %>% cohens_d(climate_change ~ caucus) #rstatix

t3= pairwise.t.test(as.numeric(complete_mp_ID$economy),complete_mp_ID$caucus,pool=F,p.adj="none")
round(t3$p.value, 2)
complete_mp_ID %>% cohens_d(economy ~ caucus) #rstatix

t4 = pairwise.t.test(as.numeric(complete_mp_ID$nature_fauna),complete_mp_ID$caucus,pool=F,p.adj="none")
round(t4$p.value, 2)
complete_mp_ID %>% cohens_d(nature_fauna ~ caucus) #rstatix

t5 = pairwise.t.test(as.numeric(complete_mp_ID$indigenous_peoples),complete_mp_ID$caucus,pool=F,p.adj="none")
round(t5$p.value, 2)
complete_mp_ID %>% cohens_d(indigenous_peoples ~ caucus) #rstatix

