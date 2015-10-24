/**
 * Created by jonybang on 19.09.15.
 */
angular.module('app').directive('datetimePicker', ['Helpers', function(Helpers) {
    return {
        require: 'ngModel',
        link: function(scope, elm, attrs, ctrl) {
            if (ctrl && ctrl.$validators) {
                ctrl.$validators.min = function(modelValue) {
                    var result = attrs.min ? false : true;

                    if(modelValue && attrs.min){
                        var cur_date = new Date(modelValue);
                        var min_date = new Date(Helpers.convertDateStringsToDates(attrs.min));

                        result = cur_date > min_date;
                    }
                    return result;
                };
            }
        }
    };
}]);