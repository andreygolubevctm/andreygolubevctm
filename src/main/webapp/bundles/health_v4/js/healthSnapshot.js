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

        $elements = {};

    function initHealthSnapshot() {
        _setupFields();
        _eventSubscriptions();
        _applyEventListeners();
    }

    function _setupFields() {

        $elements = {
            quoteSnapshot: $('.quoteSnapshot'),
            livingIn: $('.quoteSnapshot .living-in'),
            livingInSpan: $('.quoteSnapshot .living-in .snapshot-items span'),
            state: $('#health_situation_state'),
            cover: $('input[name=health_situation_healthCvr]'),
            income: $(':input[name="health_healthCover_income"]') ,
            toggleList: $('.toggle-snapshot-list'),
            bornLabels: $('.quoteSnapshot .born-labels'),
            addPartnerDob: $('.add-partner-dob'),
            partnerDobInputD: $('#health_healthCover_partner_dobInputD'),
            primary: {
                dob: $('#health_healthCover_primary_dob'),
                dobSpan: $('.quoteSnapshot .primary-dob .snapshot-items span')
            },
            partner: {
                dob: $('#health_healthCover_partner_dob'),
                dobSpan: $('.quoteSnapshot .partner-dob .snapshot-items span')
            },
            rebate: $('input[name=health_healthCover_rebate]'),
            rebateText: $('.quoteSnapshot .snapshot-items.rebate-text'),
            rebateSubText: $('.quoteSnapshot .rebate .snapshot-items.sub-text'),
            hospital: {
                container: $('.Hospital_container'),
                itemFirst: $('.quoteSnapshot .hospital .snapshot-item-first'),
                listCount: $('.quoteSnapshot .hospital .snapshot-list-count'),
                list: $('.quoteSnapshot .hospital .snapshot-list'),
                toggleList: $('.quoteSnapshot .hospital .toggle-snapshot-list')
            },
            extras: {
                container: $('.GeneralHealth_container'),
                itemFirst: $('.quoteSnapshot .extras .snapshot-item-first'),
                listCount: $('.quoteSnapshot .extras .snapshot-list-count'),
                list: $('.quoteSnapshot .extras .snapshot-list'),
                toggleList: $('.quoteSnapshot .extras .toggle-snapshot-list')
            }
        };
    }

    function _eventSubscriptions() {

        // Initial render
        meerkat.messaging.subscribe(meerkat.modules.events.journeyEngine.BEFORE_STEP_CHANGED, function renderSnapshotOnJourneyReadySubscription() {
            _.defer(function() {
                _renderSnapshot();
            });
        });
        meerkat.messaging.subscribe(meerkat.modules.events.health.SNAPSHOT_FIELDS_CHANGE, function renderSnapshotOnJourneyReadySubscription() {
            _.defer(function() {
                _renderSnapshot();
            });
        });
        meerkat.messaging.subscribe(meerkat.modules.events.RESULTS_SORTED, function renderSnapshotOnJourneyReadySubscription() {
            _.defer(function() {
                _renderSnapshot();
            });
        });
        meerkat.messaging.subscribe(meerkat.modules.events.healthLocation.STATE_CHANGED, function renderSnapshotOnStateFieldChange() {
            _.defer(function() {
                _renderSnapshot();
            });
        });
    }

    function _applyEventListeners() {
        $elements.addPartnerDob.on('click', function addPartnerDobClicked() {
            $elements.partnerDobInputD.focus();
        });

        $elements.toggleList.on('click', function() {
            var $this = $(this);

            $this.parent().find('.snapshot-list').slideDown('fast');
            $this.addClass('hidden');
        });
    }

    function _renderSnapshot() {
        meerkat.modules.contentPopulation.render('.quoteSnapshot');
        _.defer(_render);
    }

    function _showHide(data, selector, property) {
        $(selector).each(function(){
            $(this).toggleClass('hidden', _.isEmpty(data[property]));
        });
    }

    function _render() {
        var data = _getData(),
            noData = !_hasData(data);

        if (!noData && !_.isEmpty(data.livingIn)) {
            $elements.livingIn.removeClass('hidden');
            $elements.livingInSpan.text(data.livingIn);
        } else {
            $elements.livingIn.addClass('hidden');
        }

        if (!noData && !_.isEmpty(data.coverFor)) {
            var notSingle = _.indexOf(["Couple","Family"], data.coverFor) >= 0;

            $elements.quoteSnapshot.toggleClass('has-partner', notSingle);
            $elements.bornLabels.toggleClass('hidden', !notSingle);
            $elements.addPartnerDob.toggleClass('hidden', !notSingle || (notSingle && !_.isEmpty(data.partnerBorn)));
        }

        // render primary dob
        if (!noData && !_.isEmpty(data.primaryBorn)) {
            _renderDob('primary', data.primaryBorn);
        }

        // render partner dob
        if (!noData && !_.isEmpty(data.partnerBorn)) {
            _renderDob('partner', data.partnerBorn);
        }

        // set rebate text
        $elements.rebateText.text(data.rebateText);

        // set rebate lhc %
        $elements.rebateSubText.text(data.rebateSubText);

        // render hospital
        var hospitalType = meerkat.modules.benefits.getHospitalType();
        if (!noData && !_.isEmpty(data.hospital) && hospitalType === 'customise') {
            _renderBenefits('hospital', data.hospital);
        } else if (hospitalType === 'limited') {
            $elements.hospital.itemFirst.text('Limited Cover');
            $elements.hospital.toggleList.addClass('hidden');
        }

        // render extras
        if (!noData && !_.isEmpty(data.extras)) {
            _renderBenefits('extras', data.extras);
        }

        // Toggle benefits rows.
        _showHide(data,'.quoteSnapshot .hospital','hospital', noData);
        _showHide(data,'.quoteSnapshot .extras','extras', noData);
    }

    function _renderDob(type, data) {
        var dob = meerkat.modules.dateUtils.returnDate(data),
            formattedDob = meerkat.modules.dateUtils.format(dob, "D MMM YYYY");

        $elements[type].dobSpan.text(formattedDob);
    }

    function _renderBenefits(type, data) {
        var count = type === 'hospital' ? meerkat.modules.benefitsModel.getHospitalCount() :
                                          meerkat.modules.benefitsModel.getExtrasCount(),
            moreThanOne = count > 1,
            i;

        $elements[type].itemFirst.text(data[0]);

        if (moreThanOne) {
            $elements[type].listCount.text(count - 1);

            $elements[type].list.empty();
            for (i = 1; i < data.length; i++) {
                $elements[type].list.append(
                    $("<li/>").append(data[i])
                );
            }
            $elements[type].list.hide();
        }

        $elements[type].toggleList.toggleClass('hidden', !moreThanOne);
    }

    function _getData() {
        var livingIn = $elements.state.val(),
            coverFor = $.trim($elements.cover.filter(":checked").parent().text()),
            primaryBorn = $elements.primary.dob.val(),
            partnerBorn = $elements.partner.dob.val(),
            rebateText = _fetchRebateText(),
            rebateSubText = _fetchRebateSubText($elements.income.filter(':checked').val()),
            hospital = _fetchBenefits(true),
            extras = _fetchBenefits();

        return {
            livingIn: _.isEmpty(livingIn) ? false : livingIn,
            coverFor: _.isEmpty(coverFor) ? false : coverFor,
            primaryBorn: _.isEmpty(primaryBorn) ? false : primaryBorn,
            partnerBorn: _.isEmpty(partnerBorn) ? false : partnerBorn,
            rebateText: rebateText,
            rebateSubText: rebateSubText,
            hospital: _.isEmpty(hospital) ? false : hospital,
            extras: _.isEmpty(extras) ? false : extras
        };
    }

    function _hasData(data) {
        var props = _.keys(data);
        for(var i=0; i < props.length; i++) {
            if(!_.isEmpty(data[props[i]])) {
                return true;
            }
        }
        return false;
    }

    function _fetchRebateText() {
        return meerkat.modules.healthRebate.getSelectedRebateTierLabelText();
    }

    function _fetchRebateSubText(income) {
        var $optin = $elements.rebate.filter(':checked');
        if ($optin.length && $optin.val() === 'Y') {
            if (income < 3) {
                return meerkat.modules.healthRebate.getRebate();
            } else {
                return "You're not eligible to receive a rebate";
            }
        } else {
            return '';
        }
    }

    function _fetchBenefits(isHospital) {
        var list = [],
            benefits = isHospital ? meerkat.modules.benefitsModel.getHospital() : meerkat.modules.benefitsModel.getExtras();

        benefits.forEach(function(benefitId) {
            var label = $elements[isHospital ? 'hospital' : 'extras'].container
                    .find('input[data-benefit-id=' + benefitId + ']').next('label').find('.benefitTitle').text();

            if (!_.isEmpty(label)) {
                list.push(label);
            }
        });

        return list;
    }

    meerkat.modules.register('healthSnapshot', {
        init: initHealthSnapshot
    });

})(jQuery);