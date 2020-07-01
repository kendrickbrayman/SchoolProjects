library(dplyr)
library(readr)
library(ggplot2)

data <- read.csv('data.csv')
data$date <- as.Date(as.character(data$date),format = "%m/%d/%Y")
data2 = data.frame(data,movement = rowMeans(data[,4:9], na.rm = T))
cali <- data2[data$sub_region_2 == "California",]

plot1 <- ggplot(cali, aes(x = date)) +
  geom_line(aes(y = retail_recreation,color = "retail_recreation")) +
  geom_line(aes(y = grocery_pharmacy,color = "grocery_pharmacy")) + 
  geom_line(aes(y = parks,color = "parks")) +
  geom_line(aes(y = transit_stations,color = "transit_stations")) +
  geom_line(aes(y = workplaces,color = "workplaces")) +
  geom_line(aes(y = residential,color = "residential")) + 
  scale_colour_manual("",breaks = c('retail_recreation','grocery_pharmacy','parks','transit_stations','workplaces','residential'), values = c("green", "blue", "steelblue", 'orangered', 'purple', 'black')) +
  geom_vline(xintercept = cali$date[19], color = 'red', linetype = 2) +
  labs(y = "Movement % change", title = "California Statewide Movement")
  
print(plot1)  


plot2 <- ggplot(data2[data2$date > as.Date("2020-02-15"),], aes(x = date, y = movement, colors = sub_region_2)) +
  geom_line() +
  geom_line(data = cali, aes(x = date, y = movement), color = 'blue', size = 1) +
  geom_vline(xintercept = cali$date[19], color = 'red', linetype = 2) +
  labs(y = "Movement % change", title = "California County Movement")
print(plot2)
