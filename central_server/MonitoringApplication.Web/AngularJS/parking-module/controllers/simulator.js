angular.module("ParkingModule")
    .controller("SimulatorCtrl", function ($scope, Parking, ParkingPlace, UnauthorizedPayment, ParkingPlaceStatus) {

        $scope.parkings = [];
        $scope.parkingPlaces = {};
        $scope.changeStatusHash = {};

        function init() {
            $scope.parkings = Parking.query(
                {},
                function success(parkings) {
                    // Load all parking places
                    for (var i = 0; i < parkings.length; i++) {
                        var parking = parkings[i];
                        console.log("P ", parking.id);
                        Parking.get(
                            { parkingId: parking.id },
                            function success(data) {
                                $scope.parkingPlaces[data.id] = data.parkingPlaces;
                                for (var j = 0; j < data.parkingPlaces.length; j++) {
                                    $scope.changeStatusHash[data.parkingPlaces[j].id] = -1;
                                }
                            }
                        );
                    }
                });
        }

        $scope.changeStatus = function (place) {
            var status = $scope.changeStatusHash[place.id];
            if (status >= 0) {
                ParkingPlaceStatus.get(
                    { parkingId: place.parkingId, placeId: place.id, status: status },
                    function success() {
                        $scope.refreshParkingPlaces(place.parkingId);
                    })
            }
        }

        $scope.pay = function(place) {
            var hours = prompt("Please enter duration in hours:");
            UnauthorizedPayment.save(
            {
                parkingId: place.parkingId,
                parkingPlaceCode: place.code,
                duration: hours + ":00:00"
            },
            function success() {
                $scope.refreshParkingPlaces(place.parkingId);
            })
        }

        $scope.refreshParkingPlaces = function(parkingId) {
            // Update parking
            Parking.get(
                { parkingId: parkingId },
                function success(data) {
                    $scope.parkingPlaces[data.id] = data.parkingPlaces;
                }
            );
        }

        init();
    });