# CrossValidationMultiLabel
A code to execute and save cross-validation in multilabel classification. This code is part of my doctoral research.

# How to cite 
@misc{Gatto2021, author = {Gatto, E. C.}, title = {Cross-Validation for MultiLabel Classification}, year = {2021}, publisher = {GitHub}, journal = {GitHub repository}, howpublished = {\url{https://github.com/cissagatto/CrossValidationMultiLabel}}}

## Scripts
This source code consists of an R project for R Studio and the following R scripts:

1. libraries
2. utils
3. CrossValidationMultiLabel
4. main
5. cvm
6. generateJobsConda

## Multi-Label Datasets
You can download the multi-label datasets at this link: https://cometa.ujaen.es/datasets/

## Preparing your experiment

### Step-1
Confirms if the folder *utils* contains the following files: *Clus.jar*, *R_csv_2_arff.jar*, and *weka.jar*, and also the folder *lib* with *commons-math-1.0.jar*, *jgap.jar*, weka.jar and *Clus.jar.* Without these jars, the code not runs. 

### Step-2
Place a copy of this code in _C:/Users/[username]/CrossValidationMultiLabel or _/home/[username]/CrossValidationMultiLabel. Our files are configured to obtain the paths of the folders from this path. You can change this in the code if you want.

### Step-3
A file called _datasets.csv_ must be in the *root project* folder. This file is used to read information about the datasets and they are used in the code. All 74 datasets available in *Cometa* are in this file. If you want to use another dataset, please, add the following information about the dataset in the file:

_Id, Name, Domain, Labels, Instances, Attributes, Inputs, Labelsets, Single, Max freq, Card, Dens, MeanIR, Scumble, TCS, AttStart, AttEnd, LabelStart, LabelEnd, xn, yn, gridn_

The *Id* of the dataset is a mandatory parameter in the command line to run all code. The fields are used in a lot of internal functions. Please, make sure that this information is available before running the code. *xn* and *yn* correspond to a dimension of the quadrangular map for kohonen, and *gridn* is (xn * yn). Example: xn = 4, yn = 4, gridn = 16.

# Run

```
Rscript cvm.R [number_dataset] [number_cores] [number_folds] [validation] [folder]
```

Where:

_number_dataset_ is the dataset number in the datasets.csv file

_number_cores_ is the number of cores that you wanto to use in paralel

_number_folds_ is the number of folds you want for cross-validation

_validation_ 0 if you dont want the validation set and 1 if you want

_folder_ temporary folder like SHM or SCRATCH to speed up the process

Example:

With Validation
```
Rscript cvm.R 2 10 10 1 "/dev/shm/results"
```

This code will generate a 10 folds cross-valdation, using 20 cores, for the birds (2) dataset with train, test and validation sets.


Whithout Validation
```
Rscript cvm.R 2 1 10 0 "/dev/shm/cv"
```

This code will generate a 10 folds cross-valdation, using 1 core, for the birds (2) dataset with train and test sets.

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

# Report Error

Please contact me: elainececiliagatto@gmail.com

# Thanks
