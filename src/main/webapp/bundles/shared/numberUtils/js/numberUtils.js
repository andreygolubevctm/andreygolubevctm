////////////////////////////////////////////////////////////////
//// UTILITIES MODULE                                       ////
////--------------------------------------------------------////
//// This is just a module to put small common functions in ////
//// for use across the framework. Don't let this get out   ////
//// of hand, as good functionality should be promoted to   ////
//// module of it's own.                                    ////
////--------------------------------------------------------////
//// REQUIRES: jquery as $, underscorejs as _ for _.map     ////
////--------------------------------------------------------////
////////////////////////////////////////////////////////////////

;(function($, undefined){

    var meerkat = window.meerkat;

    //return a number with a leading zero if required
    function leadingZero(value){
        if(value < 10){
            value = '0' + value;
        }
        return value;
    }


    meerkat.modules.register('numberUtils', {
        leadingZero: leadingZero
    });

})(jQuery);
