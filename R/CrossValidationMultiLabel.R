##################################################################################################
# Cross Validation MultiLabel                                                                    #
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




library(here)
library(stringr)
FolderRoot <- here::here()
FolderScripts <- here::here("R")



##############################################################################
#' Convert CSV to ARFF File Format
#'
#' @description
#' This function exports a dataset to a CSV file and converts it to the ARFF format (used by Weka and other machine learning tools),
#' focusing on multi-label classification tasks. It removes specific columns not required for modeling and ensures correct formatting
#' of binary label values using shell commands.
#'
#' @param parameters A list containing dataset metadata and configuration, especially:
#' \itemize{
#'   \item \code{Dataset.Info$Name}: Name of the dataset.
#'   \item \code{Dataset.Info$LabelStart}: Index of the first label column.
#'   \item \code{Dataset.Info$LabelEnd}: Index of the last label column.
#'   \item \code{Directories$FolderUtils}: Path to utility scripts used for ARFF conversion.
#' }
#' @param save A character string indicating the folder where the CSV and ARFF files will be saved.
#' @param data A list that contains a \code{dataset} data frame to be converted.
#' @param folds An integer specifying the current fold number, used in naming output files.
#' @param type A string indicating the split type (e.g., \code{"Iterative"} or \code{"Stratified"}), used in the output filenames.
#'
#' @return No return value. This function is called for its side effects: writing CSV and ARFF files to disk.
#'
#' @examples
#' \dontrun{
#' csv_to_arff(
#'   parameters = params,
#'   save = "output/folder",
#'   data = dataset,
#'   folds = 1,
#'   type = "Iterative"
#' )
#' }
#'
#' @author Elaine Cecília Gatto - Cissa
csv_to_arff <- function(parameters, save, data, folds, type.split){
  
  name.csv = paste0(save, "/", parameters$Dataset.Info$Name, 
                    "-Split-", type.split, "-", folds, ".csv")
  
  name.arff = paste0(save, "/", parameters$Dataset.Info$Name,
                     "-Split-", type.split, "-", folds, ".arff")
  
  data2 <- data$dataset[, !colnames(data$dataset) %in% c(".labelcount", ".SCUMBLE")]
  write.csv(data2, name.csv, row.names = FALSE)
  
  arg1Tr = name.csv
  arg2Tr = name.arff
  arg3Tr = paste(parameters$Dataset.Info$LabelStart,
                 "-", parameters$Dataset.Info$LabelEnd, sep = "")
  
  converteArff(arg1Tr, arg2Tr, arg3Tr, parameters$Directories$FolderUtils)
  
  str0 = paste("sed -i 's/{0}/{0,1}/g;s/{1}/{0,1}/g' ", name.arff)
  res = system(str0)
  
  if (res != 0) {
    cat("\nError running system command:\n", str0, "\n")
    stop("Execution aborted due to shell command error.")
  }
}





##################################################################################################
#' Generate File Paths for Dataset Output Files
#'
#' @description
#' Constructs and returns the expected file paths for dataset-related files
#' such as the `.csv` result file, `.arff` dataset file, and `.xml` metadata file,
#' based on the folder structure and dataset name defined in `parameters`.
#'
#' This function is useful for consistent access to dataset-related files
#' during automated processing, evaluation, or export routines in MLC pipelines.
#'
#' @param parameters A list object containing the following fields:
#' \itemize{
#'   \item \code{Directories$FolderResults}: Path where result `.csv` files are stored.
#'   \item \code{Directories$FolderDataset}: Path where dataset `.arff` and `.xml` files are stored.
#'   \item \code{Dataset.Info$Name}: The base name of the dataset (used as file prefix).
#' }
#'
#' @return A named list with the following elements:
#' \itemize{
#'   \item \code{name.csv}: Path to the result CSV file.
#'   \item \code{name.arff}: Path to the dataset ARFF file.
#'   \item \code{name.xml}: Path to the dataset XML metadata file.
#' }
#'
#' @examples
#' \dontrun{
#'   parameters <- list(
#'     Directories = list(
#'       FolderResults = "/results",
#'       FolderDataset = "/datasets"
#'     ),
#'     Dataset.Info = list(Name = "emotions")
#'   )
#'   file.paths <- get.names.files(parameters)
#'   print(file.paths$name.csv)   # "/results/emotions.csv"
#'   print(file.paths$name.arff)  # "/datasets/emotions.arff"
#'   print(file.paths$name.xml)   # "/datasets/emotions.xml"
#' }
#'
#' @author Elaine Cecilia Gatto - Cissa
#'
#' @export
get.names.files <- function(parameters) {
  retorno = list()
  
  name.csv = paste0(parameters$Directories$FolderResults,
                    "/",
                    parameters$Dataset.Info$Name,
                    ".csv")
  
  name.arff = paste0(
    parameters$Directories$FolderDataset,
    "/",
    parameters$Dataset.Info$Name,
    ".arff"
  )
  
  name.xml = paste0(parameters$Directories$FolderDataset,
                    "/",
                    parameters$Dataset.Info$Name,
                    ".xml")
  retorno$name.csv = name.csv
  retorno$name.arff = name.arff
  retorno$name.xml = name.xml
  return(retorno)
}


##############################################################################
#' Get Index Range for Label Columns
#'
#' @description
#' Returns the sequence of column indices corresponding to the label columns 
#' in a multi-label dataset, based on metadata provided in the `parameters` object.
#'
#' This function is useful for extracting or referencing the label portion of a 
#' dataset matrix (e.g., for computing statistics or training MLC models).
#'
#' @param parameters A list object containing:
#' \itemize{
#'   \item \code{Dataset.Info$LabelStart}: An integer indicating the starting index of label columns.
#'   \item \code{Dataset.Info$LabelEnd}: An integer indicating the ending index of label columns.
#' }
#'
#' @return An integer vector containing the sequence of label column indices.
#'
#' @examples
#' \dontrun{
#'   parameters <- list(Dataset.Info = list(LabelStart = 5, LabelEnd = 10))
#'   label.indices <- get.label.indexes(parameters)
#'   print(label.indices)  # 5 6 7 8 9 10
#' }
#'
#' @author Elaine Cecilia Gatto - Cissa
#'
#' @export
get.label.indexes <- function(parameters) {
  indices.labels = seq(parameters$Dataset.Info$LabelStart,
                       parameters$Dataset.Info$LabelEnd,
                       by = 1)
  return(indices.labels)
}



##############################################################################
#' Check Consistency Between Dataset Labels and XML Definition
#'
#' @description
#' Verifies whether the label names defined in the XML metadata file match exactly
#' the label names extracted from the dataset. This ensures consistency between
#' the dataset structure and its metadata specification.
#'
#' If any mismatch is found, the function throws an error showing the differing labels.
#'
#' @param parameters A list object containing configuration information (not used directly in this function but kept for interface consistency).
#' @param names.files A list containing the path to the XML file, with:
#' \itemize{
#'   \item \code{name.xml}: A string indicating the path to the XML metadata file.
#' }
#' @param arquivo An `mldr` object representing the loaded dataset, typically read using `mldr::mldr("file.arff")`.
#'
#' @return No return value. This function is used for validation and will stop execution
#' with an error message if the label names from the XML and dataset do not match.
#'
#' @examples
#' \dontrun{
#'   parameters <- list()
#'   names.files <- list(name.xml = "path/to/metadata.xml")
#'   arquivo <- mldr::mldr("path/to/dataset.arff")
#'   check.labels(parameters, names.files, arquivo)
#' }
#'
#' @author Elaine Cecilia Gatto - Cissa
#'
#' @export
check.labels <- function(parameters, arquivo, names.files) {
  xml_labels <- read_xml(names.files$name.xml)
  labels_nodes <- xml_find_all(xml_labels, ".//d1:label", xml_ns(xml_labels))
  label_names_xml <- xml_attr(labels_nodes, "name")
  
  # Substituir '-' por '.'
  label_names_xml <- gsub("-", ".", label_names_xml)
  
  label_names_dataset <- rownames(arquivo$labels)
  label_names_dataset <- gsub("-", ".", label_names_dataset)
  
  #res1 = setdiff(label_names_xml, label_names_dataset)
  #res2 = setdiff(label_names_dataset, label_names_xml)
  #res3 = identical(sort(label_names_xml), sort(label_names_dataset))
  
  if (!identical(label_names_xml, label_names_dataset)) {
    stop(
      "❌ The labels defined in the XML file do not match the labels extracted from the dataset.\n",
      "🔍 Please check if the specified label column indices (LabelStart and LabelEnd) are correct.\n",
      "⚠️ Labels in XML: ",
      paste(label_names_xml, collapse = ", "),
      "\n",
      "⚠️ Labels in dataset: ",
      paste(label_names_dataset, collapse = ", ")
    )
  } else {
    message("✅ Label check successful: XML and dataset label names match exactly.")
  }
}


##############################################################################
#' Open and Load a Multi-Label Dataset Using MLD Parameters
#'
#' @description
#' Loads a multi-label dataset using the `mldr` package, applying label index configuration
#' provided in the `parameters` object. The dataset is filtered to exclude meta-features 
#' like `.labelcount` and `.SCUMBLE`, saved to a CSV file, and validated against its XML 
#' metadata for label consistency.
#'
#' This function acts as a convenient wrapper to read, preprocess, save, and validate
#' the dataset in a single step.
#'
#' @param parameters A list object containing:
#' \itemize{
#'   \item \code{Directories}: Paths for output folders and dataset locations.
#'   \item \code{Dataset.Info}: Metadata including dataset name and label index range (start and end).
#' }
#'
#' @return An `mldr` object with the dataset loaded and ready for use in experiments.
#'
#' @examples
#' \dontrun{
#'   parameters <- list(
#'     Directories = list(FolderResults = "results"),
#'     Dataset.Info = list(
#'       Name = "dataset.arff",
#'       LabelStart = 5,
#'       LabelEnd = 10
#'     )
#'   )
#'   dataset <- open.dataset(parameters)
#' }
#'
#' @author Elaine Cecilia Gatto - Cissa
#'
#' @export
open.dataset <- function(parameters) {
  retorno = list()
  
  name = paste0(parameters$Directories$FolderResults,
                "/",
                parameters$Dataset.Info$Name)
  
  indices.labels = get.label.indexes(parameters)
  
  arquivo = mldr(name, use_xml = TRUE, label_indices = indices.labels)
  
  names.files = get.names.files(parameters)
  
  dados_filtrados <- subset(arquivo$data, select = -c(.labelcount, .SCUMBLE))
  write.csv(dados_filtrados, names.files$name.csv, row.names = FALSE)
  
  check.labels(parameters, arquivo, names.files)
  
  retorno$dataset = arquivo
  return(arquivo)
}



##############################################################################
#' @title Dataset Analysis and Export
#'
#' @description
#' Analyzes a multi-label dataset using the `mldr` package, verifies label consistency with an associated XML file,
#' and exports relevant metadata (labels, labelsets, attributes, and dataset measures) to CSV files.
#' Useful for diagnostic and preprocessing steps in multi-label classification pipelines.
#'
#' @param parameters A list containing configuration elements, structured as:
#' \itemize{
#'   \item \code{parameters$Directories$FolderResults} - Directory where output files will be saved.
#'   \item \code{parameters$Dataset.Info$Name} - Dataset base name (used to locate .arff/.xml files).
#'   \item \code{parameters$Dataset.Info$LabelStart} - Starting column index for label columns in the dataset.
#'   \item \code{parameters$Dataset.Info$LabelEnd} - Ending column index for label columns in the dataset.
#' }
#'
#' @return A named list containing the following elements:
#' \itemize{
#'   \item \code{labelsNames} - Data frame of label indices and names.
#'   \item \code{labelsInfo} - Data frame with label-wise frequency and metrics.
#'   \item \code{labelSets} - Data frame with labelset combinations and their frequencies.
#'   \item \code{attInfo} - Data frame with the first 1000 attribute names and their types.
#'   \item \code{measures} - Data frame with global dataset statistics (e.g., cardinality, density).
#' }
#'
#' @examples
#' \dontrun{
#' parameters <- list(
#'   Directories = list(
#'     FolderResults = "~/Project/Results"
#'   ),
#'   Dataset.Info = list(
#'     Name = "emotions",
#'     LabelStart = 1,
#'     LabelEnd = 6
#'   )
#' )
#'
#' result <- dataset.analysis(parameters)
#' head(result$infoLabels)
#' }
#'
#' @importFrom mldr mldr
#' @importFrom xml2 read_xml xml_find_all xml_ns xml_attr
#' @export
dataset.analysis <- function(parameters) {
  retorno = list()
  
  arquivo = open.dataset(parameters)
  
  nomesRotulos = data.frame(rownames(arquivo$labels))
  index = seq(1, nrow(nomesRotulos), by = 1)
  nomesRotulos = data.frame(index, nomesRotulos)
  names(nomesRotulos) = c("index", "names.labels")
  name6 = paste0(parameters$Directories$FolderResults, "/label-names.csv")
  write.csv(nomesRotulos, name6, row.names = FALSE)
  retorno$labelsNames = nomesRotulos
  
  info.labels = data.frame(arquivo$labels)
  info.labels = data.frame(labels = rownames(info.labels), info.labels)
  rownames(info.labels) = NULL
  name1 = paste0(parameters$Directories$FolderResults,
                 "/label-measures.csv")
  write.csv(info.labels, name1, row.names = FALSE)
  retorno$labelsInfo = info.labels
  
  labelsets = data.frame(arquivo$labelsets)
  names(labelsets) = c("labelset", "frequency")
  name4 = paste0(parameters$Directories$FolderResults, "/label-sets.csv")
  write.csv(labelsets, name4, row.names = FALSE)
  retorno$labelSets = labelsets
  
  # AQUI TEM OS DE ENTRADA E SAÍDA
  att.indices = data.frame(arquivo$attributesIndexes)
  #n.c.all = ncol(att.indices) 
  #n.l.all = nrow(att.indices) # for EukaryoteGO is 12689
  #head(att.indices)
  
  # APENAS OS ATRIBUTOS DE ENTRADA
  att.type = data.frame(arquivo$attributes)
  names.att = rownames(att.type)
  #n.c.input = ncol(att.type)
  #n.l.input = nrow(att.type) # for EukaryoteGO is 12711
  #head(att.type)
  
  att.info = data.frame(names.att, att.type)
  rownames(att.info) = NULL
  
  att = data.frame(att.info[c(parameters$Dataset.Info$AttStart:parameters$Dataset.Info$AttEnd),])
  #head(att)
  #ncol(att) 
  #nrow(att)
  #head(att)
  
  # Suponha que você tenha dois dataframes: df1 e df2
  
  if (nrow(att) != nrow(att.indices)) {
    stop("Different number of attributes. Terminated. Check the attributes number.")
  }
  
  
  att.info = data.frame(index = att.indices, att)
  name5 = paste0(parameters$Directories$FolderResults, "/input-info.csv")
  write.csv(att.info, name5, row.names = FALSE)
  retorno$attInfo = att.info
  
  measures = data.frame(arquivo$measures)
  name5 = paste0(parameters$Directories$FolderResults,
                 "/dataset-measures.csv")
  write.csv(measures, name5, row.names = FALSE)
  retorno$measures = measures
  
  return(retorno)
  
  gc()
}




##############################################################################
#' Save Information for a Data Fold Split
#'
#' @description
#' This function saves structured information about a specific fold from a data splitting process, including label names, label sets, attribute information, and evaluation measures.
#' It organizes outputs into directories according to the type of split and data type, creating subfolders and exporting several CSV files for reproducibility and inspection.
#'
#' @param parameters A list containing configuration elements, especially the `Directories` list where folders for saving outputs are defined.
#' @param data A list containing the following elements:
#' - `labels`: A data frame with label information.
#' - `labelsets`: A data frame of label combinations and their frequencies.
#' - `attributesIndexes`: Indices of attributes used.
#' - `attributes`: Metadata or statistics related to attributes.
#' - `measures`: Performance measures or metrics calculated.
#' @param fold An integer specifying the fold number in the current data split.
#' @param type.split A string indicating the type of data split. Common values are `"iterative"` or `"stratified"`.
#' @param type.split A string identifying the data set type (e.g., `"Train"`, `"Test"`), used to determine folder naming.
#'
#' @return A list with the following elements:
#' - `nomesRotulos`: A data frame containing label names with their corresponding index.
#' - `info.labels`: A data frame containing detailed label information.
#' - `labelsets`: A data frame of label combinations and their frequencies.
#' - `attInfo`: A data frame with attribute indices and statistics.
#' - `measures`: A data frame with performance measures.
#'
#' @examples
#' \dontrun{
#' result <- save.fold.info(
#'   parameters = params,
#'   data = dataset,
#'   fold = 1,
#'   type.split = "iterative",
#'   type.split = "Train"
#' )
#' }
#'
#' @author Elaine Cecília Gatto - Cissa
save.fold.info <- function(parameters,
                           data,
                           fold,
                           type.strat,
                           type.split) {
  
  
  retorno = list()
  folderMain <- parameters$Directories[[paste0("Folder",
                                               ifelse(
                                                 tolower(type.strat) == "iterative",
                                                 "Iterative",
                                                 "Stratified"
                                               ))]]
  
  folderData <- parameters$Directories[[paste0("Folder", toupper(substr(type.strat, 1, 1)), type.split)]]
  folderInfo <- parameters$Directories[[paste0("Folder", toupper(substr(type.strat, 1, 1)), "Info")]]
  folderLabels <- parameters$Directories[[paste0("Folder", toupper(substr(type.strat, 1, 1)), "SL")]]
  folderNames <- parameters$Directories[[paste0("Folder", toupper(substr(type.strat, 1, 1)), "NL")]]
  
  info.folder = paste0(folderInfo, "/", type.split)
  if (dir.exists(info.folder) == FALSE) {
    dir.create(info.folder)
  }
  
  infoSplit = paste0(info.folder, "/Split-", fold)
  if (dir.exists(infoSplit) == FALSE) {
    dir.create(infoSplit)
  }
  
  nomesRotulos = data.frame(rownames(data$labels))
  index = seq(1, nrow(nomesRotulos), by = 1)
  nomesRotulos = data.frame(index, nomesRotulos)
  names(nomesRotulos) = c("index", "names.labels")
  name6 = paste0(infoSplit, "/label-names.csv")
  write.csv(nomesRotulos, name6, row.names = FALSE)
  retorno$nomesRotulos = nomesRotulos
  
  info.labels = data.frame(data$labels)
  info.labels = data.frame(labels = rownames(info.labels), info.labels)
  rownames(info.labels) = NULL
  name1 = paste0(infoSplit, "/label-info.csv")
  write.csv(info.labels, name1, row.names = FALSE)
  retorno$info.labels = info.labels
  
  labelsets = data.frame(data$labelsets)
  names(labelsets) = c("labelset", "frequency")
  name4 = paste0(infoSplit, "/label-sets.csv")
  write.csv(labelsets, name4, row.names = FALSE)
  retorno$labelsets = labelsets
  
  att.indices = data.frame(data$attributesIndexes)
  att.type = data.frame(data$attributes)
  names.att = rownames(att.type)
  att.info = data.frame(names.att, att.type)
  rownames(att.info) = NULL
  att = data.frame(att.info[c(parameters$Dataset.Info$AttStart:parameters$Dataset.Info$AttEnd),])
  
  if (nrow(att) != nrow(att.indices)) {
    stop("Different number of attributes. Terminated. Check the attributes number.")
  }
  
  name5 = paste0(infoSplit, "/input-info.csv")
  write.csv(att.info, name5, row.names = FALSE)
  retorno$attInfo = att.info
  
  measures = data.frame(data$measures)
  name5 = paste0(infoSplit, "/measures.csv")
  write.csv(measures, name5, row.names = FALSE)
  retorno$measures = measures
  
  return(retorno)
  
  gc()
}




#' Generate and Save Label Statistics and Metadata for Multi-Label Datasets
#'
#' @description
#' Computes and exports descriptive statistics and label-related properties 
#' of a multi-label dataset. It handles flexible label spaces and dynamically 
#' creates directory structures based on the data split type, fold number, 
#' and data subset (e.g., training, test, validation).
#'
#' This function is useful for tracking class imbalance, label concurrence,
#' and interactions across different data splits, especially in experimental 
#' settings such as cross-validation or stratified splits.
#'
#' @param parameters A list object containing metadata and directory configurations.
#'                   It must include the field `Directories`, which maps folder
#'                   names for each data type and split method.
#' @param data An `mldr` object containing the dataset, including both features
#'             and label matrix (accessible via `$dataset`).
#' @param fold An integer representing the current fold number used in the split.
#' @param type.split A string defining the splitting method: either `"stratified"` or `"iterative"`.
#' @param type.split A string indicating the data subset: `"Tr"` (train), `"Ts"` (test), or `"Vl"` (validation).
#'
#' @return No return value. The function creates and writes multiple summary files
#'         to disk, such as:
#' \itemize{
#'   \item `summary.csv`: Feature-level descriptive statistics.
#'   \item `label-matrix.txt`: Multi-dimensional contingency table of labels.
#'   \item `num-pos-neg.csv`: Positive and negative instance count for each label.
#'   \item `max-min-freq.csv`: Labels with highest and lowest frequencies.
#'   \item `zeros.csv` (if applicable): Labels with zero positive instances.
#'   \item `concurrence.pdf`: Label concurrence visualization (via `mldr`).
#'   \item `label-interactions.txt`: Label interaction details.
#' }
#'
#' @examples
#' \dontrun{
#'   parameters <- list(Directories = list(
#'     FolderIterativeTr = "/path/to/train",
#'     FolderIterativeInfo = "/path/to/info",
#'     FolderIterativeSL = "/path/to/SL",
#'     FolderIterativeNL = "/path/to/NL"
#'   ))
#'   data <- mldr::bibtex  # any mldr object
#'   properties.datasets(parameters, data, fold = 1, type.split = "iterative", type.split = "Tr")
#' }
#'
#' @author Elaine Cecilia Gatto - Cissa
#' 
#' @importFrom utils write.csv
#' @importFrom mldr concurrenceReport labelInteractions
#' @importFrom dplyr arrange
#'
#' @export
properties.datasets <- function(parameters,
                                data,
                                fold,
                                type.strat,
                                type.split) {
  
  folderMain <- parameters$Directories[[paste0("Folder",
                                               ifelse(
                                                 tolower(type.strat) == "iterative",
                                                 "Iterative",
                                                 "Stratified"
                                               ))]]
  
  folderData <- parameters$Directories[[paste0("Folder", toupper(substr(type.strat, 1, 1)), type.split)]]
  folderInfo <- parameters$Directories[[paste0("Folder", toupper(substr(type.strat, 1, 1)), "Info")]]
  folderLabels <- parameters$Directories[[paste0("Folder", toupper(substr(type.strat, 1, 1)), "SL")]]
  folderNames <- parameters$Directories[[paste0("Folder", toupper(substr(type.strat, 1, 1)), "NL")]]
  
  info.folder = paste0(folderInfo, "/", type.split)
  if (dir.exists(info.folder) == FALSE) {
    dir.create(info.folder)
  }
  
  infoSplit = paste0(info.folder, "/Split-", fold)
  if (dir.exists(infoSplit) == FALSE) {
    dir.create(infoSplit)
  }
  
  indices = get.label.indexes(parameters)
  
  data.sd = apply(data$dataset, 2, sd)
  data.mean = apply(data$dataset, 2, mean)
  data.median = apply(data$dataset , 2, median)
  data.sum = apply(data$dataset , 2, sum)
  data.max = apply(data$dataset , 2, max)
  data.min = apply(data$dataset , 2, min)
  data.quartis = apply(data$dataset, 2, quantile, 
                       probs = c(0.10, 0.25, 0.50, 0.75, 0.90))
  data.summary = rbind(
    sd = data.sd,
    mean = data.mean,
    median = data.median,
    sum = data.sum,
    max = data.max,
    min = data.min,
    quartis = data.quartis
  )
  name = paste0(infoSplit, "/summary.csv")
  write.csv(data.summary, name)
  
  ##################################################################
  labels = data$dataset[,indices]
  
  ##################################################################
  name = paste0(infoSplit, "/label-matrix.txt")
  sink(name )
  print(table(labels))
  sink()
  
  ##################################################################
  instances <- data.frame(
    label = names(labels),
    negative = colSums(labels == 0),
    positive = colSums(labels == 1)
  )
  rownames(instances) = NULL
  name = paste0(infoSplit, "/num-pos-neg.csv")
  write.csv(instances, name, row.names = FALSE)
  
  ##########################################################################
  negative = instances[,c(1:2)]
  negative = arrange(negative, desc(negative))
  ultimo.n = nrow(negative)
  max.n = data.frame(negative[1, ])
  min.n = data.frame(negative[ultimo.n, ])
  
  neg.max.label = max.n$label
  neg.max.freq = max.n$negative
  neg.min.label = min.n$label
  neg.min.freq = min.n$negative
  
  positive = instances[,c(1,3)]
  positive = arrange(positive, desc(positive))
  ultimo.p = nrow(positive)
  max.p = data.frame(positive[1, ])
  min.p = data.frame(positive[ultimo.p, ])
  
  pos.max.label = max.p$label
  pos.max.freq = max.p$positive
  pos.min.label = min.p$label
  pos.min.freq = min.p$positive
  
  final = cbind(pos.max.label, pos.max.freq, 
                pos.min.label, pos.min.freq,
                neg.max.label, neg.max.freq, 
                neg.min.label, neg.min.freq)
  name = paste0(infoSplit, "/max-min-freq.csv")
  write.csv(final, name, row.names = FALSE)
  
  ##########################################################################
  if (any(labels$count == 0)) {
    zero_counts <- labels.train[labels.train$count == 0, ]
    name = paste0(infoSplit, "zeros.csv")
    write.csv(zero_counts, name)
    message("\nClasses has zeros")
  } else {
    message("\nClasses has no Zeros")
  }
  
  #name = paste0(infoSplit, "/concurrence.pdf")
  #mldr::concurrenceReport(data, pdfOutput = TRUE, file = name)
  
  name = paste0(infoSplit, "/label-interactions.txt")
  sink(name )
  print(mldr::labelInteractions(data))
  sink()
  
}




#' Perform Cross-Validation Data Partitioning
#'
#' This function partitions a dataset into folds for cross-validation using both "iterative" 
#' and "stratified" sampling methods. For each fold, training, testing, and optionally validation 
#' sets are generated, saved as CSV and ARFF files, and dataset properties are computed.
#'
#' @param parameters A list containing the necessary configuration and dataset information, 
#' including directories, dataset details, number of folds, and validation settings.
#'
#' @return This function does not return a value explicitly. The outputs are saved as files 
#' in the directories specified within `parameters`.
#'
#' @examples
#' \dontrun{
#' params <- list(
#'   Dataset.Info = list(Name = "example_dataset", Labels = c(1:5)),
#'   Config.File = list(Number.Folds = 5, Validation = 1),
#'   Directories = list(
#'     FolderIterative = "path/to/iterative",
#'     FolderStratified = "path/to/stratified"
#'   )
#' )
#' compute.cv(params)
#' }
#'
#' @author Elaine Cecília Gatto
compute.cv <- function(parameters) {
  
  retorno = list()
  
  names.files = get.names.files(parameters)
  indices.labels = get.label.indexes(parameters)
  
  data = data.frame(read.csv(names.files$name.csv))
  
  arquivo.csv = mldr_from_dataframe(data,
                                    labelIndices = indices.labels,
                                    name = parameters$Dataset.Info$Name)
  
  #nome.csv = paste0(parameters$Directories$FolderResults,"/label-names.csv")
  #nomes = data.frame(read.csv(nome.csv))
  #arquivo.csv$labels
  
  check.labels(parameters, arquivo.csv, names.files)
  
  label.space = data.frame(data[,indices.labels])
  res.all = dependency(label.space)
  
  
  # arquivo.arff = mldr(name,
  #                     use_xml = TRUE,
  #                     xml_file = paste0(parameters$Directories$FolderDataset, "/", parameters$Dataset.Info$Name),
  #                     label_indices = indices.labels,
  #                     label_amount = parameters$Dataset.Info$Labels,
  #                     force_read_from_file = TRUE,
  #                     stringsAsFactors = TRUE)
  #
  # arquivo$dataset[, arquivo$labels$index] <-
  #   apply(arquivo$dataset[, arquivo$labels$index], 2, as.numeric)
  
  type.strat = c("iterative", "stratified")
  type.cap <- paste0(toupper(substring(type.strat, 1, 1)), substring(type.strat, 2))
  
  s = 1
  while (s <= length(type.strat)) {
    
    set.seed(1234)
    cv.data.iterative <- create_kfold_partition(arquivo.csv,
                                                parameters$Config.File$Number.Folds, 
                                                type.strat[s])
    cvDataFolds = cv.data.iterative$fold
    
    folds_df <- do.call(rbind, lapply(seq_along(cvDataFolds), function(fold) {
      data.frame(Fold = fold, Index = cvDataFolds[[fold]])
    }))
    
    name = file.path(parameters$Directories[[paste0("Folder", 
                                                    type.cap[s])]], 
                     "index-att-folds.csv")
    write.csv(folds_df, name, row.names = FALSE)
    
    base.folder = parameters$Directories[[paste0("Folder", type.cap[s])]]
    
    
    if (parameters$Config.File$Validation == 1) {
      
      label.dependency = data.frame()
      
      f = 1
      while (f <= parameters$Config.File$Number.Folds) {
        
        cat("\n#================================================")
        cat("\n#", type.strat[s], "                             ")
        cat("\n# WITH VALIDATION                                ")
        cat("\n# FOLD ", f, "                                   ")
        cat("\n#================================================")
        
        data.fold = partition_fold(cv.data.iterative, f, 
                                   has.validation = TRUE)
        treino = data.fold$train
        teste = data.fold$test
        validacao = data.fold$validation
        
        lbtr = treino$dataset[,indices.labels]
        res.tr = dependency(lbtr)
        
        lbts = teste$dataset[,indices.labels]
        res.ts = dependency(lbts)
        
        lbvl = validacao$dataset[,indices.labels]
        res.vl = dependency(lbvl)
        
        all = data.frame(fold = f,
                         train = res.tr$label.dependency,
                         test = res.ts$label.dependency,
                         val = res.vl$label.dependency)
        
        label.dependency = rbind(label.dependency, all)
        
        res.tr = save.fold.info(
          parameters,
          data = treino,
          fold = f,
          type.strat = type.strat[s],
          type.split = "Tr"
        )
        
        res.ts = save.fold.info(
          parameters,
          data = teste,
          fold = f,
          type.strat = type.strat[s],
          type.split = "Ts"
        )
        
        res.vl = save.fold.info(
          parameters,
          data = validacao,
          fold = f,
          type.strat = type.strat[s],
          type.split = "Vl"
        )
        
        csv_to_arff(parameters, 
                    save = file.path(base.folder, "CrossValidation", "Tr"), 
                    data = treino, fold = f, type.split = "Tr")
        
        csv_to_arff(parameters, 
                    save = file.path(base.folder, "CrossValidation", "Ts"), 
                    teste, f, type.split = "Ts")
        
        csv_to_arff(parameters,
                    save = file.path(base.folder, "CrossValidation", "Vl"), 
                    validacao, f, type.split = "Vl")
        
        properties.datasets(parameters,
                            data = treino,
                            fold = f,
                            type.strat = type.strat[s],
                            type.split = "Tr")
        
        properties.datasets(parameters,
                            data = teste,
                            fold = f,
                            type.strat = type.strat[s],
                            type.split = "Ts")
        
        properties.datasets(parameters,
                            data = validacao,
                            fold = f,
                            type.strat = type.strat[s],
                            type.split = "Vl")
        
        f = f + 1
        gc()
      } # fim do while
      
      name = paste0(base.folder, "/dependency.csv")
      write.csv(label.dependency, name, row.names = FALSE)
      
      
    } else {
      
      label.dependency = data.frame()
      
      f = 1
      while (f <= parameters$Config.File$Number.Folds) {
        
        cat("\n#================================================")
        cat("\n#", type.strat[s], "                             ")
        cat("\n# WITHOUT VALIDATION                             ")
        cat("\n# FOLD ", f, "                                   ")
        cat("\n#================================================")
        
        data.fold = partition_fold(cv.data.iterative, f, 
                                   has.validation = FALSE)
        treino = data.fold$train
        teste = data.fold$test
        
        lbtr = treino$dataset[,indices.labels]
        res.tr = dependency(lbtr)
        
        lbts = teste$dataset[,indices.labels]
        res.ts = dependency(lbts)
        
        all = data.frame(fold = f,
                         train = res.tr$label.dependency,
                         test = res.ts$label.dependency)
        
        label.dependency = rbind(label.dependency, all)
        
        res.tr = save.fold.info(
          parameters,
          data = treino,
          fold = f,
          type.strat = type.strat[s],
          type.split = "Tr"
        )
        
        res.ts = save.fold.info(
          parameters,
          data = teste,
          fold = f,
          type.strat = type.strat[s],
          type.split = "Ts"
        )
        
        csv_to_arff(parameters, 
                    save = file.path(base.folder, "CrossValidation", "Tr"), 
                    data = treino, fold = f, type.split = "Tr")
        
        csv_to_arff(parameters, 
                    save = file.path(base.folder, "CrossValidation", "Ts"), 
                    teste, f, type.split = "Ts")
        
        properties.datasets(parameters,
                            data = treino,
                            fold = f,
                            type.strat = type.strat[s],
                            type.split = "Tr")
        
        properties.datasets(parameters,
                            data = teste,
                            fold = f,
                            type.strat = type.strat[s],
                            type.split = "Ts")
        
        
        f = f + 1
        gc()
      } # fim do while
      
      name = paste0(base.folder, "/dependency.csv")
      write.csv(label.dependency, name, row.names = FALSE)
      
    } # fim do else
    
    s = s + 1
    gc()
  } # end iterative OR stratified
  
} # end function



#' @title Compute Label Dependency Across Cross-Validation Folds
#'
#' @description
#' Computes the average label dependency metric for each fold in a multi-label cross-validation setup,
#' based on the method proposed by Luaces et al. (2012).
#' The dependency is calculated using a combination of Pearson correlation and label co-occurrence.
#'
#' @param parameters A list containing the following elements:
#' \itemize{
#'   \item \code{parameters$Config.File$Number.Folds} - Total number of folds used in cross-validation.
#'   \item \code{parameters$LabelSpace$Classes} - A list of binary label matrices (one per fold).
#'   \item \code{parameters$Directories$FolderLocal} - Path where the output CSV file will be saved.
#' }
#'
#' @return A data frame with two columns:
#' \itemize{
#'   \item \code{fold} - Fold index.
#'   \item \code{dependency.label} - Average label dependency for that fold.
#' }
#'
#' @examples
#' \dontrun{
#' parameters <- list(
#'   Config.File = list(Number.Folds = 5),
#'   LabelSpace = list(Classes = list(fold1 = data.frame(...), ...)),
#'   Directories = list(FolderLocal = "./results")
#' )
#'
#' result <- compute.label.dependecy(parameters)
#' print(result)
#' }
#'
#' @seealso \code{\link{dependency}} for the dependency computation logic.
#' @export
compute.label.dependecy <- function(parameters) {
  
  final <- data.frame(fold = integer(), dependency.label = numeric())
  
  for (f in seq_len(parameters$Config.File$Number.Folds)) {
    cat("\nFold", f)
    
    label.space <- as.data.frame(parameters$LabelSpace$Classes[[f]])
    res <- dependency(label.space)
    
    final <- rbind(final,
                   data.frame(
                     fold = f,
                     dependency.label = res$label.dependency
                   ))
  }
  
  write.csv(
    final,
    file.path(
      parameters$Directories$FolderLocal,
      "label_dependencies.csv"
    ),
    row.names = FALSE
  )
  
  return(final)
}



##################################################################
#' @title Compute Label Dependency for a Binary Label Matrix
#'
#' @description
#' Computes the label dependency value based on the approach from Luaces et al. (2012),
#' using the Pearson correlation of label pairs, weighted by their co-occurrence.
#' It only considers the lower triangle of the pairwise matrix to avoid redundancy.
#'
#' @param label.space A binary matrix or data frame (instances × labels), where 1 indicates label presence.
#'
#' @return A list with:
#' \itemize{
#'   \item \code{label.dependency} - A numeric value representing the overall label dependency.
#' }
#'
#' @examples
#' label.space <- matrix(c(1,0,1, 0,1,1, 1,1,0), ncol=3, byrow=TRUE)
#' result <- dependency(label.space)
#' print(result$label.dependency)
#'
#' @references
#' Luaces, O., Díez, J., Barranquero, J., del Coz, J. J., & Bahamonde, A. (2012).
#' Binary relevance efficacy for multilabel classification. Progress in Artificial Intelligence, 1(4), 303–313.
#'
#' @import Matrix
#' @export
dependency <- function(label.space) {
  retorno <- list()
  
  library(Matrix)
  label.space <- Matrix(as.matrix(label.space), sparse = TRUE)
  label.space <- as(as.matrix(label.space), "dgCMatrix")
  
  pearson.matrix <- cor(as.matrix(label.space), method = "pearson")
  pearson.matrix[is.na(pearson.matrix)] <- 0
  
  intersection.matrix <- t(label.space) %*% label.space
  intersection.matrix <- as.matrix(intersection.matrix)
  
  pearson.abs <- abs(pearson.matrix)
  pearson.abs[upper.tri(pearson.abs)] <- 0
  intersection.matrix[upper.tri(intersection.matrix)] <- 0
  
  produto <- pearson.abs * intersection.matrix
  
  soma_produto <- sum(produto)
  soma_intersecoes <- sum(intersection.matrix)
  
  retorno$label.dependency <- if (soma_intersecoes > 0) {
    soma_produto / soma_intersecoes
  } else {
    0
  }
  
  return(retorno)
}



##################################################################################################
# Please, any errors, contact us: elainececiliagatto@gmail.com                                   #
# Thank you very much!                                                                           #
##################################################################################################