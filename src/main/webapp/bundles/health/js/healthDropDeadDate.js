;(function ($, undefined) {

    var meerkat = window.meerkat;

    function init() {
    }


    function getDropDatePassed(obj) {
        var today = new Date();
        var dropDatePassed = true;
        if(typeof obj.dropDeadDate !== 'undefined') {
            dropDatePassed = today.getTime() > obj.dropDeadDate.getTime();
        }
        return dropDatePassed;
    }

    meerkat.modules.register("healthDropDeadDate", {
        init : init,
        getDropDatePassed: getDropDatePassed
    });

})(jQuery);