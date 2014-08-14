# Map Chart

This project represents a formalized workflow for the creation of global and US state topojson maps suitable for choropleth charts. The processing pipeline relies on NaturalEarth 10m cultural vector data.

## Mapping pipeline

The mapping pipeline is started by calling 'make' from the base directory. The pipeline requires ogr2ogr, node.js, topojson and coffeescript. 

```bash
brew install node gdal
npm install -g coffee-script
npm install
```

## Testbed

The testbed needs bower to install its dependencies. From the testbed directory

```bash
npm install
npm install -g bower
bower install
```

## Products

The mapping pipeline will produce a single topojson map file, worldMap.topo.json, containing three layers:

- countries [national boundaries] have an SU_A3 property and a NAME id
- states [US states]
- subunits [just the boundary of the continental US] have an SU_A3 property and a SOVEREIGNT id

The file is also automatically copied to the testbed.

## Make options

SIMPLIFY_PROPORTION (0.05) - Will pass this simplification factor to topojson when creating maps. 
REMOVE_LAYERS ("") - Will remove the named layers from the finished data product. 
