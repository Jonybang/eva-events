/**
 * Created by jonybang on 09.08.15.
 */
angular.module('app').directive('animatedButton', ['$animate', 'debounce', '$timeout', function($animate, debounce, $timeout) {
    return {
        restrict: 'E',
        template: '<button type="button" ng-hide="notChanged && hideBeforeChange" class="btn btn-primary {{classes}}" ng-click="click()">{{text}}</button>',
        scope: {
            //require
            ngModel: '=',
            text: '@',
            //sub
            classes: '@',
            hideBeforeChange: '=',
            //callbacks
            ngClick: '&'
        },
        link: function (scope, element) {

            function addAndRemoveAnimate(animation, hideAfter){
                $animate.addClass(element.find('.btn'), 'animated ' + animation).then(function(){
                    $animate.removeClass(element.find('.btn'), 'animated ' + animation);

                    if(hideAfter)
                        scope.notChanged = true;
                });
            }
            var debounceAnimate = debounce(500, addAndRemoveAnimate);

            scope.notChanged = true;
            var isFirst = true;

            scope.$watch('ngModel', function(){
                if(isFirst){
                    isFirst = false;
                    return;
                }

                if(scope.notChanged)
                    addAndRemoveAnimate('bounceInDown');
                else
                    debounceAnimate('bounce');

                scope.notChanged = false;
            });
            scope.click = function(){
                if(scope.ngClick)
                    $timeout(scope.ngClick);

                addAndRemoveAnimate('bounceOutUp', true);
            }
        }
    };
}]);