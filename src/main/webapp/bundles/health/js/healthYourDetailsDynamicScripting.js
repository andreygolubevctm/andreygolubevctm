;(function($, undefined) {

    var meerkat = window.meerkat,
        $fields = {},
        $yourDetailsNoOfDependents = null,
        $rebateIncomeThresholdDropdownBox = null,
        $dynamicDialogueBoxRebateIncomeThresholdsConfirmation = null,
        // this was adapted from simplesDynamicDialogue.js
        _derivedData = {},
        _dynamicValues = [
            {
                text: '%REBATE_TIER%',
                get: function() {
                    if(!_derivedData) {
                        return '';
                    }
                    if (!_derivedData.rebate) {
                        return '';
                    }

                    return _derivedData.rebate.tier ? _derivedData.rebate.tier : '';
                }
            },
            {
                text: '%INCOME_THRESHOLD%',
                get: function() {
                    if(!_derivedData) {
                        return '';
                    }
                    if (!_derivedData.rebate) {
                        return '';
                    }

                    return _derivedData.rebate.incomeThreshold ? _derivedData.rebate.incomeThreshold : '';
                }
            }
        ];

    function onInitialise() {
        $yourDetailsNoOfDependents = $('#health_healthCover_dependants');
        $rebateIncomeThresholdDropdownBox = $('#health_healthCover_income');

        _setupRebateIncomeThresholdsConfirmationDynamicTextTemplate();
    }

    function _setupListeners() {

        var yourDetailsRebateTierUpdated = function(){
            _derivedData.rebate = _getRebateData();

            performUpdateRebateIncomeThresholdsConfirmationDynamicDialogueBox();
        };

        $yourDetailsNoOfDependents.on('change.yourDetailsNoOfDependentsUpdated', yourDetailsRebateTierUpdated);
        $rebateIncomeThresholdDropdownBox.on('change.yourDetailsRebateIncomeThresholdUpdated', yourDetailsRebateTierUpdated);
    }

    function _setupFields() {
        $fields = {
            rebate: {
                applyRebate: $('input[name=health_healthCover_rebate]'),
                currentPercentage: $('#health_rebate'),
                tier: $('#health_healthCover_income')
            }
        };
    }

    function onBeforeEnterYourDetails() {
        _setupFields();
        _setupListeners();

        _derivedData = _getTemplateData();
        performUpdateRebateIncomeThresholdsConfirmationDynamicDialogueBox();

        meerkat.modules.healthAboutYou.updateComplianceDialogCopy();
    }

    // This is used to cache selectors and the original HTML for for field labels dialogue boxes etc that have
    // placeholder text to be replaced - note that if the html does not exist when onInitialise is run it will
    // not be cached - this may actually cause the dynamic script to be hidden - due to this a try catch has been added.
    function _setupRebateIncomeThresholdsConfirmationDynamicTextTemplate() {

        try {
            $dynamicDialogueBoxRebateIncomeThresholdsConfirmation = {
                'elementRef':$('.simples-dialogue-37'),
                'template': $('.simples-dialogue-37').html()
            };
        }
        catch(err) {
            console.error( "Required Rebate Income Thresholds Confirmation dialogue box does not exist");
        }

    }

    function performUpdateRebateIncomeThresholdsConfirmationDynamicDialogueBox() {
        try {
            var newHtml = $dynamicDialogueBoxRebateIncomeThresholdsConfirmation.template.valueOf();
            replacePlaceholderText($dynamicDialogueBoxRebateIncomeThresholdsConfirmation.elementRef, newHtml, null);
        }
        catch(err) {
            console.error( "Rebate Income Thresholds Confirmation dynamic text replacement did not occur due to an error");
        }
    }

    // This function requires:
    // an element selector reference  (The element to be updated),
    // the html template (the original HTML template for the element which contains the original placeholder text values),
    // onParse ( a function that can be run upon updating the element)
    //
    // It searches the _dynamicValues array for any matching placeholders and replaces any matching placeholders
    function replacePlaceholderText(elementRef, newHtml, onParse) {
        if(!elementRef || !newHtml) return;

        _.defer(function () {
            var dialogue = elementRef;
            var html = newHtml;

            for(var i = 0; i < _dynamicValues.length; i++) {
                var value = _dynamicValues[i];
                if(html.indexOf(value.text) > -1) {
                    html = html.replace(new RegExp(value.text, 'g'), value.get());
                }
            }

            dialogue.html(html);

            if(onParse && typeof onParse === 'function') {
                onParse();
            }
        });
    }

    function _getTemplateData() {
        var data = {
            rebate: _getRebateData()
        };

        return data;
    }

    function _getRebateData() {

        _derivedData.rebate = {};

        var rebateTier = _getRebateTier($fields.rebate.tier.val()),
            rebatePercent = $fields.rebate.currentPercentage.val() + '%',
            rebatePretty = ((!_.isUndefined(rebateTier) &&  !_.isUndefined(rebatePercent))? (rebateTier + ' - ' + rebatePercent) : ''),
            aboutYouPageApplyRebateFieldVal = $fields.rebate.applyRebate.filter(':checked').val(),
            incomeTier = _getRebateIncomeThreshold($fields.rebate.tier.find('option:selected').text()),
            data =  {
                tier: rebateTier,
                percent: rebatePercent,
                prettyPrinted: rebatePretty,
                aboutYouPageApplyRebateFieldVal: aboutYouPageApplyRebateFieldVal,
                incomeThreshold: incomeTier
            };

        return data;
    }

    function _getRebateTier(rebateTierEnum) {
        if (rebateTierEnum > 0) {
            return 'Tier ' + rebateTierEnum;
        } else {
            return 'Base tier';
        }
    }

    function _getRebateIncomeThreshold(rebateIncomeThresholdDropdownText) {
        if (rebateIncomeThresholdDropdownText.length > 0) {
            if (rebateIncomeThresholdDropdownText == 'Please choose...') {
                return 'PLEASE SELECT YOUR TAXABLE INCOME';
            } else {
                return rebateIncomeThresholdDropdownText.slice(0, rebateIncomeThresholdDropdownText.indexOf(' ('));
            }
        } else {
            return 'PLEASE SELECT YOUR TAXABLE INCOME';
        }
    }

    meerkat.modules.register("healthYourDetailsDynamicScripting", {
        onInitialise: onInitialise,
        onBeforeEnterYourDetails: onBeforeEnterYourDetails
    });

})(jQuery);
