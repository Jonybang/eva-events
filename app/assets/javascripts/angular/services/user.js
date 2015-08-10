/**
 * Created by jonybang on 04.07.15.
 */
angular.module('app')
    .factory('User', ['$http', function($http) {
        var service = {
            get_id: function() {
                return $http.get('/user_id')
                    .then(function(response) {
                        return service.user_id = response.data;
                    });
            },
            get_person: function() {
                return $http.get('/current_person')
                    .then(function(response) {
                        return service.person = response.data;
                    });
            }
        };
        return service;
}]);