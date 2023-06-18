
rm(list=ls())

source('context.R')
source('R/data_functions.R')

data_file_name <- download_data()
data_sheets <- list_data_sheets(data_file_name)
gen_data <- prepare_gen_data(data_sheets)
names(gen_data)
# long format

gen_types_plot = c("NetGeneration", "Hydro", "Geothermal", "Gas", "Wind", "Coal", "Solar", "Biogas")
cols_keep = c("Year", gen_types_plot)
dt_gen <- copy(gen_data)[, ..cols_keep]

dt_plot = melt(dt_gen, id.vars = c("Year"), 
             variable.name = "Generation", 
             value.name = "AnnualGWh")

dt_plot[, Generation := factor(Generation, levels = gen_types_plot)]

p1 <- make_plot_gen_year(data = dt_plot)
grid.arrange(p1)
