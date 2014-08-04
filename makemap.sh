#!/bin/bash
# recommend running with ./makemap.sh 0.05 subunits

rm subunits.json
rm subunits.topo.json
rm merged_subunits.topo.json
rm states.json
rm mergedStatesAndSubunits.json

exclude=( 'ATA' 'HMD' 'PYF' 'ATF' 'ALA' 'CYM' 'FLK' 'GGY' 'NCL' 'NIU' 'NFK' 'BLM' 'SHN' 'MAF' 'SPM' 'SXM' 'SGS' 'TCA' 'UMI' 'VIR' 'WLF' \
  'NSV' 'FRO' 'ECG' 'EUI' 'SFA' 'FSA' 'SGG' 'ATB' 'ATS' 'PAZ' 'PMD' 'ESC' 'FJI' 'NJM' 'WSM' 'TON' 'NZC' 'KIR' 'NZA' 'GUM' 'MNP' 'PLW' 'REU' 'MUS' \
  'BAC' 'CHP' 'ASM' 'SHS' 'SGX' 'FSM' 'SYC' 'ZAI'\
  'CPV' )
query=$(printf "and SU_A3 <> '%s' " "${exclude[@]}")
query=${query:4}
echo $query

#construct US states
ogr2ogr \
  -f GeoJSON \
  -where "adm0_a3='USA'" \
  states.json \
  infiles/ne_10m_admin_1_states_provinces.shp

#construct geoJSON
ogr2ogr \
  -f GeoJSON \
  -where "$query" \
  subunits.json \
  infiles/ne_10m_admin_0_map_subunits.shp

#construct topoJSON subunits
topojson \
  -o subunits.topo.json \
  --id-property SOVEREIGNT \
  --simplify-proportion $1\
  --p SOV_A3 \
  subunits.json \
  states.json

#merge subunits
topojson-merge subunits.topo.json \
  --io=subunits \
  --oo=countries \
  --key='d.SOV_A3' \
  -o merged_subunits.topo.json

cp merged_subunits.topo.json testbed/data/maps/merged_subunits.topo.json

