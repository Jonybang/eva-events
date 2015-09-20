/*!
 @package noty - jQuery Notification Plugin
 @version version: 2.2.4
 @contributors https://github.com/needim/noty/graphs/contributors

 @documentation Examples and Documentation - http://needim.github.com/noty/

 @license Licensed under the MIT licenses: http://www.opensource.org/licenses/mit-license.php
 */
angular.module('noty', []).factory('$noty', ['$q', function ($q) {
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

    var service = {
        settings: settings,
        show: function(options){
            return noty(service.extendOptions(options));
        },
        dialog: function(options){
            return $q(function(resolve, reject) {
                var temp = {
                    timeout: false,
                    type: 'confirm',
                    layout: 'center',
                    animation : {
                        open: 'animated tada',
                        close : 'animated bounceOut'
                    },
                    buttons: [
                        {addClass: 'btn btn-danger', text: 'Ок', onClick: function($noty) {
                            // this = button element
                            // $noty = $noty element
                            $noty.close();
                            resolve();
                        }
                        },
                        {addClass: 'btn btn-default', text: 'Отмена', onClick: function($noty) {
                            $noty.close();
                            reject();
                        }
                        }
                    ]
                };

                noty(service.extendOptions(options, temp));

            });
        },
        message: function(options){
            noty(service.extendOptions(options, {animation: {open: 'animated bounceInRight'}, type: 'information', layout: 'bottomRight', timeout: 10000}));
        },
        extendOptions: function(options, sub_temp){
            var temp = angular.copy(settings);

            if(sub_temp)
                angular.extend(temp, sub_temp);

            if(options)
                angular.extend(temp, options);

            return temp;
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
    };
    return service;
}]);