
rm(list=ls())

source('context.R')
source('R/data_functions.R')

data_file_name <- download_data()
data_sheets <- list_data_sheets(data_file_name)
gen_data <- prepare_gen_data(data_sheets)

# long format
dt = melt(gen_data, id.vars = c("Year"), 
             variable.name = "Generation", 
             value.name = "AnnualGWh")

gen_plot = c("NetGeneration", "Hydro", "Gas", "Coal", "Geothermal", "Wind")
dt_plot <- dt[Generation %in% gen_plot]

p1 <- make_plot_gen_year(data = dt_plot)
grid.arrange(p1)
