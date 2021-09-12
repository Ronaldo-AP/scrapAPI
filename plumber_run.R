rm(list = ls())

library(plumber)

options(digits=9)
options(encoding='UTF-8')

# Set work directory
setwd('/home/scrap')

# Get API code
api <- plumb('./main.R')

# API Run 
api$run(host = '0.0.0.0', port = 80L)
