;(function ($, undefined) {

    var meerkat = window.meerkat;

    function init() {
    }


    function getDropDatePassed(obj) {
        var dropDatePassed = true;
        if(typeof obj.dropDeadDate !== 'undefined') {
            var today = new Date();
            var dropDeadDate = typeof obj.dropDeadDate === 'string' ? new Date(obj.dropDeadDate) : obj.dropDeadDate;
            dropDatePassed = today.getTime() > dropDeadDate.getTime();
        }
        return dropDatePassed;
    }

    meerkat.modules.register("healthDropDeadDate", {
        init : init,
        getDropDatePassed: getDropDatePassed
    });

})(jQuery);