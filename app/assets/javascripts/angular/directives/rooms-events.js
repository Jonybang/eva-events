angular.module('app').directive('roomsEvents', ['$timeout', '$sce', '$q', 'debounce', function($timeout, $sce, $q, $debounce) {
    return {
        restrict: 'E',
        templateUrl: roomsEventsHtml,
        scope: {
            //rooms include or not events
            ngModel: '=',
            //if rooms not include events
            events: '=',
            //date for cross date dropped
            date: '=',
            //callbacks
            ngChange: '&',
            ngClickEvent: '&',
            resoursableAdded: '&',
            //flags
            showAll: '=',
            adderDisabled: '=',
            notCurTaskDisabled: '='

        },
        link: function (scope, element){
            scope.begin_hour = 8;
            scope.end_hour = 17;
            scope.begin_minute = 0;

            var hourPixels = 36;
            var minimum_hours = 0.5;

            function generateHours (){
                if(!scope.events)
                    return;

                scope.hours = [];
                var date = new Date(scope.date);

                while(date.getHours() < scope.end_hour){
                    var hour = {date: angular.copy(date), events: []};

                    scope.events.forEach(function(obj){
                        obj.begin_date = new Date(obj.begin_date);
                        if(obj.begin_date.getHours() == date.getHours()){
                            hour.events.push(obj);
                            scope.setEventStyle(hour, hour.events.length - 1);
                        }
                    });

                    scope.hours.push(hour);

                    date.setHours(date.getHours() + 1);
                }
                refreshRoomsEventsLength();
            }

            scope.$watchCollection('events', generateHours);
            scope.$watchCollection('date', generateHours);

            function refreshRoomsEventsLength(){
                scope.roomsEventsLength = {};
                scope.events.forEach(function(event){
                    if(!scope.roomsEventsLength[event.room_id])
                        scope.roomsEventsLength[event.room_id] = 1;
                    else
                        scope.roomsEventsLength[event.room_id]++;
                })
            }

            function getPixelDiffBetweenDates(first_date, second_date, plus){
                var diff = new Date(second_date) - new Date(first_date);
                var pixels = ((diff * hourPixels) / (60000 * 60));
                if(plus)
                    pixels += plus;

                return pixels  + 'px';
            }


            scope.checkAndSetBeginTime = function(datetime){
                if(getBeginDate(datetime) - datetime >= 60000) {
                    scope.begin_hour = datetime.getHours();
                    scope.begin_minute = datetime.getMinutes();
                    return true;
                }
                return false;
            };
            function getBeginDate(date){
                var minDate = new Date(date);
                minDate.setHours(scope.begin_hour);
                minDate.setMinutes(scope.begin_minute);
                return minDate;
            }


            function checkAndMoveNextEvent(events, curIndex){
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
            };
            scope.getDurationMinutes = function (duration) {
                return Math.ceil(((duration < 1.0) ? duration : (duration % Math.floor(duration))) * 100) * 60/100;
            };


            function logHours(event, after){
                var str = after ? ' ПОСЛЕ: ' : ' ДО: ';
                console.log(event.name + ' НАЧАЛО ' + str + event.begin_date.getHours());
                console.log(event.name + ' ОКОНЧАНИЕ ' + str + event.end_date.getHours());
            }

            scope.refreshStyles = function(){
                scope.ngModel.forEach(function(room){
                    room.events.forEach(function(obj, index){
                        scope.setEventStyle(room.events, index);
                    })
                });
            };
            scope.setEventStyle = function(hour, index){
                events = hour.events;

                if(!events || !events.length)
                    return;
                var event = events[index];
                var prevEvent;
                if(index)
                    prevEvent = events[index - 1];

                event.style = {
                    'display': 'block'
                };

                hour.style = {
                    'height': hourPixels + 'px',
                    'padding-top': ''
                };

                event.content_style = {
                    'height': getPixelDiffBetweenDates(event.begin_date, event.end_date, -12),
                    'background-color': event.color_code
                };

                if(prevEvent)
                    hour.style['padding-top'] = getPixelDiffBetweenDates(prevEvent.end_date, event.begin_date);
                else
                    hour.style['padding-top'] = getPixelDiffBetweenDates(event.begin_date, hour.date);

                return event;
            };
            scope.eventDragStart = function(event){
                event.style.display = 'none';
            }
            scope.eventDragEnd = function(event){
                event.style.display = 'block';
            }
            scope.eventDropped = function(hour, room, item, destIndex){
                item.room_id = room.id;

                item.style.display = 'block';

                var prevIndex = -1;
                hour.events.some(function(obj, idx){
                    var result = obj.id == item.id;
                    if(result){
                        prevIndex = idx;
                    }
                    return result;
                });

                var roomArr = [];
                if(hour.events.length){
                    hour.events.forEach(function(obj, index, array){
                        if(index == destIndex)
                            roomArr.push(item);

                        if(obj.id != item.id && obj.room_id == item.room_id)
                            roomArr.push(obj);
                    });

                    if(destIndex == hour.events.length && hour.events.length > roomArr.length)
                        roomArr.push(item);
                } else {
                    roomArr.push(item);
                }

                var duration = scope.getDuration(item);

                logHours(item);

                if(destIndex && roomArr.length > 1){
                    item.begin_date = new Date(roomArr[destIndex - 1].end_date);
                } else {
                    if(scope.date)
                        item.begin_date = new Date(scope.date);

                    item.begin_date.setHours(hour.date.getHours());
                    item.begin_date.setMinutes(0);
                }

                item.end_date = angular.copy(item.begin_date);
                item.end_date.setHours(item.begin_date.getHours() + duration);
                item.end_date.setMinutes(item.begin_date.getMinutes() + scope.getDurationMinutes(duration));
                logHours(item, true);

                scope.events.some(function(obj, idx){
                    var result = obj.id == item.id;
                    if(result){
                        scope.events[idx] = item;
                    }
                    return result;
                });

                scope.setEventStyle({date: hour.date, events: roomArr}, destIndex == 0 ? 0 : destIndex - 1);

                checkAndMoveNextEvent(roomArr, 0);

                refreshRoomsEventsLength();
                //$timeout(scope.refreshStyles);

                $timeout(scope.ngChange);
                return item;
            };

            scope.resizeEvent = function(hour, index){
                var events = hour.events;
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

                            scope.setEventStyle(hour, index - 1);
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
                    scope.setEventStyle(hour, idx);
                });

                scope.setEventStyle(hour, index);
            };
            scope.clickEvent = function(event){
                if(scope.ngClickEvent)
                    scope.ngClickEvent({event_obj: event});
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