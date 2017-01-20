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
        rebateText = [
            'Full rebate applies',
            'Tier 1 applied',
            'Tier 2 applied',
            'Tier 3 applied',
            'No rebate applied'
        ],
        _selectetedRebateLabelText = '',
        $elements = {},
        inEditMode = false;

    function init() {
        _setupFields();
        _eventSubscriptions();

        meerkat.modules.healthTiers.initHealthTiers();
        meerkat.modules.healthTiers.setTiers(true);
        _updateRebateLabelText();
    }

    function _setupFields() {
        $elements = {
            situationSelect: $('input[name=health_situation_healthCvr]'),
            applyRebate: $('#health_healthCover_rebate'),
            rebateCheckbox: $('#health_healthCover_rebateCheckbox'),
            incomeSelectContainer: $('.income_container'),
            lhcContainers: $('.health-cover,  .dateinput_container, #health_healthCover_primaryCover, .income_container .select'),
            dependentsSelect: $('#health_healthCover_dependants'),
            incomeSelect: $('#health_healthCover_income'),
            selectedRebateText: $('#selectedRebateText'),
            rebateLabel: $('#rebateLabel'),
            rebateLabelText: $('#rebateLabel span'),
            editTier: $('.editTier'),
            rebateLegend: $('#health_healthCover_tier_row_legend'),
            healthCoverDetails: $('#startForm')
        };
    }

    function _eventSubscriptions() {
        $(':input[name="health_situation_healthCvr"], #health_healthCover_rebateCheckbox').on('change', function updateRebateTiers() {
            meerkat.modules.healthChoices.setCover($elements.situationSelect.filter(':checked').val());
            meerkat.modules.healthTiers.setTiers();
        });

        $elements.rebateCheckbox.on('change', function toggleRebateDropdown() {
            var isChecked = $(this).is(':checked');

            $elements.incomeSelectContainer.toggleClass('hidden', !isChecked);
            $elements.applyRebate.val(isChecked ? 'Y' : 'N');
        });

        $elements.editTier.off().on('click', function() {
            toggleEdit(true);
        });

        // update the lhc message. used lhcElements for now as the questions have changed dramatically
        $elements.lhcContainers.find(':input').on('change', function updateRebateContinuousCover(event) {

            var $this = $(this);

            if ($this.hasClass('dateinput-day') || $this.hasClass('dateinput-month') || $this.hasClass('dateinput-year') || ($this.attr('name').indexOf('primary_dob') >= 0 && $this.val() === "") || ($this.attr('name').indexOf('partner_dob') >= 0 && $this.val() === "")) return;

            // update rebate
            if ($this.valid()) {
                _setRebate();
            }

            // toggle dependants count if inEditMode
            if (inEditMode) {
                $elements.dependentsSelect.parent('.select').toggleClass('hidden', !meerkat.modules.healthDependants.situationEnablesDependants());
            }

        });

        $elements.incomeSelect.on('change', function() {
            updateSelectedRebateLabel();
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

        completeText += 'earning ' + $elDropdownOption.text();

        if (meerkat.modules.healthTiers.shouldShowDependants()) {
            completeText += ', ' + dependantsText;
        }

        _selectetedRebateLabelText = completeText;

        $elements.selectedRebateText.text(completeText);

        if ($elements.incomeSelect.prop('selectedIndex') === 0) {
            $elements.incomeSelect.prop('selectedIndex', 1);
        }
    }

    function getSelectedRebateLabelText() {
        return _selectetedRebateLabelText;
    }

    function _setRebate() {
        meerkat.modules.healthRates.loadRatesBeforeResultsPage(true, function (rates) {
            if (!isNaN(rates.rebate) && parseFloat(rates.rebate) > 0) {
                $elements.rebateLegend.html('You are eligible for a ' + rates.rebate + '% rebate.');
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
        return cover == 'F' || cover == 'C';
    }

    function isRebateApplied() {
        return $elements.applyRebate.val() === 'Y';
    }

    function _updateRebateLabelText() {
        $elements.rebateLabelText.text(getRebateLabelText());
    }

    function getRebateLabelText(tier) {
        return rebateText[tier || ($elements.incomeSelect.val() || 0)];
    }

    function toggleEdit(isEdit) {
        $elements.selectedRebateText.toggle(!isEdit);
        $elements.rebateLabel.toggle(!isEdit);
        $elements.dependentsSelect.parent('.select').toggleClass('hidden', !isEdit || (isEdit && !meerkat.modules.healthDependants.situationEnablesDependants()));
        $elements.incomeSelect.parent('.select').toggleClass('hidden', !isEdit);

        if (!isEdit) {
            _updateRebateLabelText();
            updateSelectedRebateLabel();
            _setRebate();
        }

        inEditMode = isEdit;
    }

    meerkat.modules.register("healthRebate", {
        init: init,
        events: moduleEvents,
        hasPartner: hasPartner,
        updateSelectedRebateLabel: updateSelectedRebateLabel,
        getRebate: getRebate,
        isRebateApplied: isRebateApplied,
        toggleEdit: toggleEdit,
        getRebateLabelText: getRebateLabelText,
        getSelectedRebateLabelText: getSelectedRebateLabelText
    });


})(jQuery);