/**
 * Description: Health setup
 */
;(function ($, undefined) {


    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        exception = meerkat.logging.exception,
        log = meerkat.logging.info;

    var moduleEvents = {
            health: {},
            WEBAPP_LOCK: 'WEBAPP_LOCK',
            WEBAPP_UNLOCK: 'WEBAPP_UNLOCK'
        },
        rates = null,
        rebate = '',
        rebateTiers = [
            'Full rebate applies',
            'Tier 1 applied',
            'Tier 2 applied',
            'Tier 3 applied',
            'No rebate applied'
        ],
        _selectetedRebateLabelText = '',
        _selectetedRebateTierLabelText = '',
        $elements = {};

    function init() {
        _setupFields();
        _eventSubscriptions();

        meerkat.modules.healthTiers.initHealthTiers();
        meerkat.modules.healthTiers.setTiers(true);
        updateSelectedRebateLabel();
    }

    function onStartInit() {
        // make rebate selected 'Y' by default
        if ($elements.applyRebate.is(':checked') === false) {
            $elements.applyRebate.filter('[value=Y]').trigger('click');
        } else {
            toggleRebateQuestions();
        }
    }

    function _setupFields() {

        $elements = {
            situationSelect: $('input[name=health_situation_healthCvr]'),
            applyRebate: $('input[name="health_healthCover_rebate"]'),
            householdIncomeRow: $('#health_healthCover_income_field_row'),
            lhcContainers: $('.lhcRebateCalcTrigger'),
            dependentsSelect: $('#health_healthCover_dependants'),
            incomeLabelSpans: {
                single: $('#health_healthCover_situation_single'),
                hasPartner: $('#health_healthCover_situation_hasPartner')
            },
            incomeSelect: $(':input[name="health_healthCover_income"]'),
            rebateLabel: $('#rebateLabel'),
            rebateLabelText: $('#rebateLabel span'),
            rebateLegend: $('#health_healthCover_tier_row_legend'),
            healthCoverDetails: $('#startForm')
        };
    }

    function _eventSubscriptions() {
        $(':input[name="health_situation_healthCvr"], :input[name="health_healthCover_income"], #health_situation_dependants, #health_healthCover_dependants').on('change', function updateRebateTiers() {
            meerkat.modules.healthChoices.setCover($elements.situationSelect.filter(':checked').val());
            meerkat.modules.healthTiers.setTiers();
        });

        $elements.applyRebate.on('change', function() {
            toggleRebateQuestions();
        });

        // update the lhc message. used lhcElements for now as the questions have changed dramatically
        $elements.lhcContainers.find(':input').on('change', function updateRebateContinuousCover(event, forceRebateFromFilters) {
            var forceRebate = typeof forceRebateFromFilters === 'undefined' ? true : forceRebateFromFilters;
            var $this = $(this);

            if ($this.hasClass('dateinput-day') || $this.hasClass('dateinput-month') || $this.hasClass('dateinput-year') || ($this.attr('name').indexOf('primary_dob') >= 0 && $this.val() === "") || ($this.attr('name').indexOf('partner_dob') >= 0 && $this.val() === "")) return;

            // update rebate
            if ($this.valid()) {
                setRebate(forceRebate);
            }

        });

        $elements.incomeSelect.on('change', function() {
            updateSelectedRebateLabel();
        });

        meerkat.messaging.subscribe(meerkatEvents.healthSituation.SITUATION_CHANGED, function situationChanged() {
            toggleIncomeLabel();
        });
    }

    function toggleRebateQuestions() {
        meerkat.modules.healthDependants.toggleDependants();
        updateSelectedRebateLabel();
        var $checked = $elements.applyRebate.filter(":checked");
        if($checked.length && $checked.val() === "N") {
            meerkat.modules.healthRates.unsetRebate();
        }
    }

    function updateSelectedRebateLabel() {
        // on first load, select the dropdown value and set it as a text label
        var selectedIncome,
            completeText = '',
            dependantsText = "including any adjustments for your " + $elements.dependentsSelect.val() + " dependants",
            cover = meerkat.modules.healthChoices.returnCoverCode(),
            rebateTierText;

        if ($elements.incomeSelect.filter(':checked').length === 0) {
            rebateTierText = '';
            selectedIncome = '';
        } else {
            rebateTierText = rebateTiers[$elements.incomeSelect.filter(':checked').val()];
            selectedIncome =  'earning ' + $("label[for="+$elements.incomeSelect.filter(':checked').attr("id")+"]").text();
        }

        if (cover !== '') {
            var statusText = '';
            switch (cover) {
                case 'SM':
                case 'SF':
                    statusText = 'Singles ';
                    break;
                case 'C':
                    statusText = 'Couples ';
                    break;
                case 'EF':
                case 'F':
                    statusText = 'Families ';
                    break;
                default:
                    statusText = '';
                    break;
            }
            completeText = statusText;  // is it the correct behaviour to exclude 'Single Parent Families ' in the list above?
        }

        completeText += selectedIncome;

        if (meerkat.modules.healthDependants.situationEnablesDependants() && $elements.dependentsSelect.prop('selectedIndex') !== 0) {
            completeText += ', ' + dependantsText;
        }

        // Used on the results AND OR snapshot
        _selectetedRebateLabelText = completeText;

        // Used else where, and here.
        _selectetedRebateTierLabelText = rebateTierText;
        $elements.rebateLabelText.text(rebateTierText);
    }

    function getSelectedRebateLabelText() {
        return _selectetedRebateLabelText;
    }

    function getSelectedRebateTierLabelText() {
        return _selectetedRebateTierLabelText;
    }

    function setRebate(forceRebate) {
        meerkat.modules.healthRates.loadRatesBeforeResultsPage(forceRebate, function (rates) {
            if (!isNaN(rates.rebate) && parseFloat(rates.rebate) > 0) {

                if ($elements.incomeSelect.filter(':checked').length > 0) {
                    $elements.rebateLegend.html('You are eligible for a ' + rates.rebate + '% rebate.');
                }

                rebate = rates.rebate;
            } else {
                $elements.rebateLegend.html('');
                rebate = '';
            }
        });
    }

    function getRebate() {
        return rebate ? rebate + '%' : '';
    }

    // Use the situation value to determine if a partner is visible on the journey.
    function hasPartner() {
        var cover = meerkat.modules.healthSituation.getSituation();
        return cover == 'F' || cover == 'C' || cover == 'EF';
    }

    function isRebateApplied() {
        return $elements.applyRebate.filter(':checked').val() === 'Y';
    }

    function toggleIncomeLabel() {
        $elements.incomeLabelSpans.single.toggleClass('hidden', hasPartner());
        $elements.incomeLabelSpans.hasPartner.toggleClass('hidden', !hasPartner());
    }

    meerkat.modules.register("healthRebate", {
        init: init,
        events: moduleEvents,
        onStartInit: onStartInit,
        hasPartner: hasPartner,
        updateSelectedRebateLabel: updateSelectedRebateLabel,
        getRebate: getRebate,
        setRebate: setRebate,
        toggleRebateQuestions: toggleRebateQuestions,
        isRebateApplied: isRebateApplied,
        getSelectedRebateLabelText: getSelectedRebateLabelText,
        getSelectedRebateTierLabelText: getSelectedRebateTierLabelText
    });


})(jQuery);