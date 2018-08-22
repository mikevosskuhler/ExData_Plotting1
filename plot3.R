require(tidyverse)
require(magrittr)
#this script requires the datafile to be in the same folder as the script
this.dir <- rstudioapi::getActiveDocumentContext()$path #this only works in rstudio
this.dir %<>% gsub(pattern = "/plot3.R", replacement = "")
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

#plotting
png(filename = "plot3.png") #turning on graphic device
par(mar = c(3,4,2,2)) #setting margins
plot(x = power_subs$Time, y = power_subs$Sub_metering_1, type = "l",
     xlab = "", ylab = "Energy sub metering", main = "") #initiate
lines(x = power_subs$Time, y = power_subs$Sub_metering_2, col = "red") #annotate
lines(x = power_subs$Time, y = power_subs$Sub_metering_3, col = "blue")#annotate
dev.off() #turning off graphics device