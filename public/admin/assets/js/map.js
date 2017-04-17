var directionsService ;
var directionsDisplay ;
var map ;

function initMap() {
  directionsService = new google.maps.DirectionsService;
  directionsDisplay = new google.maps.DirectionsRenderer;
  map = new google.maps.Map(document.getElementById('map'), {
    zoom: 7,
    center: {lat: 41.85, lng: -87.65}
  });
  directionsDisplay.setMap(map);
  directionsService.route({
    origin: 'Liberty Market, Lahore',
    destination: 'Kalma Chock, Lahore',
    travelMode: 'DRIVING'
  }, function(response, status) {
    if (status === 'OK') {
      directionsDisplay.setDirections(response);
    } else {
      console.log('Directions request failed due to ' + status);
    }
  });
}

function draw_dir(start_point , end_point){
  directionsService.route({
    origin: start_point,
    destination: end_point,
    travelMode: 'DRIVING'
  }, function(response, status) {
    if (status === 'OK') {
      directionsDisplay.setDirections(response);
    } else {
      console.log('Directions request failed due to ' + status);
    }
  });
}
