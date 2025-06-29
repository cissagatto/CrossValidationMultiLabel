cat("\n##################################################################################################")
cat("\n# START!                                                                                         #") 
cat("\n##################################################################################################")
cat("\n\n\n\n") 

rm(list=ls())

##############################################################################
# X-FOLDS CROSS VALIDATION MULTI-LABEL                                       # 
# Copyright (C) 2025                                                         #
#                                                                            #
# This code is free software: you can redistribute it and/or modify it under #
# the terms of the GNU General Public License as published by the Free       #
# Software Foundation, either version 3 of the License, or (at your option)  #
# any later version. This code is distributed in the hope that it will be    #
# useful, but WITHOUT ANY WARRANTY; without even the implied warranty of     #
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General   #
# Public License for more details.                                           #
#                                                                            #
# 1 - Prof PhD Elaine Cecilia Gatto                                          #
# 2 - Prof PhD Ricardo Cerri                                                 #
# 3 - Prof PhD Mauri Ferrandin                                               #
# 4 - Prof PhD Celine Vens                                                   #
# 5 - PhD Felipe Nakano Kenji                                                #
# 6 - Prof PhD Jesse Read                                                    #
#                                                                            #
# 1 = Federal University of São Carlos - UFSCar - https://www2.ufscar.br     #
# Campus São Carlos | Computer Department - DC - https://site.dc.ufscar.br | #
# Post Graduate Program in Computer Science - PPGCC                          # 
# http://ppgcc.dc.ufscar.br | Bioinformatics and Machine Learning Group      #
# BIOMAL - http://www.biomal.ufscar.br                                       # 
#                                                                            # 
# 1 = Federal University of Lavras - UFLA                                    #
#                                                                            # 
# 2 = State University of São Paulo - USP                                    #
#                                                                            # 
# 3 - Federal University of Santa Catarina Campus Blumenau - UFSC            #
# https://ufsc.br/                                                           #
#                                                                            #
# 4 and 5 - Katholieke Universiteit Leuven Campus Kulak Kortrijk Belgium     #
# Medicine Department - https://kulak.kuleuven.be/                           #
# https://kulak.kuleuven.be/nl/over_kulak/faculteiten/geneeskunde            #
#                                                                            #
# 6 - Ecole Polytechnique | Institut Polytechnique de Paris | 1 rue Honoré   #
# d’Estienne d’Orves - 91120 - Palaiseau - FRANCE                            #
#                                                                            #
##############################################################################


cat("\n################################")
cat("\n# Set Work Space               #")
cat("\n###############################\n\n")
library(here)
library(stringr)
FolderRoot <- here::here()
FolderScripts <- here::here("R")



cat("\n########################################")
cat("\n# R Options Configuration              #")
cat("\n########################################\n\n")
options(java.parameters = "-Xmx64g")  # JAVA
options(show.error.messages = TRUE)   # ERROR MESSAGES
options(scipen=20)                    # number of places after the comma



cat("\n########################################")
cat("\n# Creating parameters list              #")
cat("\n########################################\n\n")
parameters = list()


cat("\n########################################")
cat("\n# Reading Datasets-Original.csv        #")
cat("\n########################################\n\n")
setwd(FolderRoot)
datasets <- data.frame(read.csv("datasets-original.csv"))
parameters$Datasets.List = datasets


cat("\n#####################################")
cat("\n# GET ARGUMENTS FROM COMMAND LINE   #")
cat("\n#####################################\n\n")
args <- commandArgs(TRUE)

config_file <- args[1]


# config_file = "~/CrossValidationMultiLabel/config-files/cvm-3sources_bbc1000.csv"


parameters$Config.File$Name = config_file
if(file.exists(config_file)==FALSE){
  cat("#\n#############################################################")
  cat("#\n Missing Config File! Verify the following path:            #")
  cat("#\n ", config_file, "                                          #")
  cat("################################################################\n\n")
  break
} else {
  cat("\n########################################")
  cat("\n# Properly loaded configuration file!  #")
  cat("\n########################################\n\n")
}


cat("\n########################################")
cat("\n# Config File                          #\n")
config = data.frame(read.csv(config_file))
print(config)
cat("\n########################################\n\n")


cat("\n########################################")
cat("\n# Getting Parameters                   #\n")
cat("\n########################################")
FolderScripts = toString(config$Value[1])
FolderScripts = str_remove(FolderScripts, pattern = " ")
parameters$Directories$FolderScripts = FolderScripts

dataset_path = toString(config$Value[2])
dataset_path = str_remove(dataset_path, pattern = " ")
parameters$Config.File$Dataset.Path = dataset_path

temporary_path = toString(config$Value[3])
temporary_path = str_remove(temporary_path, pattern = " ")
parameters$Config.File$Temporary.Path = temporary_path

report_path = toString(config$Value[4]) 
report_path = str_remove(report_path, pattern = " ")
parameters$Config.File$Reports = report_path

dataset_name = toString(config$Value[5])
dataset_name = str_remove(dataset_name, pattern = " ")
parameters$Config.File$Dataset.Name = dataset_name

number_dataset = as.numeric(config$Value[6])
parameters$Config.File$Number.Dataset = number_dataset

validation = as.numeric(config$Value[7])
parameters$Config.File$Validation = validation

number_folds = as.numeric(config$Value[8])
parameters$Config.File$Number.Folds = number_folds

number_cores = as.numeric(config$Value[9])
parameters$Config.File$Number.Cores = number_cores

ds = datasets[number_dataset,]
parameters$Dataset.Info = ds

cat("\n########################################")
cat("\n# Loading R Sources                    #")
cat("\n########################################\n\n")
source(file.path(FolderScripts, "libraries.R"))
source(file.path(FolderScripts, "utils.R"))


cat("\n########################################")
cat("\n# Creating temporary processing folder #")
cat("\n########################################\n\n")
if (dir.exists(temporary_path) == FALSE) {dir.create(temporary_path)}


cat("\n###############################")
cat("\n# Get directories             #")
cat("\n###############################\n\n")
diretorios <- directories(parameters)
parameters$Directories = diretorios


cat("\n###############################")
cat("\n# Copy files                  #")
cat("\n###############################\n\n")
arff.name = paste0(parameters$Directories$FolderDataset, "/", parameters$Config.File$Dataset.Name, ".arff")
xml.name = paste0(parameters$Directories$FolderDataset, "/", parameters$Config.File$Dataset.Name, ".xml")

str01 = paste0("cp ", arff.name, " ", parameters$Directories$FolderResults)
res = system(str01)
if (res != 0) {
  cat("\nError: ", str01)
  break
}

str02 = paste0("cp ", xml.name, " ", parameters$Directories$FolderResults)
res = system(str02)
if (res != 0) {
  cat("\nError: ", str02)
  break
}


cat("\n###############################")
cat("\n# Computing Cross Validation  #")
cat("\n###############################\n\n")

if(parameters$Config.File$Number.Folds == 1){
  cat("\n Number folds == 1. Please, run again with a number of folds > 1!")
  
} else {
  
  source(file.path(FolderScripts, "CrossValidationMultiLabel.R"))
  
  cat("\n###############################")
  cat("\n# Dataset Analysis            #")
  cat("\n###############################\n\n")
  timeDA = system.time(resDA <- dataset.analysis(parameters))
  resultDA <- t(data.matrix(timeDA))
  
  cat("\n###############################")
  cat("\n# Splitting                   #")
  cat("\n###############################\n\n")
  timeCV = system.time(resDA <- compute.cv(parameters))
  resultCV <- t(data.matrix(timeCV))
  
}


cat("\n############################################################")
cat("\n# Compress results                                         #")
cat("\n############################################################\n\n")
tar.file <- paste0(parameters$Directories$FolderResults, "/", 
                   parameters$Dataset.Info$Name,
                   ".tar.gz")
str03 <- paste("tar -zcvf", tar.file, "-C", 
               parameters$Directories$FolderResults, ".")
res = system(str03)

#if (res != 0) {
#  cat("\nError: ", str03)
#  break
#}


cat("\n##############################################################")
cat("\n# Copy to Reports Folder                                     #")
cat("\n##############################################################\n\n")
str05 = paste("cp ", tar.file, " ", parameters$Directories$FolderReports)
res = system(str05)
if (res != 0) {
  cat("\nError: ", str05)
  break
}


cat("\n##############################################################")
cat("\n# Deleting                                                   #")
cat("\n##############################################################\n\n")

print(system(paste0("rm -r ", parameters$Directories$FolderResults)))


rm(list = ls())
gc()

cat("\n##################################################################################################")
cat("\n# END. Thanks God!                                                                               #") 
cat("\n##################################################################################################")
cat("\n\n\n\n") 


##################################################################################################
# Please, any errors, contact us: elainececiliagatto@gmail.com                                   #
# Thank you very much!                                                                           #
##################################################################################################
