'use strict';

var app = angular.module('app');

app.factory('Organization', ['railsResourceFactory', 'railsSerializer', function (railsResourceFactory, railsSerializer) {
    return railsResourceFactory({
        url: '/api/organizations',
        name: 'organization',
        serializer: railsSerializer(function () {
            this.exclude('class');
            //this.rename('chief_id', 'contact_id');
        })
    });
}]);
app.factory('Forum', ['railsResourceFactory', 'railsSerializer', function (railsResourceFactory, railsSerializer) {
    return railsResourceFactory({
        url: '/api/forums',
        name: 'forum',
        serializer: railsSerializer(function () {
            this.exclude('class');
//            this.exclude('performers');
//            this.exclude('project_status');
//            this.exclude('project');
//            //this.nestedAttribute('performers');
//            this.exclude('contact');
//            //this.resource('performers', 'Contact');
        })
    });
}]);
app.factory('ForumEvent', ['railsResourceFactory', 'railsSerializer', function (railsResourceFactory, railsSerializer) {
    return railsResourceFactory({
        url: '/api/events',
        name: 'event',
        serializer: railsSerializer(function () {
            this.exclude('class');
        })
    });
}]);
app.factory('Person', ['railsResourceFactory', 'railsSerializer', function (railsResourceFactory, railsSerializer) {
    return railsResourceFactory({
        url: '/api/persons',
        name: 'person',
        serializer: railsSerializer(function () {
            this.exclude('class');
            //this.nestedAttribute('contact_data');
        })
    });
}]);