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
  filter(Date == as.Date("2007-02-01") | Date == as.Date("2007-02-02"))

complete = complete.cases(final)
final = final[complete, ]

graphics.off()
png("plot4.png", height = 480, width = 480)
par(mfrow = c(1, 1))
par(mar = c(4, 4, 1, 1))

h = hist(
  x = as.numeric(final$Global_active_power),
  col = "red",
  breaks = 20,
  ylim = c(0,1200),
  xlab = "Global Active Power(kilowatts)",
  main = "Global Active Power"
)

dev.off()
