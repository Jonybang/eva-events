/**
 * Created by jonybang on 10.07.15.
 */
angular.module('app').directive('disabled', ['$noty', function ($noty) {

    function link(scope, element, attr, ctrls) {
        element.bind('click', function() {
            $noty.show({text:'Извините, но в настоящее время данная функция недоступна. Сайт находится на стадии альфа.'});
        });
    }

    var directive = {
        restrict: 'AC',
        scope: {},
        link: link
    };
    return directive;
}]);