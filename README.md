# CrossValidationMultiLabel
A code to execute and save a cross validation in multilabel classification. This code is part of my doctoral research.

## Scripts
This source code consists of a R project for R Studio and the following R scripts:

1. libraries
2. utils
3. CrossValidationMultiLabel
4. main
5. cvm

## Multi-Label Datasets
You can download the multi-label datasets in this link: https://cometa.ujaen.es/datasets/

## Jars
Confirms if the folder UTILS contains the following files: Clus.jar, R_csv_2_arff.jar and weka.jar. Without these jars the code not runs. 

## Datasets Folder
After downloading the dataset you want to use, place it in the */CrossValidationMultilabel/Datasets/Originals* folder. Don't forget that the .xml and .arff files of the respective dataset are needed.

## Folder Path
Place a copy of this code in _"C:/Users/[username]/CrossValidationMultilabel"_ or _"/home/username/CrossValidationMultilabel"_. Our files are configured to obtain the paths of the folders from the root. You can change this in the code if you want.

## File "datasets.csv"
A file called "datasets.csv" must be in the *datasets* folder. This file is used to read informations about the datasets and they are used in the code. All 74 datasets available in cometa are in this file. If you want to use another dataset, please, add the following information about the dataset in the file:

_Id, Name, Domain, Labels, Instances, Attributes, Inputs, Labelsets, Single, Max freq, Card, Dens, MeanIR, Scumble, TCS, AttStart, AttEnd, LabelStart, LabelEnd_

The _"Id"_ of the dataset is a mandatory parameter (_n_dataset_) in the command line to run all code. The "LabelStart" and "LabelEnd" are used in a lot of internal functions. Please, make sure that these information are available before run the code.

# Run

```
Rscript cvm.R [number_dataset] [number_folds]
```

Example:

```
Rscript cvm.R 2 5
```

## Acknowledgment
This study is financed in part by the Coordenação de Aperfeiçoamento de Pessoal de Nível Superior - Brasil (CAPES) - Finance Code 001

## Links

[Post Graduate Program in Computer Science](http://ppgcc.dc.ufscar.br/pt-br)

[Biomal](http://www.biomal.ufscar.br/)

[Computer Department](https://site.dc.ufscar.br/)

[CAPES](https://www.gov.br/capes/pt-br)

[Embarcados](https://www.embarcados.com.br/author/cissa/)

[Linkedin](https://www.linkedin.com/in/elainececiliagatto/)

[Linkedin](https://www.linkedin.com/company/27241216)

[Instagram](https://www.instagram.com/professoracissa/)

[Facebook](https://www.facebook.com/ProfessoraCissa/)

[Twitter](https://twitter.com/professoracissa)

# Thanks
