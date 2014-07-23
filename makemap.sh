#!/bin/bash

rm countries.json
rm countries.topo.json
rm states.json
rm states.topo.json

if [ $# -eq 0 ]
  then 
    echo "No arguments. Bye."
    exit
fi

if [ $2 = "countries" ]; then 
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
    countries.json
fi

if [ $2 = "states" ]; then 
  ogr2ogr \
    -f GeoJSON \
    -where "ADM0_A3 = 'USA'" \
    states.json \
    infiles/ne_10m_admin_1_states_provinces.shp

  topojson \
    -o states.topo.json \
    --id-property NAME \
    --p NAME -p NAME \
    --simplify-proportion $1\
    -- \
    states.json
fi
