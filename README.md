# CrossValidationMultiLabel
A code to execute and save cross-validation in multilabel classification. This code is part of my doctoral research.

## Scripts
This source code consists of an R project for R Studio and the following R scripts:

1. libraries
2. utils
3. CrossValidationMultiLabel
4. main
5. cvm

## Multi-Label Datasets
You can download the multi-label datasets at this link: https://cometa.ujaen.es/datasets/

## Jars
Confirms if the folder UTILS contains the following files: Clus.jar, R_csv_2_arff.jar, and weka.jar. Without these jars, the code not runs. 

## Datasets Folder
After downloading the dataset you want to use, place it in the */CrossValidationMultilabel/Datasets/Originals* folder. Don't forget that the .xml and .arff files of the respective dataset are needed.

## Folder Path
Place a copy of this code in _"C:/Users/[username]/CrossValidationMultiLabel"_ or _"/home/username/CrossValidationMultiLabel"_. Our files are configured to obtain the paths of the folders from the root. You can change this in the code if you want.

## File "datasets.csv"
A file called *datasets.csv* must be in the root project folder. This file is used to read information about the datasets and they are used in the code. All 74 datasets available in cometa (https://cometa.ujaen.es/) are in this file. If you want to use another dataset, please, add the following information about the dataset in the file:

*Id, Name, Domain, Labels, Instances, Attributes, Inputs, Labelsets, Single, Max freq, Card, Dens, MeanIR, Scumble, TCS, AttStart, AttEnd, LabelStart, LabelEnd, xn, yn, gridn*

The _"Id"_ of the dataset is a mandatory parameter in the command line to run all code. The fields are used in a lot of internal functions. Please, make sure that this information is available before running the code. *xn* and *yn* correspond to a dimension of the quadrangular map for kohonen, and *gridn* is *xn* * *yn*. Example: xn = 4, yn = 4, gridn = 16.

# Run

```
Rscript cvm.R [number_dataset] [number_folds] [validation]
```

Where:

_number_dataset_ is the dataset number in the datasets.csv file

_number_folds_ is the number of folds you want for cross-validation

_validation_ 0 if you dont want the validation set and 1 if you want


Example:

With Validation
```
Rscript cvm.R 2 5 1
```

This code will generate a 5 folds cross-valdation for the birds dataset with train, test and validation sets.


Whithout Validation
```
Rscript cvm.R 2 6 0
```

This code will generate a 6 folds cross-valdation for the birds dataset with train and test sets.

## Acknowledgment
This study is financed in part by the Coordenação de Aperfeiçoamento de Pessoal de Nível Superior - Brasil (CAPES) - Finance Code 001

## Links

[Post-Graduate Program in Computer Science](http://ppgcc.dc.ufscar.br/pt-br)

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
