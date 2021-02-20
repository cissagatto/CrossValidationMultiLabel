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
#
##################################################################################################
partition <- function(ds, dataset_name, namesLabels, Folder){
  
  retorno = list()
  
  # número de elementos (rótulos)
  num.labels = ds$Labels
  cat("\nNumber of Labels: ", num.labels)
  
  # partições geradas por bell
  num.partitions = bell(num.labels)
  cat("\nNumber of Partitions: ", num.partitions)
  
  # partições geradas
  BellPartitions = listParts(num.labels, do.set=FALSE)
  #cat("\nList Bell Partitions: ")
  #print(BellPartitions)
  
  # ordenando o vetor de nomes de rótulos
  ordem.labels = sort(namesLabels, index.return = TRUE)
  
  # criando um data frame que tem o número e o nome do rótulo
  rotulos = data.frame(ordem.labels)
  names(rotulos) = c("rotulos","indice")
  
  cat("\nNames Labels\n")
  print(rotulos)
  
  # data frame para salvar as partições geradas
  part = c(0)
  group = c(0)
  id_labels = c(0)
  particoes = data.frame(part, group, id_labels)
  
  # data frame para salvar a quantidade de grupos dentro de cada partição
  totalGroups = c(0)
  groupsPerPartitions = data.frame(part, totalGroups)
  
  # organizando as informações das partições em um data frame
  cat("\nStart replace numbers per names labels")
  n = length(BellPartitions)
  p = 1
  for(p in 1:n){
    cat("\nPartition: ", p)
    m = length(BellPartitions[[p]])
    part = p
    totalGroups = m
    groupsPerPartitions = rbind(groupsPerPartitions, data.frame(part, totalGroups))
    
    g = 1
    for(g in 1:m){
      #cat("\n\tGroup: ", g)
      h = as.data.frame(BellPartitions[[p]][g])
      colnames(h)[1] = "X"
      part = p
      group = g
      id_labels = h$X
      b = data.frame(part, group, id_labels)
      particoes = rbind(particoes, b)
      g = g + 1
      gc()
    } # fim do grupo
    
    p = p +1
    gc()
  } # fim da partição
  
  # organizando as partições
  particoes = particoes[-1,]
  id = seq(1, nrow(particoes), by=1)
  particoes2 = cbind(id, particoes)
  #head(particoes3)
  
  # Associando os nomes dos rótulos com os índices dos rótulos
  labels=particoes2$id_labels
  particoes3 = cbind(particoes2, labels)
  rotulos2 = rotulos[order(rotulos$indice , decreasing = FALSE), ] 
  j = 1
  while(j<=num.labels){
    particoes3$labels[particoes3$labels == j] <- rotulos2$rotulos[j]  
    j = j + 1
  }
  
  groupsPerPartitions = groupsPerPartitions[-1,]
  
  countPartitions = count(groupsPerPartitions, vars = groupsPerPartitions$totalGroups)
  colnames(countPartitions) = c("groups", "total")
  
  # salvando as informações
  setwd(Folder)
  write.csv(particoes3, paste(dataset_name, "-partitions.csv", sep=""))
  write.csv(groupsPerPartitions, paste(dataset_name, "-groupsPerPartitions.csv", sep=""))
  write.csv(countPartitions, paste(dataset_name, "-countPartitions.csv", sep=""))
  
  # return
  retorno$numPartitions = num.partitions
  retorno$BellPartitions = BellPartitions
  retorno$labelsNumber = num.labels
  retorno$labelsOrder = ordem.labels
  retorno$labelsNames = rotulos
  retorno$partitions = particoes3
  retorno$groupsPerPartitions = groupsPerPartitions
  return(retorno)
  
  setwd(Folder)
  write_rds(retorno, "results.rds")
  save(retorno, "results.RData")
  
  gc()
  
  cat("\n##################################################################################################")
  cat("\n# Compute Partitions: END                                                                        #") 
  cat("\n##################################################################################################")
  cat("\n\n\n\n")
  
}


##################################################################################################
# Please, any errors, contact us: elainececiliagatto@gmail.com                                   #
# Thank you very much!                                                                           #
##################################################################################################
