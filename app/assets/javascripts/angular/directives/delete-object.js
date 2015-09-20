/**
 * Created by jonybang on 19.09.15.
 */
angular.module('app').directive('deleteObject', ['Models', '$noty', '$timeout', function(Models, $noty, $timeout) {
    return {
        restrict: 'A',
        scope: {
            deleteObject: '=',
            objModel: '@',
            deleteSuccess: '&'
        },
        link: function ($scope, $element, $attrs){
            $element.click(function(){
                if(!$scope.objModel || !$scope.deleteObject || !$scope.deleteObject.id)
                    return;

                $noty.dialog({text:'Вы действительно хотите удалить объект "' + $scope.deleteObject.name + '"?'}).then(function(){
                    var objPromise = new Models[$scope.objModel]({id: $scope.deleteObject.id}).delete();
                    objPromise.then(function(){
                        $noty.message({text:'Объект "' + $scope.deleteObject.name + '" успешно удален.'});
                        $timeout($scope.deleteSuccess);
                    });
                })
            });
        }
    };
}]);