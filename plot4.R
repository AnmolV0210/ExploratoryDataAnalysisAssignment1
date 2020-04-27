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

##creating png file
png(filename = "plot4.png", width = 480, height = 480)

##using par to plot 4 plots
par(mfrow = c(2,2))

##plot 1
plot(data$DT,data$Global_active_power, type = "l", ylab = "Global Active Power(kilowatts)", xlab = "")

##plot2
plot(data$DT,data$Voltage, type = "l", xlab = "datetime", ylab = "Voltage")

##plot3
plot(data$DT,data$Sub_metering_1, type = "n", xlab = "", ylab = "Energy sub meeting")
lines(data$DT,data$Sub_metering_1, type = "l")
lines(data$DT,data$Sub_metering_2, type = "l", col = "red")
lines(data$DT,data$Sub_metering_3, type = "l", col = "blue")
legend("topright", c("Sub_metering_1","Sub_metering_2","Sub_metering_3"), cex=0.75, lty=c(1,1,1), lwd=c(2.5,2.5,2.5), col=c("black","red","blue"))

##plot 4
plot(data$DT,data$Global_reactive_power, type = "l", xlab = "datetime", ylab = "Global_reactive_power")

##Turn off graphic device
dev.off()