;(function ($, undefined) {

    var meerkat = window.meerkat,
        _dentalArr = [
            'extras.DentalGeneral.benefits.DentalGeneral012PeriodicExam',
            'extras.DentalGeneral.benefits.DentalGeneral114ScaleClean',
            'extras.DentalGeneral.benefits.DentalGeneral121Fluoride'
        ]; // general dental resultPath to sum

    /**
     * Gets dental item value in $ or %
     * @param benefit {string} The benefit resultPath ie. `extras.DentalGeneral.benefits.DentalGeneral012PeriodicExam`
     * @param product {object} The product object
     * @returns {string} The dental value in $ or %
     * @private
     */
    function _getBenefitValue(benefit, product) {
        return benefit.split('.').reduce(function(product, i) {
            return product[i];
        }, product);
    }

    /**
     * Gets the sum of dental items value in $
     * @param values {array} General Dental values
     * @returns {string} The sum in $
     * @private
     */
    function _getSum(values) {
        return '$' + values.reduce(function(total, num) {
            return (total + num);
        }).toFixed(2);
    }

    /**
     * Gets the minimum dental items value in %
     * @param values {array} General Dental values
     * @returns {string} The minimum value in %
     * @private
     */
    function _getMinPercentage(values) {
        return Math.min.apply(null, values) + '%';
    }

    /**
     * Used to get the sum total or percentage of general dental items
     * @param product
     * @returns {string} The total sum in $ or the minimum %
     */
    function getValue(product) {
        var toSumValues = null,
            values = _dentalArr.map(function(dental) {
                var val = _getBenefitValue(dental, product),
                    valLen = val.length;

                toSumValues = (val.slice(0, 1) === '$');
                return toSumValues ? parseFloat(val.slice(1, valLen)) : val.slice(0, valLen - 1);
            });

        return toSumValues ? _getSum(values) : _getMinPercentage(values);
    }

    meerkat.modules.register('healthResultsDentalSum', {
        getValue: getValue
    });

})(jQuery);
