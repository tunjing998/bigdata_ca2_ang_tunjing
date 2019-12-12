//reference from https://stackoverflow.com/questions/22890082/convert-to-date-mongodb-via-mongoimport
db.dublin_weather.find().forEach(function(el){
    el.date = new Date(el.date);
    db.dublin_weather.save(el);
})

db.jlhome_temperature.find().forEach(function(el){
   // el.date = new Date(el.date);
    let tmp = el.date.split('/');
    // print(tmp);
    let tmp2 = tmp[2].split(' ');
    db.jlhome_temperature.save(new Date(tmp[0]+"-"+tmp[1]+"-"+tmp2[0]+"T"+tmp2[1]+":00"));
})

db.jlhome_power.find().forEach(function(el){
    let tmp = el.date.split('/');
    let tmp2 = tmp[2].split(' ');
    db.jlhome_power.save(new Date(tmp[0]+"-"+tmp[1]+"-"+tmp2[0]+"T"+tmp2[1]+":00"));
})

