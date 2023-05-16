
source('context.R')

# Read in MBIE Electricity Statistics file, updated quarterly
url.base <- 'https://www.mbie.govt.nz/assets/Data-Files/Energy/nz-energy-quarterly-and-energy-in-nz/'
url.file <- 'electricity.xlsx'
url <- paste0(url.base, url.file)
data.file <- file.path(data_dir, "electricity.xlsx")
download.file(url, data.file)

# extract sheet names
sheets <- data.file %>%
  excel_sheets() %>% 
  set_names() 
# read all sheets into data.table format (kludgy)
x <- lapply(sheets, function(X) readxl::read_excel(data.file, sheet = X))
x <- lapply(x, as.data.table)
names(x) <- sheets

# Format Annual Statistics (GWh) 'Table 2' the 4th sheet
dt0 <- x$'Table 2'

# Remove rows of all NA
dt0 <- dt0[rowSums(is.na(dt0)) != ncol(dt0),]
# Remove header row
dt0 <- dt0[-1,]
# Remove notes
names(dt0)[1] <- "Row"

dt_notes <-dt0[which(dt0$Row=="Notes:"):nrow(dt0), 1]
dt0_data <- dt0[1:which(dt0$Row=="Notes:")-1,]


dt0$Row
dt0[,1]

# Transpose for years as rows
dt = as.data.table(t(as.matrix(dt0_data)))

# Name columns with first row
names(dt) <- as.character(dt[1,])
dt<-dt[-1,]

# Remove last annual year change row
dt<-dt[-which(dt[,1] == "Annual % change")]
dt <- copy(dt)[, 'Calendar year' := as.numeric(dt$'Calendar year')]

head(dt[,1:4])




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