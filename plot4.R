require(tidyverse)
require(magrittr)
#this script requires the datafile to be in the same folder as the script
this.dir <- rstudioapi::getActiveDocumentContext()$path #this only works in rstudio
this.dir %<>% gsub(pattern = "/plot4.R", replacement = "")
setwd(this.dir)

#loading data
power_data <- read.table("household_power_consumption.txt", sep = ";", header = T)
power_data$Date <- as.Date(power_data$Date, "%d/%m/%Y") #converting to date format

#filtering 2007-02-01 and 2007-02-02
power_subs <- power_data %>% filter(Date == "2007-02-01" | Date == "2007-02-02")

#converting time col to time datatype
power_subs$Time <- paste(power_subs$Date,power_subs$Time) %>% 
  strptime(format = "%Y-%m-%d %H:%M:%S") #which incorporates the date data 

#converting global active power to numeric
power_subs$Global_active_power <- power_subs$Global_active_power %>% as.character() %>% 
  as.numeric()

#converting submeterering 1-3 to numerics
power_subs$Sub_metering_1 %<>% as.character() %>% as.numeric()
power_subs$Sub_metering_2 %<>% as.character() %>% as.numeric()
power_subs$Sub_metering_3 %<>% as.character() %>% as.numeric()

#creating plotgrid
png(filename = "plot4.png") #open graphics device
par(mfrow = c(2,2)) #create plotgrid
plot(x = power_subs$Time, y = power_subs$Global_active_power, type = "l", 
     main = "", ylab = "Global Active Power (kilowatts)", xlab = "") #initiate plot1
plot(x = power_subs$Time, y = power_subs$Voltage, type = "l",
     main = "", xlab = "datetime", ylab = "Voltage")  #initiate plot2
plot(x = power_subs$Time, y = power_subs$Sub_metering_1, type = "l",
     xlab = "", ylab = "Energy sub metering", main = "") #initiate
lines(x = power_subs$Time, y = power_subs$Sub_metering_2, col = "red") #annotate
lines(x = power_subs$Time, y = power_subs$Sub_metering_3, col = "blue")#annotate
plot(x = power_subs$Time, y = power_subs$Global_reactive_power, type = "l",
     xlab = "datetime", main = "") #initiate plot4
dev.off()#turn off graphics device
