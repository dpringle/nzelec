
library(tidyverse)
library(lubridate)
library(gridExtra)
library("grid")
library('here')
library(readxl)
library(data.table)


# by convention give the root folder of the project through an environment variable
project_root_dir <- here::here()
if (project_root_dir == "") {project_root_dir <- "/home/rstudio"} 

data_dir <- file.path(here(),'data')
data_dir

url.base <- 'https://www.mbie.govt.nz/assets/Data-Files/Energy/nz-energy-quarterly-and-energy-in-nz/'
url.file <- 'electricity.xlsx'
url <- paste0(url.base, url.file)

data.file <- file.path(data_dir, "electricity.xlsx")
download.file(url, data.file)

sheets <- data.file %>%
  excel_sheets() %>% 
  set_names() 
class(sheets)

x <- lapply(sheets, function(X) readxl::read_excel(data.file, sheet = X))





# x <- lapply(x, as.data.table)
# names(x) <- sheets
# 
# # Long table of vaccination data, and HSU population data by age-ethnic splits
# vx_query <- x[["Vaccination Query"]]
# dhb_pop <- x[["HSU Table"]]
# 
# # Join data and tidy up
# vx <- merge(x = vx_query, y = dhb_pop, by = c("Ethnic group", "Age group", "DHB of residence"))
# oldnames = c("Week ending date", 
#              "Dose number", 
#              "Ethnic group", 
#              "Age group", 
#              "DHB of residence",
#              "# doses administered", 
#              "# people (HSU)")
# newnames = c("week", 
#              "dose", 
#              "ethnicgroup", 
#              "agegroup", 
#              "DHB", 
#              "count", 
#              "popsegment")
# setnames(vx, old = oldnames, new = newnames)
# setcolorder(vx, newnames)
# 
# # Set as date, remove incomplete data sometimes present for next week
# vx$week <- as.Date(vx$week)
# vx <- vx[week <= maxdate]
# 
# # Set as factors
# vx$dose <- factor(vx$dose)
# vx$agegroup <- factor(vx$agegroup)
# vx$ethnicgroup <- factor(vx$ethnicgroup)
# 
# # Remove 'Unknown', 'Overseas' and 'Overseas and undefined'
# vx <- vx[!get("DHB") %in% c('Unknown', 'Overseas','Overseas and undefined')] 
# 
# vx$DHB <- factor(vx$DHB)
# 
# # pop as HSU population stats with above names
# pop <- dhb_pop
# oldnames = c("Ethnic group", 
#              "Age group", 
#              "DHB of residence",
#              "# people (HSU)")
# newnames = c("ethnicgroup", 
#              "agegroup", 
#              "DHB",
#              "popsegment")
# setnames(pop, old = oldnames, new = newnames)
# setcolorder(pop, newnames)
# setorderv(pop, c( "DHB", "ethnicgroup", "agegroup"))