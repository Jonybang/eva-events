/**
 * Created by jonybang on 10.07.15.
 */
angular.module('app').controller('AppCtrl', ['$scope', '$location', 'User', 'Organization',
    function($scope, $location, User, Organization) {
        User.get_person().then(function(result){
            $scope.person = result;
            if(!result.organizations.length)
                return;

            Organization.get(result.organizations[0].id).then(function (organization) {
                $scope.organization = organization;
            });
        });



        $scope.tabsData = [
            { route : 'app.events', heading : 'События' },
            { route : '#', heading : 'Материалы', disabled: true },
            { route : '#', heading : 'Чат', disabled: true }
        ];
    }]);