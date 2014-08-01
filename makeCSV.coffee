fs = require('fs')

datafile = 'focusEntities.json'
csvFile = 'entries.csv'

entities = JSON.parse(fs.readFileSync datafile)

csvText = "SOVEREIGNT,lon,lat"

for d,i in entities
  if d.geoInfo?
    csvText += "\n#{d.geoInfo.country},#{d.geoInfo.longitude},#{d.geoInfo.latitude}"

fs.writeFileSync(csvFile, csvText, 'utf8')
