fs = require('fs')
sys = require('sys')
_ = require('underscore')

exec = require('child_process').exec

vectorMap = JSON.parse(fs.readFileSync "states_and_subunits.topo.json")

mergeLayers = _.find(process.argv, (d) -> d[0..2] is '--m').split('=')[1]
if mergeLayers isnt ""
  mergeLayers = JSON.parse mergeLayers
  mergeLayers.remove = mergeLayers.remove.map (sov_a3) -> _.find(vectorMap.objects.countries.geometries, (d) -> d.properties.SOV_A3 is sov_a3)
  mergeLayers.merge = _.find(vectorMap.objects.countries.geometries, (d) -> d.properties.SOV_A3 is mergeLayers.merge)
  mergeLayers.remove.forEach (d) ->
    mergeLayers.merge.arcs = mergeLayers.merge.arcs.concat d.arcs
    vectorMap.objects.countries.geometries.splice(_.indexOf(vectorMap.objects.countries.geometries,d),1)

#remove US and Canada from countries layer
vectorMap.objects.countries.geometries = vectorMap.objects.countries.geometries.filter (d) ->
  delete d.properties.SU_A3
  d.properties.SOV_A3 isnt "US1" and d.properties.SOV_A3 isnt "CAN"

#merge the countries2 layer into countries
vectorMap.objects.countries2.geometries.forEach (d) -> vectorMap.objects.countries.geometries.push d
delete vectorMap.objects.countries2

#remove Canadian states
vectorMap.objects.states.geometries = vectorMap.objects.states.geometries.filter (d) ->
  d.properties.SOV_A3 isnt "CAN"

#delete specified unwanted layer
layerToRemove = _.find(process.argv, (d) -> d[0..2] is '--r').split('=')[1]
if layerToRemove?
  delete vectorMap.objects[layerToRemove]

#delete subunits
delete vectorMap.objects["subunits"]

#merge external data
externalData = _.find(process.argv, (d) -> d[0..2] is '--e')?.split('=')[1]
if externalData
  if not fs.existsSync externalData
    console.error "manualMerge.coffee missing external data file"
    return
  else
    externalData = JSON.parse(fs.readFileSync externalData)
    #for every layer mentioned in the external file
    Object.keys(externalData).forEach (layer) ->
      #for every property
      Object.keys(externalData[layer]).forEach (extraProperty) ->
        #for every feature
        Object.keys(externalData[layer][extraProperty]).forEach (featureId) ->
          #match id and bind property
          foundFeature = _.find(vectorMap.objects[layer].geometries, (d) -> d.id is featureId)
          if foundFeature?
            foundFeature.properties[extraProperty] = externalData[layer][extraProperty][featureId]

output = JSON.stringify(vectorMap,null,0)
fs.writeFileSync('worldMap.topo.json', output, 'utf8')
