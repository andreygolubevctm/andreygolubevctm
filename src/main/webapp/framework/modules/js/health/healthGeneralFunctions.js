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

    function init() {

        $(document).ready(function ($) {

        });

    }

    function resetCreditCardConfig() {
        config = { 'visa':true, 'mc':true, 'amex':true, 'diners':false };
    }

    function setCreditCardConfig(options) {
        config = options;
    }

    function renderFields() {
        var $_obj = $('#health_payment_credit_type');
        var $_icons = $('#health_payment_credit-selection .cards');
        $_icons.children().hide();

        var _html = '<option id="health_payment_credit_type_" value="">Please choose...</option>';
        var _selected = $_obj.find(':selected').val();


        if( config.visa === true ){
            _html += '<option id="health_payment_credit_type_v" value="v">Visa</option>';
            $_icons.find('.visa').show();
        }

        if( config.mc === true ){
            _html += '<option id="health_payment_credit_type_m" value="m">Mastercard</option>';
            $_icons.find('.mastercard').show();
        }

        if( config.amex === true ){
            _html += '<option id="health_payment_credit_type_a" value="a">AMEX</option>';
            $_icons.find('.amex').show();
        }

        if( config.diners === true ){
            _html += '<option id="health_payment_credit_type_d" value="d">Diners Club</option>';
            $_icons.find('.diners').show();
        }

        $_obj.html( _html ).find('option[value="'+ _selected +'"]').attr('selected', 'selected');
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
        init: init,
        events: events,
        resetConfig: resetCreditCardConfig,
        setCreditCardRules: setCreditCardRules,
        setCreditCardConfig: setCreditCardConfig,
        render: renderFields
    });

})(jQuery);

