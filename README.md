# Map Chart

This project represents a formalized workflow for the creation of global and US state topojson maps suitable for choropleth charts. The processing pipeline relies on NaturalEarth 10m cultural vector data.

## Mapping pipeline

The mapping pipeline is started by calling 'make' from the base directory. The pipeline requires ogr2ogr, node.js, topojson and coffeescript. 

```bash
brew install node gdal
npm install -g coffee-script
npm install -g topojson
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

- countries [national boundaries] with these properties:
  * SOV_A3 [abbreviation] -> also the id
  * longName 
- states [US states] with these properties:
  * SOV_A3 ["US1"]
  * longName
  * postal -> also the id

The file is also automatically copied to the testbed.

## Make options, set in config.mk

SIMPLIFY_PROPORTION (0.05) - Will pass this simplification factor to topojson when creating maps.
REMOVE_LAYER ("") - Will remove the named layer from the finished data product. Currently the only valid options are "countries" and "states"
COUNTRY_ID_PROP [SOV_A3] - Sets the property used as an id for the country layer
STATE_ID_PROP [postal] - Sets the property used as an id for the state layer
