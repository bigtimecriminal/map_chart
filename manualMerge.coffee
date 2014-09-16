fs = require('fs')
sys = require('sys')
topojson = require('topojson')
_ = require('underscore')

exec = require('child_process').exec

vectorMap = JSON.parse(fs.readFileSync "states_and_subunits.topo.json")

#identify groups of countries to merge
idsToMerge = _.find(process.argv, (d) -> d[0..2] is '--m').split('=')[1]
if idsToMerge isnt ""
  idsToMerge = JSON.parse idsToMerge
  idsToMerge.forEach (mergeGroup) ->
    #merge the countries and copy over properties
    pathsToMerge = vectorMap.objects.countries.geometries.filter((d) -> _.find(mergeGroup.remove.concat(mergeGroup.merge), (f) -> f is d.id)? )
    masterPath = _.find(vectorMap.objects.countries.geometries, (d) -> d.id is mergeGroup.merge)
    mergedPaths = topojson.mergeArcs(vectorMap, pathsToMerge)
    mergedPaths.id = masterPath.id
    mergedPaths.properties = masterPath.properties

    vectorMap.objects.countries.geometries = vectorMap.objects.countries.geometries.filter((d) -> not _.find(mergeGroup.remove.concat(mergeGroup.merge), (f) -> f is d.id)? )
    vectorMap.objects.countries.geometries.push(mergedPaths)

#copy over countries properties to countries2 geometries
vectorMap.objects.countries2.geometries.forEach (d) ->
  d.properties =  _.find(vectorMap.objects.countries.geometries, (f) -> d.id is f.id).properties

#remove US and Canada from countries layer
vectorMap.objects.countries.geometries = vectorMap.objects.countries.geometries.filter (d) ->
  delete d.properties.SU_A3
  d.properties.SOV_A3 isnt "US1" and d.properties.SOV_A3 isnt "CAN"

#merge the countries2 layer into countries
vectorMap.objects.countries2.geometries.forEach (d) ->
  vectorMap.objects.countries.geometries.push d
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


topojson.prune(vectorMap)
output = JSON.stringify(vectorMap,null,0)
fs.writeFileSync('worldMap.topo.json', output, 'utf8')
