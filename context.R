
library(tidyverse)
library(lubridate)
library(gridExtra)
library('grid')
library('here')
library(readxl)
library(data.table)

# by convention give the root folder of the project through an environment variable
project_root_dir <- here::here()
if (project_root_dir == "") {project_root_dir <- "/home/rstudio"} 

data_dir <- file.path(here(),'data')

