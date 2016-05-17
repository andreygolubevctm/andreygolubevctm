/**
 * Description: Create a separate module in this file for each of health's global modules from __health_legacy.js
 */

;(function ($, undefined) {

    var meerkat = window.meerkat;

    var events = {
            healthCreditCard: {}
        };

    /**
     * These masks don't appear to be used, may just be for informational purposes.
     * dinersMask = '9999 999999 9999',
     * visaMask = '9999 9999 9999 9999',
     * mcMask = '9999 9999 9999 9999',
     * amexMask = '9999 999999 99999',
     */
    var config = {},
        ccvMasks = {
        "a": '9999', // AMEX
        "d": '999', // DINERS
        "m": '999', // MASTERCARD
        "v": '999' // VISA
    };

    function resetCreditCardConfig() {
        config = { 'visa':true, 'mc':true, 'amex':true, 'diners':false };
    }

    function setCreditCardConfig(options) {
        config = options;
    }

    function renderFields() {
        var $cardContainer = $('.health-credit_card_details-type');
        var $_icons = $('#health_payment_credit-selection .cards');
        $_icons.children().hide();
        var _html = '';
        var _selected = $cardContainer.find('input').filter(':checked').val();

        if( config.visa === true ){
            _html += setCreditCardObj('v', 'Visa', _selected);
            $_icons.find('.visa').show();
        }

        if( config.mc === true ){
            _html += setCreditCardObj('m', 'Mastercard', _selected);
            $_icons.find('.mastercard').show();
        }

        if( config.amex === true ){
            _html += setCreditCardObj('a', 'Amex', _selected);
            $_icons.find('.amex').show();
        }

        if( config.diners === true ){
            _html += setCreditCardObj('d', 'Diners Club', _selected);
            $_icons.find('.diners').show();
        }

        $cardContainer.html(_html);
    }

    function setCreditCardObj(value, label, selected){
        var obj = {inputname : 'health_payment_credit_type'};
        var creditCardTemplate = $('#credit-card-template').html();
        var ccHtmlTemplate = _.template(creditCardTemplate);
        var prefix = "health_payment_credit_type_";

        obj.inputvalue = prefix+""+value;
        obj.inputid = obj.inputname+"_"+value;
        obj.inputlabel = label;
        obj.inputSelected = value == selected;

        return ccHtmlTemplate(obj);
    }

    function setCreditCardRules() {
        _setRules(_getCardType(), $('#health_payment_credit_number'), $('#health_payment_credit_ccv'));
    }

    function _getCardType() {
        return $('#health_payment_credit_type').find(':selected').val();
    }

    function _setRules(cardType, $creditCardInput, $ccvInput) {

        if ($creditCardInput.length == 1 && cardType !== '') {
            $creditCardInput.removeRule('creditCardNumber');
        } else {
            return false;
        }

        if (typeof $ccvInput == 'undefined') {
            $ccvInput = false;
        }

        $creditCardInput.addRule("creditCardNumber", {cardType: cardType});
        if(ccvMasks[cardType]) {
            _CCVmask($ccvInput, ccvMasks[cardType]);
        } else {
            return false;
        }
        return true;
    }

    function _CCVmask($_objCCV, mask) {
        if (!$_objCCV) return;
        var len = mask.length || 4;
        $_objCCV.attr('maxlength', len);
    }

    meerkat.modules.register("healthCreditCard", {
        events: events,
        resetConfig: resetCreditCardConfig,
        setCreditCardRules: setCreditCardRules,
        setCreditCardConfig: setCreditCardConfig,
        render: renderFields
    });

})(jQuery);

