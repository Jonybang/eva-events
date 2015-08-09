/**
 * Created by jonybang on 07.08.15.
 */

'use strict';

var app = angular.module('app.resources');

app.controller('ResourcesIndexCtrl', ['$scope', '$state', '$animate', '$element', '$timeout', 'debounce',
    'Resoursable', 'Contact', 'ContactEditor', 'Equip', 'EquipEditor', 'ProjectResource', 'Helpers',
    function($scope, $state, $animate, $element, $timeout, debounce,
             Resoursable, Contact, ContactEditor, Equip, EquipEditor, ProjectResource, Helpers) {
    $scope.tabsData = [
        { route : 'app.resources.all', heading : 'Все' },
        { route : 'app.resources.contacts', heading : 'Люди' },
        { route : 'app.resources.equips', heading : 'Оборудование' }
    ];
    $scope.opened = {};

    var self = this;
    self.begin_date = new Date('08/11/2015');
    self.end_date = new Date();
    self.end_date.setDate(self.begin_date.getDate() + 9);

    ProjectResource.query().then(function(resources){
        $scope.list = self.list = resources;
    });

    self.resourcesChanged = function(){
        self.toggleChanged = !self.toggleChanged;
    };
    self.saveChanges = function(){
        self.list.forEach(function(res){
            var resource = new ProjectResource(res).update();
        });
    };

    self.getResources = function () {
        Resoursable.query().then(function(resources){
            self.resources = resources;
        });
    };
    self.getContacts = function () {
        Contact.query().then(function(contacts){
            self.contacts = contacts;
        });
    };
    self.getEquips = function () {
        Equip.query().then(function(equips){
            self.equips = equips;
        });
    };

    self.newOrEditResource = function (resource){
        //Добавляет или редактирует ресурс
        //Если ресурс передан как аргумент - то редактируем его

        var Editor, getFunction, array;
        if(resource.class == 'Contact'){
            Editor = ContactEditor;
            getFunction = self.getContacts;
            array = self.contacts;
        }
        else if(resource.class == 'Equip'){
            Editor = EquipEditor;
            getFunction = self.getEquips;
            array = self.equips;
        }

        if($state.current.name == 'app.resources.all'){
            getFunction = self.getResources;
            array = self.resources;
        }

        Editor({}, resource).then(function(result){
            if(result.is_new){
                getFunction();
            } else {
                Helpers.addOrReplace(array, result, result.id, true);
            }
        });
    };
}]);
app.controller('ResourcesAllCtrl', ['$scope', function($scope) {
    $scope.resCtrl.getResources();
}]);
app.controller('ResourcesContactsCtrl', ['$scope', function($scope) {
    $scope.resCtrl.getContacts();
}]);

app.controller('ResourcesEquipsCtrl', ['$scope', function($scope) {
    $scope.resCtrl.getEquips();
}]);

app.controller('ContactsFormCtrl', ['$scope', 'Contact', '$modalInstance', 'inputs', function($scope, Contact, $modalInstance, inputs) {
    $scope.contact = {
        contact_data : {}
    };

    if(inputs.contact_id){
        Contact.get(inputs.contact_id).then(function(contact){
            angular.extend($scope.contact, contact);
        })
    }

//    $scope.refreshResponsible = function(q, selected) {
//        return Contact.query({q: q, limit:50}).then(function(contacts){
//            if(!selected || !selected.length)
//                $scope.responsible = contacts;
//            else
//                $scope.responsible = contacts.filter(function(contact){
//                    return selected.indexOf(contact.id) == -1;
//                });
//        });
//    };

    $scope.save = function() {
        $scope.$broadcast('show-errors-check-validity');
        if (!$scope.contactForm.$valid) {
            return;
        }

        var obj;
        //если id нет - значит это новый контакт
        if(!$scope.contact.id)
            obj = new Contact($scope.contact).create();
        else
            obj = new Contact($scope.contact).update();

        obj.then(function success (result){
                var contact = result.resource ? result.resource : result;
                $modalInstance.close(contact);
            },
            function error (info){
                $scope.errors = info.data.errors;
            });
    }
}]);
app.controller('EquipsFormCtrl', ['$scope', 'Equip', '$modalInstance', 'inputs', function($scope, Equip, $modalInstance, inputs) {
    $scope.equip = {
    };

    if(inputs.equip_id){
        Equip.get(inputs.equip_id).then(function(equip){
            angular.extend($scope.equip, equip);
        })
    }

//    $scope.refreshResponsible = function(q, selected) {
//        return Contact.query({q: q, limit:50}).then(function(contacts){
//            if(!selected || !selected.length)
//                $scope.responsible = contacts;
//            else
//                $scope.responsible = contacts.filter(function(contact){
//                    return selected.indexOf(contact.id) == -1;
//                });
//        });
//    };

    $scope.save = function() {
        $scope.$broadcast('show-errors-check-validity');
        if (!$scope.equipForm.$valid) {
            return;
        }

        var obj;
        //если id нет - значит это новый контакт
        if(!$scope.equip.id)
            obj = new Equip($scope.equip).create();
        else
            obj = new Equip($scope.equip).update();

        obj.then(function success (result){
                var equip = result.resource ? result.resource : result;
                $modalInstance.close(equip);
            },
            function error (info){
                $scope.errors = info.data.errors;
            });
    }
}]);