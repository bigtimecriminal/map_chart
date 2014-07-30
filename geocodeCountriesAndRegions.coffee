
fs = require('fs')
nimble = require('nimble')
sleep = require('sleep')
csv = require('ya-csv')

#construct geocoder
geocoder = require('node-geocoder')
geocoderProvider = 'google'
httpAdapter = 'http'
geocoder = require('node-geocoder').getGeocoder(geocoderProvider, httpAdapter)

entries = []
q = []
datafile = 'focusEntries.json'

if fs.existsSync(datafile)
  entries = JSON.parse(fs.readFileSync datafile)
  for d,i in entries
    ((_d,_i) ->
      if not _d.geoInfo?
        q.push((callback) ->
          sleep.usleep(500000)
          geocoder.geocode(_d.placeName, (err, res) ->
            console.log("geocoding", _d.placeName)
            if err
              console.log(_d.placeName, "geocoding error")
            else
              try
                _d.geoInfo = res[0]
              catch e
                console.log(_d.placeName,'error cancelled execution')
            return callback()
          )
        )
    )(d,i)

  q.push( (callback) ->
    output = JSON.stringify(entries,null,2)
    fs.writeFileSync('focusEntities.json', output, 'utf8')
  )

  nimble.series(q)
