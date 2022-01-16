##################################################################################################

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
FolderScripts = paste(FolderRoot, "/R", sep="")

library(stringr)

setwd(FolderRoot)
datasets = data.frame(read.csv("datasets-2022.csv"))
n = nrow(datasets)

FolderJob = paste(FolderRoot, "/JobsEuler", sep="")
if(dir.exists(FolderJob)==FALSE){dir.create(FolderJob)}

i = 1
  while(i<=n){

    dataset = datasets[i,]
    cat("\n\tDataset:", dataset$Name)

    nome = paste(FolderJob, "/cv-", dataset$Name, ".sh", sep="")
    output.file <- file(nome, "wb")

    write("#!/bin/bash", file = output.file)

    write("#PBS -l select=1:ncpus=10", file = output.file, append = TRUE)

    write("#PBS -l walltime=128:00:00", file = output.file, append = TRUE)

    write("#PBS -m abe", file = output.file, append = TRUE)

    write("#PBS -M elainegatto@estudante.ufscar.br", file = output.file,
          append = TRUE)

    write(" ", file = output.file, append = TRUE)

    write("eval \"$(conda shell.bash hook)\" ", file = output.file,
          append = TRUE)

    write("conda activate hpml", file = output.file, append = TRUE)

    str7 = paste("Rscript /mnt/nfs/home/elaine/CrossValidationMultiLabel/R/cvm.R ",
                 dataset$Id, " 10 10 ", "\"/lustre/elaine/cv-",
                 dataset$Name, "\"", sep="")

    write(str7, file = output.file, append = TRUE)

    write("cd /lustre/elaine/", file = output.file, append = TRUE)

    #str8 = paste("rm -r \"/lustre/elaine/bdfg-", dataset$Name,"\"", sep="")

    str8 = paste("rm -r /lustre/elaine/cv-", dataset$Name, "\"", sep="")

    write(str8, file = output.file, append = TRUE)

    close(output.file)
    
    

    i = i + 1
    gc()
  }
