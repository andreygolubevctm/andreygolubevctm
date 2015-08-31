/**
 * Description: Create a separate module in this file for each of health's global modules.
 */

;(function ($, undefined) {

    var meerkat = window.meerkat;

    var events = {
            healthCreditCard: {}
        };

    var//dinersMask = '9999 999999 9999', // These masks don't appear to be used.
        dinersMaskCCV = '999',
        //visaMask = '9999 9999 9999 9999',
        visaMaskCCV = '999',
        //mcMask = '9999 9999 9999 9999',
        mcMaskCCV = '999',
        //amexMask = '9999 999999 99999',
        amexMaskCCV = '9999',

        config = {};


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

    function _setRules(_type, $_obj, $_objCCV) {

        if ($_obj.length == 1 && _type !== '') {
            _remove($_obj);
        } else {
            return false;
        }

        if (typeof $_objCCV == 'undefined') {
            $_objCCV = false;
        }

        switch (_type) {
            case 'a':
                $_obj.rules("add", "ccNumberAmex");
                this._CCVmask($_objCCV, amexMaskCCV);
                break;
            case 'v':
                $_obj.rules("add", "ccNumberVisa");
                this._CCVmask($_objCCV, visaMaskCCV);
                break;
            case 'd':
                $_obj.rules("add", "ccNumberDiners");
                this._CCVmask($_objCCV, dinersMaskCCV);
                break;
            case 'm':
                $_obj.rules("add", "ccNumberMC");
                this._CCVmask($_objCCV, mcMaskCCV);
                break;
            default:
                return false;
        }

        return true;
    }

    //TODO: refactor this.
    function _remove($_obj) {
        $_obj.rules("remove", "ccNumber");
        $_obj.rules("remove", "ccNumberAmex");
        $_obj.rules("remove", "ccNumberMC");
        $_obj.rules("remove", "ccNumberVisa");
        $_obj.rules("remove", "ccNumberDiners");
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

