fs = require('fs')
sys = require('sys')
exec = require('child_process').exec

vectorMap = JSON.parse(fs.readFileSync "merged_subunits.topo.json")

vectorMap.objects.countries.geometries.push vectorMap.objects.countries2.geometries[0]

output = JSON.stringify(vectorMap,null,0)
fs.writeFileSync('worldMap.topo.json', output, 'utf8')

puts = (error, stdout, stderr) -> sys.puts(stdout)
exec("cp worldMap.topo.json testbed/data/maps/", puts);