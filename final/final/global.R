library(leaflet)
library(shiny)
library(ggplot2)
library(tidyverse)
library(data.table)
library(hash)
library(rlist)
# Saves the breakfast cereal dataset to the `cereals` variable.
food <- fread("https://uofi.box.com/shared/static/5637axblfhajotail80yw7j2s4r27hxd.csv", header=TRUE, stringsAsFactors=FALSE,
              na.strings = c("","na"))
food <- filter(food,Risk != "NA")
