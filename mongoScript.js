
//Sort the date in Mongo
//reference from https://stackoverflow.com/questions/22890082/convert-to-date-mongodb-via-mongoimport
db.dublin_weather.find().forEach(function (el) {
    let tmp = el.date.split('/');
    let tmp2 = tmp[2].split(' ');
    el.date = new Date(tmp2[0] + "-" + tmp[1] + "-" + tmp[0] + "T" + tmp2[1] + ":00Z");  
    db.dublin_weather.save(el);
})

db.jlhome_temperature.find().forEach(function (el) {
    let tmp = el.date.split('/');
    let tmp2 = tmp[2].split(' ');
    el.date = new Date(tmp2[0] + "-" + tmp[1] + "-" + tmp[0] + "T" + tmp2[1] + ":00Z");  
    db.jlhome_temperature.save(el);
})

db.jlhome_power.find().forEach(function (el) {
    let tmp = el.date.split('/');
    let tmp2 = tmp[2].split(' ');
    el.date = new Date(tmp2[0] + "-" + tmp[1] + "-" + tmp[0] + "T" + tmp2[1] + ":00Z");  
    db.jlhome_power.save(el);
})

db.dublin_weather.find({
    "date": {
        $gte: ISODate("2018-01-01T00:00:00.000Z"),
        $lt: ISODate("2019-01-01T00:00:00.000Z")
    }
})

db.jlhome_power_hour.find({
    "date": {
        $gte: ISODate("2018-01-01T00:00:00.000Z"),
        $lt: ISODate("2019-01-01T00:00:00.000Z")
    }
})

db.jlhome_temperature.find({
    "date": {
        $gte: ISODate("2018-01-01T00:00:00.000Z"),
        $lt: ISODate("2019-01-01T00:00:00.000Z")
    }
})

mapTemperature = function () {
    let d = this.date;
    let day = d.getDate();
    if(day<10)
    {
        day = "0"+day;
    }
    let hour = d.getHours();
    if(hour<10){
        hour = "0"+hour;
    }
    let d2 = d.getFullYear()+"-"+(d.getMonth()+1)+"-"+(d.getDate())+"T"+hour+":00:00";
    emit(d2,this.temperature);
}

mapPower = function () {
    let d = this.date;
    let day = d.getDate();
    if(day<10)
    {
        day = "0"+day;
    }
    let hour = d.getHours();
    if(hour<10){
        hour = "0"+hour;
    }
    let d2 = d.getFullYear()+"-"+(d.getMonth()+1)+"-"+(d.getDate())+"T"+hour+":00:00";
    emit(d2,this.power);
}

reduceAverage = function(key,value){
    return Array.avg(value);
}

db.dublin_weather.find(){
    
}

db.jlhome_temperature.mapReduce(mapTemperature,reduceAverage,{out:"jlhome_temperature_hour"})
db.jlhome_power.mapReduce(mapPower,reduceAverage,{out:"jlhome_power_hour"})


db.jlhome_temperature_hour.find().forEach(function (el) {
    el.date = new Date(el._id);  
    db.jlhome_temperature_hour.save(el);
})
db.jlhome_power_hour.find().forEach(function (el) {
    el.date = new Date(el._id);  
    db.jlhome_power_hour.save(el);
})
