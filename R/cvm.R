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
sistema = c(Sys.info())
FolderRoot = ""
if (sistema[1] == "Linux"){
  FolderRoot = paste("/home/", sistema[7], "/CrossValidationMultiLabel", sep="")
  setwd(FolderRoot)
} else {
  FolderRoot = paste("C:/Users/", sistema[7], "/CrossValidationMultiLabel", sep="")
  setwd(FolderRoot)
}
setwd(FolderRoot)
FolderScripts = paste(FolderRoot, "/R", sep="")

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
datasets <- data.frame(read.csv("datasets.csv"))


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
cat("\n number_dataset \t ", number_dataset)


##################################################################################################
# Get the number of cores                                                                        #
##################################################################################################
number_cores <- as.numeric(args[2])
cat("\n cores \t ", number_cores)


##################################################################################################
# Get the number of folds                                                                        #
##################################################################################################
number_folds <- as.numeric(args[3])
cat("\n folds \t ", number_folds)

##################################################################################################
# Validation
##################################################################################################
validation <- as.numeric(args[4])
cat("\n validation \t ", validation)


##################################################################################################
# folder results                                                                                 #
##################################################################################################
FolderResults <- toString(args[5])
cat("\n folder \t ", FolderResults)


##################################################################################################
# Get dataset name                                                                               #
##################################################################################################
dataset_name <- toString(ds$Name) 
cat("\n nome \t ", dataset_name)


##################################################################################################
# DON'T RUN -- it's only for test the code
# ds <- datasets[29,]
# dataset_name = ds$Name
# number_dataset = ds$Id
# number_cores = 10
# number_folds = 10
# FolderResults = "/dev/shm/res"
# validation = 1
##################################################################################################


##################################################################################################
# cat("\nCopy FROM google drive \n")
# destino = paste(FolderRoot, "/Datasets/Originais/", dataset_name, sep="")
# origem = paste("cloud:elaine/Datasets/Originais/", dataset_name, ".arff", sep="")
# comando = paste("rclone -v copy ", origem, " ", destino, sep="")
# cat("\n", comando, "\n") 
# a = print(system(comando))
# a = as.numeric(a)
# if(a != 0) {
#   stop("Erro RCLONE")
#   quit("yes")
# }

# destino = paste(FolderRoot, "/Datasets/Originais/", dataset_name, sep="")
# origem = paste("cloud:elaine/Datasets/Originais/", dataset_name, ".xml", sep="")
# comando = paste("rclone -v copy ", origem, " ", destino, sep="")
# cat("\n", comando, "\n") 
# a = print(system(comando))
# a = as.numeric(a)
# if(a != 0) {
#   stop("Erro RCLONE")
#   quit("yes")
# }

 
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


##################################################################################################
# CREATING FOLDERS                                                                               #
##################################################################################################  
cat("\nCross Validation")
timeCVM = system.time(res <- CrossValidationMultiLabel(folders, ds, dataset_name, 
                                                       number_dataset, number_folds, 
                                                       validation, folderResults))
cat("\n")


setwd(folders$FolderDS)
save(timeCVM, file = paste(dataset_name, "-RunTimeFinal.rds", sep=""))
save(res, file = paste(dataset_name, "-Results.rds", sep=""))

########################################################################################################################
# cat("\n Copy to google drive")
# origem = 
# destino = paste("cloud:elaine/CrossValidation/CrossValidation_WithValidation/", dataset_name, sep="")
# comando = paste("rclone copy ", origem, " ", destino, sep="")
# cat("\n", comando, "\n") 
# a = print(system(comando))
# a = as.numeric(a)
# if(a != 0) {
#  stop("Erro RCLONE")
#  quit("yes")
# }
