/**
 * Currency Utils Module.
 */

;(function($, undefined){

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        log = meerkat.logging.info;

    /**
     * Converts the from numeric value into a dollar value.
     * Returns the same value if is not a numeric value
     * ex toDollarValue(1000) returns $1,000
     * @param from
     * @returns {*}
     */
    function toDollarValue(from) {
        if (!isNaN(from)) {
            return '$' + from.replace(/\B(?=(\d{3})+(?!\d))/g, ",");
        }
        return from;
    }

    //return a number with comma for thousands
    function formatMoney(value){
        var parts = value.toString().split(".");
        parts[0] = parts[0].replace(/\B(?=(\d{3})+(?!\d))/g, ",");
        return parts.join(".");
    }

    meerkat.modules.register('currencyUtils', {
        formatMoney: formatMoney,
        toDollarValue: toDollarValue
    });

})(jQuery);