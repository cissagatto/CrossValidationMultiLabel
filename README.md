# X-Folds Cross Validation MultiLabel
A code to execute and save cross-validation in multilabel classification. This code is part of my doctoral research.


## How to Cite 📑
If you use this code in your research, please cite the following:

```bibtex
@misc{Gatto2025,
  author = {Gatto, E. C.},
  title = {Cross-Validation Multi-Label Classification},
  year = {2025},
  publisher = {GitHub},
  journal = {GitHub repository},
  howpublished = {\url{https://github.com/cissagatto/CrossValidationMultiLabel}}
}
```

## 🗂️ Project Structure

The codebase includes R scripts in `/R` folder:

* `config-files.R`
* `libraries.R`
* `utils.R`
* `CrossValidationMultiLabel.R`
* `main.R`
* `cvm.R`

## Multi-Label Datasets

Below are some reliable repositories where you can download datasets for multi-label classification tasks:

- [COMETA Dataset Collection (University of Jaén)](https://cometa.ujaen.es/datasets/): A diverse collection of datasets for multi-label learning, designed for standardized benchmarking and experimentation.

- [MLL Resources (University of Córdoba)](https://www.uco.es/kdis/mllresources/): A repository of widely used datasets in multi-label machine learning research, covering various domains.

- [Extreme Classification Repository (Microsoft Research / Manik Varma)](http://manikvarma.org/downloads/XC/XMLRepository.html): A collection of large-scale datasets for extreme multi-label classification, with millions of labels, suitable for high-dimensional problems.

> 💡 These resources are useful for training and evaluating multi-label classification algorithms across a range of domains, such as text, image, and structured data.


## ⚙️ How to Reproduce the Experiment

### Step-1
Confirms if the folder *Utils* contains the following files: *Clus.jar*, *R_csv_2_arff.jar*, and *weka.jar*, and also the folder *lib* with *commons-math-1.0.jar*, *jgap.jar*, weka.jar and *Clus.jar.* Without these jars, the code not runs. 

### Step-2
Copy this code and place it where you want. The folder configurations is "~/CrossValidationMultiLabel"

### Step-3 – Prepare the Dataset Metadata File
A file called `datasets-original.csv` should be placed in the **root project folder**. This file contains details for 90 multilabel datasets used in the code. To add a new dataset, include the following information in the file:


| Parameter    | Status    | Description                                           |
|------------- |-----------|-------------------------------------------------------|
| Id           | mandatory | Integer number to identify the dataset                |
| Name         | mandatory | Dataset name (please follow the benchmark)            |
| Domain       | optional  | Dataset domain                                        |
| Instances    | mandatory | Total number of dataset instances                     |
| Attributes   | mandatory | Total number of dataset attributes                    |
| Labels       | mandatory | Total number of labels in the label space             |
| Inputs       | mandatory | Total number of dataset input attributes              |
| Labelsets    | optional  |                                                       |
| Single       | optional  |                                                       |
| Max.freq     | optional  |                                                       |
| Cardinality  | optional  |                                                       |
| Density      | optional  |                                                       |
| Mean.IR      | optional  |                                                       | 
| Scumble      | optional  |                                                       | 
| Scumble.CV   | optional  |                                                       | 
| TCS          | optional  |                                                       |
| Diversity    | optional  |                                                       |
| rDep         | optional  |                                                       |
| ULD          | optional  |                                                       | 
| AttStart     | mandatory | Column number where the attribute space begins * 1    | 
| AttEnd       | mandatory | Column number where the attribute space ends          |
| LabelStart   | mandatory | Column number where the label space begins            |
| LabelEnd     | mandatory | Column number where the label space ends              |
| xn           | optional  | Value for Dimension X of the Kohone's map             | 
| yn           | optional  | Value for Dimension Y of the Kohonen's map            |
| gridn        | optional  | X times Y value. Kohonen's map must be square         |
| max.neigbors | optional  | The maximum number of neighbors is given by LABELS -1 |


1. The value is always `1` because it refers to the first column.

2. [Click here](https://link.springer.com/book/10.1007/978-3-319-41111-8) for detailed explanations of each property.

> ℹ️ In **R**, both columns and rows are indexed starting from `1`.  
> ⚠️ Be aware that in **Python**, indexing starts from `0`, which can lead to off-by-one errors when switching between the two languages.


## STEP 4: Environment Setup 🔧

Before running the code, ensure that all required **Java**, **R**, and **Python** libraries are installed on your system.  

You can use a pre-configured [Conda environment](https://1drv.ms/u/s!Aq6SGcf6js1mw4hbhU9Raqarl8bH8Q?e=IA2aQs) created specifically for this experiment. Download the environment files using the link above, then run the following command to set it up:

```bash
conda env create -f Teste.yml
```

For more information on creating and managing Conda environments, refer to the official Conda documentation



### STEP 5: Configuration File ⚙️

To run this code, you will need a configuration file in **CSV** format containing the following information:

| **Config**       | **Description**                                                                 |
|------------------|---------------------------------------------------------------------------------|
| `FolderScripts`  | Absolute path to the folder containing the R scripts                            |
| `Dataset_Path`   | Absolute path to the folder where the dataset `.tar.gz` file is stored          |
| `Temporary_Path` | Absolute path to the folder used for temporary data processing *                |
| `Reports_Path`   | Absolute path to the reports folder                                             |
| `Dataset_Name`   | Name of the dataset, as defined in the `dataset-original.csv` file              |
| `Number_Dataset` | Numeric ID of the dataset, as defined in the `dataset-original.csv` file        |
| `Validation`     | 1 = to generate test, train and validation sets. 0 otherwise                    |
| `Number_Folds`   | Number of folds to be used in cross-validation                                  |


> 📝 *We recommend using high-speed temporary storage directories such as `/dev/shm`, `/tmp`, or `/scratch` for better performance during processing.*

For detailed guidance on setting up the configuration, please refer to the example CSV files provided.


# Run

To run, first enter the folder ~/CrossValidationMultiLabel/R in a terminal and the type:

```
Rscript cvm.R absolute_path_to_config_file
```


Example:

```
Rscript cvm.R ~/CrossValidationMultiLabel/config-files/cvm-3sources_bbc1000.csv
```


## Folder Structure
<img src="https://github.com/cissagatto/CrossValidationMultiLabel/blob/main/images/folder_strucutre_mlcv.png" width="300">

## DOWNLOAD RESULTS
[Click here](https://1drv.ms/u/s!Aq6SGcf6js1mrZJSfd6FpToCtGVqJw?e=NxaBfW)


## Acknowledgment
- This study was financed in part by the Coordenação de Aperfeiçoamento de Pessoal de Nível Superior - Brasil (CAPES) - Finance Code 001.
- This study was financed in part by the Conselho Nacional de Desenvolvimento Científico e Tecnológico - Brasil (CNPQ) - Process number 200371/2022-3.
- The authors also thank the Brazilian research agencies FAPESP financial support.
- (Belgium ....)




## 📞 Contact
Elaine Cecília Gatto
✉️ [elainececiliagatto@gmail.com](mailto:elainececiliagatto@gmail.com)




## Links

| [Site](https://sites.google.com/view/professor-cissa-gatto) | [Post-Graduate Program in Computer Science](http://ppgcc.dc.ufscar.br/pt-br) | [Computer Department](https://site.dc.ufscar.br/) |  [Biomal](http://www.biomal.ufscar.br/) | [CNPQ](https://www.gov.br/cnpq/pt-br) | [Ku Leuven](https://kulak.kuleuven.be/) | [Embarcados](https://www.embarcados.com.br/author/cissa/) | [Read Prensa](https://prensa.li/@cissa.gatto/) | [Linkedin Company](https://www.linkedin.com/company/27241216) | [Linkedin Profile](https://www.linkedin.com/in/elainececiliagatto/) | [Instagram](https://www.instagram.com/cissagatto) | [Facebook](https://www.facebook.com/cissagatto) | [Twitter](https://twitter.com/cissagatto) | [Twitch](https://www.twitch.tv/cissagatto) | [Youtube](https://www.youtube.com/CissaGatto) |

# Thanks

