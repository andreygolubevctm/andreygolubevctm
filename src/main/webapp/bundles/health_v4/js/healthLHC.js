;(function ($, undefined) {

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        _baseDatesRequestData = {
            primaryDOB: null,
            partnerDOB: null
        },
        _baseDatesResponseData = {}, // request object for 'lhc/base-dates/post.json'
        _calculateRequestData = {    // request object for 'lhc/calculate/post.json'
            primary: {},
            partner: {}
        },
        _newLhc = null;

    function onInitialise() {
        var hasPartner = meerkat.modules.healthChoices.hasPartner(),
            dob = meerkat.modules.dateUtils.returnDate(meerkat.modules.healthPrimary.getAppDob()),
            partnerDOB = hasPartner ? meerkat.modules.dateUtils.returnDate(meerkat.modules.healthPartner.getAppDob()) : null,
            primaryGetContCover = meerkat.modules.healthPrimary.getContinuousCover(),
            partnerGetContCover = null;

        _baseDatesRequestData = {
            primaryDOB: meerkat.modules.dateUtils.format(dob, 'YYYY-MM-DD'),
            partnerDOB: !_.isNull(partnerDOB) ? meerkat.modules.dateUtils.format(partnerDOB, 'YYYY-MM-DD') : null
        };

        _calculateRequestData = {
            primary: {
                continuousCover: !!primaryGetContCover,
                neverHadCover: meerkat.modules.healthPrimary.getNeverHadCover(),
                coverDates: []
            }
        };

        if (hasPartner) {
            partnerGetContCover = meerkat.modules.healthPartner.getContinuousCover();

            _calculateRequestData.partner = {
                continuousCover: !!partnerGetContCover,
                neverHadCover: meerkat.modules.healthPartner.getNeverHadCover(),
                coverDates: []
            };
        }

        getBaseDates().done(function(res) {
            if ( (res.primary.lhcDaysApplicable > 0 && (meerkat.modules.healthPrimary.getUnsureCover() || primaryGetContCover === false)) ||
                 (hasPartner && res.partner.lhcDaysApplicable > 0 && (meerkat.modules.healthPartner.getUnsureCover() || partnerGetContCover === false)) ) {

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
            onSuccess: function(res) {
                _baseDatesResponseData = res;
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
            onSuccess: function(res) {
                _newLhc = meerkat.modules.healthChoices.hasPartner() ? res.combined.lhcPercentage : res.primary.lhcPercentage;
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