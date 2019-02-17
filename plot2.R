library(dplyr)

url = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(url, basename(url))

unzip("exdata%2Fdata%2Fhousehold_power_consumption.zip")

setAs("character","myDate", function(from) as.Date(from, format="%d/%m/%Y") )
colclass = rep("character", 9)
colclass[1]="myDate"
colclass[2]="character"
colclass[3]="numeric"

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
  select(Date, Time, Global_active_power) %>% 
  filter(Date == as.Date("2007-02-01") | Date == as.Date("2007-02-02")) %>%
  mutate(datetime=as.POSIXct(paste(as.character(Date), Time, sep = '')))
#head(final)

complete = complete.cases(final)
final = final[complete, ]

graphics.off()
png("plot4.png", height = 480, width = 480)
par(mfrow = c(1, 1))
par(mar = c(4, 4, 1, 1))

with(final, plot(datetime, Global_active_power, type="s",ylab="Global Active Power(kilowatts)", lwd=1))


dev.off()