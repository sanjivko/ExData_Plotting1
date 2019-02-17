library(dplyr)

url = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(url, basename(url))

unzip("exdata%2Fdata%2Fhousehold_power_consumption.zip")

setAs("character","myDate", function(from) as.Date(from, format="%d/%m/%Y") )
colclass = rep("character", 9)
colclass[1]="myDate"
colclass[2]="character"
colclass[3]="numeric"
colclass[4]="numeric"
colclass[5]="numeric"

data <-
  read.table(
    "household_power_consumption.txt",
    header = TRUE,
    sep = ";",
    colClasses = colclass,
    stringsAsFactors = FALSE,
    na.strings = "?"
  )

final = tbl_df(data) %>% 
  select(Date, Time, Global_active_power, Global_reactive_power, Voltage, Sub_metering_1,Sub_metering_2, Sub_metering_3) %>% 
  filter(Date == as.Date("2007-02-01") | Date == as.Date("2007-02-02")) %>%
  mutate(datetime=as.POSIXct(paste(as.character(Date), Time, sep = '')))
#head(final)

complete = complete.cases(final)
final = final[complete, ]

graphics.off()
par(fin=c())
par(mfrow = c(2, 2))
par(mar = c(4, 4, 1, 1))

#plot1
with(final, plot(datetime, Global_active_power, type="s",ylab="Global Active Power", xlab="", lwd=1))


#plot2
with(final, plot(datetime, Voltage, type="s",lwd=1))

#plot3
with(final, plot(datetime,Sub_metering_1,type="s",ylab="Energy sub metering", xlab = ""))
lines(final$datetime, final$Sub_metering_2, col="red")
lines(final$datetime, final$Sub_metering_3, col="blue")
legend("topright",legend=c("Sub_metering_1","Sub_metering_2","Sub_metering_3"), 
       col=c("black","red","blue"), lty=c(1,1,1), ncol=1)

#plot4
with(final, plot(datetime, Global_reactive_power, type="s",lwd=1))


dev.copy(png, 'plot4.png', height = 480, width = 480)
dev.off()
