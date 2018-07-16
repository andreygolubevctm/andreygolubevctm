;(function ($, undefined) {

    var meerkat = window.meerkat;

    /**
     * Gets benefit item value in $ or %
     * @param benefit {string} The benefit resultPath ie. `extras.DentalGeneral.benefits.DentalGeneral012PeriodicExam`
     * @param product {object} The product object
     * @returns {string} The benefit value in $ or %
     * @private
     */
    function _getBenefitValue(benefit, product) {
        return benefit.split('.').reduce(function(product, i) {
            return product[i];
        }, product);
    }

    /**
     * Gets the sum of benefit items value in $
     * @param values {array} Benefit values
     * @returns {string} The sum in $
     * @private
     */
    function _getSum(values) {
        return '$' + values.reduce(function(total, num) {
            return (total + num);
        }).toFixed(2);
    }

    /**
     * Gets the minimum benefit items value in %
     * @param values {array} Benefit values
     * @returns {string} The minimum value in %
     * @private
     */
    function _getMinPercentage(values) {
        return Math.min.apply(null, values) + '%';
    }

    /**
     * Used to get the sum total or percentage of benefit items
     * @param product {object} The product
     * @param benefitsResultsPaths {array} Benefit resultsPath to sum
     * @returns {string} The total sum in $ or the minimum %
     */
    function getValue(product, benefitsResultsPaths) {
        var toSumValues = null,
            values = benefitsResultsPaths.map(function(benefit) {
                var val = _getBenefitValue(benefit, product),
                    valLen = val.length;

                toSumValues = (val.slice(0, 1) === '$');
                return toSumValues ? parseFloat(val.slice(1, valLen)) : val.slice(0, valLen - 1);
            });

        return toSumValues ? _getSum(values) : _getMinPercentage(values);
    }

    meerkat.modules.register('healthResultsBenefitsSum', {
        getValue: getValue
    });

})(jQuery);
