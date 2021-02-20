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
# Script 2 - utils                                                                               #
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
converteArff <- function(arg1, arg2, arg3, FolderUtils){  
  str = paste("java -jar ", FolderUtils, "/R_csv_2_arff.jar ", arg1, " ", arg2, " ", arg3, sep="")
  print(system(str))
  cat("\n\n")  
}



##################################################################################################
# FUNCTION                                                                        #
#     Objective:                                                                                 #

#     Parameters                                                                                 #

#     Return:                                                                                    #

##################################################################################################
createDirs1 <- function(FolderRoot){
  
  retorno = list()
  
  FolderUtils = paste(FolderRoot, "/utils", sep="")
  if(dir.exists(FolderUtils)==TRUE){
    cat("\n")
  } else {
    dir.create(FolderUtils)
  }
  
  FolderDatasets = paste(FolderRoot, "/Datasets", sep="")
  if(dir.exists(FolderDatasets)==TRUE){
    cat("\n")
  } else {
    dir.create(FolderDatasets)
  }
  
  FolderResults = paste(FolderRoot, "/Results", sep="")
  if(dir.exists(FolderResults)==TRUE){
    cat("\n")
  } else {
    dir.create(FolderResults)  
  }
  
  FolderOriginals = paste(FolderDatasets, "/Originals", sep="")
  if(dir.exists(FolderOriginals)==TRUE){
    cat("\n")
  } else {
    dir.create(FolderOriginals)  
  }
  
  retorno$FolderUtils = FolderUtils
  retorno$FolderDatasets = FolderDatasets
  retorno$FolderOriginals = FolderOriginals
  retorno$FolderResults = FolderResults
  
  return(retorno)
  
  gc()
  
}

##################################################################################################
# Please, any errors, contact us: elainececiliagatto@gmail.com                                   #
# Thank you very much!                                                                           #
##################################################################################################