fs = require('fs')
sys = require('sys')
exec = require('child_process').exec

vectorMap = JSON.parse(fs.readFileSync "states_and_subunits.topo.json")

vectorMap.objects.countries2.geometries.forEach (d) -> vectorMap.objects.countries.geometries.push d
delete vectorMap.objects.countries2

output = JSON.stringify(vectorMap,null,0)
fs.writeFileSync('worldMap.topo.json', output, 'utf8')
puts = (error, stdout, stderr) -> sys.puts(stdout)
exec("cp worldMap.topo.json testbed/data/maps/", puts);
