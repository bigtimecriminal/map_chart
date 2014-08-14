#seperates Greenland and French Guiana from their country groups.

fs = require('fs')
sys = require('sys')
exec = require('child_process').exec

subunits = JSON.parse(fs.readFileSync "subunits.json")

subunits.features = subunits.features.map (d) ->
  if d.properties.NAME is "Greenland" or d.properties.NAME is "French Guiana"
    d.properties.SOVEREIGNT = d.properties.NAME
    d.properties.SOV_A3 = d.properties.ADM0_A3
  d

output = JSON.stringify(subunits,null,2)
fs.writeFileSync('subunits.json', output, 'utf8')
