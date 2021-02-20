##################################################################################################
# BELL PARTITIONS MULTILABEL CLASSIFICATION                                                      #
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
# Script 1 - Libraries                                                                           #
##################################################################################################

##################################################################################################
# Configures the workspace according to the operating system                                     #
##################################################################################################
sistema = c(Sys.info())
FolderRoot = ""
if (sistema[1] == "Linux"){
  FolderRoot = paste("/home/", sistema[7], "/BellPartitionsMultiLabel", sep="")
  setwd(FolderRoot)
} else {
  FolderRoot = paste("C:/Users/", sistema[7], "/BellPartitionsMultiLabel", sep="")
  setwd(FolderRoot)
}
setwd(FolderRoot)
FolderScripts = paste(FolderRoot, "/R/", sep="")
setwd(FolderScripts)


##################################################################################################
# ARGS COMMAND LINE                                                                              #
##################################################################################################
cat("\nArgs Command Line\n")
args <- commandArgs(TRUE)
cat(args, sep = "\n")


##################################################################################################
# LOAD MAIN.R                                                                                     #
##################################################################################################
cat("\nLoad Scripts\n")
FolderScripts = paste(FolderRoot, "/R/", sep="")
setwd(FolderScripts)
source("run.R") 


##################################################################################################
# GET THE DIRECTORIES                                                                            #
##################################################################################################
cat("\nGet directories\n")
diretorios <- directories()


##################################################################################################
# Read the dataset file with the information for each dataset                                    #
##################################################################################################
cat("\nOpen datasets.csv\n")
setwd(FolderRoot)
datasets <- data.frame(read.csv("datasets.csv"))
n = nrow(datasets)


##################################################################################################
# Get the number of folds                                                                        #
##################################################################################################
number_dataset <- as.numeric(args[1])


##################################################################################################
# 
##################################################################################################

ds = datasets[number_dataset,]
dataset_name <- toString(ds$Name) 
cat("\nDataset: ", dataset_name)

cat("\nCompute Bell Partitions for MultiLabel Classification")
timeBPM = system.time(res <- execute(number_dataset))
cat("\n")

#res$partitions$groupsPerPartitions

# C:\Users\elain\BellPartitionsMultiLabel\Results\emotions\Results
Folder = paste(FolderRoot, "/Results/", dataset_name, sep="")
setwd(Folder)
save(timeBPM, file = paste(dataset_name, "-RunTimeFinal.rds", sep=""))
save(res, file = paste(dataset_name, "-Results.rds", sep=""))


##################################################################################################
# Please, any errors, contact us: elainececiliagatto@gmail.com                                   #
# Thank you very much!                                                                           #
##################################################################################################