cat("\n##################################################################################################")
cat("\n# START!                                                                                         #") 
cat("\n##################################################################################################")
cat("\n\n\n\n") 

rm(list=ls())

##################################################################################################
# CrossValidationMultiLabel                                                                      #
# Copyright (C) 2021                                                                             #
#                                                                                                #
# This code is free software: you can redistribute it and/or modify it under the terms of the    #
# GNU General Public License as published by the Free Software Foundation, either version 3 of   #  
# the License, or (at your option) any later version. This code is distributed in the hope       #
# that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of         #
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for    #
# more details.                                                                                  #     
#                                                                                                #
# Elaine Cecilia Gatto | Prof. Dr. Ricardo Cerri | Prof. Dr. Mauri Ferrandin                     #
# Federal University of Sao Carlos (UFSCar: https://www2.ufscar.br/) Campus Sao Carlos           #
# Computer Department (DC: https://site.dc.ufscar.br/)                                           #
# Program of Post Graduation in Computer Science (PPG-CC: http://ppgcc.dc.ufscar.br/)            #
# Bioinformatics and Machine Learning Group (BIOMAL: http://www.biomal.ufscar.br/)               #
#                                                                                                #
##################################################################################################

##################################################################################################
# Configures the workspace according to the operating system                                     #
##################################################################################################
FolderRoot = "~/CrossValidationMultiLabel"
FolderScripts = paste(FolderRoot, "/R/", sep="")


##################################################################################################
# Options Configuration                                                                          #
##################################################################################################
options(java.parameters = "-Xmx64g")
options(show.error.messages = TRUE)
options(scipen=30)


##################################################################################################
# Read the dataset file with the information for each dataset                                    #
##################################################################################################
setwd(FolderRoot)
datasets <- data.frame(read.csv("datasets-original.csv"))


##################################################################################################
# ARGS COMMAND LINE                                                                              #
##################################################################################################
args <- commandArgs(TRUE)


##################################################################################################
# Get dataset information                                                                        #
##################################################################################################
ds <- datasets[args[1],]


##################################################################################################
# Get dataset information                                                                        #
##################################################################################################
number_dataset <- as.numeric(args[1])
cat("\nCV number_dataset: \t\t", number_dataset)


##################################################################################################
# Get the number of cores                                                                        #
##################################################################################################
number_cores <- as.numeric(args[2])
cat("\nCV number_cores: \t\t", number_cores)


##################################################################################################
# Get the number of folds                                                                        #
##################################################################################################
number_folds <- as.numeric(args[3])
cat("\nCV number_folds: \t\t", number_folds)


##################################################################################################
# Validation
##################################################################################################
validation <- as.numeric(args[4])
cat("\nCV validation: \t\t\t", validation)


##################################################################################################
# folder results                                                                                 #
##################################################################################################
FolderResults <- toString(args[5])
cat("\nCV FolderResults: \t\t", FolderResults)


##################################################################################################
# Get dataset name                                                                               #
##################################################################################################
dataset_name <- toString(ds$Name) 
cat("\nCV dataset_nome: \t\t", dataset_name)


##################################################################################################
# DON'T RUN -- it's only for test the code
ds <- datasets[27,]
dataset_name = ds$Name
number_dataset = ds$Id
number_cores = 10
number_folds = 10
FolderResults = "/dev/shm/res"
validation = 1
##################################################################################################


 
##################################################################################################
# LOAD RUN.R                                                                                     #
##################################################################################################
setwd(FolderScripts)
source("main.R")
 
 

##################################################################################################
# CREATING FOLDERS                                                                               #
##################################################################################################
cat("\nCreating folders")
folders = createDirs(FolderResults)

cat("\n")
print(folders)
cat("\n")


##################################################################################################
# CREATING FOLDERS                                                                               #
##################################################################################################  
cat("\nCross Validation")
timeCVM = system.time(res <- CrossValidationMultiLabel(folders, ds, dataset_name, 
                                                       number_dataset, number_folds, 
                                                       validation, FolderResults))
result_set <- t(data.matrix(timeCVM))
setwd(folders$FolderDS)
write.csv(result_set, "CV-Runtime.csv")

##################################################################################################
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
