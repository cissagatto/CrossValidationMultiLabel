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
createDirs <- function(FolderResults){
  
  retorno = list()
  
  FolderResults = FolderResults
  if(dir.exists(FolderResults)==FALSE){
    dir.create(FolderResults)  
  }
  
  FolderScripts = paste(FolderRoot, "/R", sep="")
  if(dir.exists(FolderScripts)==FALSE){
    dir.create(FolderScripts)  
  }
  
  FolderUtils = paste(FolderRoot, "/utils", sep="")
  if(dir.exists(FolderUtils)==FALSE){
    dir.create(FolderUtils)    
  }
  
  FolderDatasets = paste(FolderRoot, "/Datasets", sep="")
  if(dir.exists(FolderDatasets)==FALSE){
    dir.create(FolderDatasets)
  } 
  
  FolderOriginals = paste(FolderDatasets, "/Originals", sep="")
  if(dir.exists(FolderOriginals)==FALSE){
    dir.create(FolderOriginals)  
  }
  
  FolderCV = paste(FolderResults, "/CrossValidation", sep="")
  if(dir.exists(FolderCV)==FALSE){
    dir.create(FolderCV)  
  }
  
  FolderTR = paste(FolderCV, "/Tr", sep="")
  if(dir.exists(FolderTR)==FALSE){
    dir.create(FolderTR)  
  }
  
  FolderTS = paste(FolderCV, "/Ts", sep="")
  if(dir.exists(FolderTS)==FALSE){
    dir.create(FolderTS)  
  }
  
  FolderVL = paste(FolderCV, "/Vl", sep="")
  if(dir.exists(FolderVL)==FALSE){
    dir.create(FolderVL)  
  }
  
  FolderDS = paste(FolderRoot, "/", dataset_name, sep="")
  if(dir.exists(FolderDS)==FALSE){
    dir.create(FolderDS)  
  } 
  
  FolderLS = paste(FolderCV, "/LabelSpace", sep="")
  if(dir.exists(FolderLS)==FALSE){
    dir.create(FolderLS)      
  }
  
  FolderNamesLabels = paste(FolderCV, "/NamesLabels", sep="")
  if(dir.exists(FolderNamesLabels)==FALSE){
    dir.create(FolderNamesLabels)  
  }

  retorno$FolderDS = FolderDS
  retorno$FolderLS = FolderLS
  retorno$FolderNamesLabels = FolderNamesLabels
  retorno$FolderResults = FolderResults
  retorno$FolderScripts = FolderScripts
  retorno$FolderUtils = FolderUtils
  retorno$FolderDatasets = FolderDatasets
  retorno$FolderOriginals = FolderOriginals
  retorno$FolderCV = FolderCV
  retorno$FolderTR = FolderTR
  retorno$FolderTS = FolderTS
  retorno$FolderVL = FolderVL
  
  return(retorno)
  
  gc()
  
}

##################################################################################################
# Please, any errors, contact us: elainececiliagatto@gmail.com                                   #
# Thank you very much!                                                                           #
##################################################################################################