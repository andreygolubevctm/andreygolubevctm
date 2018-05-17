;(function ($, undefined) {

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        _baseDatesRequestData = {
            primaryDOB: null,
            partnerDOB: null
        },
        _baseDatesResponseData = {},
        _calculateRequestData = {
            primary: {},
            partner: {}
        },
        _newLhc = null;

    function onInitialise() {
        var dob = meerkat.modules.dateUtils.returnDate(meerkat.modules.healthPrimary.getDOB()),
            partnerDOB = meerkat.modules.healthChoices.hasPartner() ? meerkat.modules.dateUtils.returnDate(meerkat.modules.healthPartner.getDOB()) : null;

        _baseDatesRequestData = {
            primaryDOB: meerkat.modules.dateUtils.format(dob, 'YYYY-MM-DD'),
            partnerDOB: !_.isNull(partnerDOB) ? meerkat.modules.dateUtils.format(partnerDOB, 'YYYY-MM-DD') : null
        };

        _calculateRequestData = {
            primary: {
                continuousCover: !!meerkat.modules.healthPrimary.getContinuousCover(),
                neverHadCover: meerkat.modules.healthPrimary.getNeverHadCover(),
                coverDates: []
            }
        };

        if (meerkat.modules.healthChoices.hasPartner()) {
            _calculateRequestData.partner = {
                continuousCover: !!meerkat.modules.healthPartner.getContinuousCover(),
                neverHadCover: meerkat.modules.healthPartner.getNeverHadCover(),
                coverDates: []
            };
        }

        getBaseDates().done(function(res) {
            if ( (res.primary.lhcDaysApplicable > 0 && (meerkat.modules.healthPrimary.getUnsureCover() || meerkat.modules.healthPrimary.getContinuousCover() === false)) ||
                 (meerkat.modules.healthChoices.hasPartner() && res.partner.lhcDaysApplicable > 0 && (meerkat.modules.healthPartner.getUnsureCover() || meerkat.modules.healthPartner.getContinuousCover() === false)) ) {

                getLHC();
            } else {
                resetNewLHC();
            }
        });
    }

    // applicant is either 'primary' || 'partner'
    // coverDates value eg. [{ from: '2017-04-17, to: 2018-03-31 }...] || null
    function setCoverDates(applicant, coverDates) {
        _calculateRequestData[applicant].coverDates = coverDates;
    }

    function getBaseDates() {
        return meerkat.modules.comms.post({
            url: 'spring/lhc/base-dates/post.json',
            contentType: 'application/json;',
            dataType: 'json',
            errorLevel: 'silent',
            data: JSON.stringify(_baseDatesRequestData),
            onSuccess: function(json) {
                _baseDatesResponseData = json;
                _calculateRequestData.primary = $.extend({}, _baseDatesResponseData.primary, _calculateRequestData.primary);

                if (meerkat.modules.healthChoices.hasPartner()) {
                    _calculateRequestData.partner = $.extend({}, _baseDatesResponseData.partner, _calculateRequestData.partner);
                }
            },
            onError: function onError(obj, txt, errorThrown) {
                console.log({errorMessage: txt + ': ' + errorThrown});
            }
        });
    }

    function getLHC() {
        return meerkat.modules.comms.post({
            url: 'spring/lhc/calculate/post.json',
            contentType: 'application/json;',
            dataType: 'json',
            errorLevel: 'silent',
            data: JSON.stringify(_calculateRequestData),
            onSuccess: function(json) {
                _newLhc = meerkat.modules.healthChoices.hasPartner() ? json.combined.lhcPercentage : json.primary.lhcPercentage;
            },
            onError: function onError(obj, txt, errorThrown) {
                console.log({errorMessage: txt + ': ' + errorThrown});
            }
        });
    }

    function getPrimary() {
        return _calculateRequestData.primary;
    }

    function getNewLHC() {
        return _newLhc;
    }

    function resetNewLHC() {
        _newLhc = null;
    }

    meerkat.modules.register('healthLHC', {
        onInitialise: onInitialise,
        setCoverDates: setCoverDates,
        getBaseDates: getBaseDates,
        getLHC: getLHC,
        getPrimary: getPrimary,
        getNewLHC: getNewLHC,
        resetNewLHC: resetNewLHC
    });

})(jQuery);