/*
 Borrowed from: https://github.com/lavinjj/angularjs-spinner
 */
'use strict';

angular.module('app').factory('loadingInterceptor', ['$q', '$rootScope', '$noty', '$location', 'debounce',
    function ($q, $rootScope, $noty, $location, debounce) {
        function timeoutForClosing(){
            setTimeout(function(){
                if(!loading.showing){
                    if(loading.close)
                        loading.close();
                    loading = '';
                } else {
                    timeoutForClosing();
                }
            }, 200);
        }
        var loading,
            close = debounce(600, function(){
                timeoutForClosing();
            });
        return {
            request: function (config) {
                if(!loading)
                    loading = $noty.show({text:'Загрузка данных', type:'success', timeout: false, killer: true, dismissQueue: false});

                return config || $q.when(config);
            },
            requestError: function(request){
                $noty.show({text:'Ошибка загрузки данных', type:'error'});
                return $q.reject(request);
            },
            response: function (response) {
                close();
                return response || $q.when(response);
            },
            responseError: function (response) {
                close();
                if (response && response.status === 404) {
                    $noty.show({text:'Ошибка загрузки данных: Не найдено', type:'warning'});
                }
                if (response && response.status >= 500) {
                    $noty.show({text:'Ошибка загрузки данных: Ошибка сервера', type:'error'});
                }
                return $q.reject(response);
            }
        };
    }]);

angular.module('app').config(['$httpProvider', function ($httpProvider) {
    $httpProvider.interceptors.push('loadingInterceptor');
}]);