;(function ($) {
    var meerkat = window.meerkat;

    /**
     * Get the list of available extras.
     */
    function getAvailableExtrasAsList(obj) {
        var feature = Features.getPageStructure(obj.featuresStructureIndexToUse)[0];
        var availableExtras = [], output = "";
        _.each(feature.children, function (ft) {
            var hasResult = ft.resultPath != null && ft.resultPath !== '';
            var pathValue = hasResult ? Object.byString(obj, ft.resultPath) : false;
            if (pathValue == "Y") {
                availableExtras.push(ft);
            }
        });
        _.each(availableExtras, function (ft, i) {
            var separator = '';
            if (i != availableExtras.length - 1) {
                separator = ', ';
            } else if (i == (availableExtras.length - 2)) {
                separator = ' and ';
            }
            output += ft.safeName + separator;
        });
        
        return output;

    }


    function getExcessChildTemplate(obj, ft) {
        var hasResult = ft.resultPath != null && ft.resultPath !== '';
        var pathValue = hasResult ? Object.byString(obj, ft.resultPath) : false;
        if (hasResult) {
            var displayValue = Features.parseFeatureValue(pathValue, true);
            if (pathValue) {
                return "<div>" + displayValue + "</div>";
            }
        }
        return "-";
    }

    meerkat.modules.register('healthv4Results', {
        getAvailableExtrasAsList: getAvailableExtrasAsList,
        getExcessChildTemplate: getExcessChildTemplate
    });

})(jQuery);
