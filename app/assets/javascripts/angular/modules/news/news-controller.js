/**
 * Created by jonybang on 10.08.15.
 */
'use strict';

var app = angular.module('app.news');

app.controller('NewsCtrl', ['$scope', 'News', 'NewsEditor', 'Helpers', '$state', '$modal', function($scope, News, NewsEditor, Helpers, $state, $modal) {
    function getNews(){
        News.query({forum_id: $state.params.forumId, sort:'created_at_DESC'}).then(function(news){
            $scope.news_list = news;
        });
    }
    getNews();
    $scope.newOrEditEvent = function(forum, news){
        NewsEditor({forum_id: forum.id}, news).then(function(result){
            Helpers.addOrReplace($scope.news_list, result, result.id, true);
        });
    };
}]);