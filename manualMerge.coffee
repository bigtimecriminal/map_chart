fs = require('fs')
sys = require('sys')

exec = require('child_process').exec

vectorMap = JSON.parse(fs.readFileSync "states_and_subunits.topo.json")

#filter unneeded subunits
vectorMap.objects.subunits.geometries = vectorMap.objects.subunits.geometries.filter (d) ->
  if d.properties.SU_A3 is "USB"
    d.properties.SU_A3 = "US1"
    return true
  false

#remove US and Canada from countries layer
vectorMap.objects.countries.geometries = vectorMap.objects.countries.geometries.filter (d) ->
  delete d.properties.SU_A3
  d.properties.SOV_A3 isnt "US1" and d.properties.SOV_A3 isnt "CAN"

#merge the countries2 layer into countries
vectorMap.objects.countries2.geometries.forEach (d) -> vectorMap.objects.countries.geometries.push d
delete vectorMap.objects.countries2

if ~process.argv.indexOf("--r")
	layersToRemove = process.argv[(process.argv.indexOf("--r")+1)...]
	layersToRemove.forEach (d) ->
		delete vectorMap.objects[d]

output = JSON.stringify(vectorMap,null,0)
fs.writeFileSync('worldMap.topo.json', output, 'utf8')
puts = (error, stdout, stderr) -> sys.puts(stdout)
exec("cp worldMap.topo.json testbed/data/maps/", puts)
