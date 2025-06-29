##################################################################################################
# Cross Validation MultiLabel - Libraries Setup                                                  #
# Copyright (C) 2025                                                                             #
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
##################################################################################################

##################################################################################################
# SET WORKSPACE                                                                                  #
##################################################################################################

library(here)
library(stringr)
FolderRoot <- here::here()
FolderScripts <- here::here("R")

##################################################################################################
# Install and Load Required Packages                                                             #
# This script verifies whether the required R packages are installed.                           #
# If not, installs them automatically and loads them into the session.                           #
# Supports CRAN and GitHub packages.                                                            #
##################################################################################################

# List of required CRAN packages
cran_packages <- c(
  "readr", "foreign", "stringr", "rJava", "RWeka", "mldr", "xml2",
  "parallel", "utiml", "foreach", "doParallel", "dplyr", "here"
)

# Base packages (already included with R)
base_packages <- c("parallel")

# GitHub packages: named list with package name and corresponding repository
github_packages <- list(
  # Adicione aqui se houver pacotes do GitHub, exemplo:
  # ExamplePkg = "usuario/repositorio"
)

# Install a single CRAN package if not already installed
install_cran_package <- function(pkg) {
  if (!require(pkg, character.only = TRUE, quietly = TRUE)) {
    message(paste("Installing CRAN package:", pkg))
    tryCatch({
      install.packages(pkg, dependencies = TRUE)
      library(pkg, character.only = TRUE, quietly = TRUE)
      message(paste("Package", pkg, "successfully installed."))
    }, error = function(e) {
      message(paste("Error installing package", pkg, ":", e$message))
    })
  } else {
    message(paste("Package", pkg, "is already installed."))
  }
}

# Install a single GitHub package if not already installed
install_github_package <- function(pkg, repo) {
  if (!require(pkg, character.only = TRUE, quietly = TRUE)) {
    if (!require("devtools", character.only = TRUE, quietly = TRUE)) {
      install.packages("devtools")
      library(devtools, quietly = TRUE)
    }
    message(paste("Installing GitHub package:", pkg))
    tryCatch({
      devtools::install_github(repo)
      library(pkg, character.only = TRUE, quietly = TRUE)
      message(paste("Package", pkg, "successfully installed."))
    }, error = function(e) {
      message(paste("Error installing GitHub package", pkg, ":", e$message))
    })
  } else {
    message(paste("Package", pkg, "is already installed."))
  }
}

# Load base packages
for (pkg in base_packages) {
  library(pkg, character.only = TRUE, quietly = TRUE)
  message(paste("Base package", pkg, "loaded."))
}

# Install and load CRAN packages
for (pkg in cran_packages) {
  install_cran_package(pkg)
}

# Install and load GitHub packages (if applicable)
for (pkg in names(github_packages)) {
  install_github_package(pkg, github_packages[[pkg]])
}

message("✅ All packages have been successfully verified and installed!")


##################################################################################################
# Please, any errors, contact us: elainececiliagatto@gmail.com                                   #
# Thank you very much!                                                                           #
##################################################################################################
