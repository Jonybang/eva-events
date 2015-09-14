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
            ngClick: '&',
            resoursableAdded: '&',
            //flags
            showAll: '=',
            adderDisabled: '=',
            notCurTaskDisabled: '='

        },
        link: function (scope, element){
            var begin_hour = 8;
            var multipler = 1;
            var minimum_hours = 0.5;

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
                return multipler * (diff / 100000) + 'px';
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
                    nextEvent.end_date.setMinutes(nextEvent.begin_date.getMinutes() + scope.getDurationMinutes(duration));

                    logHours(nextEvent, true);
                }
                scope.setEventStyle(events, nextIndex);

                checkAndMoveNextEvent(events, nextIndex, nextEvent, nextIndex + 1);
            }
            scope.getDuration = function (event) {
                if(!(event.begin_date instanceof Date))
                    event.begin_date = new Date(event.begin_date);
                if(!(event.end_date instanceof Date))
                    event.end_date = new Date(event.end_date);

                return (event.end_date - event.begin_date)/3600000;
            }
            scope.getDurationMinutes = function (duration) {
                return Math.ceil(((duration < 1.0) ? duration : (duration % Math.floor(duration))) * 100) * 60/100;
            }
            function logHours(event, after){
                var str = after ? ' ПОСЛЕ: ' : ' ДО: ';
                console.log(event.name + ' НАЧАЛО ' + str + event.begin_date.getHours());
                console.log(event.name + ' ОКОНЧАНИЕ ' + str + event.end_date.getHours());
            }

            scope.setEventStyle = function(events, index){
                var event = events[index];
                var prevEvent;
                if(index)
                    prevEvent = events[index - 1];

                event.style = {
                    'height': '',
                    'margin-top': ''
                };

                event.style['height'] = getPixelDiffBetweenDates(event.begin_date, event.end_date);

                if(prevEvent)
                    event.style['margin-top'] = getPixelDiffBetweenDates(prevEvent.end_date, event.begin_date);
                return event.style;
            };
            scope.eventDropped = function(events, item, destIndex){
                var prevIndex;
                events.some(function(obj, idx){
                    var result = obj.id == item.id;
                    if(result){
                        prevIndex = idx;
                    }
                    return result;
                });

                if(destIndex - prevIndex == 1)
                    return;

                var duration = scope.getDuration(item);

                logHours(item);

                var prevEventIndex = destIndex - 2;

                var newArr = [];
                if(prevIndex != destIndex){
                    events.forEach(function(obj, index, array){
                        if(index == destIndex)
                            newArr.push(item);

                        if(obj.id != item.id)
                            newArr.push(obj);
                    });

                    if(destIndex == events.length && events.length > newArr.length)
                        newArr.push(item);

                    if(prevEventIndex < 0)
                        prevEventIndex = 0;
                } else {
                    newArr = events;
                    newArr[destIndex] = item;
                    prevEventIndex++;
                }

                if(destIndex)
                    item.begin_date = new Date(newArr[prevEventIndex].end_date);
                else
                    item.begin_date.setHours(begin_hour);

                console.log(newArr);

                item.end_date = angular.copy(item.begin_date);
                item.end_date.setHours(item.begin_date.getHours() + duration);
                item.end_date.setMinutes(item.begin_date.getMinutes() + scope.getDurationMinutes(duration));
                logHours(item, true);

                scope.setEventStyle(newArr, destIndex == 0 ? 0 : destIndex - 1);

                checkAndMoveNextEvent(newArr, 0, item, 1);
                $timeout(scope.ngChange);
                return item;
            };

            scope.resizeEvent = function(events, index){
                var event = events[index];

                var duration = scope.getDuration(event);

                var newMinutes;
                var date;
                if(event.resizer.position == 'bottom'){
                    newMinutes = event.end_date.getMinutes() - event.resizer.newStepY;
                    date = 'end_date';
                } else{
                    newMinutes = event.begin_date.getMinutes() - event.resizer.newStepY;
                    date = 'begin_date';

                    if(index > 0){
                        var prevEvent = events[index - 1];
                        if(prevEvent && prevEvent.end_date >= event.begin_date){
                            prevEvent.end_date = angular.copy(event.begin_date);

                            prevEvent.end_date.setMinutes(prevEvent.end_date.getMinutes() - event.resizer.newStepY);

                            if(prevEvent.begin_date >= event.begin_date){
                                scope.eventDropped(events, prevEvent, index+1);
                                // events.splice(index - 1, 1);
                                // events.splice(index, 0, prevEvent);
                            }

                            scope.setEventStyle(events, index - 1);
                        }
                    }
                }
                var testEvent = angular.copy(event);
                testEvent[date].setMinutes(newMinutes);
                var newDuration = scope.getDuration(testEvent);

                $timeout(scope.ngChange);

                if(newDuration < minimum_hours && newDuration < duration){
                    event.end_date.setHours(event.begin_date.getHours() + minimum_hours);
                    return;
                }

                event[date].setMinutes(newMinutes);

                events.forEach(function(obj, idx){
                    if(idx > index && idx && obj.begin_date <= events[idx - 1].end_date){
                        var duration = scope.getDuration(obj);

                        obj.begin_date = angular.copy(events[idx - 1].end_date);
                        obj.end_date = angular.copy(events[idx - 1].end_date);
                        obj.end_date.setHours(obj.begin_date.getHours() + duration);
                    }
                    scope.setEventStyle(events, idx);
                });

                scope.setEventStyle(events, index);
            };
            scope.clickEvent = function(event){
                if(scope.ngClick)
                    scope.ngClick({event_obj: event});
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