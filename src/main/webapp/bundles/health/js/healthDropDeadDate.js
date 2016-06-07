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

    function setDropDeadDate(providerContentText, product) {
        var formattedDate = '';

        if ($.trim(providerContentText) !== '') {
            var dateSplit = providerContentText.split("/");
            var rearrangedDate = dateSplit[1]+"/"+dateSplit[0]+"/"+dateSplit[2];
            var newDate = new Date(rearrangedDate);
            if ( isNaN( newDate.getTime() ) ) {
                setDefaultDropDeadDate(product);
            } else {
                formattedDate = meerkat.modules.dateUtils.format(newDate, "Do of MMMM, YYYY");
                product.dropDeadDateFormatted =  formattedDate;
                product.dropDeadDate =  new Date(rearrangedDate);
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