angular.module("ParkingModule", ['ui.router', 'ngResource', 'mgcrea.ngStrap'])
.config(function ($stateProvider, $urlRouterProvider) {
    $stateProvider
        .state('map', {
            url: '/map',
            templateUrl: 'AngularJS/parking-module/templates/map.html',
            controller: 'MapCtrl'
        })
    .state('simulator', {
        url: '/simulator',
        templateUrl: 'AngularJS/parking-module/templates/simulator.html',
        controller: 'SimulatorCtrl'
    });
})
.factory('Parking', function ($resource) {
    return $resource('http://preview.hardver.ba/parkings/api/parkings/:parkingId');
    //return $resource('http://localhost:9009/parkings/api/parkings/:parkingId');
})
.factory("ParkingPlace", function($resource) {
    return $resource('http://preview.hardver.ba/parkings/api/parkings/:parkingId/places/:placeId');
})
.factory("UnauthorizedPayment", function($resource) {
    return $resource("http://preview.hardver.ba/parkings/api/unauthorized-payment");
})
.factory("ParkingPlaceStatus", function ($resource) {
    return $resource('http://preview.hardver.ba/parkings/api/parkings/:parkingId/places/:placeId/status');
});