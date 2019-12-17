#setwd("/Users/connolls/Documents/Modules/Computing/Data Analytics 2/Project")
power1718<-read.csv("JLHome1718Power.csv",
                    header = FALSE)
temp1718<-read.csv("JLHome1718Temperature.csv",
                   header = FALSE)

head(power1718)
tail(power1718)

head(temp1718)
tail(temp1718)


weather<-read.csv("hourly_dublin_17_18.csv",
                  header = TRUE)
head(weather)
str(weather)

head(power1718)




#install.packages("lubridate")
library(lubridate)
help(ymd_hms)



power1718_datetime<-dmy_hm(power1718[,1])
head(power1718_datetime)
test<-head(power1718_datetime)
matrix(unlist(strsplit(as.character(test),' ')),
       ncol=2,byrow=TRUE)
t<-matrix(unlist(strsplit(as.character(power1718_datetime),
                          ' ')),ncol=2,byrow=TRUE)

power171819<-as.data.frame(cbind(year(power1718_datetime),
                                 month(power1718_datetime),
                                 day(power1718_datetime),
                                 weekdays(power1718_datetime), 
                                 hour(power1718_datetime),
                                 minute(power1718_datetime),t))
colnames(power171819)<-c("Year","Month","Day_Month","Weekday",
                         "Hour","Minute","Date","Time")
head(power171819)
str(power171819)

Power<-power1718[,2]
power171819<-cbind(power171819,Power)
str(power171819)

power18<-power171819[power171819$Year=="2018",]
dev.off
plot(1:nrow(power18),power18$Power,lty=1)
dates<-unique(power171819$Date)#get unique days in data
length(dates)
nrow(power171819)
average_power<-c() #store average power over an hour
h<-c() #store the hour
d<-c() #store the day

for(i in 1:length(dates)){
  power_date<-power171819[which(power171819$Date==levels(power171819$Date)[i]),]
  #select all rows with that date 
  for (j in 0:23){
    if(length(which(power_date[,"Hour"]==j))>0){
      average_power<-append(average_power,
                            mean(power_date$Power[which(power_date[,"Hour"]==j)]),
                            length(average_power))
      #append is for adding the item to end of vector 
      h<-append(h,j,length(h))  
      d<-append(d,levels(power171819$Date)[i],length(d)) 
    }
  }
}



length(h)
length(average_power)
length(d)


average_power171819<-data.frame(d,h,average_power)

head(average_power171819)
str(average_power171819)



temp1718_datetime<-dmy_hm(temp1718[,1])
tt<-matrix(unlist(strsplit(as.character(temp1718_datetime),' ')),ncol=2,byrow=TRUE)

temp171819<-data.frame(cbind(year(temp1718_datetime),month(temp1718_datetime),day(temp1718_datetime),
                             weekdays(temp1718_datetime), hour(temp1718_datetime),
                             minute(temp1718_datetime),tt))
colnames(temp171819)<-c("Year","Month","Day_Month","Weekday","Hour","Minute","Date","Time")
Temp<-temp1718[,2]
temp171819<-cbind(temp171819,Temp)
temp18<-temp171819[temp171819$Year=="2018",]
table(temp18$Hour)

dates<-unique(temp171819$Date)#get unique days in data
head(temp171819)
str(temp171819)
average_temp<-c()
h<-c()
d<-c()

for(i in 1:length(dates)){
  temp_date<-temp171819[which(temp171819$Date==levels(temp171819$Date)[i]),]
  #select all rows with that date 
  for (j in 0:23){
    if(length(which(temp_date[,"Hour"]==j))>0){
      average_temp<-append(average_temp,
                            mean(temp_date$Temp[which(temp_date[,"Hour"]==j)]),
                            length(average_temp))
      #append is for adding the item to end of vector 
      h<-append(h,j,length(h))  
      d<-append(d,levels(temp171819$Date)[i],length(d)) 
    }
  }
}



length(h)
length(average_temp)
length(d)
#boxplot(average_temp)


average_temp171819<-data.frame(d,h,average_temp)
head(average_temp171819)
str(average_temp171819)

head(weather)
head(average_temp171819)
head(average_power171819)
nrow(average_temp171819)
nrow(average_power171819)

weather1718_datetime<-dmy_hm(weather[,1])

tt<-matrix(unlist(strsplit(as.character(weather1718_datetime),' ')),ncol=2,byrow=TRUE)

weather1718<-data.frame(cbind(year(weather1718_datetime),month(weather1718_datetime),day(weather1718_datetime),
                              weekdays(weather1718_datetime), hour(weather1718_datetime),
                              minute(weather1718_datetime),tt))
colnames(weather1718)<-c("Year","Month","Day_Month","Weekday","Hour","Minute","Date","Time")


weather1718<-cbind(weather1718,weather[,-1])
head(weather1718)

head(average_power171819)

##create a variable m with date and hourly time to merge files
# and make sure correct rows are matched to correct rows
m<-paste(average_power171819$d,average_power171819$h,sep="_")
head(m)
average_power171819<-cbind(average_power171819,m)
head(average_power171819)

m<-paste(average_temp171819$d,average_temp171819$h,sep="_")
head(m)
average_temp171819<-cbind(average_temp171819,m)
head(average_temp171819)

average_power171819$id  <- 1:nrow(average_power171819)
head(average_power171819)

help(merge)
average_power_temp171819<-merge(average_power171819,
                                average_temp171819,by="m")
average_power_temp171819<-average_power_temp171819[order(average_power_temp171819$id), ]
head(average_power_temp171819)
head(weather1718)

m<-paste(weather1718$Date,weather1718$Hour,sep="_")
head(m)
weather1718<-cbind(weather1718,m)

power_temp_weather1718<-merge(average_power_temp171819,weather1718,by="m")
power_temp_weather1718<-power_temp_weather1718[order(power_temp_weather1718$id), ]
head(power_temp_weather1718)
tail(power_temp_weather1718)

#remove unwanted variables and tidy-up data
#example
power_temp_weather1718<-power_temp_weather1718[,-c(2,3,5,6)]
head(power_temp_weather1718)


power_temp_weather18<-power_temp_weather1718[power_temp_weather1718$Year=="2018",]

Date<-paste(power_temp_weather18$Date,power_temp_weather18$Time,sep=" ")
x<-data.frame(Date)
x<-cbind(x,power_temp_weather18$average_power,power_temp_weather18$average_temp)
head(x)
names(x)<-c("Date","Power","Temperature")
head(x,10)
write.csv(x,"JLHome18HourlyAveragePowerTemp.csv",row.names = FALSE)

pairs(power_temp_weather18)
head(power_temp_weather18)
