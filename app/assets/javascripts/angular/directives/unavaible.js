/**
 * Created by jonybang on 11.07.15.
 */
angular.module('app').directive('unavailable', function() {
    return {
        restrict: 'E',
        template: '<span class="glyphicon glyphicon-minus" aria-hidden="true"></span>'
    };
});