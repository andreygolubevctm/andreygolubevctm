(function ($) {

    var nonDigitsRegex = /[^\d.-]/g;
    $.validator.addMethod("currency", function (value, elem, param) {
        var val = $(elem).val();

        if (isNaN(val)) {
            val = String(val).replace(nonDigitsRegex, '');
        }

        if (val != '' && val > 0) {
            return true;
        }

        return false;
    });

    /**
     * Convert a value > 3 digits to ###,###,### etc.
     * @param value
     * @returns {string}
     */
    function formatSeparated(value) {
        return String(value).length > 3 ? value.replace(/\B(?=(?:\d{3})+(?!\d))/g, ',') : value;
    }

    /**
     * Example data-attribute rule:
     *      data-rule-currencyrange="{&quot;max&quot;: &quot;100.50&quot;,&quot;t&quot;: &quot;Amount to borrow&quot;}"
     */
    $.validator.addMethod("currencyrange", function(value, elem, param) {

        var minCurrency = param.min ? Number(param.min) : 0,
            maxCurrency = param.max ? Number(param.max) : 0,
            title = param["t"],
            defaultValue = param.dV ? Number(param.dV) : 0;

        if(isNaN(value)) {
            value = String(value).replace(nonDigitsRegex, '');
        }

        if(defaultValue > 0 && value == defaultValue) {
            return true;
        }

        if(minCurrency !== 0 && value < minCurrency) {
            $.validator.messages.currencyrange = title + " cannot be lower than $" + formatSeparated(param.min);
            return false;
        }
        if(maxCurrency !== 0 && value > maxCurrency) {
            $.validator.messages.currencyrange = title + " cannot be higher than $" + formatSeparated(param.max);
            return false;
        }

        return true;

    });

})(jQuery);