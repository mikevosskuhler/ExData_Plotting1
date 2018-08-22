require(tidyverse)
require(magrittr)
#this script requires the datafile to be in the same folder as the script
this.dir <- rstudioapi::getActiveDocumentContext()$path #this only works in rstudio
this.dir %<>% gsub(pattern = "/plot2.R", replacement = "")
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


#creating the plot
png(filename = "plot2.png") #opening png grapics device
par(mar = c(3,4,2,2)) #setting margins
plot(x = power_subs$Time, y = power_subs$Global_active_power, type = "l", 
     main = "", ylab = "Global Active Power (kilowatts)", xlab = "") #initiate plot
dev.off() #closing graphics device
