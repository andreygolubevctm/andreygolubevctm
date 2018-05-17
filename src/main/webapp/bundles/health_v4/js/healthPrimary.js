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
            primaryEverHadCover: $(':input[name=health_healthCover_primary_everHadCover]'),
            primaryCurrentFundName: $(':input[name=health_healthCover_primary_fundName]'),
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

        $elements.currentCover.on('change', function toggleEverHadCover() {
            var $checked = $elements.currentCover.filter(':checked'),
                hideField = !$checked.length || ($checked.val() === 'Y');

            meerkat.modules.fieldUtilities.toggleVisible(
                $elements.primaryEverHadCover,
                hideField
            );
        });

        $elements.currentCover.on('change', function toggleCurrentHealthFund() {
            var $checked = $elements.currentCover.filter(':checked'),
                hideField = !$checked.length || ($checked.val() === 'N');

            meerkat.modules.fieldUtilities.toggleVisible(
                $elements.primaryCurrentFundName,
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

            meerkat.modules.fieldUtilities.toggleVisible(
                $elements.primaryEverHadCover,
                true
            );

            meerkat.modules.fieldUtilities.toggleVisible(
                $elements.primaryCurrentFundName,
                true
            );

        }
    }

    function getDOB() {
        return $elements.dob.val();
    }

    function getContinuousCover() {
        return $elements.currentCover.filter(':checked').val() === 'Y' ? $elements.primaryCoverLoading.filter(':checked').val() === 'Y' : null;
    }

    function getNeverHadCover() {
        return $elements.currentCover.filter(':checked').val() === 'N' && $elements.primaryEverHadCover.filter(':checked').val() === 'N';
    }

    function getUnsureCover() {
        return $elements.currentCover.filter(':checked').val() === 'N' && $elements.primaryEverHadCover.filter(':checked').val() === 'Y';
    }

    meerkat.modules.register('healthPrimary', {
        init: initHealthPrimary,
        getCurrentCover: getCurrentCover,
        onStartInit: onStartInit,
        getDOB: getDOB,
        getContinuousCover: getContinuousCover,
        getNeverHadCover: getNeverHadCover,
        getUnsureCover: getUnsureCover
    });

})(jQuery);