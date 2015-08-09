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
            get_contact: function() {
                return $http.get('/current_contact')
                    .then(function(response) {
                        return service.contact = response.data;
                    });
            }
        };
        return service;
}]);