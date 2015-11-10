mapbox = Layer.create!(source: "osm", name: "MapBox Street", url: "http://{s}.tiles.mapbox.com/v3/examples.map-i87786ca/{z}/{x}/{y}.png", urlssl: "https://{s}.tiles.mapbox.com/v3/examples.map-i87786ca/{z}/{x}/{y}.png", attribution: "Tiles by MapBox")
mapnik = Layer.create!(source: "osm", name: "Mapnik", url: "http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png", urlssl: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png", attribution: "Tiles by OpenStreetMap")
mapnik_fr = Layer.create!(source: "osm", name: "Mapnik-fr", url: "http://{s}.tile.openstreetmap.fr/osmfr/{z}/{x}/{y}.png", urlssl: "https://{s}.tile.openstreetmap.fr/osmfr/{z}/{x}/{y}.png", attribution: "Tiles by OpenStreetMap-France")
mapquest = Layer.create!(source: "osm", name: "MapQuest", url: "http://otile2.mqcdn.com/tiles/1.0.0/osm/{z}/{x}/{y}.png", urlssl: "https://otile2-s.mqcdn.com/tiles/1.0.0/osm/{z}/{x}/{y}.png", attribution: "Tiles by MapQuest")
stamen_bw = Layer.create!(source: "osm", name: "Stamen B&W", url: "http://{s}.tile.stamen.com/toner/{z}/{x}/{y}.png", urlssl: "https://stamen-tiles-{s}.a.ssl.fastly.net/toner/{z}/{x}/{y}.png", attribution: "Tiles by Stamen Design")
here_layer = Layer.create!(source: "here", name: "Here", url: "http://4.base.maps.cit.api.here.com/maptile/2.1/maptile/newest/normal.day/{z}/{x}/{y}/256/png8?app_id=yihiGwg1ibLi0q6BfBOa&app_code=5GEGWZnjPAA-ZIwc7DF3Mw", urlssl: "https://4.base.maps.cit.api.here.com/maptile/2.1/maptile/newest/normal.day/{z}/{x}/{y}/256/png8?app_id=yihiGwg1ibLi0q6BfBOa&app_code=5GEGWZnjPAA-ZIwc7DF3Mw", attribution: "Here")
osrm = RouterOsrm.create!(mode: "car", name: "project-osrm.org", url_time:"http://router.project-osrm.org", url_isochrone:"http://localhost:1723")
here_router = RouterHere.create!(mode: "truck", name: "Here")
otp_router = RouterOtp.create!(mode: "public_transport", name: "OpenTripPlanner-Bordeaux", url_time:"http://localhost:8080", ref:"bordeaux")
profile_osm = Profile.create!(name: "OSM", layers: [mapbox, mapnik, mapnik_fr, mapquest, stamen_bw], routers: [osrm])
profile_here = Profile.create!(name: "Here", layers: [here_layer], routers: [here_router])
profile_otp = Profile.create!(name: "OpenTripPlanner", layers: [mapbox, mapnik, mapnik_fr, mapquest, stamen_bw], routers: [otp_router])
profile_all = Profile.create!(name: "All", layers: [mapbox, mapnik, mapnik_fr, mapquest, stamen_bw, here_layer], routers: [osrm, here_router, otp_router])
reseller = Reseller.create!(host: "localhost:3000", name: "Mapotempo")
customer = Customer.create!(reseller: reseller, name: "Toto", default_country: "France", router: osrm, profile: profile_osm, test: true, max_vehicles: 10)
admin = User.create!(email: "admin@example.com", password: "123456789", reseller: reseller, layer: mapbox)
fred = User.create!(email: "test@example.com", password: "123456789", layer: mapbox, customer: customer)
toto = User.create!(email: "toto@example.com", password: "123456789", customer: customer)
store = Store.create!(name: "l1", street: "Place Picard", postalcode: "33000", city: "Bordeaux", lat: 44.81673, lng: -0.55115, customer: customer)
Vehicle.create!(capacity: 100, customer: customer, name: "Renault Kangoo", store_start: store, store_stop: store)
Vehicle.create!(capacity: 100, customer: customer, name: "Fiat Vito", store_start: store, store_stop: store)
Destination.create!(name: "l1", street: "Place Picard", postalcode: "33000", city: "Bordeaux", lat: 44.84512, lng: -0.578, quantity: 1, customer: customer)
Destination.create!(name: "l2", street: "Rue Esprit des Lois", postalcode: "33000", city: "Bordeaux", lat: 44.83395, lng: -0.56545, quantity: 1, customer: customer)
Destination.create!(name: "l3", street: "Rue de Nuits", postalcode: "33000", city: "Bordeaux", lat: 44.84272, lng: -0.55013, quantity: 1, customer: customer)
Destination.create!(name: "l4", street: "Rue de New York", postalcode: "33000", city: "Bordeaux", lat: 44.86576, lng: -0.57577, quantity: 1, customer: customer)
Tag.create!(label: "lundi", customer: customer)
Tag.create!(label: "jeudi", customer: customer)
Tag.create!(label: "frigo", customer: customer)
