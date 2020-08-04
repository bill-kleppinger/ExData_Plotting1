## R script for EDA course project #1

# Get the data set and unzip the file
# skip steps if the data folder, zip file or txt file already exist
if(!file.exists("./data")) { dir.create("./data") }

fileURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
if(!file.exists("./data/household_power_consumption.zip")) {
  download.file(fileURL, "./data/household_power_consumption.zip", method="curl")
  fileDownloadDate <- date()
}

if(!file.exists("./data/household_power_consumption.txt")) {
  unzip("./data/household_power_consumption.zip", exdir="./data")
}

## Estimate memory required (assume all variables are double precision floating point numbers)
##    2,075,259 rows * 9 columns * 8 bytes = 149,418,648 bytes = 142.5 MB
## Should be fine to load into memory

hpc <- read.table("./data/household_power_consumption.txt",
    header=TRUE, sep=";", na.strings="?"
)

library(lubridate)
library(dplyr)
hpc <- transform(hpc, Date=dmy(Date))
hpc <- transform(hpc, Time=hms(Time))
d1 <- ymd("2007-02-01") # Thursday
d2 <- ymd("2007-02-02") # Friday
hpc <- hpc %>% filter(d1 <= Date & Date <= d2)
hpc <- hpc %>% mutate(dt = Date + Time)

# Plot 4
png(filename="plot4.png", width=480, height=480)
par(mfrow=c(2,2))
# top left
with(hpc, plot(dt, Global_active_power,
               type="l",
               xlab="",
               ylab="Global Active Power"
))
# top right
with(hpc, plot(dt, Voltage,
               type="l",
               xlab="datetime",
               ylab="Voltage"
))
#bottom left
with(hpc, {
  plot(dt, Sub_metering_1,
               type="l",
               col="black",
               xlab="",
               ylab="Energy sub metering"
  )
  points(dt, Sub_metering_2,
                 type="l",
                 col="red"
  )
  points(dt, Sub_metering_3,
                 type="l",
                 col="blue"
  )
  legend("topright",
       col=c("black", "red", "blue"),
       lwd=2,
       legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
       bty="n"
  )
})
# bottom right
with(hpc, plot(dt, Global_reactive_power,
               type="l",
               xlab="datetime",
               ylab="Global_reactive_power"
))
dev.off()
