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
        $elements = {};

    function init() {
        _setupFields();
        _eventSubscriptions();

        meerkat.modules.healthTiers.initHealthTiers();
        meerkat.modules.healthTiers.setTiers(true);
    }

    function _setupFields() {
        $elements = {
            situationSelect: $('input[name=health_situation_healthCvr]'),
            applyRebate: $('#health_healthCover_rebate'),
            incomeSelectContainer: $('#income_container'),
            lhcContainers: $('.health-cover,  .dateinput_container, #health_healthCover_primaryCover'),
            incomeSelect: $('#health_healthCover_income'),
            selectedRebateText: $('#selectedRebateText'),
            rebateLabel: $('#rebateLabel'),
            editTier: $('.editTier'),
            rebateLegend: $('#health_healthCover_tier_row_legend'),
            healthCoverDetails: $('#startForm')
        };
    }

    function _eventSubscriptions() {
        $(':input[name="health_situation_healthCvr"], #health_healthCover_rebate').on('change', function updateRebateTiers() {
            meerkat.modules.healthChoices.setCover($elements.situationSelect.filter(':checked').val());
            meerkat.modules.healthTiers.setTiers();
        });

        $elements.applyRebate.on('change', function toggleRebateDropdown() {
            $elements.incomeSelectContainer.toggleClass('hidden', !$(this).is(':checked'));
        });

        $elements.editTier.off().on('click', function showTierDropdown() {
            $elements.selectedRebateText.hide();
            $elements.rebateLabel.hide();
            $elements.incomeSelect.parent('.select').removeClass('hidden');
        });

        // update the lhc message. used lhcElements for now as the questions have changed dramatically
        $elements.lhcContainers.find(':input').on('change', function updateRebateContinuousCover(event) {

            var $this = $(this);

            if ($this.hasClass('dateinput-day') || $this.hasClass('dateinput-month') || $this.hasClass('dateinput-year') || ($this.attr('name').indexOf('primary_dob') >= 0 && $this.val() === "") || ($this.attr('name').indexOf('partner_dob') >= 0 && $this.val() === "")) return;

            // update rebate
            if ($this.valid()) {
                _setRebate();
            }
        });
    }

    function updateSelectedRebateLabel() {
        // on first load, select the dropdown value and set it as a text label
        var $elDropdownOption = $elements.incomeSelect.prop('selectedIndex') === 0 ? $elements.incomeSelect.find('option:eq(1)') : $elements.incomeSelect.find(':selected'),
            completeText = '',
            dependantsText = 'including any adjustments for your dependants',
            cover = meerkat.modules.healthChoices.returnCoverCode();

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
                default:
                    statusText = 'Families ';
                    break;
            }
            completeText = statusText;
        }

        completeText += $elDropdownOption.text();

        if (meerkat.modules.healthTiers.shouldShowDependants()) {
            completeText += ', ' + dependantsText;
        }

        $elements.selectedRebateText.text(completeText);

        if ($elements.incomeSelect.prop('selectedIndex') === 0) {
            $elements.incomeSelect.prop('selectedIndex', 1);
        }
    }

    function _setRebate() {
        meerkat.modules.healthRates.loadRatesBeforeResultsPage(true, function (rates) {
            if (!isNaN(rates.rebate) && parseFloat(rates.rebate) > 0) {
                $elements.rebateLegend.html('You are eligible for a ' + rates.rebate + '% rebate.');
            } else {
                $elements.rebateLegend.html('');
            }
        });
    }

    // Use the situation value to determine if a partner is visible on the journey.
    function hasPartner() {
        var cover = meerkat.modules.healthChoices.getSituation();
        return cover == 'F' || cover == 'C';
    }

    function getDependents() {
        return ($elements.healthCoverDetails && $.inArray($elements.healthCoverDetails.find(':input[name="health_situation_healthCvr"]').filter(':checked').val(), ['SPF', 'F']) >= 0 ? 1 : 0);
    }

    function isRebateApplied() {
        return $('#health_healthCover_rebate').prop('checked');
    }

    meerkat.modules.register("healthRebate", {
        init: init,
        hasPartner: hasPartner,
        updateSelectedRebateLabel: updateSelectedRebateLabel,
        getDependents: getDependents,
        isRebateApplied: isRebateApplied
    });


})(jQuery);