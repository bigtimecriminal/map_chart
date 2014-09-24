# Map Chart

This project represents a formalized workflow for the creation of global and US state topojson maps suitable for choropleth charts. The processing pipeline relies on NaturalEarth 10m cultural vector data.

## Mapping pipeline

The mapping pipeline is started by calling 'make' from the base directory. The pipeline requires ogr2ogr, node.js, topojson and coffeescript. 

```bash
brew install node gdal
npm install -g coffee-script
npm install -g topojson
npm install
```

The default configuration file can be brought in with

```bash
cp sample_configurations/config.world_and_states.mk config.mk
```

## Testbed

The testbed needs bower to install its dependencies. From the testbed directory

```bash
npm install
npm install -g bower
bower install
```

## Products

With the 'world_and_states' configuration file, the mapping pipeline will produce a single topojson map, worldMap.topo.json, containing three layers:

- countries [national boundaries] with these properties:
  * SOV_A3 (3 letter abbreviation) -> also the id
  * longName (a caveat - this property is renamed from "SOVEREIGNT", so to use it as the id, you'll need to use that original name in the config file.)
- states [US states] with these properties:
  * SOV_A3 ["US1"]
  * longName (
  * postal -> also the id

The file is also automatically copied to the testbed.

## Using longName ids
When starting out with choropleth chart making, it might be helpful to use maps where the id of a country is its full name rather than it's 3-letter SOV_A3 tag. To make a map like this, use the alternate config.mk file:

```bash
cp sample_configurations/config.world_and_states_by_full_name.mk config.mk
```

## Make options

SIMPLIFY_PROPORTION (0.05) - Will pass this simplification factor to topojson when creating maps.

REMOVE_LAYER ("") - Will remove the named layer from the finished data product. Currently the only valid options are "countries" and "states".

COUNTRY_ID_PROP [SOV_A3] - Sets the property used as an id for the country layer. 

STATE_ID_PROP [postal] - Sets the property used as an id for the state layer.

MERGED_STATES_ID_PROP[SOV_A3]  -  Set to the property in states.json the matches the property name of your COUNTRY_ID_PROP 
