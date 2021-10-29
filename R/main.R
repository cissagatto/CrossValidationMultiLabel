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
CrossValidationMultiLabel <- function(folders, ds, dataset_name,
                                      number_dataset, number_folds, 
                                      validation, FolderResults){
  
  cat("\nCreating folders")
  folders = createDirs(FolderResults)
  
  if(number_folds==1){
    cat("\n Number folds == 1. Please, run again with a number_folds > 1!")
    
  } else {
    
    cat("\n Compute Cross Validation")
    timeCVM = system.time(resCVM <- CrossVal(folders, ds, dataset_name, number_cores,
                                             number_dataset, number_folds, 
                                             validation, FolderResults))
    
    cat("\nTreat Label Space Information")
    timeLS = system.time(resLS <- LabelSpace(folders, ds, dataset_name, number_cores,
                                             number_dataset, number_folds))       
  }
  
    
  setwd(folders$FolderDS)
  Runtime = rbind(timeCVM, timeLS)
  write.csv(Runtime, "RunTime.csv")
  
}

##################################################################################################
# Please, any errors, contact us: elainececiliagatto@gmail.com                                   #
# Thank you very much!                                                                           #
##################################################################################################