angular.module('app').directive('roomsEvents', ['$timeout', '$sce', '$q', 'debounce', function($timeout, $sce, $q, $debounce) {
    return {
        restrict: 'E',
        templateUrl: roomsEventsHtml,
        scope: {
            //rooms include or not events
            ngModel: '=',
            //if rooms not include events
            events: '=',
            //callbacks
            ngChange: '&',
            resoursableAdded: '&',
            //flags
            showAll: '=',
            adderDisabled: '=',
            notCurTaskDisabled: '='

        },
        link: function (scope, element){
            var begin_hour = 8;

            var initEvents = $debounce(500, function (){
                if(!scope.events || !scope.events.length ||
                    !scope.ngModel || !scope.ngModel.length)
                        return;

                var eventsLength = 0;
                var roomsIdxs = {};
                scope.ngModel.forEach(function(obj, index){
                    roomsIdxs[obj.id] = index;

                    if(obj.events && obj.events.length)
                        eventsLength += obj.events.length;
                });

                if(scope.events.length == eventsLength)
                    return;

                scope.events.forEach(function(obj){
                    var room = scope.ngModel[roomsIdxs[obj.room_id]];

                    if(!room.events)
                        room.events = [];

                    room.events.push(obj);
                });
            });

            scope.$watchCollection('events', initEvents);
            scope.$watchCollection('ngModel', initEvents);

            function getPixelDiffBetweenDates(first_date, second_date){
                var diff = new Date(second_date) - new Date(first_date);
                return diff / 100000 + 'px';
            }
            function checkAndMoveNextEvent(events, curIndex, curEvent){
                // var curEvent = curEvent ? curEvent : events[curIndex];
                // var nextIndex = (nextIndex || nextIndex === 0) ? nextIndex : (curIndex + 1);
                var nextIndex = curIndex + 1;
                var curEvent = events[curIndex];
                var nextEvent = events[nextIndex];
                if(!nextEvent)
                    return;

                curEvent.end_date = new Date(curEvent.end_date);
                nextEvent.begin_date = new Date(nextEvent.begin_date);

                if(nextEvent.begin_date < curEvent.end_date){
                    var duration = scope.getDuration(nextEvent);
                    logHours(nextEvent);

                    nextEvent.begin_date = new Date(curEvent.end_date);
                    nextEvent.end_date.setHours(nextEvent.begin_date.getHours() + duration);

                    logHours(nextEvent, true);
                }

                checkAndMoveNextEvent(events, nextIndex, nextEvent, nextIndex + 1);
            }
            scope.getDuration = function (event) {
                if(!(event.begin_date instanceof Date))
                    event.begin_date = new Date(event.begin_date);
                if(!(event.end_date instanceof Date))
                    event.end_date = new Date(event.end_date);

                return (event.end_date - event.begin_date)/3600000;
            }
            function logHours(event, after){
                var str = after ? ' ПОСЛЕ: ' : ' ДО: ';
                console.log(event.name + ' НАЧАЛО ' + str + event.begin_date.getHours());
                console.log(event.name + ' ОКОНЧАНИЕ ' + str + event.end_date.getHours());
            }

            scope.getEventStyle = function(events, index){
                var event = events[index];
                var prevEvent;
                if(index)
                    prevEvent = events[index - 1];

                var style = {
                    'height': getPixelDiffBetweenDates(event.begin_date, event.end_date),
                    'margin-top': ''
                };

                if(prevEvent)
                    style['margin-top'] = getPixelDiffBetweenDates(prevEvent.end_date, event.begin_date);
                return style;
            };
            scope.eventDropped = function(events, item, destIndex){
                var prevIndex;
                events.some(function(obj, idx){
                    var result = obj.id == item.id;
                    if(result)
                        prevIndex = idx;
                    return result;
                });
                if(prevIndex == destIndex)
                    return;
                
                var duration = scope.getDuration(item);

                logHours(item);

                var newArr = [];
                events.forEach(function(obj, index, array){
                    if(index == destIndex)
                        newArr.push(item);

                    if(obj.id != item.id)
                        newArr.push(obj);
                });
                if(destIndex == events.length && events.length > newArr.length)
                    newArr.push(item);
                console.log(newArr);

                if(destIndex && destIndex == 1){
                    item.begin_date = new Date(newArr[destIndex - 1].end_date);
                } else if(destIndex) {
                    item.begin_date = new Date(newArr[destIndex - 2].end_date);
                } else {
                    item.begin_date.setHours(begin_hour);
                }
                item.end_date.setHours(item.begin_date.getHours() + duration);
                logHours(item, true);

                // var nextIndex = prevIndex < destIndex ? destIndex : destIndex + 1;
                // checkAndMoveNextEvent(newArr, destIndex, item, nextIndex);
                checkAndMoveNextEvent(newArr, 0, item, 1);
                return item;
            };

            var timer;
            scope.enterAddButton = function(date, res) {
                scope.calendar.forEach(function(_date){
                    _date.hover = false;
                });
                date.timer = res.timer = $timeout(function(){
                    date.hover = res.hover = true;
                }, 400);
            };
            scope.leaveAddButton = function(date, res) {
                $timeout.cancel(date.timer);
                date.hover = res.hover = false;
            };


            Date.prototype.addHours= function(h){
                this.setHours(this.getHours() + parseInt(h));
                return this;
            };
        }
    };
}]);