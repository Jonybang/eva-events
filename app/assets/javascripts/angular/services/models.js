'use strict';

var app = angular.module('app');
//app.factory('Contact', ['$resource', function($resource) {
//    return $resource('/api/contacts/:id', {id: '@id'}, {'update': {method: 'PUT'}});
//}]);

//app.factory('Project', ['$resource', function($resource) {
//    return $resource('/api/projects/:id', {id: '@id'}, {'update': {method: 'PUT'}});
//}]);

app.factory('ProjectStatus', ['$resource', function($resource) {
    return $resource('/api/project_statuses/:id', {id: '@id'}, {'update': {method: 'PUT'}});
}]);
app.factory('ProjectTaskStatus', ['$resource', function($resource) {
    return $resource('/api/project_task_statuses/:id', {id: '@id'}, {'update': {method: 'PUT'}});
}]);

//app.factory('ProjectTask', ['$resource', 'Helpers', function($resource, Helpers) {
//    return $resource('/api/project_tasks/:id',
//        {id: '@id'},
//        {'update': {
//            method: 'PUT'
//        }});
//}]);
app.factory('Project', ['railsResourceFactory', 'railsSerializer', function (railsResourceFactory, railsSerializer) {
    return railsResourceFactory({
        url: '/api/projects',
        name: 'project',
        serializer: railsSerializer(function () {
            this.exclude('class');
            //this.rename('chief_id', 'contact_id');
        })
    });
}]);
app.factory('ProjectTask', ['railsResourceFactory', 'railsSerializer', function (railsResourceFactory, railsSerializer) {
    return railsResourceFactory({
        url: '/api/project_tasks',
        name: 'project_task',
        serializer: railsSerializer(function () {
            this.exclude('class');
            this.exclude('performers');
            this.exclude('project_status');
            this.exclude('project');
            //this.nestedAttribute('performers');
            this.exclude('contact');
            //this.resource('performers', 'Contact');
        })
    });
}]);
app.factory('ProjectResource', ['railsResourceFactory', 'railsSerializer', function (railsResourceFactory, railsSerializer) {
    return railsResourceFactory({
        url: '/api/project_resources',
        name: 'project_resource',
        serializer: railsSerializer(function () {
            this.exclude('class');
            this.exclude('resoursable_class');
        })
    });
}]);
app.factory('Contact', ['railsResourceFactory', 'railsSerializer', function (railsResourceFactory, railsSerializer) {
    return railsResourceFactory({
        url: '/api/contacts',
        name: 'contact',
        serializer: railsSerializer(function () {
            this.exclude('class');
            this.nestedAttribute('contact_data');
        })
    });
}]);
app.factory('Equip', ['railsResourceFactory', 'railsSerializer', function (railsResourceFactory, railsSerializer) {
    return railsResourceFactory({
        url: '/api/equips',
        name: 'equip',
        serializer: railsSerializer(function () {
            this.exclude('class');
        })
    });
}]);
app.factory('Resoursable', ['railsResourceFactory', 'railsSerializer', function (railsResourceFactory, railsSerializer) {
    return railsResourceFactory({
        url: '/api/resoursable',
        name: 'resoursable',
        serializer: railsSerializer(function () {
            this.exclude('class');
        })
    });
}]);