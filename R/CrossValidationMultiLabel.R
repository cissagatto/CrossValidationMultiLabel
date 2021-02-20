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
# FUNCTION CROSS VALIDATION                                                                      #
#   Objective                                                                                    #
#      Creates the folds of the cross validation                                                 #  
#   Parameters                                                                                   #
#       ds: specific dataset information                                                         #
#       dataset_name: dataset name. It is used to save files.                                    #
#       number_folds: number of folds to be created                                              #
#   Return                                                                                       #
#       k-folds test, train and validation                                                       #
##################################################################################################
CrossVal <- function(ds, dataset_name, number_folds, validation, 
                     FolderDatasets, FolderUtils, FolderCV, FolderO){ 
  
  retorno = list()
  
  FolderCVTR = paste(FolderCV, "/Tr", sep="")
  if(dir.exists(FolderCVTR)==TRUE){
    cat("\n")
  } else {
    dir.create(FolderCVTR)  
  }
  
  FolderCVTS = paste(FolderCV, "/Ts", sep="")
  if(dir.exists(FolderCVTS)==TRUE){
    cat("\n")
  } else {
    dir.create(FolderCVTS)  
  }
  
  FolderCVVL = paste(FolderCV, "/Vl", sep="")
  if(dir.exists(FolderCVVL)==TRUE){
    cat("\n")
  } else {
    dir.create(FolderCVVL)  
  }
  
  library(foreign)
  setwd(FolderO)
  arquivo = mldr(dataset_name)
  
  nomesRotulos = c(colnames(arquivo$dataset[ds$LabelStart:ds$LabelEnd]))
  setwd(FolderCV)
  write.csv(nomesRotulos, "namesLabels.csv")
  write.csv(arquivo$measures, paste(dataset_name, "-measures.csv", sep=""))
  
  cat("\nCreates folds for cross-validation\n")
  set.seed(1234)
  cvdata <- create_kfold_partition(arquivo, number_folds, "iterative")
  cvDataFolds = cvdata$fold
  
  
  if(validation == 1){
    # from the first fold to the last
    i = 1
    while(i<=number_folds){
      
      cat("\nFold: ", i)
      
      # get the specific fold
      FoldSpecific = partition_fold(cvdata, i, has.validation = TRUE)
      
      #########################################################
      cat("\n\tTRAIN ", i, "\n")
      setwd(FolderCVTR)
      
      # get the start and end column labels
      inicio = ds$LabelStart
      fim = ds$LabelEnd
      
      #cat("\n\t\tTRAIN: separates the measurements and the testing FOLD\n")
      treino_rds = FoldSpecific$train
      treino_ds = FoldSpecific$train$dataset
      treino_ds$.labelcount = NULL
      treino_ds$.SCUMBLE = NULL
      treino_ds = data.frame(treino_ds)
      
      
      #cat("\n\t\tTRAIN: Save CSV")
      str_csv_treino = paste(dataset_name, "-Split-Tr-", i, ".csv", sep="")
      write.csv(treino_ds, str_csv_treino, row.names = FALSE)
      
      #cat("\n\t\tTRAIN: Convert, and save, CSV to ARFF")
      str_arff_treino = paste(dataset_name, "-Split-Tr-", i, ".arff", sep="")
      arg1Tr = str_csv_treino
      arg2Tr = str_arff_treino
      arg3Tr = paste(inicio, "-", fim, sep="")
      converteArff(arg1Tr, arg2Tr, arg3Tr, FolderUtils)
      
      #cat("\n\t\tTRAIN: Verify and correct {0} and {1}\n")
      arquivo = paste(FolderCVTR, "/", str_arff_treino, sep="")
      str0 = paste("sed -i 's/{0}/{0,1}/g;s/{1}/{0,1}/g' ", arquivo, sep="")
      print(system(str0))
      
      
      #########################################################
      cat("\n\tTEST ", i, "\n")
      setwd(FolderCVTS)
      
      #cat("\n\t\tTEST: separates the measurements and the testing FOLD\n")
      teste_rds = FoldSpecific$test
      teste_ds = FoldSpecific$test$dataset
      teste_ds$.labelcount = NULL
      teste_ds$.SCUMBLE = NULL
      teste_ds = data.frame(teste_ds)       
      
      #cat("\n\t\tTEST: Save CSV\n")
      str_csv_teste = paste(dataset_name, "-Split-Ts-", i, ".csv", sep="")
      write.csv(teste_ds, str_csv_teste, row.names = FALSE)
      
      #cat("\n\t\tTEST: Convert, and save, CSV to ARFF\n")
      str_arff_teste = paste(dataset_name, "-Split-Ts-", i, ".arff", sep="")
      arg1Tr = str_csv_teste
      arg2Tr = str_arff_teste
      arg3Tr = paste(inicio, "-", fim, sep="")
      converteArff(arg1Tr, arg2Tr, arg3Tr, FolderUtils)
      
      #cat("\n\t\tTEST: Verify and correct {0} and {1}\n")
      arquivo = paste(FolderCVTS, "/", str_arff_teste, sep="")
      str0 = paste("sed -i 's/{0}/{0,1}/g;s/{1}/{0,1}/g' ", arquivo, sep="")
      print(system(str0))
      
      #########################################################
      cat("\n\tVALIDATION ", i, "\n")
      setwd(FolderCVVL)
      
      #cat("\n\t\tVALIDATION: separates the measurements and the testing FOLD\n")
      val_rds = FoldSpecific$validation
      val_ds = FoldSpecific$validation$dataset
      val_ds$.labelcount = NULL
      val_ds$.SCUMBLE = NULL
      val_ds = data.frame(val_ds)
      
      #cat("\n\t\tVALIDATION: Save CSV\n")
      str_csv_val = paste(dataset_name, "-Split-Vl-", i, ".csv", sep="")
      write.csv(val_ds, str_csv_val, row.names = FALSE)
      
      #cat("\n\t\tVALIDATION: Convert, and save, CSV to ARFF\n")
      str_arff_val = paste(dataset_name, "-Split-Vl-", i, ".arff", sep="")
      arg1Tr = str_csv_val
      arg2Tr = str_arff_val
      arg3Tr = paste(inicio, "-", fim, sep="")
      converteArff(arg1Tr, arg2Tr, arg3Tr, FolderUtils)
      
      #cat("\n\t\tVALIDATION: Verify and correct {0} and {1} in ARFF files\n")
      arquivo = paste(FolderCVVL, "/", str_arff_val, sep="")
      str0 = paste("sed -i 's/{0}/{0,1}/g;s/{1}/{0,1}/g' ", arquivo, sep="")
      print(system(str0))
      
      i = i + 1
      gc()
    }    
  } else {
    # from the first fold to the last
    i = 1
    while(i<=number_folds){
      
      cat("\nFold: ", i)
      
      # get the specific fold
      FoldSpecific = partition_fold(cvdata, i, has.validation = FALSE)
      
      #########################################################
      cat("\n\tTRAIN ", i, "\n")
      setwd(FolderCVTR)
      
      # get the start and end column labels
      inicio = ds$LabelStart
      fim = ds$LabelEnd
      
      #cat("\n\t\tTRAIN: separates the measurements and the testing FOLD\n")
      treino_rds = FoldSpecific$train
      treino_ds = FoldSpecific$train$dataset
      treino_ds$.labelcount = NULL
      treino_ds$.SCUMBLE = NULL
      treino_ds = data.frame(treino_ds)
      
      #cat("\n\t\tTRAIN: Save CSV")
      str_csv_treino = paste(dataset_name, "-Split-Tr-", i, ".csv", sep="")
      write.csv(treino_ds, str_csv_treino, row.names = FALSE)
      
      #cat("\n\t\tTRAIN: Convert, and save, CSV to ARFF")
      str_arff_treino = paste(dataset_name, "-Split-Tr-", i, ".arff", sep="")
      arg1Tr = str_csv_treino
      arg2Tr = str_arff_treino
      arg3Tr = paste(inicio, "-", fim, sep="")
      converteArff(arg1Tr, arg2Tr, arg3Tr, FolderUtils)
      
      #cat("\n\t\tTRAIN: Verify and correct {0} and {1}\n")
      arquivo = paste(FolderCVTR, "/", str_arff_treino, sep="")
      str0 = paste("sed -i 's/{0}/{0,1}/g;s/{1}/{0,1}/g' ", arquivo, sep="")
      print(system(str0))
      
      
      #########################################################
      cat("\n\tTEST ", i, "\n")
      setwd(FolderCVTS)
      
      #cat("\n\t\tTEST: separates the measurements and the testing FOLD\n")
      teste_rds = FoldSpecific$test
      teste_ds = FoldSpecific$test$dataset
      teste_ds$.labelcount = NULL
      teste_ds$.SCUMBLE = NULL
      teste_ds = data.frame(teste_ds)       
      
      #cat("\n\t\tTEST: Save CSV\n")
      str_csv_teste = paste(dataset_name, "-Split-Ts-", i, ".csv", sep="")
      write.csv(teste_ds, str_csv_teste, row.names = FALSE)
      
      #cat("\n\t\tTEST: Convert, and save, CSV to ARFF\n")
      str_arff_teste = paste(dataset_name, "-Split-Ts-", i, ".arff", sep="")
      arg1Tr = str_csv_teste
      arg2Tr = str_arff_teste
      arg3Tr = paste(inicio, "-", fim, sep="")
      converteArff(arg1Tr, arg2Tr, arg3Tr, FolderUtils)
      
      #cat("\n\t\tTEST: Verify and correct {0} and {1}\n")
      arquivo = paste(FolderCVTS, "/", str_arff_teste, sep="")
      str0 = paste("sed -i 's/{0}/{0,1}/g;s/{1}/{0,1}/g' ", arquivo, sep="")
      print(system(str0))
      
      i = i + 1
      gc()
    }    
  }
  
  retorno$cvdata = cvdata
  retorno$mldr_dataset = arquivo
  
  return(retorno)
  
  gc()
  cat("\n##################################################################################################")
  cat("\n# FUNCTION CROSS VALIDATION: END                                                                 #") 
  cat("\n##################################################################################################")
  cat("\n\n\n\n")
}


##################################################################################################
# FUNCTION LABEL SPACE                                                                           #
#   Objective                                                                                    #
#       Separates the label space from the rest of the data to be used as input for              # 
#       calculating correlations                                                                 #                                                                                        
#   Parameters                                                                                   #
#       ds: specific dataset information                                                         #
#       dataset_name: dataset name. It is used to save files.                                    #
#       number_folds: number of folds created                                                    #
#       Folder: folder where the folds are                                                       #
#   Return:                                                                                      #
#       Training set labels space                                                                #
##################################################################################################
LabelSpace <- function(ds, dataset_name, number_folds, FolderDS, FolderCV){
  
  retorno = list()
  classes = list()
  
  FolderLS = paste(FolderDS, "/LabelSpace", sep="")
  if(dir.exists(FolderLS)==TRUE){
    cat("\n")
  } else {
    dir.create(FolderLS)  
  }
  
  FolderNamesLabels = paste(FolderDS, "/NamesLabels", sep="")
  if(dir.exists(FolderNamesLabels)==TRUE){
    cat("\n")
  } else {
    dir.create(FolderNamesLabels)  
  }
  
  FolderCVTR = paste(FolderCV, "/Tr", sep="")
  if(dir.exists(FolderCVTR)==TRUE){
    cat("\n")
  } else {
    dir.create(FolderCVTR)  
  }
  
  # from the first FOLD to the last
  k = 1
  while(k<=number_folds){
    
    cat("\n\tFold: ", k)
    
    # enter folder train
    setwd(FolderCVTR)
    
    # get the correct split
    nome_arquivo = paste(dataset_name, "-Split-Tr-", k, ".csv", sep="")
    arquivo = data.frame(read.csv(nome_arquivo))
    
    # split label space from input space
    classes[[k]] = arquivo[,ds$LabelStart:ds$LabelEnd]
    
    setwd(FolderLS)
    nome = paste(dataset_name, "-LabelSpace.csv")
    write.csv(classes[[k]], nome)
    
    namesLabels = c(colnames(classes[[k]]))
    setwd(FolderNamesLabels)
    nome = paste(dataset_name, "-NamesLabels.csv", sep="")
    write.csv(namesLabels, nome)
    
    k = k + 1 # increment FOLD
    gc() # garbage collection
  } # End While of the 10-folds
  
  retorno$NamesLabels = namesLabels
  retorno$Classes = classes
  
  return(retorno)
  
  gc()
  cat("\n##################################################################################################")
  cat("\n# FUNCTION LABEL SPACE: END                                                                      #") 
  cat("\n##################################################################################################")
  cat("\n\n\n\n")
}

##################################################################################################
# Please, any errors, contact us: elainececiliagatto@gmail.com                                   #
# Thank you very much!                                                                           #
##################################################################################################