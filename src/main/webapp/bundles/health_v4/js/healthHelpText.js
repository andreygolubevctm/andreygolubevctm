;(function ($, undefined) {

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        _featureIsActive = false,
        $elements = {
            about_already_have_insurance: $('#health_healthCover_health_cover'),
            insurance_pref_partner_already_have_insurance: $('#_partner_health_cover')
        };

    function _toggleHelp($el) {
        if ($el.length) {
            $('.' + $el.attr('name') + '-help-text').toggleClass('hidden', $el.filter(':checked').val() === 'N');
        }
    }

    function activateFeature() {
        _featureIsActive = true;
    }

    $elements.insurance_pref_partner_already_have_insurance.find(':input').on('change', function() {
        if (_featureIsActive) {
            _toggleHelp($(this));
        }
    });

    $elements.about_already_have_insurance.find(':input').on('change', function() {
        if (_featureIsActive) {
            _toggleHelp($(this));
        }
    });

    meerkat.modules.register('healthHelpText', {
        activateFeature: activateFeature
    });

})(jQuery);