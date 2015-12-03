/**
 * Created by jonybang on 22.09.15.
 */
//= require jquery
//= require slick.min

$(function(){
    if($('#public-rooms-slider').length){
        $('#public-rooms-slider').slick({
            dots: true,
            infinite: true,
            speed: 300,
            slidesToShow: 1,
            adaptiveHeight: true
        })
    }
});