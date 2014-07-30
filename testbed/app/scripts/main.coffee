require.config
  paths:
    'jquery': '../vendor/jquery/dist/jquery.min'
    'd3': '../vendor/d3/d3'
    'threejs': '../vendor/threejs/build/three'
    'topojson': '../vendor/topojson/topojson'
  shim:
    'd3': exports: 'd3'

requirejs( ['d3', 'threejs', 'topojson'], (d3, threejs, topojson) ->

  makeId = (str) ->
    str.replace(/[!\"\s#$%&'\(\)\*\+,\.\/:;<=>\?\@\[\\\]\^`\{\|\}~]/g, '')

  projection = d3.geo.equirectangular()
  path = d3.geo.path()
    .projection(projection)
  vectorMap = null

  d3.json("../data/maps/merged_subunits.topo.json", (err, _vectorMap) ->
  
    width = 1600
    height = 800


    projection.scale(205)
      .translate([width/2,height/2])
      .center([0, 15])

    vectorMap = _vectorMap
    g = d3.select("body").append("svg")
        .attr
          "width" : width
          "height" : height
          "id" : "vectorMap"
          "fill-opacity" : 0
          "stroke" : "white"
          "fill" : (d) ->
            "red"
          "stroke-width" : 1


    map_path = g.selectAll("path")
      .data(topojson.feature(vectorMap, vectorMap.objects.countries).features)

    map_path.enter()
      .append("path")
      .attr
        "d" : path
        "fill" : "#444"
        "id" : (d) -> 
          console.log d.id
          makeId(d.id)
        "fill-opacity" : 0.3
        "fill" : (d) ->
          val = Math.floor(Math.random() * 4)
          if val is 0
            return "red"
          if val is 1
            return "yellow"
          if val is 2
            return "blue"
        "stroke-opacity" : 0.5

  )
)
