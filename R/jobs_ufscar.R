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
FolderRoot = "~/CrossValidationMultiLabel"
FolderScripts = paste(FolderRoot, "/R/", sep = "")

library(stringr)

setwd(FolderRoot)
datasets = data.frame(read.csv("datasets-original.csv"))
n = nrow(datasets)

FolderJob = paste(FolderRoot, "/Jobs-CV", sep = "")
if (dir.exists(FolderJob) == FALSE) {
  dir.create(FolderJob)
}


i = 1
while (i <= n) {
  dataset = datasets[i, ]
  cat("\n\tDataset:", dataset$Name)
  
  nome = paste(FolderJob, "/", dataset$Name, ".sh", sep = "")
  output.file <- file(nome, "wb")
  
  write("#!/bin/bash", file = output.file)
  
  str1 = paste("#SBATCH -J ", dataset$Name, sep = "")
  write(str1, file = output.file, append = TRUE)
  
  write("#SBATCH -o %j.out", file = output.file, append = TRUE)
  
  write("#SBATCH -n 1", file = output.file, append = TRUE)
  
  write("#SBATCH -c 10", file = output.file, append = TRUE)
  
  #write("#SBATCH --partition fast", file = output.file, append = TRUE)
  
  write("#SBATCH -t 128:00:00", file = output.file, append = TRUE)
  
  write(
    "#SBATCH --mail-user=elainegatto@estudante.ufscar.br",
    file = output.file,
    append = TRUE
  )
  
  write("#SBATCH --mail-type=ALL",
        file = output.file,
        append = TRUE)
  
  write("", file = output.file, append = TRUE)
  
  str2 = paste("local_job=",  "\"/scratch/", dataset$Name, "\"", sep =
                 "")
  write(str2, file = output.file, append = TRUE)
  
  write("", file = output.file, append = TRUE)
  
  write("function clean_job(){", file = output.file, append = TRUE)
  
  str3 = paste(" echo", "\"Limpando ambiente...\"", sep = " ")
  write(str3, file = output.file, append = TRUE)
  
  str4 = paste(" rm -rf ", "\"${local_job}\"", sep = "")
  write(str4, file = output.file, append = TRUE)
  
  write("}", file = output.file, append = TRUE)
  
  write("", file = output.file, append = TRUE)
  
  write("trap clean_job EXIT HUP INT TERM ERR",
        file = output.file,
        append = TRUE)
  
  write("", file = output.file, append = TRUE)
  
  write("set -eE", file = output.file, append = TRUE)
  
  write("", file = output.file, append = TRUE)
  
  write("umask 077", file = output.file, append = TRUE)
  
  write("", file = output.file, append = TRUE)
  
  str5 = paste("echo RUN ", dataset$Name, sep = "")
  write(str5, file = output.file, append = TRUE)
  
  write("", file = output.file, append = TRUE)
  
  write(
    "source /home/u704616/miniconda3/etc/profile.d/conda.sh",
    file = output.file,
    append = TRUE
  )
  
  write("conda activate AmbienteTeste", file = output.file, append = TRUE)
  
  str7 = paste(
    "Rscript /home/u704616/CrossValidationMultiLabel/R/cvm.R ",
    dataset$Id,
    " 10 10 1 ",
    "\"/scratch/",
    dataset$Name,
    "\"",
    sep = ""
  )
  write(str7, file = output.file, append = TRUE)
  
  close(output.file)
  
  i = i + 1
  gc()
}
