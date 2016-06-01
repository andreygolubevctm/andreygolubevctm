;(function ($, undefined) {

    function init() {
    }

    function getDropDatePassed(obj) {
        var dropDatePassed = true;
        if(typeof obj.dropDeadDate !== 'undefined') {
            var today = new Date();
            var dropDeadDate = getDropDeadDate(obj);
            dropDatePassed = today.getTime() > dropDeadDate.getTime();
        }
        return dropDatePassed;
    }

    function getDropDeadDate(obj) {
        return typeof obj.dropDeadDate === 'string' ? new Date(obj.dropDeadDate) : obj.dropDeadDate;
    }

    meerkat.modules.register("healthDropDeadDate", {
        init : init,
        getDropDatePassed: getDropDatePassed,
        getDropDate : getDropDeadDate
    });

})(jQuery);