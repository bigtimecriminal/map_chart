SHELL = /bin/sh

include config.mk

all: worldMap.topo.json
	
worldMap.topo.json: states_and_subunits.topo.json
	coffee manualMerge.coffee --r=$(REMOVE_LAYER) --e=$(EXTERNAL_DATA) --m=$(MERGE)
	mkdir -p testbed/data/maps
	cp worldMap.topo.json testbed/data/maps/worldMap.topo.json

states_and_subunits.topo.json : subunits.topo.json states.topo.json
	topojson -o $@ \
		--p SOV_A3 \
		--p SU_A3 \
    --p postal \
    --p longName \
		-- \
		$< \
		$(word 2,$^) \

subunits.topo.json: subunits.json
	topojson \
		-o $@ \
		--id-property $(COUNTRY_ID_PROP) \
		--simplify-proportion $(SIMPLIFY_PROPORTION) \
		--p SOV_A3 \
		--p SU_A3 \
    --p longName=SOVEREIGNT \
		$< 

	topojson-merge $@ \
		--io=subunits \
		--oo=countries \
		-o $@

states.topo.json: states.json
	topojson \
		-o $@ \
		--id-property $(STATE_ID_PROP) \
		--simplify-proportion $(SIMPLIFY_PROPORTION) \
		--p admin \
		--p SOV_A3=sov_a3 \
		--p postal \
    --p longName=name \
		$<

	topojson-merge $@ \
		--io=states \
		--oo=countries2 \
    --k='d.properties.$(MERGED_STATES_ID_PROP)' \
		--p SOV_A3 \
		--p postal \
		-o $@

subunits.json: infiles/ne_10m_admin_0_map_subunits.shp exclude.txt
	ogr2ogr \
		-f GeoJSON \
		-where "$(shell cat exclude.txt)" \
		$@ \
		$<
	coffee adjustSubunits.coffee

states.json: infiles/ne_10m_admin_1_states_provinces_lakes.shp
	ogr2ogr \
		-f GeoJSON \
		-where "adm0_a3='USA' or adm0_a3='CAN'" \
		$@ \
		$<

infiles/ne_10m_admin_0_map_subunits.shp: infiles/ne_10m_admin_0_map_subunits.zip
	unzip -o $< -d infiles
	touch $@

infiles/ne_10m_admin_1_states_provinces_lakes.shp: infiles/ne_10m_admin_1_states_provinces_lakes.zip
	unzip -o $< -d infiles
	touch $@

infiles/ne_10m_admin_0_map_subunits.zip:
	mkdir -p $(dir $@)
	curl -o $@ 'http://naciscdn.org/naturalearth/10m/cultural/ne_10m_admin_0_map_subunits.zip'

infiles/ne_10m_admin_1_states_provinces_lakes.zip:
	mkdir -p $(dir $@)
	curl -o $@ 'http://naciscdn.org/naturalearth/10m/cultural/ne_10m_admin_1_states_provinces_lakes.zip'

exclude.txt:
	./genExcludeFile.sh

clean:
	rm -f states.json
	rm -f states.topo.json
	rm -f states_and_subunits.topo.json
	rm -f subunits.json
	rm -f subunits.topo.json
	rm -f worldMap.topo.json
	rm -f exclude.txt

