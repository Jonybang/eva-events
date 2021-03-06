// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
// require app_assets
// require polyfiller
//= require modernizr.min

//= require moment-with-locales.min

//= require jquery
//= require jquery_ujs
//= require select2
//= require select2_locale_ru
//= require jquery.validate.min
//= require jquery_nested_form
//= require jquery.noty.packaged.min
//= require selectize.min

//= require angular.min
//= require angular-date-picker-polyfill.min
//= require angular-resource.min
// require angular-route.min

// require ui-bootstrap-tpls
//= require ui-bootstrap-tpls-0.13.4.min
//= require showErrors.min
//= require datetime-picker.min
//= require angular-ui-router.min
//= require ui-router-tabs

//= require ng-rails-csrf
//= require angular-moment.min
//= require angular-debounce.min
//= require angular-sanitize.min
//= require select.min
//= require angularjs/rails/resource
//= require angular-drag-and-drop-lists.min.js
//= require angular-animate.min
//= require angular-selectize

//= require bootstrap
//= require bootstrap-formhelpers.min
//= require bootstrap-formhelpers-phone

//= require d3.min
//= require d3/text-wrap
//= require d3/gantt-chart-d3v2

// require ./angular/modules/projects/projects.js.erb
// require ./angular/modules/gantt/gantt.js.erb
//= require ./angular/modules/rooms/rooms.js.erb
//= require ./angular/modules/organizations/organizations.js.erb
//= require ./angular/modules/forums/forums.js.erb
//= require ./angular/modules/events/events.js.erb
//= require ./angular/modules/persons/persons.js.erb
//= require ./angular/modules/news/news.js.erb
//= require angular/app.js.erb
//= require angular/services/models.js
//= require angular/services/editors.js.erb
//= require_tree ./angular

// require manager

//webshim.polyfill('es5 mediaelement forms forms-ext');
//$(function(){
//    webshim.polyfill('es5 mediaelement forms forms-ext');
//});

//$(document).on("ready page:load", function(){
//    $('.eva-select').select2();
//    $("form").validate();
//    $("input[type='url']").keydown(function() {
//        if(!this.value || this.value == "http:/" || this.value == "https:/"){
//            this.value = '';
//            return;
//        }
//
//        if (!/^https?:\/\//.test(this.value)) {
//            this.value = "http://" + this.value;
//        }
//    });
//});
$(function(){
    $('a.disabled').click(function(){
        noty({text:"Извините, но в настоящее время данная функция недоступна. Сайт находится на стадии альфа."});
        return false;
    });
});
//Date.prototype.addHours= function(h){
//    this.setHours(this.getHours()+h);
//    return this;
//}

var d3RU = {
    "decimal": ",",
    "thousands": "\xa0",
    "grouping": [3],
    "currency": ["", " руб."],
    "dateTime": "%A, %e %B %Y г. %X",
    "date": "%d.%m.%Y",
    "time": "%H:%M:%S",
    "periods": ["AM", "PM"],
    "days": ["воскресенье", "понедельник", "вторник", "среда", "четверг", "пятница", "суббота"],
    "shortDays": ["вс", "пн", "вт", "ср", "чт", "пт", "сб"],
    "months": ["января", "февраля", "марта", "апреля", "мая", "июня", "июля", "августа", "сентября", "октября", "ноября", "декабря"],
    "shortMonths": ["янв", "фев", "мар", "апр", "май", "июн", "июл", "авг", "сен", "окт", "ноя", "дек"]
};
$(function(){


    angular.element(document.body).bind('click', function (e) {
        if(angular.element(e.target).attr('popover-template'))
            return;
        var popups = document.querySelectorAll('.popover');
        if(popups) {
            for(var i=0; i<popups.length; i++) {
                var popup = popups[i];
                var popupElement = angular.element(popup);

                if(popupElement[0].previousSibling != e.target && popupElement[0].previousSibling != e.target.parentElement){
                    popupElement.scope().$parent.isOpen=false;
                    popupElement.remove();
                }
            }
        }
    });


});
