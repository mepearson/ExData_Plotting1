#Load Packages and libaries
#install.packages("RCurl")
#install.packages("sqldf")
library(RCurl)
library(sqldf)


# Download file to local working drive, store in "data" sub-folder, unzip
if(!file.exists("data")){dir.create("data")}
zipurl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
destzip <- "./data/power.zip"
destfolder <- "./data"
download.file(url=zipurl, destfile=destzip, method='curl')
unzip(destzip,exdir=destfolder)

#Process Local file, reading in subset of dates needed
f <- "./data/household_power_consumption.txt"  
power2 <- read.csv.sql(f, sep = ";", sql = "SELECT * FROM file where Date LIKE '2/2/2007' OR Date LIKE '1/2/2007'")

#Process character date/time to have datetime col
power2$dt <- paste(power2$Date, power2$Time)
power2$Datetime <- strptime(gsub("1/2/","01/02/",gsub("2/2/","02/02/",power2$dt)), "%d/%m/%Y %H:%M:%S")

#Clear previous plotting parameters
dev.off()

##Plot 1: Global Active Power
png(file="plot1.png",width=480,height=480)
hist(power2$Global_active_power, 
     main="Global Active Power", 
     xlab="Global Active Power (kilowatts)",
     col="red")
dev.off()
