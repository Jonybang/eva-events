/**
 * Created by jonybang on 08.07.15.
 */
'use strict';

angular.module('app')
    .factory('Helpers', ['$http', function($http) {

        var service = {
            addOrReplace: function (array, object, id, isPush){
                //Добавляет в массив или обновляет в нем объект, в зависимости от того:
                //задано ли поле id(тоесть существует ли уже объект с таким id)
                if(!id){
                    if(isPush)
                        array.push(object);
                    else
                        array.unshift(object);
                }

                else {
                    array.some(function(obj, index){
                        var result = obj.id == id && obj.class == object.class;
                        if(result){
                            angular.extend(array[index], object);
                        }
                        return result;
                    })
                }
            },
            removeById: function(array, id){
                //Ищет объект в массиве по id и удаляет его
                array.some(function(obj, index){
                    if(obj.id == id){
                        array.splice(index, 1);
                    }
                    return obj.id == id;
                });
            },
            addItemToParentObjectInArrayById: function(array, item, id, fieldInObj){
                //Ищет объект в массиве по id и добавляет в массив найденного объекта
                //параметр item в поле объекта fieldInObj, которое должно являться массивом
                array.some(function(obj, index){
                    if(obj.id == id){
                        //Если не массив или пустой или нет такого поля - просто пересоздаем массив
                        if(!obj[fieldInObj] || !obj[fieldInObj].length)
                            obj[fieldInObj] = [];

                        obj[fieldInObj].push(item);
                    }
                    return obj.id == id;
                });
            },
            parseDatesToStr: function (_object) {
                function parseObjectDates(object){
                    var key;
                    var data = object.resource ? object.resource : object;
                    for (key in data) {
                        if(Object.prototype.toString.call(data[key]) === '[object Date]'){
                            data[key] = this.convertUTCDateToLocalDate(data[key]);
                            data[key] = data[key].getFullYear() +'-'+ ("0" + (data[key].getMonth() + 1)).slice(-2) +'-'+ ("0" + data[key].getDate()).slice(-2);
                        }
                    }
                }
                if(_object.length){
                    _object.forEach(function(item, i){
                        parseObjectDates(_object[i]);
                    })
                }else{
                    parseObjectDates(_object)
                }
                return _object;
            },
            convertUTCDateToLocalDate: function (date) {
                var newDate = new Date(date.getTime()+date.getTimezoneOffset()*60*1000);

                var offset = date.getTimezoneOffset() / 60;
                var hours = date.getHours();

                newDate.setHours(hours - offset);

                return newDate;
            }
        };
        return service;
    }]);
function convertDateStringsToDates (input, toLocal) {
    //var regexIso8601 = /^([\+-]?\d{4}(?!\d{2}\b))((-?)((0[1-9]|1[0-2])(\3([12]\d|0[1-9]|3[01]))?|W([0-4]\d|5[0-2])(-?[1-7])?|(00[1-9]|0[1-9]\d|[12]\d{2}|3([0-5]\d|6[1-6])))([T\s]((([01]\d|2[0-3])((:?)[0-5]\d)?|24\:?00)([\.,]\d+(?!:))?)?(\17[0-5]\d([\.,]\d+)?)?([zZ]|([\+-])([01]\d|2[0-3]):?([0-5]\d)?)?)?)?$/;
    var regexIso8601 = /^(\d{4}|\+\d{6})(?:-(\d{2})(?:-(\d{2})(?:T(\d{2}):(\d{2}):(\d{2})\.(\d{1,})(Z|([\-+])(\d{2}):(\d{2}))?)?)?)?$/;
    //return input;
    // Ignore things that aren't objects.
    if (typeof input !== "object") return input;

    for (var key in input) {
        if (!input.hasOwnProperty(key)) continue;

        var value = input[key];
        var match;
        // Check for string properties which look like dates.
        if (typeof value === "string" && (match = value.match(regexIso8601))) {
            var milliseconds = Date.parse(match[0]);
            if (!isNaN(milliseconds)) {
                if (toLocal) {
                    var date = new Date(milliseconds);
                    var mmnt = moment.utc(date);
                    var local = mmnt.local();
                    var new_date = local.toDate();
                    input[key] = date;
                } else {
                    input[key] = moment(new Date(milliseconds)).utc().toDate();
                }

            }
        } else if (typeof value === "object") {
            // Recurse into object
            convertDateStringsToDates(value);
        }
    }
    return input;
}