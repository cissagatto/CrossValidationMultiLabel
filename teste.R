# Pacote para ler arquivos ARFF
#install.packages("foreign")  # ou use 'RWeka'
# library(foreign)
library(RWeka)

arff_file <- "/home/cissagatto/CrossValidationMultiLabel/Datasets/ng20.arff"
dados <- RWeka::read.arff(arff_file)

labels_xml <- c(
  "comp.os_ms_windows_misc",
  "religion.rmisc",
  "rec.sport.baseball",
  "sci.space",
  "comp.sys.mac_hardware",
  "sci.med",
  "politics.pmisc",
  "rec.autos",
  "misc_forsale",
  "politics.mideast",
  "rec.motorcycles",
  "politics.guns",
  "rec.sport.hockey",
  "comp.sys.ibm_pc_hardware",
  "comp.graphics",
  "sci.crypt",
  "sci.electronics",
  "religion.christian",
  "religion.atheism",
  "comp.windows_x"
)

atributos <- dados[ , !(names(dados) %in% labels_xml) ]
rotulos   <- dados[ , labels_xml ]

dados_reordenados <- cbind(atributos, rotulos)
setwd()
write.arff(dados_reordenados, file = "ng20_labels_at_end.arff")
