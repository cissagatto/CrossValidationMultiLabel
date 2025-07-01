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



###############################################################################
#
###############################################################################
library(here)
library(stringr)
FolderRoot <- here::here()
FolderScripts <- here::here("R")


###############################################################################
# READING DATASET INFORMATION FROM DATASETS-ORIGINAL.CSV                      #
###############################################################################
name = paste0(FolderRoot, "/datasets-original.csv")
datasets = data.frame(read.csv(name))
n = nrow(datasets)
head(datasets)


###############################################################################
# CREATING FOLDER TO SAVE CONFIG FILES                                        #
###############################################################################
FolderCF = paste(FolderRoot, "/config-files", sep = "")
if (dir.exists(FolderCF) == FALSE) { dir.create(FolderCF) }


i = 1
while (i <= n) {
  ds = datasets[i, ]
  cat("\n\tDataset:", ds$Name)
  
  file.name = paste0(FolderCF, "/cvm-", ds$Name, ".csv")
  
  output.file <- file(file.name, "wb")
  
  write("Config, Value", file = output.file, append = TRUE)
  
  write("FolderScripts, /lapix/arquivos/elaine/CrossValidationMultiLabel/R", 
        file = output.file, append = TRUE)
  
  write("Dataset_Path, /lapix/arquivos/elaine/CrossValidationMultiLabel/Datasets",
        file = output.file, append = TRUE)
  
  temp.name = paste("/tmp/", ds$Name, sep = "")
  
  str.0 = paste("Temporary_Path, ", temp.name, sep = "")
  write(str.0, file = output.file, append = TRUE)
  
  write("Reports_Path, /lapix/arquivos/elaine/CrossValidationMultiLabel/Reports",
        file = output.file, append = TRUE)
  
  str.2 = paste("Dataset_Name, ", ds$Name, sep = "")
  write(str.2, file = output.file, append = TRUE)
  
  str.3 = paste("Number_Dataset, ", ds$Id, sep = "")
  write(str.3, file = output.file, append = TRUE)
  
  write("Validation, 1", file = output.file, append = TRUE)
  
  write("Number_Folds, 10", file = output.file, append = TRUE)
  
  close(output.file)
  
  i = i + 1
  gc()
}


###############################################################################
# Please, any errors, contact us: elainececiliagatto@gmail.com                #
# Thank you very much!                                                        #                                #
###############################################################################
