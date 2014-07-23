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

  d3.json("../data/maps/countries.topo.025.json", (err, _vectorMap) ->
  
    width = 1100
    height = 550


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
          "stroke" : "black"
          "stroke-width" : 1

    console.log g

    map_path = g.selectAll("path")
      .data(topojson.feature(vectorMap, vectorMap.objects.countries).features)

    map_path.enter()
      .append("path")
      .attr
        "d" : path
        "fill" : "#444"
        "id" : (d) -> makeId(d.id)
        "fill-opacity" : 0.3
        "stroke-opacity" : 0.5

    debugger
  )
)