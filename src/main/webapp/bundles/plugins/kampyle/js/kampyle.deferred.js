;(function ($, undefined) {

    var meerkat = window.meerkat;

    var $component,
        _formId = meerkat.site.kampyleId;

    function updateTransId() {
        if (!isKampyleEnabled()) {
            return;
        }
        var transId = meerkat.modules.transactionId.get();
        if(typeof k_button != 'undefined' && typeof k_button.setCustomVariable == 'function') {
            k_button.setCustomVariable(7891, transId);
        }
    }

    function init() {

        if (!isKampyleEnabled()) {
            return;
        }

        $(document).ready(function () {
            // Check if its already there, just in case...
            $component = $('#kampyle');
            // If not (first load), prepend to footer.
            if (!$component.length) {
                $('#footer .container').prepend('<div id="kampyle" data-kampyle-formid="' + _formId + '"><a href="https://www.kampyle.com/feedback_form/ff-feedback-form.php?site_code=7343362&amp;lang=en&amp;form_id=' + _formId + '" target="kampyleWindow" id="kampylink" class="k_static btn btn-cta"><span class="visible-xs">Feedback</span></a></div>');
                $component = $('#kampyle');
            }

            // Hook up link
            $component.on('click', '#kampylink', function kampyleLink(event) {
                updateTransId();

                if (typeof k_button !== 'undefined') {
                    event.preventDefault();
                    k_button.open_ff('site_code=7343362&lang=en&form_id=' + _formId);
                }

                meerkat.modules.writeQuote.write({triggeredsave: 'kampyle'});
            });
        });
    }

    function isKampyleEnabled() {
        return !!_formId;
    }

    meerkat.modules.register("kampyle", {
        init: init
    });

})(jQuery);