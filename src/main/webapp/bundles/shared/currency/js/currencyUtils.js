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

    meerkat.modules.register('currencyUtils', {
        toDollarValue: toDollarValue
    });

})(jQuery);