angular.module("ParkingModule")
    .controller('MapCtrl', function ($scope, Parking) {

        $scope.parkings = [];

        function init() {
            $scope.parkings = Parking.query(function success(parkings) {
                for (var i in parkings) {
                    var parking = parkings[i];

                    var str = "<b>" + parking.name + "</b>";
                    str += "<br /><br />";
                    str += "Total places: " + parking.totalPlaces + "<br />";
                    str += "Free places: " + parking.freePlaces + "<br />";
                    str += "Blocked places: " + parking.blockedSensors + "<br />";
                    str += "Expired places: " + parking.expiredButOccupiedPlaces;

                    var icon = greenIcon;

                    if (parking.blockedSensors > 0)
                        icon = redIcon;
                    else if (parking.expiredButOccupiedPlaces > 0)
                        icon = yellowIcon;

                    L.marker([parking.gpsCoordinate.latitude, parking.gpsCoordinate.longitude], { icon: icon }).addTo(map)
                        .bindPopup(str);
                }
            });
        }

        var map;

        var greenIcon = L.icon({
            iconUrl: 'content/markers/green-marker.png',
            iconSize: [48, 48], // size of the icon
            iconAnchor: [24, 48], // point of the icon which will correspond to marker's location
            popupAnchor: [0, -30] // point from which the popup should open relative to the iconAnchor
        });
        var blueIcon = L.icon({
            iconUrl: 'content/markers/blue-marker.png',
            iconSize: [48, 48], // size of the icon
            iconAnchor: [24, 48], // point of the icon which will correspond to marker's location
            popupAnchor: [0, -30] // point from which the popup should open relative to the iconAnchor
        });
        var redIcon = L.icon({
            iconUrl: 'content/markers/red-marker.png',
            iconSize: [48, 48], // size of the icon
            iconAnchor: [24, 48], // point of the icon which will correspond to marker's location
            popupAnchor: [0, -30] // point from which the popup should open relative to the iconAnchor
        });
        var yellowIcon = L.icon({
            iconUrl: 'content/markers/yellow-marker.png',
            iconSize: [48, 48], // size of the icon
            iconAnchor: [24, 48], // point of the icon which will correspond to marker's location
            popupAnchor: [0, -30] // point from which the popup should open relative to the iconAnchor
        });

        $scope.displayMap = function () {
            var height = Math.max(document.documentElement.clientHeight, window.innerHeight || 0)
            jQuery("#map").height(height-45);

            // create a map in the "map" div, set the view to a given place and zoom
            map = L.map('map').setView([43.8562586, 18.4130763], 13);

            // add an OpenStreetMap tile layer
            L.tileLayer('http://{s}.tile.osm.org/{z}/{x}/{y}.png', {
                attribution: '&copy; <a href="http://osm.org/copyright">OpenStreetMap</a> contributors'
            }).addTo(map);

            $(window).resize(function () {
                var height = Math.max(document.documentElement.clientHeight, window.innerHeight || 0)
                jQuery("#map").height(height - 45);
                map.invalidateSize();
            });
        }

        init();
    });