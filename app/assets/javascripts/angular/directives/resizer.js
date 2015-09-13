/**
 * Created by jonybang on 14.09.15.
 */
angular.module('app').directive('resizer', ['$document', '$timeout', function($document, $timeout) {
    return {
        restrict: 'A',
        scope: {
            ngModel: '=',
            //callbacks
            ngChange: '&'
        },
        link: function ($scope, $element, $attrs){
            var step = 10;
            if(!$scope.ngModel)
                $scope.ngModel = {};

            $element.on('mousedown', function(event) {
                event.preventDefault();

                $scope.ngModel.position = $element.hasClass('top') ? 'top' : 'bottom';

                $scope.ngModel.active = 1;
                $scope.ngModel.initY = event.pageY;

                $scope.ngModel.y = 0;
                $scope.ngModel.stepY = 0;

                $document.on('mousemove', mousemove);
                $document.on('mouseup', mouseup);
            });

            function mousemove(event) {
                // Handle horizontal resizer
                $scope.ngModel.y = $scope.ngModel.initY - event.pageY;
                if(Math.abs($scope.ngModel.y - $scope.ngModel.stepY) >= step){
                    $scope.ngModel.newStepY = Math.ceil($scope.ngModel.y/step) * step - $scope.ngModel.stepY;
                    $scope.ngModel.stepY += $scope.ngModel.newStepY;

                    $timeout($scope.ngChange);

                    $scope.$apply();
                }
            }

            function mouseup(event) {
                $document.unbind('mousemove', mousemove);
                $document.unbind('mouseup', mouseup);
                $scope.ngModel.active = 0;
            }
        }
    };
}]);