;(function ($, undefined) {

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        $elements = {};

    function initHealthPrimary() {
        _setupFields();
        _applyEventListeners();
    }

    function _setupFields() {
        $elements = {
            primaryCoverLoading: $(':input[name=health_healthCover_primary_healthCoverLoading]'),
            primaryCoverRow: $('#health_healthCover_primaryCover'),
            currentCover: $('input[name=health_healthCover_primary_cover]'),
            dob: $('#health_healthCover_primary_dob'),
            partnerDOB: $('#benefits_partner_dob')
        };

	    $elements.primaryCoverLoading.add($elements.dob).add($elements.currentCover).attr('data-attach','true');
    }

    function _applyEventListeners() {
        $elements.currentCover.add($elements.dob).on('change', function toggleContinuousCover() {
            var $checked = $elements.currentCover.filter(':checked'),
                hideField = !$checked.length || ($checked.val() === 'N') || ($checked.val() === 'Y' && meerkat.modules.age.isLessThan31Or31AndBeforeJuly1($elements.dob.val()));

            meerkat.modules.fieldUtilities.toggleVisible(
                $elements.primaryCoverLoading,
                hideField
            );
        });
    }

    function getCurrentCover() {
        return $elements.currentCover.filter(':checked').val();
    }

    function onStartInit() {
        var $checked = $elements.currentCover.filter(':checked');
        if ($checked.length) {
            $checked.change();
        } else {
            meerkat.modules.fieldUtilities.toggleVisible(
                $elements.primaryCoverLoading,
                true
            );
        }
    }

    meerkat.modules.register('healthPrimary', {
        init: initHealthPrimary,
        getCurrentCover: getCurrentCover,
        onStartInit: onStartInit
    });

})(jQuery);