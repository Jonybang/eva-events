angular.module('app').directive('focusMe', ['$timeout', function($timeout) {
    return {
        link: function(scope, element, attrs) {
            scope.$watch(attrs.focusMe, function(value) {
                if(value === true) {
                    console.log('value=',value);
                    $timeout(function() {
                        element[0].focus();
                        scope[attrs.focusMe] = false;
                    }, 500);
                }
            });
        }
    };
}]);