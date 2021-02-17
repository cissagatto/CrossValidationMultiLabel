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
FolderScripts = paste(FolderRoot, "/R/", sep="")


##################################################################################################
# LOAD SOURCES                                                                                   #
##################################################################################################
setwd(FolderScripts)
source("libraries.R")

setwd(FolderScripts)
source("utils.R")

setwd(FolderScripts)
source("CrossValidationMultiLabel.R")

##################################################################################################
# MAIN                                                                                           #
#   Objective                                                                                    #

#   Parameters                                                                                   #
#       dataset_name: dataset name. It is used to save files.                                    #
#       number_folds: number of folds to be created                                              #
#   Return                                                                                       #
##################################################################################################
CrossValidationMultiLabel <- function(i, number_folds){
  
  cat("\nOpen datasets")
  setwd(FolderRoot)
  datasets = data.frame(read.csv("datasets.csv"))
  names(datasets)[1] = "Id"
  n = nrow(datasets)
  
  cat("\nCreating folders")
  folders1 = createDirs1(FolderRoot)
  
  FolderDS = paste(folders1$FolderResults, "/", dataset_name, sep="")
  if(dir.exists(FolderDS)==TRUE){
    cat("\n")
  } else {
    dir.create(FolderDS)  
  }
  
  FolderCV = paste(FolderDS, "/CrossValidation", sep="")
  if(dir.exists(FolderCV)==TRUE){
    cat("\n")
  } else {
    dir.create(FolderCV)  
  }
  
    cat("\nStart CV")
    
    cat("\nId: ", i)
    setwd(FolderRoot)
    datasets <- data.frame(read.csv("datasets.csv"))
    n = nrow(datasets)
    ds = datasets[i,]
    dataset_name <- toString(ds$Name) 
    cat("\nDataset: ", dataset_name)	
    
    cat("\nCall Cross Validation")
    timeCVM = system.time(resCVM <- CrossVal(ds, dataset_name, number_folds, 
                                             folders1$FolderDatasets, folders1$FolderUtils, FolderCV))  
    
    cat("\nCall Label Space")
    timeLS = system.time(resLS <- LabelSpace(ds, dataset_name, number_folds, FolderDS))     
    
    setwd(FolderRoot)
    Runtime = rbind(timeCVM, timeLS)
    write.csv(Runtime, "RunTime.csv")
    
    parallel::stopCluster(cl) 
    cat("\nEND!")
  
}

##################################################################################################
# Please, any errors, contact us: elainececiliagatto@gmail.com                                   #
# Thank you very much!                                                                           #
##################################################################################################