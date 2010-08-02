var map;
var markers = {}; // used to manage markers, including deletion

// function initialize() {
jQuery(function(){
  
  // zoom should be set globally
  var zoom = zoom || 10;
  // check for out of range zoom
  if ((zoom < 0) || (zoom > 21)) { zoom = 3; }

  // set the default lat/lng
  if(!lat || !lng) {
    var lat = 40.1;
    var lng = -105.17;
  }
  // check for out of range lat/lng
  if ((lng < -180) || (lng > 180)) { lng = 0; }
  if ((lat < -90) || (lat > 90)) { lat = 0; }

  var latLng = new google.maps.LatLng(lat, lng);
  var mapOptions = {
    zoom: zoom,
    center: latLng,
    mapTypeId: google.maps.MapTypeId.ROADMAP
  };

  map = new google.maps.Map(document.getElementById("map_canvas"), mapOptions);
  loadMarkers(map);
});

// Deletes all markers in the array by removing references to them
// Changed: now takes an array of keys to ignore as a parameter. Markers
// with these keys are passed over (left on the map)
function deleteOverlays(keysToIgnore) {
  keysToIgnore = keysToIgnore || [];
  if (markers) {
    for(var key in markers) {
      try {
        if(keysToIgnore.indexOf(key) == -1) {
          markers[key].setMap(null);
        }
      }
      catch(e) {
        // IE6 and IE7 do not understand the Array.indexOf() method so we
        // are manually doing checking the key against the ignore list
        var remove = true;
        for(var i in keysToIgnore) {
          if(keysToIgnore[i] == key) {
            remove = false;
            break;
          }
        }
        // marker key is not in ignore list so remove marker from map
        if(remove) { markers[key].setMap(null); }
      }
    }
  }
}

var chart_counter = 0; // used to open multiple connections to get charts
function get_marker_icon(item) {
  // the performance improvement of loading charts through multiple connections doesn't work:
  // http://code.google.com/apis/chart/docs/making_charts.html#enhancements
  // var icon_url = "http://" + chart_counter + ".chart.apis.google.com/chart?chst=d_map_spin&chld=",
  var color = 'F1A831'; // globe light orang;
  var icon_url = "http://chart.apis.google.com/chart?chst=d_map_spin&chld=",
      icon_options_1_99 = ".5|0|" + color + "|8|_|";
  // var icon_url = "http://gmaps-samples.googlecode.com/svn/trunk/markers/blue/";
  chart_counter++;
  if (chart_counter > 9) { chart_counter = 0; }

  var marker_icon = icon_url + icon_options_1_99 + 'Truck';

  // console.log("item count=" + item.count + ", latlng=" + item.lat + "," + item.lng + ", name=" + item.name + ", icon=" + marker_icon);
  return marker_icon;
}

function loadMarkers(map) {
  var infowindow = new google.maps.InfoWindow();
  function redo() {
    var center = map.getCenter(),
    args = {};

    // collect params for server side request
    args.lat = center.lat();
    args.lng = center.lng();
    jqMapDiv = jQuery(map.getDiv());
    args.map_width = jqMapDiv.width();
    args.map_height = jqMapDiv.height();
    args.bounds = map.getBounds().toUrlValue(); // "lat_lo,lng_lo,lat_hi,lng_hi" SW, NE corners
    args.zoom = map.getZoom();

    jQuery.ajax({
      type: "GET",
      url: '/locations/markers',
      dataType: 'json',
      data: args,
      error: function(xhr, status, error) {
        alert(status);
      },
      success: function(data){
        var markerKeys = []; // keeps track of keys to ignore when removing markers from map

        jQuery.each(data, function(index, item){
          var marker;

          if(markers[item.key]) { // handle existing marker
            // if marker not currently on map...
            if(!markers[item.key].getMap()) {
              markers[item.key].setMap(map);
            }
          }
          else { // create a new marker

            marker = new google.maps.Marker({ position: (new google.maps.LatLng(item.lat, item.lng)),
                                              map: map,
                                              icon: get_marker_icon(item),
                                              title: item.name,
                                              clickable: true
                                            });

            markers[item.key] = marker;

            // popup info window
            if (item.description) {
              google.maps.event.addListener(marker, 'click', function() {
                infowindow.setContent(item.description);
                infowindow.open(map, marker);
              });
            }
            else {
              google.maps.event.addListener(marker, 'click', function() {
                map.panTo(new google.maps.LatLng(item.lat, item.lng));
                map.setZoom(map.getZoom()+1);
              });
            }
          }

          markerKeys.push(item.key);
        });

        deleteOverlays(markerKeys);
      }
    });
  };
  // google.maps.event.addListener(map, 'bounds_changed', redo);
  google.maps.event.addListener(map, 'idle', redo);
}
