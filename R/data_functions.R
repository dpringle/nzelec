
download_data <-function(
    url_base = 'https://www.mbie.govt.nz/assets/Data-Files/Energy/nz-energy-quarterly-and-energy-in-nz/',
    url_file = 'electricity.xlsx'){
  # Read in MBIE Electricity Statistics file, updated quarterly
  url_base = 'https://www.mbie.govt.nz/assets/Data-Files/Energy/nz-energy-quarterly-and-energy-in-nz/'
  url_file = 'electricity.xlsx'
  url <- paste0(url_base, url_file)
  data_file <- file.path(dir_data, url_file)
  download.file(url, data_file)
  return(data_file)
}

list_data_sheets <- function(data_file){
  # extract sheet names
  sheets <- data_file %>%
    excel_sheets() %>% 
    set_names() 
  # read all sheets into data.table format (kludgy)
  x <- lapply(sheets, function(X) readxl::read_excel(data_file, sheet = X))
  x <- lapply(x, as.data.table)
  names(x) <- sheets
  return(x)
}

prepare_gen_data <- function(data_sheets){
  # Format Annual Statistics (GWh) 'Table 2' the 4th sheet
  x <- copy(data_sheets)
  dt0 <- x$'Table 2'
  
  # Remove rows of all NA
  dt0 <- dt0[rowSums(is.na(dt0)) != ncol(dt0),]
  # Remove header row
  dt0 <- dt0[-1,]
  # Remove notes
  names(dt0)[1] <- "Row"
  
  dt_notes <-dt0[which(dt0$Row=="Notes:"):nrow(dt0), 1]
  dt0_data <- dt0[1:(which(dt0$Row=="Notes:")-1),]
  
  # Transpose for years as rows
  dt = as.data.table(t(as.matrix(dt0_data)))
  
  # Name columns with first row
  names(dt) <- as.character(dt[1,])
  dt<-dt[-1,]
  
  # Remove last annual year change row
  dt<-dt[-which(dt[,1] == "Annual % change")]
  dt <- copy(dt)[, 'Calendar year' := as.numeric(dt$'Calendar year')]
  
  head(dt[,1:4])
  names(dt)
  gen_cols <- c("Calendar year", 
                "Net Generation (GWh)1,2",
                "Hydro",                                         
                "Geothermal",
                "Biogas",
                "Wood",
                "Wind",
                "Solar3",
                "Oil",
                "Coal"  ,
                "Gas",
                "Waste Heat4")
  gen <- dt[, ..gen_cols]
  
  # Convert character cols to numeric
  changeCols <- names(gen)[sapply(gen, is.character)]
  gen[,(changeCols):= lapply(.SD, as.numeric), .SDcols = changeCols]
  head(gen)
  oldnames = gen_cols
  newnames = c("Year", 
               "NetGeneration",
               "Hydro",                                         
               "Geothermal",
               "Biogas",
               "Wood",
               "Wind",
               "Solar",
               "Oil",
               "Coal"  ,
               "Gas",
               "WasteHeat")
  setnames(gen, old = oldnames, new = newnames)
  setcolorder(gen, newnames)
  setorderv(gen, c( "Year"))
  
  return(gen)
}

make_plot_gen_year <- function(data){
  p1 <- ggplot(data, aes(x = Year, y = AnnualGWh, color = Generation))+
    geom_line() +
    labs(title = 'NZ Annual Electricity Generation (MBIE Data)\n', 
         x = 'Calendar Year',
         y = 'Volume (GWh)\n') +
    theme_dan1()
  return(p1)
}







