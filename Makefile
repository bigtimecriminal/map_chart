SHELL = /bin/sh
SIMPLIFY_PROPORTION = 0.05
REMOVE_LAYERS = ""

all: worldMap.topo.json
	
worldMap.topo.json: states_and_subunits.topo.json
	coffee manualMerge.coffee --r $(REMOVE)

states_and_subunits.topo.json : subunits.topo.json states.topo.json
	topojson -o $@ \
		--p SOV_A3 \
		--p SU_A3 \
		-- \
		$< \
		$(word 2,$^) \

subunits.topo.json: subunits.json
	topojson \
		-o $@ \
		--id-property SOVEREIGNT \
		--simplify-proportion $(SIMPLIFY_PROPORTION) \
		--p SOV_A3 \
		--p SU_A3 \
		$< 

	topojson-merge $@ \
		--io=subunits \
		--oo=countries \
		-o $@

states.topo.json: states.json
	topojson \
		-o $@ \
		--id-property name \
		--simplify-proportion $(SIMPLIFY_PROPORTION) \
		--p admin \
		--p SOV_A3=sov_a3 \
		$<

	topojson-merge $@ \
		--io=states \
		--oo=countries2 \
    --k='d.properties.admin' \
		--p SOV_A3 \
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
	curl -o $@ 'http://www.nacis.org/naturalearth/10m/cultural/ne_10m_admin_0_map_subunits.zip'

infiles/ne_10m_admin_1_states_provinces_lakes.zip:
	mkdir -p $(dir $@)
	curl -o $@ 'http://www.nacis.org/naturalearth/10m/cultural/ne_10m_admin_1_states_provinces_lakes.zip'

exclude.txt:
	./genExcludeFile.sh

clean:
	rm -rf *.json
	rm exclude.txt
