library(mongolite)
library(car)
library(StatMeasures)
library(lubridate)
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

want<- c(alldata$date,alldata$jlpower,alldata$jltemperature,alldata$rain,alldata$temp,alldata$wetb,alldata$dewpt,alldata$vappr,alldata$rhum,alldata$msl,alldata$wdsp,alldata$wddir,alldata$ww,alldata$w,alldata$sun,alldata$vis,alldata$clht,alldata$clamt)
want<- c("date","jlpower","jltemperature","rain","temp","wetb","dewpt","vappr","rhum","msl","wdsp","wddir","ww","w","sun","vis","clht","clamt")

mydata <-subset(alldata,select = want)

#got 42 missing data




summary(mydata)
attach(mydata)

boxplot(jlpower)
hist(jlpower)
outliers(jlpower)$numOutliers
# 408 outlier

boxplot(jltemperature)
hist(jltemperature)
outliers(jltemperature)$numOutliers
#93

boxplot(rain)
hist(rain)
outliers(rain)$numOutliers
#1092

boxplot(temp)
hist(temp)
outliers(temp)$numOutliers
# 6

boxplot(wetb)
hist(wetb)
#0

boxplot(dewpt)
hist(dewpt)
outliers(dewpt)$numOutliers
#10

boxplot(vappr)
hist(vappr)
outliers(vappr)$numOutliers
#52

boxplot(rhum)
hist(rhum)
outliers(rhum)$numOutliers
#100

boxplot(msl)
hist(msl)
outliers(msl)$numOutliers
#19

boxplot(wdsp)
hist(wdsp)
outliers(wdsp)$numOutliers
#164

boxplot(wddir)
hist(wddir)
outliers(wddir)$numOutliers
#0

boxplot(sun)
hist(sun)
outliers(sun)$numOutliers
#1923

boxplot(vis)
hist(vis)
outliers(vis)$numOutliers
#0

boxplot(clht)
hist(clht)
outliers(clht)$numOutliers
remove999 <- subset(clht,clht!=999)
boxplot(remove999)
hist(remove999)
outliers(remove999)$numOutliers
#975
summary(clht==999)
#2247 data is no clht
clhtReplace = clht
clhtReplace[clhtReplace==999]<- 0


table(clamt)

#reference to wenyu
define_daytime<- function(data,n){
  daytime <-c()
  for(i in 1:nrow(data)){
    hour <- hour(data[i,n])
    if(hour>=18)
    {
      daytime[i] = 3
    }
    else if(hour>9)
    {
      daytime[i] = 2
    }
    else
    {
      daytime[i] = 1
    }
  }
  daytime
}
str(mydata)
mydata$month <- month(mydata$date)
mydata[,1]
mydata$daytime<- define_daytime(mydata,1)
mydata$daytime
pairs(data.frame(jlpower,jltemperature,rain,temp,wetb,dewpt,vappr,rhum,msl,wdsp,wddir,sun,vis,clht))

#missing correlation
cor(data.frame(jlpower,jltemperature,rain,temp,wetb,dewpt,vappr,rhum,msl,wdsp,wddir,sun,vis,clht))
cor(jltemperature,temp)
cor(jltemperature,wetb)
cor(jltemperature,dewpt)
cor(jltemperature,vappr)
cor(jltemperature,rhum)
cor(jltemperature,msl)
cor(jltemperature,wdsp)

cor(temp,wetb)
cor(temp,dewpt)
cor(temp,vappr,method="spearman")
cor(temp,rhum)

cor(wetb,dewpt)
cor(wetb,vappr)

cor(dewpt,vappr,method="spearman")

cor(rhum,sun)
cor(rhum,vis)

scale_data <- scale(data.frame(jlpower,jltemperature,rain,temp,wetb,dewpt,vappr,rhum,msl,wdsp,wddir,sun,vis,clhtReplace))
wss <- (nrow(scale_data)-1)*sum(apply(scale_data,2,var))
for (i in 2:15){
  wss[i] <- sum(kmeans(scale_data, centers=i)$withinss)
}  

plot(1:15, wss, type="b", xlab="Number of Clusters",ylab="Within Clusters Sum of Squares")

k2data<-kmeans(scale_data,2)
pairs(mydata,col=k2data$cluster)
print(k2data)
k2data$centers

e<-eigen(cov(scale_data))
e
plot(1:length(e$values),e$values,type="b")
sqrt(e$values)

pca<-prcomp(scale_data) #run PCA
plot(pca,type="l") #plot screeplot
summary(pca)
print(pca)
pca$rotation

plot(pca$x[,1],pca$x[,2],xlab="PC 1", ylab="PC 2",
     col=k2data$cluster,pch=k2data$cluster)
plot(pca$x[,2],pca$x[,3],xlab="PC 2", ylab="PC 3",
     col=k2data$cluster,pch=k2data$cluster)
plot(pca$x[,1],pca$x[,3],xlab="PC 1", ylab="PC 2",
     col=k2data$cluster,pch=k2data$cluster)
attach(mydata)
lmresult <- lm(log(jlpower)~vappr)
plot(lmresult)
summary(lmresult)
lmresultMulti <- lm(log(jlpower)~jltemperature+vappr+rhum++wdsp+sun+clhtReplace+clamt+daytime)
plot(lmresultMulti)
summary(lmresultMulti)

vif(lmresultMulti)

BootstrapRand<-function(data, mod_formula, rep){
   coef_table<-c()
  for(i in 1:rep){
  data_boot<- data[sample(1:nrow(data),size=nrow(data),replace=T),]
  lm_boot<-lm(mod_formula,data=data_boot)
  coef_table<-rbind(coef_table,coef(lm_boot))
  }
  coef_table
  }

lm_bs_multi <- BootstrapRand(mydata,log(jlpower)~jltemperature+vappr+rhum++wdsp+sun+clhtReplace+clamt+daytime,100000)

apply(lm_bs_multi,2,mean)
#r_sq=1-SSE/SST
SST<-sum((log(jlpower)-mean(log(jlpower)))^2)
SST
fitted_boot<-(173.408867496+12.070879079*jltemperature-22.537416249*vappr+6.101169264*wdsp-0.085239352*wddir+100.572835692*sun+0.000282637*clhtReplace+19.282570106*clamt)
fitted_boot2<-(3.332261+0.03990689*jltemperature-0.08436999*vappr+0.009241768*rhum+0.01535765*wdsp+0.480168*sun-0.0000002996450*clhtReplace+0.0597881*clamt+0.4356672*daytime)
fitted_boot_fix <- exp(fitted_boot2)
SSE_boot<-sum((jlpower-fitted_boot_fix)^2)
SSE_boot <- sum((log(jlpower) - fitted_boot2)^2)
SSE_boot
r_sq<-1-(SSE_boot/SST)
r_sq


