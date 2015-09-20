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
app.factory('Forum', ['railsResourceFactory', 'railsSerializer', 'Helpers', function (railsResourceFactory, railsSerializer, Helpers) {
    var resource =  railsResourceFactory({
        url: '/api/forums',
        name: 'forum',
        serializer: railsSerializer(function () {
            this.exclude('class');
        })
    });
    resource.prototype.DeletePerson = function (id, role) {
        var self = this;
        return resource.$delete(self.$url('persons/' + id), {role: role}).then(function (person) {
            Helpers.deleteById(self[role + 's'], id);
            Helpers.deleteById(self[role + '_ids'], id);
            return person;
        });
    };
    resource.prototype.AddPerson = function (id, role) {
        var self = this;
        return resource.$post(self.$url('persons/' + id), {id: id, role: role}).then(function (person) {
            Helpers.addOrReplace(self[role + 's'], person, person.id, true);
            Helpers.pushIdIfNotExist(self[role + '_ids'], person.id);
            return person;
        });
    };
    return resource;
}]);
app.factory('ForumEvent', ['railsResourceFactory', 'railsSerializer', function (railsResourceFactory, railsSerializer) {
    return railsResourceFactory({
        url: '/api/events',
        name: 'event',
        serializer: railsSerializer(function () {
            this.exclude('class');
            this.exclude('event_type');
        })
    });
}]);
app.factory('EventType', ['railsResourceFactory', 'railsSerializer', function (railsResourceFactory, railsSerializer) {
    return railsResourceFactory({
        url: '/api/event_types',
        name: 'event_type',
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
app.factory('Room', ['railsResourceFactory', 'railsSerializer', function (railsResourceFactory, railsSerializer) {
    return railsResourceFactory({
        url: '/api/rooms',
        name: 'room',
        serializer: railsSerializer(function () {
            this.exclude('class');
            this.nestedAttribute('events');
        })
    });
}]);
app.factory('Color', ['railsResourceFactory', 'railsSerializer', function (railsResourceFactory, railsSerializer) {
    return railsResourceFactory({
        url: '/api/colors',
        name: 'color',
        serializer: railsSerializer(function () {
            this.exclude('class');
        })
    });
}]);

app.factory('Models', ['Organization', 'Forum', 'ForumEvent', 'EventType', 'Person', 'Room', 'Color',
        function(Organization, Forum, ForumEvent, EventType, Person, Room, Color) {
            return {
                Organization: Organization,
                Forum: Forum,
                ForumEvent: ForumEvent,
                EventType: EventType,
                Person: Person,
                Room: Room,
                Color: Color
            };
}]);