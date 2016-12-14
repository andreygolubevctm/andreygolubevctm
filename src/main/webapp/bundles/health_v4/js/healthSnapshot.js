;(function($, undefined){

    var meerkat = window.meerkat,
        log = meerkat.logging.info,
        meerkatEvents = meerkat.modules.events,

        events = {
            healthSnapshot: {
                RENDER_HEALTH_SNAPSHOT : "RENDER_HEALTH_SNAPSHOT"
            }
        },
        moduleEvents = events.healthSnapshot,

        $addPartnerDob,
        $partnerDobInputD,

        rebateText = [
            'Full rebate applies',
            'Tier 1 applied',
            'Tier 2 applied',
            'Tier 3 applied',
            'No rebate applied'
        ];

    function initHealthSnapshot() {
        $addPartnerDob = $('.add-partner-dob');
        $partnerDobInputD = $('#health_healthCover_partner_dobInputD');

        eventSubscriptions();
        applyEventListeners();
    }

    function eventSubscriptions() {

        // Initial render
        meerkat.messaging.subscribe(meerkat.modules.events.journeyEngine.BEFORE_STEP_CHANGED, function renderSnapshotOnJourneyReadySubscription() {
            _.defer(function() {
                renderSnapshot();
            });
        });
        meerkat.messaging.subscribe(meerkat.modules.events.health.SNAPSHOT_FIELDS_CHANGE, function renderSnapshotOnJourneyReadySubscription() {
            _.defer(function() {
                renderSnapshot();
            });
        });
        meerkat.messaging.subscribe(meerkat.modules.events.RESULTS_SORTED, function renderSnapshotOnJourneyReadySubscription() {
            _.defer(function() {
                renderSnapshot();
            });
        });
    }

    function applyEventListeners() {
        $addPartnerDob.on('click', function addPartnerDobClicked() {
            $partnerDobInputD.focus();
        });
    }

    function renderSnapshot() {
        meerkat.modules.contentPopulation.render('.quoteSnapshot');
        _.defer(render);
    }

    function showHide(data, selector, property, forceHide) {
        $(selector).each(function(){
            $(this).toggleClass('hidden', _.isEmpty(data[property]));
        });
    }

    function render() {
        var data = getData(),
            noData = !hasData(data),
            $box, i;

        // Toggle normal content rows
        showHide(data,'.quoteSnapshot .living-in','livingIn', noData);
        showHide(data,'.quoteSnapshot .cover-for','coverFor', noData);
        showHide(data,'.quoteSnapshot .born','primaryBorn', noData);
        showHide(data,'.quoteSnapshot .partner-born','partnerBorn', noData);

        if (!noData && !_.isEmpty(data.coverFor)) {
            var notSingle = _.indexOf(["Couple","Family"], data.coverFor) >= 0;

            $('.quoteSnapshot').toggleClass('has-partner', notSingle);
            $('.quoteSnapshot .born-labels').toggleClass('hidden', !notSingle);
            $('.add-partner-dob').toggleClass('hidden', !notSingle || (notSingle && !_.isEmpty(data.partnerBorn)));
        }

        // Format primary dob
        if (!noData && !_.isEmpty(data.primaryBorn)) {
            var primaryDob = meerkat.modules.dateUtils.returnDate($('#health_healthCover_primary_dob').val()),
                formattedPrimaryDob = meerkat.modules.dateUtils.format(primaryDob, "D MMM YYYY");

            $('.quoteSnapshot .snapshot-items.primary-dob span').text(formattedPrimaryDob);
        }

        // Format partner dob
        if (!noData && !_.isEmpty(data.partnerBorn)) {
            var partnerDob = meerkat.modules.dateUtils.returnDate($('#health_healthCover_partner_dob').val()),
                formattedPartnerDob = meerkat.modules.dateUtils.format(partnerDob, "D MMM YYYY");

            $('.quoteSnapshot .snapshot-items.partner-dob span').text(formattedPartnerDob);
        }

        // set rebate text
        $('.quoteSnapshot .snapshot-items.rebate-text').text(data.rebateText);

        // set rebate lhc %
        $('.quoteSnapshot .rebate .snapshot-items.sub-text').text(data.rebateSubText);

        // Populate hospital/extras
        if (!noData && !_.isEmpty(data.hospital)) {
            $box = $('.quoteSnapshot .hospital .snapshot-list');
            $box.empty();
            for(i = 0; i < data.hospital.length; i++) {
                $box.append(
                    $("<li/>").append(data.hospital[i])
                );
            }
        }
        if(!noData && !_.isEmpty(data.extras)) {
            $box = $('.quoteSnapshot .extras .snapshot-list');
            $box.empty();
            for(i = 0; i < data.extras.length; i++) {
                $box.append(
                    $("<li/>").append(data.extras[i])
                );
            }
        }
        // Toggle benefits rows.
        showHide(data,'.quoteSnapshot .hospital','hospital', noData);
        showHide(data,'.quoteSnapshot .extras','extras', noData);

        $('.quoteSnapshot').toggle(!noData && meerkat.modules.journeyEngine.getCurrentStepIndex() < 3);
    }

    function getData() {
        // var coverFor = $("#health_situation_healthCvr").val();
        // var livingIn = $("#health_situation_location").val();
        // var lookingTo = $.trim($("input[name=health_situation_healthSitu]").filter(":checked").closest('label').text());
        // var primaryBorn = $("#health_healthCover_primary_dob").val();
        // var coverType = $("#health_situation_coverType input:checked").parent().text();
        // var tieredCoverType = $('#health_situation_coverType input').filter(":checked").val();
        // var hospital = fetchAllHospitalCheckedValues(tieredCoverType);
        // var extras = fetchAllExtrasCheckedValues(tieredCoverType);
        //
        // return {
        //     coverFor : _.isEmpty(coverFor) ? false : coverFor,
        //     livingIn : _.isEmpty(livingIn) ? false : livingIn,
        //     lookingTo : _.isEmpty(lookingTo) ? false : lookingTo,
        //     primaryBorn : _.isEmpty(primaryBorn) ? false : primaryBorn,
        //     coverType : _.isEmpty(coverType) ? false : coverType,
        //     hospital : _.isEmpty(hospital) ? false : hospital,
        //     extras : _.isEmpty(extras) ? false : extras
        // };

        var livingIn = $.trim($("input[name=health_situation_state]").filter(":checked").parent().text()),
            coverFor = $.trim($("input[name=health_situation_healthCvr]").filter(":checked").parent().text()),
            primaryBorn = $("#health_healthCover_primary_dob").val(),
            partnerBorn = $("#health_healthCover_partner_dob").val(),
            rebateText = fetchRebateText($("#health_healthCover_income").val()),
            rebateSubText = fetchRebateSubText($("#health_healthCover_income").val()),
            hospital = fetchAllHospitalCheckedValues();

        return {
            livingIn: _.isEmpty(livingIn) ? false : livingIn,
            coverFor: _.isEmpty(coverFor) ? false : coverFor,
            primaryBorn: _.isEmpty(primaryBorn) ? false : primaryBorn,
            partnerBorn: _.isEmpty(partnerBorn) ? false : partnerBorn,
            rebateText: rebateText,
            rebateSubText: rebateSubText,
            hospital: _.isEmpty(hospital) ? false : hospital
        };
    }

    function hasData(data) {
        var props = _.keys(data);
        for(var i=0; i < props.length; i++) {
            if(!_.isEmpty(data[props[i]])) {
                return true;
            }
        }
        return false;
    }

    function fetchRebateText(income) {
        if ($('#health_healthCover_rebate').is(":checked")) {
            return rebateText[income];
        } else {
            return rebateText[4];
        }
    }

    function fetchRebateSubText(income) {
        if ($('#health_healthCover_rebate').is(":checked")) {
            if (income < 3) {
                return meerkat.modules.healthRebate.getRebate();
            } else {
                return "You're not eligible to receive a rebate";
            }
        } else {
            return '';
        }
    }

    function fetchAllHospitalCheckedValues(coverType) {
        var list = [];
        // if(_.indexOf(["C","H"], coverType) >= 0) {
            $(".Hospital_container").find(':checked').each(function (item) {
                var label = $.trim($(this).next('label').find('.benefitTitle').text());
                if (!_.isEmpty(label)) {
                    list.push(label);
                }

            });
            $(".Hospital_container .noIcons").find(':checked').each(function (item) {
                var label = $.trim($($(this).next('label').contents()[0]).text());
                if (!_.isEmpty(label)) {
                    list.push(label);
                }
            });
        // }
        return list;
    }

    function fetchAllExtrasCheckedValues(coverType) {
        var list = [];
        if(_.indexOf(["C","E"], coverType) >= 0) {
            $(".GeneralHealth_container").find(':checked').each(function (item) {
                var label = $.trim($(this).next('label').find('span.iconLabel').text());
                if (!_.isEmpty(label)) {
                    list.push(label);
                }
            });
            $(".GeneralHealth_container .noIcons").find(':checked').each(function (item) {
                var label = $.trim($($(this).next('label').contents()[0]).text());
                if (!_.isEmpty(label)) {
                    list.push(label);
                }
            });
        }
        return list;
    }

    /**
     * Utility function to map cover type to a label.
     * @returns {*}
     */
    function getLabelForCoverType() {
        switch(meerkat.modules.health.getCoverType()) {
            case 'C':
                return "Hospital and Extras";
            case 'H':
                return "Hospital";
            case 'E':
                return "Extras";
        }
        return "";
    }

    /**
     * Utility function to map situation to a label.
     * @returns {*}
     */
    function getLabelForSituation() {

        switch(meerkat.modules.health.getSituation()) {
            case 'SM':
            case 'SF':
                return "you";
            case 'C':
                return "you and your partner";
            case 'F':
                return "you and your family";
            case 'SPF':
                var $dependants = $('#health_healthCover_dependants');
                var childrenLabel = parseInt($dependants.val(),10) > 1 ? 'children' : 'child';
                return "you and your " + childrenLabel;
        }
    }

    function renderPreResultsRowSnapshot() {

        var obj = {
            name: $('#health_contactDetails_name').val(),
            coverType: getLabelForCoverType(),
            situation: getLabelForSituation()
        };
        var template = meerkat.modules.templateCache.getTemplate($("#pre-results-row-content-template"));
        $('.preResultsContainer').html(template(obj));
    }

    meerkat.modules.register('healthSnapshot', {
        init:initHealthSnapshot,
        renderPreResultsRowSnapshot: renderPreResultsRowSnapshot
    });

})(jQuery);