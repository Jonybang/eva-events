angular.module('app').directive('editor', ['$timeout', function($timeout) {
    return {
        restrict: 'E',
        transclude: true,
        template:
            '<div>' +
                '<div ng-dblclick="isEdit = !isEdit" ng-hide="isEdit">{{ngBind || ngModel}}</div>' +
                '<div ng-show="isEdit"><ng-transclude></ng-transclude></div>' +
            '</div>',
        scope: {
            ngModel: '=',
            ngBind: '=',

            ngSaved: '=',
            //callbacks
            ngChange: '&'
        },
        link: function (scope, element) {
            scope.$watch('ngModel', function() {
                if(scope.isEdit){
                    $timeout(scope.ngChange)
                }
            });
            scope.$watch('ngSaved', function() {
                if(scope.ngSaved){
                    scope.isEdit = false;
                }
            });
        }
    };
}]);