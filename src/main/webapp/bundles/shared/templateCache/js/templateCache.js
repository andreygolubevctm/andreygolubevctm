;(function ($, undefined) {

    var meerkat = window.meerkat,
        exception = meerkat.logging.exception;

    var cachedTemplates = {};

    function init() {

    }

    /**
     * Fetch or process an underscore template.
     * @param $templateElement
     * @returns {*}
     */
    function getTemplate($templateElement) {
        if (!$templateElement.length) {
            exception("Template does not exist for " + JSON.stringify($templateElement));
            return;
        }

        return cachedTemplates[$templateElement.attr('id')] || _.template($templateElement.html());
    }


    meerkat.modules.register('templateCache', {
        init: init,
        getTemplate: getTemplate
    });
})(jQuery);