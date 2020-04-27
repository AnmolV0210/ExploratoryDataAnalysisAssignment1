##Loading libraries
library(data.table)
library(dplyr)

##Extratcing data from website

url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"

if(!file.exists("dataset.zip"))
    download.file(url,destfile = "dataset.zip", method = "curl")
if(!file.exists("household_power_consumption.txt"))
    unzip("dataset.zip")

## Getting the data
data <- data.table::fread("household_power_consumption.txt", na.strings = "?")

## Removing null values
data <- na.omit(data)

##Combinig date and time columns
data <- data %>% mutate(DT = paste(Date,Time))

##Change DT and Date from chr to Date/Time classs objects
data$DT <- strptime(data$DT, format="%d/%m/%Y %H:%M:%S")
data$Date <- strptime(data$Date, format="%d/%m/%Y")

##Subset 2 days i.e 01/02/2007 and 02/02/2007
data <- subset(data, Date == "2007-02-01" | Date == "2007-02-02")

##Plot the graph on/using png graphic device
png(filename = "plot2.png", width = 480, height = 480)
plot(data$DT,data$Global_active_power, type = "l", ylab = "Global Active Power(kilowatts)", xlab = "")
dev.off()
