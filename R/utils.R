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



##################################################################################################
# Configures the workspace according to the operating system                                     #
##################################################################################################
library(here)
library(stringr)
FolderRoot <- here::here()
FolderScripts <- here::here("R")




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
converteArff <- function(arg1, arg2, arg3, FolderUtils) {
  
  str = paste("java --add-opens java.base/java.lang=ALL-UNNAMED -jar ", FolderUtils, "/R_csv_2_arff.jar ",
              arg1, " ",
              arg2, " ",
              arg3, sep = "")
  
  res = print(system(str))
  
  cat("\n")
  if (res != 0) {
    cat("\nError: ", str)
    break
  }
  cat("\n")
  
}




##############################################################################################################################################################################
#' @title Create and Organize Project Directories
#' @description
#' This function creates and organizes the necessary folder structure for a Multi-Label Cross-Validation project. 
#' It verifies the existence of required directories and creates them if they do not exist, including specific subfolders for different cross-validation types.
#'
#' @param parameters A list containing configuration parameters with the following structure:
#' \itemize{
#'   \item \code{parameters$Config.File$Dataset.Path} - Path where the dataset is located.
#'   \item \code{parameters$Config.File$Temporary.Path} - Path for temporary results.
#'   \item \code{parameters$Config.File$Reports} - Path for report files.
#'   \item \code{parameters$Config.File$Dataset.Name} - Name of the dataset.
#'   \item \code{parameters$Directories$FolderScripts} - Path for R scripts.
#' }
#'
#' @return A list with the paths to all important directories created or verified:
#' \itemize{
#'   \item \code{FolderDataset} - Path to the dataset root.
#'   \item \code{FolderDS} - Path to the specific dataset folder.
#'   \item \code{FolderResults} - Path to temporary results.
#'   \item \code{FolderScripts} - Path to the R scripts.
#'   \item \code{FolderReports} - Path to reports.
#' }
#'
#' @examples
#' \dontrun{
#' parameters <- list(
#'   Config.File = list(
#'     Dataset.Path = "~/Project/Datasets",
#'     Temporary.Path = "~/Project/Temp",
#'     Reports = "~/Project/Reports",
#'     Dataset.Name = "MyDataset"
#'   ),
#'   Directories = list(
#'     FolderScripts = "~/Project/R"
#'   )
#' )
#' 
#' paths <- directories(parameters)
#' print(paths$FolderResults)
#' }
#'
#' @author 
#' Developed by the Bioinformatics and Machine Learning Group (BIOMAL - UFSCar).
#'
directories <- function(parameters) {
  
  # Base paths
  FolderDataset <- parameters$Config.File$Dataset.Path
  FolderResults <- parameters$Config.File$Temporary.Path
  FolderReports <- parameters$Config.File$Reports
  FolderScripts <- parameters$Directories$FolderScripts
  FolderUtils <- paste0(FolderRoot, "/Utils")
  dataset_name  <- parameters$Config.File$Dataset.Name
  
  # Criação das pastas principais
  base_folders <- c(FolderDataset, 
                    FolderResults, 
                    FolderReports, 
                    FolderScripts, 
                    FolderUtils)
  for (folder in base_folders) {
    if (!dir.exists(folder)) {
      dir.create(folder, recursive = TRUE)
      message(paste("Created folder:", folder))
    }
  }
  
  FolderIterative <- file.path(FolderResults, "Iterative")
  if (!dir.exists(FolderIterative)) {dir.create(FolderIterative, recursive = TRUE)}
  
  FolderICV <- file.path(FolderIterative, "CrossValidation")
  if (!dir.exists(FolderICV)) {dir.create(FolderICV, recursive = TRUE)}
  
  FolderITR  <- file.path(FolderICV, "Tr")
  if (!dir.exists(FolderITR)) {dir.create(FolderITR, recursive = TRUE)}
  
  FolderITS  <- file.path(FolderICV, "Ts")
  if (!dir.exists(FolderITS)) {dir.create(FolderITS, recursive = TRUE)}
  
  FolderIVL  <- file.path(FolderICV, "Vl")
  if (!dir.exists(FolderIVL)) {dir.create(FolderIVL, recursive = TRUE)}
  
  #FolderINL <- file.path(FolderIterative, "NamesLabels")
  #if (!dir.exists(FolderINL)) {dir.create(FolderINL, recursive = TRUE)}
  
  FolderISL <- file.path(FolderIterative, "LabelSpace")
  if (!dir.exists(FolderISL)) {dir.create(FolderISL, recursive = TRUE)}
  
  FolderIInfo <- file.path(FolderIterative, "Info")
  if (!dir.exists(FolderIInfo)) {dir.create(FolderIInfo, recursive = TRUE)}
  
  FolderStratified <- file.path(FolderResults, "Stratified")
  if (!dir.exists(FolderStratified)) {dir.create(FolderStratified, recursive = TRUE)}
  
  FolderSCV <- file.path(FolderStratified, "CrossValidation")
  if (!dir.exists(FolderSCV)) {dir.create(FolderSCV, recursive = TRUE)}
  
  FolderSTR  <- file.path(FolderSCV, "Tr")
  if (!dir.exists(FolderSTR)) {dir.create(FolderSTR, recursive = TRUE)}
  
  FolderSTS  <- file.path(FolderSCV, "Ts")
  if (!dir.exists(FolderSTS)) {dir.create(FolderSTS, recursive = TRUE)}
  
  FolderSVL  <- file.path(FolderSCV, "Vl")
  if (!dir.exists(FolderSVL)) {dir.create(FolderSVL, recursive = TRUE)}
  
  #FolderSNL <- file.path(FolderStratified, "NamesLabels")
  #if (!dir.exists(FolderSNL)) {dir.create(FolderSNL, recursive = TRUE)}
  
  #FolderSSL <- file.path(FolderStratified, "LabelSpace")
  #if (!dir.exists(FolderSSL)) {dir.create(FolderSSL, recursive = TRUE)}
  
  FolderSInfo <- file.path(FolderStratified, "Info")
  if (!dir.exists(FolderSInfo)) {dir.create(FolderSInfo, recursive = TRUE)}
  
  # Inicialização da lista de diretórios
  directories <- list(
    
    FolderDataset = FolderDataset,
    FolderUtils = FolderUtils,
    
    FolderResults = FolderResults,
    FolderScripts = FolderScripts,
    FolderReports = FolderReports,
    
    FolderIterative = FolderIterative,
    FolderStratified = FolderStratified,
    
    FolderICV = FolderICV,
    FolderITR = FolderITR,
    FolderITS = FolderITS,
    FolderIVL = FolderIVL,
    FolderIInfo = FolderIInfo,
    #FolderISL = FolderISL,
    #FolderINL = FolderINL,
    
    FolderSCV = FolderSCV,
    FolderSTR = FolderSTR,
    FolderSTS = FolderSTS,
    FolderSVL = FolderSVL,
    FolderSInfo = FolderSInfo
    #FolderSSL = FolderSSL,
    #FolderSNL = FolderSNL
    
  )
  
  return(directories)
}


old <- function(){
  
  cat("\nCreates folds for cross-validation\n")
  set.seed(1234)
  cv.data.iterative <-
    create_kfold_partition(arquivo, number_folds, "iterative")
  cvDataFolds = cv.data.iterative$fold
  
  cat("\nCreates folds for cross-validation\n")
  set.seed(1234)
  cv.data.stratified <-
    create_kfold_partition(arquivo, number_folds, "stratified")
  cvDataFolds = cv.data.stratified$fold
  
  
  if (validation == 1) {
    
    resultados_tr = data.frame()
    resultados_ts = data.frame()
    resultados_vl = data.frame()
    
    # from the first fold to the last
    i = 1
    while (i <= number_folds) {
      cat("\nFold: ", i)
      
      # get the specific fold
      FoldSpecific = partition_fold(cvdata, i, has.validation = TRUE)
      
      #########################################################
      cat("\n\tTRAIN ", i, "\n")
      setwd(folders$FolderTR)
      
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
      str_csv_treino = paste(dataset_name, "-Split-Tr-", i, ".csv", sep = "")
      write.csv(treino_ds, str_csv_treino, row.names = FALSE)
      
      #cat("\n\t\tTRAIN: Convert, and save, CSV to ARFF")
      str_arff_treino = paste(dataset_name, "-Split-Tr-", i, ".arff", sep ="")
      arg1Tr = str_csv_treino
      arg2Tr = str_arff_treino
      arg3Tr = paste(inicio, "-", fim, sep = "")
      converteArff(arg1Tr, arg2Tr, arg3Tr, folders$FolderUtils)
      
      #cat("\n\t\tTRAIN: Verify and correct {0} and {1}\n")
      arquivo = paste(folders$FolderTR, "/", str_arff_treino, sep = "")
      str0 = paste("sed -i 's/{0}/{0,1}/g;s/{1}/{0,1}/g' ", arquivo, sep ="")
      print(system(str0))
      
      treino_mldr = mldr_from_dataframe(treino_ds, labelIndices = 
                                          c(ds$LabelStart:ds$LabelEnd))
      resultados_tr = rbind(resultados_tr, treino_mldr$measures)
      
      
      #########################################################
      cat("\n\tTEST ", i, "\n")
      setwd(folders$FolderTS)
      
      #cat("\n\t\tTEST: separates the measurements and the testing FOLD\n")
      teste_rds = FoldSpecific$test
      teste_ds = FoldSpecific$test$dataset
      teste_ds$.labelcount = NULL
      teste_ds$.SCUMBLE = NULL
      teste_ds = data.frame(teste_ds)
      
      #cat("\n\t\tTEST: Save CSV\n")
      str_csv_teste = paste(dataset_name, "-Split-Ts-", i, ".csv", sep =
                              "")
      write.csv(teste_ds, str_csv_teste, row.names = FALSE)
      
      #cat("\n\t\tTEST: Convert, and save, CSV to ARFF\n")
      str_arff_teste = paste(dataset_name, "-Split-Ts-", i, ".arff", sep =
                               "")
      arg1Tr = str_csv_teste
      arg2Tr = str_arff_teste
      arg3Tr = paste(inicio, "-", fim, sep = "")
      converteArff(arg1Tr, arg2Tr, arg3Tr, folders$FolderUtils)
      
      #cat("\n\t\tTEST: Verify and correct {0} and {1}\n")
      arquivo = paste(folders$FolderTS, "/", str_arff_teste, sep = "")
      str0 = paste("sed -i 's/{0}/{0,1}/g;s/{1}/{0,1}/g' ", arquivo, sep =
                     "")
      print(system(str0))
      
      teste_mldr = mldr_from_dataframe(teste_ds, labelIndices = 
                                         c(ds$LabelStart:ds$LabelEnd))
      resultados_ts = rbind(resultados_ts, teste_mldr$measures)
      
      #########################################################
      cat("\n\tVALIDATION ", i, "\n")
      setwd(folders$FolderVL)
      
      #cat("\n\t\tVALIDATION: separates the measurements and the testing FOLD\n")
      val_rds = FoldSpecific$validation
      val_ds = FoldSpecific$validation$dataset
      val_ds$.labelcount = NULL
      val_ds$.SCUMBLE = NULL
      val_ds = data.frame(val_ds)
      
      #cat("\n\t\tVALIDATION: Save CSV\n")
      str_csv_val = paste(dataset_name, "-Split-Vl-", i, ".csv", sep =
                            "")
      write.csv(val_ds, str_csv_val, row.names = FALSE)
      
      #cat("\n\t\tVALIDATION: Convert, and save, CSV to ARFF\n")
      str_arff_val = paste(dataset_name, "-Split-Vl-", i, ".arff", sep =
                             "")
      arg1Tr = str_csv_val
      arg2Tr = str_arff_val
      arg3Tr = paste(inicio, "-", fim, sep = "")
      converteArff(arg1Tr, arg2Tr, arg3Tr, folders$FolderUtils)
      
      #cat("\n\t\tVALIDATION: Verify and correct {0} and {1} in ARFF files\n")
      arquivo = paste(folders$FolderVL, "/", str_arff_val, sep = "")
      str0 = paste("sed -i 's/{0}/{0,1}/g;s/{1}/{0,1}/g' ", arquivo, sep =
                     "")
      print(system(str0))
      
      val_mldr = mldr_from_dataframe(val_ds, labelIndices = 
                                       c(ds$LabelStart:ds$LabelEnd))
      resultados_vl = rbind(resultados_vl, val_mldr$measures)
      
      i = i + 1
      gc()
    }
    
    setwd(folders$FolderDS)
    write.csv(resultados_tr, "measures-train.csv")
    write.csv(resultados_ts, "measures-test.csv")
    write.csv(resultados_vl, "measures-val.csv")
    
  } else {
    
    resultados_tr = data.frame()
    resultados_ts = data.frame()
    resultados_vl = data.frame()
    
    # from the first fold to the last
    i = 1
    while (i <= number_folds) {
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
      str_csv_treino = paste(dataset_name, "-Split-Tr-", i, ".csv", sep =
                               "")
      write.csv(treino_ds, str_csv_treino, row.names = FALSE)
      
      #cat("\n\t\tTRAIN: Convert, and save, CSV to ARFF")
      str_arff_treino = paste(dataset_name, "-Split-Tr-", i, ".arff", sep =
                                "")
      arg1Tr = str_csv_treino
      arg2Tr = str_arff_treino
      arg3Tr = paste(inicio, "-", fim, sep = "")
      converteArff(arg1Tr, arg2Tr, arg3Tr, FolderUtils)
      
      #cat("\n\t\tTRAIN: Verify and correct {0} and {1}\n")
      arquivo = paste(FolderCVTR, "/", str_arff_treino, sep = "")
      str0 = paste("sed -i 's/{0}/{0,1}/g;s/{1}/{0,1}/g' ", arquivo, sep =
                     "")
      print(system(str0))
      
      treino_mldr = mldr_from_dataframe(treino_ds, labelIndices = 
                                          c(ds$LabelStart:ds$LabelEnd))
      resultados_tr = rbind(resultados_tr, treino_mldr$measures)      
      
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
      str_csv_teste = paste(dataset_name, "-Split-Ts-", i, ".csv", sep =
                              "")
      write.csv(teste_ds, str_csv_teste, row.names = FALSE)
      
      #cat("\n\t\tTEST: Convert, and save, CSV to ARFF\n")
      str_arff_teste = paste(dataset_name, "-Split-Ts-", i, ".arff", sep =
                               "")
      arg1Tr = str_csv_teste
      arg2Tr = str_arff_teste
      arg3Tr = paste(inicio, "-", fim, sep = "")
      converteArff(arg1Tr, arg2Tr, arg3Tr, FolderUtils)
      
      #cat("\n\t\tTEST: Verify and correct {0} and {1}\n")
      arquivo = paste(FolderCVTS, "/", str_arff_teste, sep = "")
      str0 = paste("sed -i 's/{0}/{0,1}/g;s/{1}/{0,1}/g' ", arquivo, sep =
                     "")
      print(system(str0))
      
      teste_mldr = mldr_from_dataframe(teste_ds, labelIndices = 
                                         c(ds$LabelStart:ds$LabelEnd))
      resultados_ts = rbind(resultados_ts, teste_mldr$measures)
      
      i = i + 1
      gc()
    }
    
    setwd(folders$FolderDS)
    write.csv(resultados_tr, "measures-train.csv")
    write.csv(resultados_ts, "measures-test.csv")
    
  }
  
}


##################################################################################################
# Please, any errors, contact us: elainececiliagatto@gmail.com                                   #
# Thank you very much!                                                                           #
##################################################################################################