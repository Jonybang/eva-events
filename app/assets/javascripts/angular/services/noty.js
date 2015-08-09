/*!
 @package noty - jQuery Notification Plugin
 @version version: 2.2.4
 @contributors https://github.com/needim/noty/graphs/contributors

 @documentation Examples and Documentation - http://needim.github.com/noty/

 @license Licensed under the MIT licenses: http://www.opensource.org/licenses/mit-license.php
 */
angular.module('noty', []).provider('$noty', function () {
//    var settings  = $.noty.defaults;
//    angular.extend(settings, {
    angular.extend($.noty.defaults, {
        theme: 'relax',
        type: 'warning',
        layout: 'topCenter',
        timeout: 4000,
        animation : {
            open  : 'animated flipInX',
            close : 'animated flipOutX'
        }
    });
    var settings = $.noty.defaults;

    return {
        settings: settings,
        $get: function () {
            return {
                show: function(options){
                    var temp = {};
                    angular.copy(settings, temp);
                    angular.extend(temp, options)
                    return noty(temp);
                },
                closeAll: function () {
                    return $.noty.closeAll()
                },
                closeById: function (_noty) {
                    return $.noty.close(_noty.options.id)
                },
                clearShowQueue: function () {
                    return $.noty.clearQueue();
                }.bind(this)
            }
        }

    };
});