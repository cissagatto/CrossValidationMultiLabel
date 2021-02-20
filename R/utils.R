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
# FUNCTION DIRECTORIES                                                                           #
#   Objective:                                                                                   #
#      Creates all the necessary folders for the project. These are the main folders that must   # 
#      be created and used before the script starts to run                                       #  
#   Parameters:                                                                                  #
#      None                                                                                      #
#   Return:                                                                                      #
#      All path directories                                                                      #
##################################################################################################
directories <- function(){
  
  retorno = list()
  
  folderResults = paste(FolderRoot, "/Results", sep="")
  if(dir.exists(folderResults) == TRUE){
    setwd(folderResults)
    dirResults = dir(folderResults)
    n_Results = length(folderResults)
  } else {
    dir.create(folderResults)
    setwd(folderResults)
    dirResults = dir(folderResults)
    n_Results = length(folderResults)
  }
  
  folderDatasets = paste(FolderRoot, "/Datasets", sep="")
  if(dir.exists(folderDatasets) == TRUE){
    setwd(folderDatasets)
    dirDatasets = dir(folderDatasets)
    n_Datasets = length(dirDatasets)
  } else {
    dir.create(folderDatasets)
    setwd(folderDatasets)
    dirDatasets = dir(folderDatasets)
    n_Datasets = length(dirDatasets)
  }
  
  folderDO = paste(folderDatasets, "/Originals", sep="")
  if(dir.exists(folderDO) == TRUE){
    setwd(folderDO)
    dirDO = dir(folderDO)
    n_DO = length(dirDO)
  } else {
    dir.create(folderDO)
    setwd(folderDO)
    dirDO = dir(folderDO)
    n_DO = length(dirDO)
  }
  
  
  folderNamesLabels = paste(folderDatasets, "/NamesLabels", sep="")
  if(dir.exists(folderNamesLabels) == TRUE){
    setwd(folderNamesLabels)
    dirNamesLabels = dir(folderNamesLabels)
    n_NamesLabels = length(dirNamesLabels)
  } else {
    dir.create(folderNamesLabels)
    setwd(folderNamesLabels)
    dirNamesLabels = dir(folderNamesLabels)
    n_NamesLabels = length(dirNamesLabels)
  }

  
  # return folders
  retorno$folderResults = folderResults
  retorno$folderDatasets = folderDatasets
  retorno$folderDO = folderDO
  retorno$folderNamesLabels = folderNamesLabels
  
  # return of folder contents
  retorno$dirResults = dirResults
  retorno$dirDatasets = dirDatasets
  retorno$dirDO = dirDO
  retorno$dirNamesLabels = dirNamesLabels
  
  # return of the number of objects inside the folder
  retorno$n_Results = n_Results
  retorno$n_Datasets = n_Datasets
  retorno$n_DO = n_DO
  retorno$n_NamesLabels = n_NamesLabels
  
  return(retorno)
  gc()
}



##################################################################################################
# FUNCTION CREATING FOLDER PRINCIPALS                                                            #
#   Objective                                                                                    #
#       Creates the specific folders for the specific dataset                                    #
#   Parameters                                                                                   #
#       dataset_name: dataset name. It is used to create the folders.                            #
#   Return:                                                                                      #
#      All path directories                                                                      #
##################################################################################################
directoriesDataset<- function(dataset_name){
  
  diretorios = directories()
  
  retorno = list()
  
  folderFolds = paste(diretorios$folderFolds, "/", dataset_name, sep="")
  if(dir.exists(folderFolds) == TRUE){
    setwd(folderFolds)
    dir_Folds = dir(folderFolds)
    n_Folds = length(dir_Folds)
  } else {
    dir.create(folderFolds)
    setwd(folderFolds)
    dir_Folds = dir(folderFolds)
    n_Folds = length(dir_Folds)
  }
  
  folderDataset = paste(diretorios$folderResults, "/", dataset_name, sep="")
  if(dir.exists(folderDataset) == TRUE){
    setwd(folderDataset)
    dir_Dataset = dir(folderDataset)
    n_Dataset = length(dir_Dataset)
  } else {
    dir.create(folderDataset)
    setwd(folderDataset)
    dir_Dataset = dir(folderDataset)
    n_Dataset = length(dir_Dataset)
  }
  
  retorno$folderFolds = folderFolds
  retorno$folderDataset = folderDataset
  
  retorno$dir_Folds = dir_Folds
  retorno$dir_Dataset = dir_Dataset
  
  retorno$n_Folds = n_Folds
  retorno$n_Dataset = n_Dataset
  
  return(retorno)
  
}


##################################################################################################
# FUNCTION CONVERT TO ARFF                                                                       #
#     Objective:                                                                                 #
#        Convert csv file correctly to arff file                                                 #
#     Parameters                                                                                 #
#        arg 1: existing csv file name                                                           #
#        arg 2: name of the arff file to be created                                              #
#        arg 3: specific number of labels that are part of the file. Example: starts at label    # 
#        30 and ends at label 50.                                                                #
#     Return:                                                                                    #
#        The arff file in the specific folder                                                    #
##################################################################################################
converteArff <- function(arg1, arg2, arg3){  
  str = paste("java -jar ", diretorios$folderUtils, "/R_csv_2_arff.jar ", arg1, " ", arg2, " ", arg3, sep="")
  cat("\n")  
  print(system(str))
  cat("\n")  
}



##################################################################################################
# FUNCTION INFO DATA SET                                                                         #
#  Objective                                                                                     #
#     Gets the information that is in the "datasets.csv" file.                                    #  
#  Parameters                                                                                    #
#     dataset: the specific dataset                                                              #
#  Return                                                                                        #
#     Everything in the spreadsheet                                                              #
##################################################################################################
infoDataSet <- function(dataset){
  retorno = list()
  retorno$id = dataset$ID
  retorno$name = dataset$Name
  retorno$domain = dataset$Domain
  retorno$instances = dataset$Instances
  retorno$attributes = dataset$Attributes
  retorno$inputs = dataset$Inputs
  retorno$labels = dataset$Labels
  retorno$LabelsSets = dataset$LabelsSets
  retorno$single = dataset$Single
  retorno$maxfreq = dataset$MaxFreq
  retorno$card = dataset$Card
  retorno$dens = dataset$Dens
  retorno$mean = dataset$MeanIR
  retorno$scumble = dataset$Scumble
  retorno$tcs = dataset$TCS
  retorno$attStart = dataset$AttStart
  retorno$attEnd = dataset$AttEnd
  retorno$labStart = dataset$LabelStart
  retorno$labEnd = dataset$LabelEnd
  return(retorno)
  gc()
}


##################################################################################################
# Please, any errors, contact us: elainececiliagatto@gmail.com                                   #
# Thank you very much!                                                                           #
##################################################################################################
