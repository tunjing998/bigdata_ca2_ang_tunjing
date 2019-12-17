library(mongolite)

m <- mongo("dublin_weather",url = "mongodb://localhost:27017",db="bigdata_ca2_ang_tunjing")
#https://stackoverflow.com/questions/34454034/r-mongolite-date-query
dstart <- as.integer(as.POSIXct(strptime("2018-01-01","%Y-%m-%d")))*1000
dend <- as.integer(as.POSIXct(strptime("2019-01-01","%Y-%m-%d")))*1000

conditionYear18 <-paste0('{"date":{
    "$gte": {"$date" : { "$numberLong" : "', dstart, '" }},
    "$lt": {"$date" : { "$numberLong" : "', dend, '" }}
}}')

dublin_weather <-m$find(conditionYear18)

m <- mongo("jlhome_temperature_hour",url = "mongodb://localhost:27017",db="bigdata_ca2_ang_tunjing")

jlhome_temperature_hour <- m$find(conditionYear18)

m <-mongo("jlhome_power_hour",url = "mongodb://localhost:27017",db="bigdata_ca2_ang_tunjing")

jlhome_power_hour <- m$find(conditionYear18)

colnames(jlhome_power_hour) = c("jlpower","date")
colnames(jlhome_temperature_hour) = c("jltemperature","date")

alldata <- merge(x=jlhome_power_hour,y=jlhome_temperature_hour,by="date")
alldata <- merge(x=alldata,y= dublin_weather,by="date")

mydata<- c(alldata$date,alldata$jlpower,alldata$jltemperature,alldata$rain,alldata$temp,alldata$wetb,alldata$dewpt,alldata$vappr,alldata$rhum,alldata$msl,alldata$wdsp,alldata$wddir,alldata$ww,alldata$w,alldata$sun,alldata$vis,alldata$clht,alldata$clamt)

