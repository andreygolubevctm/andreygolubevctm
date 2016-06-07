;(function ($, undefined) {

    function init() {
    }

    function getDropDatePassed(obj) {
        var dropDatePassed = true;
        if(typeof obj.dropDeadDate !== 'undefined') {
            var today = new Date();
            dropDatePassed = today.getTime() > getDropDeadDate(obj).getTime();
        }
        return dropDatePassed;
    }

    function getDropDeadDate(obj) {
        return typeof obj.dropDeadDate === 'string' ? new Date(obj.dropDeadDate) : obj.dropDeadDate;
    }

    function setDropDeadDate(dropDeadDateText, product) {
        if ($.trim(dropDeadDateText) !== '') {
            try {
                var newDate = meerkat.modules.dateUtils.returnDate(dropDeadDateText);
                product.dropDeadDateFormatted = meerkat.modules.dateUtils.format(newDate, "Do of MMMM, YYYY");
                product.dropDeadDate =  newDate;
            } catch(err) {
                meerkat.modules.errorHandling.error({
                    errorLevel: 'silent',
                    page: "healthDropDeadDate.js",
                    message: "Failed to parse dropDeadDateText",
                    description: "Failed to parse dropDeadDateText: " + dropDeadDateText,
                    data: "Error message: " + err.message + " error: " + err
                });
                setDefaultDropDeadDate(product);
            }
        } else {
            setDefaultDropDeadDate(product);
        }
    }

    function setDefaultDropDeadDate(product) {
        var d = new Date();
        product.dropDeadDateFormatted = '31st March '+d.getFullYear();
        product.dropDeadDate =  new Date('31/3/'+d.getFullYear());
    }


    meerkat.modules.register("healthDropDeadDate", {
        init : init,
        getDropDatePassed: getDropDatePassed,
        getDropDeadDate : getDropDeadDate,
        setDropDeadDate : setDropDeadDate
    });

})(jQuery);