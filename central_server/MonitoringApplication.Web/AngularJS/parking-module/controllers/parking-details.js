angular.module("ParkingModule")
    .controller('ParkingDetailsCtrl', function ($scope, Parking) {

        function init() {
            $scope.parking = Parking.get({ parkingId: $scope.parkingId });
        }

        $scope.refreshParking = function() {
            $scope.parking = Parking.get({ parkingId: $scope.parkingId });
        }

        init();
    });