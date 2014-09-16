require.config
  paths:
    'jquery': '../vendor/jquery/dist/jquery.min'
    'd3': '../vendor/d3/d3'
    'threejs': '../vendor/threejs/build/three'
    'topojson': '../vendor/topojson/topojson'
    'underscore': '../vendor/underscore/underscore'
  shim:
    'd3': exports: 'd3'

requirejs( ['d3', 'threejs', 'topojson', 'underscore'], (d3, threejs, topojson, _) ->

  makeId = (str) ->
    str.replace(/[!\"\s#$%&'\(\)\*\+,\.\/:;<=>\?\@\[\\\]\^`\{\|\}~]/g, '')

  # projection = d3.geo.albersUsa()
  projection = d3.geo.equirectangular()
  path = d3.geo.path()
    .projection(projection)
  subunits = null
  vectorMap = null

  getCentroid = (d) ->
    path.centroid(d)

  d3.json("../data/maps/worldMap.topo.json", (err, _vectorMap) ->
    width = 1600
    height = 800

    projection.scale(805)
      .translate([width/2,height/2])
      .center([30, 15])
      .rotate([-10,0])

    vectorMap = _vectorMap
    svg = d3.select("body").append("svg").attr
        "width" : width
        "height" : height
    g =  svg.append("g")
        .attr
          "id" : "vectorMap"
          "fill-opacity" : 0
          "stroke" : "white"
          "fill" : (d) ->
            "red"
          "stroke-width" : 1

    layerToDisplay = "countries"

    featureSet = topojson.feature(vectorMap, vectorMap.objects[layerToDisplay])
    geometries = featureSet.features

    map_path = g.selectAll("path")
      .data(geometries)

    map_path.enter()
      .append("path")
      .attr
        "d" : path
        "fill" : "#444"
        "id" : (d) -> if d.id? then makeId(d.id) else "State"
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

    g.selectAll(".place-label")
      .data(geometries)
      .enter()
      .append("circle")
      .attr
        "class" : "place-label"
        "cx" : (d) -> getCentroid(d)[0]
        "cy" : (d) -> getCentroid(d)[1]
        "r" : 2
        "fill" : "#000"
        "fill-opacity" : 1
        "stroke-opacity" : 0

    zoom = d3.behavior.zoom()
      .on("zoom", () ->
        g.attr("transform","translate("+
            d3.event.translate.join(",")+")scale("+d3.event.scale+")")
      )

    svg.call(zoom)
  )
)
