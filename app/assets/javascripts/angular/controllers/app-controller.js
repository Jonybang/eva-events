/**
 * Created by jonybang on 10.07.15.
 */
angular.module('app').controller('AppCtrl', ['$scope', 'User', 'Organization', '$state',
    function($scope, User, Organization, $state) {
        var self = this;

        User.get_person().then(function(result){
            $scope.person = result;

            if($state.params.organizationId){
                Organization.get($state.params.organizationId).then(function(organization){
                    self.organization = $scope.organization = organization;
                })
            } else {
                if(!result.organizations.length)
                    return;
                self.organization = $scope.organization = result.organizations[0];
                $state.go('app.organizations.show', {organizationId: self.organization.id});
            }
        });
    }]);