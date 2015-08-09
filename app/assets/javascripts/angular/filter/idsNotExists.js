/**
 * Created by jonybang on 28.07.15.
 */
angular.module('app').filter('idsNotExists', function () {
    return function (items, ids) {
        return items.filter(function(obj){
            return ids.indexOf(obj.id) == -1;
        });
    };
});