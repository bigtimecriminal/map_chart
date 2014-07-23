#!/bin/bash

rm countries.json
rm countries.topo.json

ogr2ogr \
  -f GeoJSON \
  -where "SU_A3 <> 'ATA'" \
  countries.json \
  infiles/ne_10m_admin_0_countries_lakes.shp

topojson \
  -o countries.topo.json \
  --id-property ADMIN \
  --p NAME -p ADMIN \
  --simplify-proportion $1\
  -- \
  countries.json \

