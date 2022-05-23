;(function ($, undefined) {

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        exception = meerkat.logging.exception,
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
        _newLhcCompleteResult = null,
        _primary_lhc_override = null,
        _partner_lhc_override = null,
        $applicationDate = $('#health_searchDate');

    function onInitialise(callback) {
        var $healthCoverDetails = $('#contactForm');

        var hasPartner = meerkat.modules.health.hasPartner(),
            dob = meerkat.modules.dateUtils.returnDate($healthCoverDetails.find('#health_healthCover_primary_dob').val()),
            partnerDOB = hasPartner ? meerkat.modules.dateUtils.returnDate($healthCoverDetails.find('input[name="health_healthCover_partner_dob"]').val()) : null;

        _baseDatesRequestData = {
            primaryDOB: meerkat.modules.dateUtils.format(dob, 'YYYY-MM-DD'),
            partnerDOB: !_.isNull(partnerDOB) ? meerkat.modules.dateUtils.format(partnerDOB, 'YYYY-MM-DD') : null
        };

        _calculateRequestData = {
            primary: {
                continuousCover: null,
                neverHadCover: null,
                coverDates: []
            },
            // make the applicationDate LocalDate.java default compatible
            applicationDate: !$applicationDate || !$applicationDate.val || !$applicationDate.val() ? null : $applicationDate.val().split("/").reverse().join("-")
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

        getBaseDates().then(function(res) {

            if (_isBuyingPrivateHospitalCover()) {

                // primaryFlags.lhcApplicableEnum Values:           (int)  {lhcDaysApplicableEqToZero: -2, continuousCover: 0, needToCalcPartialLHC: 1, MaxLHC, 2}
                // primaryFlags.checksRequired:                     (bool) indicates that there is a good chance that the LHC will be greater than zero - (isOfLHCAge && (neverHadPrivateHospitalCover || hasHadCoverButNotCurrently))
                // primaryFlags.neverHadPrivateHospitalCover:       (bool)
                // primaryFlags.continuousCover:                    (bool)
                // primaryFlags.requirePrivateHospitalCoverHistory: (bool) if true, will need to examine private health cover coverage history to determine LHC
                var primaryFlags = _getLhcConditionsFlags('primary', res.primary.lhcDaysApplicable);
                _setLhcConditionsflags('primary', primaryFlags.neverHadPrivateHospitalCover, primaryFlags.continuousCover);

                // only use coverage dates info if if health_previousfund_primary_fundHistory_dates_unsure checkbox is not checked
                if (primaryFlags.requirePrivateHospitalCoverHistory && !$(':input[name=health_previousfund_primary_fundHistory_dates_unsure]').is(":checked")) {
                    setCoverDates('primary', meerkat.modules.healthPrivateHospitalHistory.getPrimaryCoverDates());
                }

                if (hasPartner) {
                    var partnerFlags = _getLhcConditionsFlags('partner', res.partner.lhcDaysApplicable);
                    _setLhcConditionsflags('partner', partnerFlags.neverHadPrivateHospitalCover, partnerFlags.continuousCover);

                    // only use coverage dates info if if health_previousfund_partner_fundHistory_dates_unsure checkbox is not checked
                    if (partnerFlags.requirePrivateHospitalCoverHistory && !$(':input[name=health_previousfund_partner_fundHistory_dates_unsure]').is(":checked")) {
                        setCoverDates('partner', meerkat.modules.healthPrivateHospitalHistory.getPartnerCoverDates());
                    }
                }

                getLHC().then(function() {
                    meerkat.messaging.publish(meerkatEvents.TRIGGER_UPDATE_PREMIUM);
                })
                .catch(function onError(obj, txt, errorThrown) {
                    exception(txt + ': ' + errorThrown);
                });

            } else {

                _setLhcConditionsflags('primary', false, true);
                setCoverDates('primary', "");
                if (hasPartner) {
                    _setLhcConditionsflags('partner', false, true);
                    setCoverDates('partner', "");
                }

                getLHC().then(function() {
                    meerkat.messaging.publish(meerkatEvents.TRIGGER_UPDATE_PREMIUM);
                    if(callback) {
                        callback();
                    }
                })
                .catch(function onError(obj, txt, errorThrown) {
                    exception(txt + ': ' + errorThrown);
                });

            }

        })
        .catch(function onError(obj, txt, errorThrown) {
			exception(txt + ': ' + errorThrown);
		});
    }

    function _isBuyingPrivateHospitalCover() {
        // C == Combined, H = Hospital only, E = Extras only
        // if we start selling Private Hospital insurance where the excess is more than $500 or does not qualify for LHC in some other way then this might need to check the status of the individual policy selected
        return meerkat.modules.health.getCoverType() !== 'E';
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
        var getContinuousCover = applicant === 'primary' ? meerkat.modules.healthAboutYou.getContinuousCoverPrimary() : meerkat.modules.healthAboutYou.getContinuousCoverPartner();
        var neverHadCover = applicant === 'primary' ? meerkat.modules.healthAboutYou.neverHadCoverPrimary() : meerkat.modules.healthAboutYou.neverHadCoverPartner();
        var lhcApplicable = -1,
            continuousCover = 0,
            needToCalcPartialLHC = 1,
            maxLHC = 2;

        if (getContinuousCover) {

            // 0% LHC
            lhcApplicable = continuousCover;
        } else {
            if (neverHadCover) {

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

                if (meerkat.modules.health.hasPartner()) {
                    _calculateRequestData.partner = $.extend({}, _baseDatesResponseData.partner, _calculateRequestData.partner);
                }
            },
            onError: function onError(obj, txt, errorThrown) {
                console.log({errorMessage: txt + ': ' + errorThrown});
                exception("Failed to fetch rates");
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
                var hasPartner = meerkat.modules.health.hasPartner();
                if(_primary_lhc_override !== null) {
                    res.primary.lhcPercentage = _primary_lhc_override;
                }
                if(_partner_lhc_override !== null) {
                    res.partner.lhcPercentage = _partner_lhc_override;
                }
                if(hasPartner && res.hasOwnProperty('combined')) {
                    res.combined.lhcPercentage = (res.primary.lhcPercentage + res.partner.lhcPercentage) / 2;
                }
                _newLhc = hasPartner ? res.combined.lhcPercentage : res.primary.lhcPercentage;
                _newLhcCompleteResult = res;
                updateLHCFields();
                displayLHC();
            },
            onError: function onError(obj, txt, errorThrown) {
                meerkat.logging.error(txt + ': ' + errorThrown);
                exception("Failed to fetch rates");
            }
        });
    }

    function updateLHCFields() {
		var hasPartner = meerkat.modules.health.hasPartner();
		$('#health_primaryLHC').val(_newLhcCompleteResult.hasOwnProperty('primary') ? _newLhcCompleteResult.primary.lhcPercentage : 0);
		$('#health_partnerLHC').val(hasPartner && _newLhcCompleteResult.hasOwnProperty('partner') ? _newLhcCompleteResult.partner.lhcPercentage : 0);
		$('#health_combinedLHC').val(_newLhcCompleteResult.hasOwnProperty('combined') ? _newLhcCompleteResult.combined.lhcPercentage : 0);
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

    function getNewPrimaryCAE() {
        if(!getCompleteLhcResult() || !getCompleteLhcResult().primary) {
            return '';
        }

        var primaryLhc = getCompleteLhcResult().primary.lhcPercentage;

        if(primaryLhc === 0) {
            return '30';
        }

        if(primaryLhc >= 70) {
            return '65';
        }

        return Math.floor(((primaryLhc / 2) + 30)).toString();
    }

    function getNewPartnerCAE() {
        if(!getCompleteLhcResult() || !getCompleteLhcResult().partner) {
            return '';
        }

        var partnerLhc = getCompleteLhcResult().partner.lhcPercentage;

        if(partnerLhc === 0) {
            return '30';
        }

        if(partnerLhc >= 70) {
            return '65';
        }

        return Math.floor(((partnerLhc / 2) + 30)).toString();
    }

    function resetNewLHC() {
        _newLhc = null;
        _newLhcCompleteResult = null;
    }

    function displayLHC() {
        var rates = getCompleteLhcResult();
        if(rates) {
            var hasPartner = meerkat.modules.health.hasPartner();
            meerkat.modules.healthCoverDetails.setHealthFunds();
            if(meerkat.site.isCallCentreUser === true && rates.hasOwnProperty('primary') && (!hasPartner || (rates.hasOwnProperty('combined')))){

                // Exit method if rates are invalid
                if(rates.hasOwnProperty('primary') && !rates.primary.hasOwnProperty('lhcPercentage')) return;
                if(rates.hasOwnProperty('partner') && !rates.partner.hasOwnProperty('lhcPercentage')) return;
                if(rates.hasOwnProperty('combined') && !rates.combined.hasOwnProperty('lhcPercentage')) return;

                $('.health_cover_details_rebate .fieldrow_legend').html(getOverallLoadingText(rates.primary.lhcPercentage));

                var rate = rates[hasPartner ? 'combined' : 'primary'].lhcPercentage;
                $('.simples_dialogue-checkbox-26 span[data-loading=true]').html(rate);
                if (rate > 0) {
                    $('#simples-dialogue-26').removeClass("hidden");
                } else {
                    $('#simples-dialogue-26').addClass("hidden");
                }

                if(hasPartner && rates.partner){
                    $('#health_healthCover_primaryCover .fieldrow_legend').html(getLoadingText(rates.primary.lhcPercentage, rates.combined.lhcPercentage));

                    $('#health_healthCover_partnerCover .fieldrow_legend').html(getLoadingText(rates.partner.lhcPercentage , rates.combined.lhcPercentage));

                    $('.health_cover_details_rebate .fieldrow_legend').html(getOverallLoadingText(rates.combined.lhcPercentage));
                } else {
                    $('#health_healthCover_primaryCover .fieldrow_legend').html(getOverallLoadingText(rates.primary.lhcPercentage));
                }
                meerkat.modules.healthTiers.setTiers();
            }
        }
    }

    function getLoadingText(individualLoading, loading){
        return 'Individual LHC ' + individualLoading + '%, overall  LHC ' + loading + '%';
    }

    function getOverallLoadingText(loading){
        return 'Overall LHC ' + loading + '%';
    }

    function setPrimaryLHCOverride(lhc_override) {
        _primary_lhc_override = null;
        try {
            var num = parseInt(lhc_override);
            _primary_lhc_override = _.isNaN(num) ? null : num;
        } catch(ex) {}
    }

    function setPartnerLHCOverride(lhc_override) {
        _partner_lhc_override = null;
        try {
            var num = parseInt(lhc_override);
            _partner_lhc_override = _.isNaN(num) ? null : num;
        } catch(ex) {}
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
        resetNewLHC: resetNewLHC,
        getNewPrimaryCAE: getNewPrimaryCAE,
        getNewPartnerCAE: getNewPartnerCAE,
        displayLHC: displayLHC,
        setPrimaryLHCOverride: setPrimaryLHCOverride,
        setPartnerLHCOverride: setPartnerLHCOverride
    });

})(jQuery);