# CrossValidationMultiLabel
A code to execute and save cross-validation in multilabel classification. This code is part of my doctoral research.

# How to cite 
@misc{Gatto2022, author = {Gatto, E. C.}, title = {Cross-Validation for MultiLabel Classification}, year = {2022}, publisher = {GitHub}, journal = {GitHub repository}, howpublished = {\url{https://github.com/cissagatto/CrossValidationMultiLabel}}}

## Scripts
This source code consists of an R project for R Studio and the following R scripts:

1. libraries
2. utils
3. CrossValidationMultiLabel
4. main
5. cvm


## Multi-Label Datasets
You can download the multi-label datasets at this link: https://cometa.ujaen.es/datasets/

## Preparing your experiment

### Step-1
Confirms if the folder *utils* contains the following files: *Clus.jar*, *R_csv_2_arff.jar*, and *weka.jar*, and also the folder *lib* with *commons-math-1.0.jar*, *jgap.jar*, weka.jar and *Clus.jar.* Without these jars, the code not runs. 

### Step-2
Copy this code and place it where you want. The folder configurations is "~/CrossValidationMultiLabel"

### Step-3
A file called _datasets-original.csv_ must be in the *root project folder*. This file is used to read information about the datasets and they are used in the code. We have 90 multilabel datasets in this _.csv_ file. If you want to use another dataset, please, add the following information about the dataset in the file:


| Parameter    | Status    | Description                                           |
|------------- |-----------|-------------------------------------------------------|
| Id           | mandatory | Integer number to identify the dataset                |
| Name         | mandatory | Dataset name (please follow the benchmark)            |
| Domain       | optional  | Dataset domain                                        |
| Instances    | mandatory | Total number of dataset instances                     |
| Attributes   | mandatory | Total number of dataset attributes                    |
| Labels       | mandatory | Total number of labels in the label space             |
| Inputs       | mandatory | Total number of dataset input attributes              |
| Cardinality  | optional  |                                                       |
| Density      | optional  |                                                       |
| Labelsets    | optional  |                                                       |
| Single       | optional  |                                                       |
| Max.freq     | optional  |                                                       |
| Mean.IR      | optional  |                                                       | 
| Scumble      | optional  |                                                       | 
| TCS          | optional  |                                                       | 
| AttStart     | mandatory | Column number where the attribute space begins*       | 
| AttEnd       | mandatory | Column number where the attribute space ends          |
| LabelStart   | mandatory | Column number where the label space begins            |
| LabelEnd     | mandatory | Column number where the label space ends              |
| Distinct     | optional  |                                                       |
| xn           | mandatory | Value for Dimension X of the Kohonen map              | 
| yn           | mandatory | Value for Dimension Y of the Kohonen map              |
| gridn        | mandatory | X times Y value. Kohonen's map must be square         |
| max.neigbors | mandatory | The maximum number of neighbors is given by LABELS -1 |

* Because it is the first column the number is always 1.


## STEP 4
You need to have installed all the R packages required to execute this code on your machine. Check out which are needed in the file *libraries.R*. This code does not provide any type of automatic package installation! You can use the Conda environment that I created to perform this experiment. Below are the links to download the files.

| [download txt](https://www.4shared.com/s/fUCVTl13zea) | [download yml](https://www.4shared.com/s/f8nOZyxj9iq) | [download yaml](https://www.4shared.com/s/fk5Io4faLiq) |


# Run

To run, first enter the folder ~/CrossValidationMultiLabel/R in a terminal and the type:

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

1. With Validation
```
Rscript cvm.R 2 10 10 1 "/dev/shm/results"
```

This code will generate a 10 folds cross-valdation, using 10 cores, for the birds (2) dataset with train, test and validation sets. If you send _number_folds_ = 1 the code will break. For now, this code is specifcally to build a X-Fold Cross-Validation file. Then, you need to pass a value greater than 1 to _number_folds_ parametrer. If you want to use holdout, please consulte the UTIML tutorial https://github.com/rivolli/utiml.


2. Whithout Validation
```
Rscript cvm.R 2 1 10 0 "/dev/shm/cv"
```

This code will generate a 10 folds cross-valdation, using 1 core, for the birds (2) dataset with train and test sets.

## Folder Structure
<img src="https://github.com/cissagatto/CrossValidationMultiLabel/blob/main/images/folder_strucutre_mlcv.png" width="300">

## DOWNLOAD RESULTS
[Click here](https://1drv.ms/u/s!Aq6SGcf6js1mrZJSfd6FpToCtGVqJw?e=NxaBfW)

## Acknowledgment
This study is financed in part by the Coordenação de Aperfeiçoamento de Pessoal de Nível Superior - Brasil (CAPES) - Finance Code 001

## Links

| [Site](https://sites.google.com/view/professor-cissa-gatto) | [Post-Graduate Program in Computer Science](http://ppgcc.dc.ufscar.br/pt-br) | [Computer Department](https://site.dc.ufscar.br/) |  [Biomal](http://www.biomal.ufscar.br/) | [CNPQ](https://www.gov.br/cnpq/pt-br) | [Ku Leuven](https://kulak.kuleuven.be/) | [Embarcados](https://www.embarcados.com.br/author/cissa/) | [Read Prensa](https://prensa.li/@cissa.gatto/) | [Linkedin Company](https://www.linkedin.com/company/27241216) | [Linkedin Profile](https://www.linkedin.com/in/elainececiliagatto/) | [Instagram](https://www.instagram.com/cissagatto) | [Facebook](https://www.facebook.com/cissagatto) | [Twitter](https://twitter.com/cissagatto) | [Twitch](https://www.twitch.tv/cissagatto) | [Youtube](https://www.youtube.com/CissaGatto) |

## Report Error
Please contact me: elainececiliagatto@gmail.com

# Thanks
