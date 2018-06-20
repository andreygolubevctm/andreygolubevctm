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
        _newLhc = null,
        _newLhcCompleteResult = null;

    function onInitialise() {
        var hasPartner = meerkat.modules.healthChoices.hasPartner(),
            dob = meerkat.modules.dateUtils.returnDate(meerkat.modules.healthPrimary.getAppDob()),
            partnerDOB = hasPartner ? meerkat.modules.dateUtils.returnDate(meerkat.modules.healthPartner.getAppDob()) : null;

        _baseDatesRequestData = {
            primaryDOB: meerkat.modules.dateUtils.format(dob, 'YYYY-MM-DD'),
            partnerDOB: !_.isNull(partnerDOB) ? meerkat.modules.dateUtils.format(partnerDOB, 'YYYY-MM-DD') : null
        };

        _calculateRequestData = {
            primary: {
                continuousCover: null,
                neverHadCover: null,
                coverDates: []
            }
        };

        if (hasPartner) {

            _calculateRequestData.partner = {
                continuousCover: null,
                neverHadCover: null,
                coverDates: []
            };

        } else {
            _calculateRequestData.partner = null;
        }

        getBaseDates().done(function(res) {

            if (_isBuyingPrivateHospitalCover()) {

                // primaryFlags.lhcApplicableEnum Values:           (int)  {lhcDaysApplicableEqToZero: -2, continuousCover: 0, needToCalcPartialLHC: 1, MaxLHC, 2}
                // primaryFlags.checksRequired:                     (bool) indicates that there is a good chance that the LHC will be greater than zero - (isOfLHCAge && (neverHadPrivateHospitalCover || hasHadCoverButNotCurrently))
                // primaryFlags.neverHadPrivateHospitalCover:       (bool)
                // primaryFlags.continuousCover:                    (bool)
                // primaryFlags.requirePrivateHospitalCoverHistory: (bool) if true, will need to examine private health cover coverage history to determine LHC
                var primaryFlags = _getLhcConditionsFlags('primary', res.primary.lhcDaysApplicable);
                _setLhcConditionsflags('primary', primaryFlags.neverHadPrivateHospitalCover, primaryFlags.continuousCover);

                //if health_previousfund_primary_fundHistory_dates_unsure checkbox is checked don't use coverage dates info
                if (primaryFlags.requirePrivateHospitalCoverHistory && !$(':input[name=health_previousfund_primary_fundHistory_dates_unsure]').is(":checked")) {
                    setCoverDates('primary', meerkat.modules.healthPrivateHospitalHistory.getPrimaryCoverDates());
                }

                if (hasPartner) {
                    var partnerFlags = _getLhcConditionsFlags('partner', res.partner.lhcDaysApplicable);
                    _setLhcConditionsflags('partner', partnerFlags.neverHadPrivateHospitalCover, partnerFlags.continuousCover);

                    //if health_previousfund_partner_fundHistory_dates_unsure checkbox is checked don't use coverage dates info
                    if (partnerFlags.requirePrivateHospitalCoverHistory && !$(':input[name=health_previousfund_partner_fundHistory_dates_unsure]').is(":checked")) {
                        setCoverDates('partner', meerkat.modules.healthPrivateHospitalHistory.getPartnerCoverDates());
                    }
                }

                getLHC().done(function() {
                    meerkat.messaging.publish(meerkatEvents.TRIGGER_UPDATE_PREMIUM);
                });

            } else {

                _setLhcConditionsflags('primary', false, true);
                setCoverDates('primary', "");
                if (hasPartner) {
                    _setLhcConditionsflags('partner', false, true);
                    setCoverDates('partner', "");
                }

                getLHC().done(function() {
                    meerkat.messaging.publish(meerkatEvents.TRIGGER_UPDATE_PREMIUM);
                });

            }

        });
    }

    function _isBuyingPrivateHospitalCover() {
        // C == Combined, H = Hospital only, E = Extras only
        // if we start selling Private Hospital insurance where the excess is more than $500 or does not qualify for LHC in some other way then this might need to check the status of the individual policy selected
        return meerkat.modules.healthChoices.getCoverType() !== 'E';
    }

    // Applicant is either 'primary' || 'partner'
    // assumes that policy being purchased is for Private hospital / combined
    // returns JSON object
    //     lhcApplicableEnum Values:           (int)  {lhcDaysApplicableEqToZero: -2, continuousCover: 0, needToCalcPartialLHC: 1, MaxLHC, 2}
    //     checksRequired:                     (bool) indicates that there is a good chance that the LHC will be greater than zero - (isOfLHCAge && (neverHadPrivateHospitalCover || hasHadCoverButNotCurrently))
    //     neverHadPrivateHospitalCover:       (bool)
    //     continuousCover:                    (bool)
    //     requirePrivateHospitalCoverHistory: (bool) if true, will need to examine private health cover coverage history to determine LHC
    function _getLhcConditionsFlags(applicant, lhcDaysApplicable) {

        var lhcApplicable = -2;
        var checksRequired = false;
        var continuousCover = false;
        var neverHadPrivateHospitalCover = false;
        var requirePrivateHospitalCoverHistory = false;

        if (lhcDaysApplicable > 0) {
            lhcApplicable = _determineSingularLhcRequirements(applicant);
            if (lhcApplicable > 0) {
                checksRequired = true;

                if (lhcApplicable > 1) {
                    neverHadPrivateHospitalCover = true;
                } else {
                    //possibly held Private Health Insurance before but not currently
                    requirePrivateHospitalCoverHistory = true;
                }

            } else {
                // either below LHC age or has indicated that has continuous cover
                continuousCover = true;
            }
        }

        // lhcApplicableEnum Values:   {lhcDaysApplicableEqToZero: -2, continuousCover: 0, needToCalcPartialLHC: 1, MaxLHC, 2}
        return {lhcApplicableEnum: lhcApplicable, checksRequired: checksRequired, neverHadPrivateHospitalCover: neverHadPrivateHospitalCover, continuousCover: continuousCover, requirePrivateHospitalCoverHistory: requirePrivateHospitalCoverHistory};
    }

    // applicant is either 'primary' || 'partner'
    // assumes that policy being purchased is for Private hospital / combined
    // assumes that applicants age is within the LHC Applicable range
    function _determineSingularLhcRequirements(applicant) {
        var capitalisePersonDetailType = applicant.charAt(0).toUpperCase() + applicant.slice(1);

        var lhcApplicable = -1,
            continuousCover = 0,
            needToCalcPartialLHC = 1,
            maxLHC = 2;

        if (meerkat.modules['health' + capitalisePersonDetailType].getContinuousCover()) {

            // 0% LHC
            lhcApplicable = continuousCover;
        } else {
            if (meerkat.modules['health' + capitalisePersonDetailType].getNeverHadPrivateHospital_1() || meerkat.modules['health' + capitalisePersonDetailType].getNeverHadPrivateHospital_2() === true) {

                //never actually had cover!!!
                lhcApplicable = maxLHC;
            } else {

                // Either it is too early to tell OR Has indicated that they have had Private Hospital Insurance in the past but don't currently have cover
                //( (meerkat.modules['health' + capitalisePersonDetailType].getHeldPrivateHealthInsuranceBeforeButNotCurrently() === true) || (meerkat.modules['health' + capitalisePersonDetailType].getNeverExplicitlyAskedIfHeldPrivateHospitalCover() === true && $elements[applicant].everHadPrivateHospital_2.filter(':checked').val() === 'Y') )
                lhcApplicable = needToCalcPartialLHC;
            }
        }

        return lhcApplicable;
    }

    // applicant is either 'primary' || 'partner'
    // neverHadPrivateHospitalCover & continuousCover should be set with either: true | false | null
    function _setLhcConditionsflags (applicant, neverHadPrivateHospitalCover, continuousCover) {
        _calculateRequestData[applicant].neverHadCover = neverHadPrivateHospitalCover;
        _calculateRequestData[applicant].continuousCover = continuousCover;
    }

    // applicant is either 'primary' || 'partner'
    // coverDates value eg. [{ from: '2017-04-17, to: 2018-03-31 }...] || null
    function setCoverDates(applicant, coverDates) {
        // if coverDates is not an array or null the webservice will throw an error
        if (coverDates === "") {
            _calculateRequestData[applicant].coverDates = [];
        } else {
            _calculateRequestData[applicant].coverDates = coverDates;
        }
    }

    // it may be worthwhile checking _isBuyingPrivateHospitalCover() first to see if calling this service is necessary
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
                _newLhcCompleteResult = res;
            },
            onError: function onError(obj, txt, errorThrown) {
                console.log({errorMessage: txt + ': ' + errorThrown});
            }
        });
    }

    function getPrimary() {
        return _calculateRequestData.primary;
    }

    function getPartner() {
        return _calculateRequestData.partner;
    }

    function getCompleteLhcResult() {
        return _newLhcCompleteResult;
    }

    function getNewLHC() {
        return _newLhc;
    }

    function resetNewLHC() {
        _newLhc = null;
        _newLhcCompleteResult = null;
    }

    meerkat.modules.register('healthLHC', {
        onInitialise: onInitialise,
        setCoverDates: setCoverDates,
        getBaseDates: getBaseDates,
        getLHC: getLHC,
        getPrimary: getPrimary,
        getPartner: getPartner,
        getCompleteLhcResult: getCompleteLhcResult,
        getNewLHC: getNewLHC,
        resetNewLHC: resetNewLHC
    });

})(jQuery);