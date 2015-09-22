/**
 * Created by jonybang on 28.07.15.
 */
angular.module('app').filter('enducement',['Helpers', function (Helpers) {
    return function (num, words) {
        return Helpers.enducement(num, words[0], words[1], words[2]);
    };
}]);