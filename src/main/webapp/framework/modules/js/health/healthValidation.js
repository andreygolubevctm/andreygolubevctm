/*To proceed a user must select either a valid postcode or enter a suburb and
select a valid suburb/postcode/state value from the autocomplete. This is to
avoid suburbs that match multiple locations being sent with request only to be
returned empty because can only search a single location (FUE-23). */
$.validator.addMethod("validateHealthPostcodeSuburb",
    function(value, element) {

        if( healthChoices.isValidLocation(value) ) {
            healthChoices.setLocation(value);

            return true;
        }

        return false;
    }
);

//
// Ensures that client agrees to the field
// Makes sure that checkbox for 'Y' is checked
//
$.validator.addMethod("agree", function (value, element) {
    if (value === "Y") {
        return $(element).is(":checked");
    } else {
        return false;
    }
}, "");

// from health/persons.tag
$.validator.addMethod("genderTitle",
    function(value, element, param) {

        if(value == ''){
            return true;
        };

        var _gender = $(element).closest('.qe-window').find('.person-gender input:checked').val();

        if(typeof _gender == 'undefined' || _gender == ''){
            return true; <%-- no need to validate until both completed --%>
        };

        switch( value )
        {
            case 'MR':
                var _success = (_gender == 'M') ? true : false;
                break;
            case 'MRS':
            case 'MISS':
            case 'MS':
                var _success = (_gender == 'F') ? true : false;
                break;
            default:
                var _success = true;
                break;
        };

        return _success;
    },
    $.validator.messages.genderTitle = 'The title and gender do not match'
);

// from health/persons.tag
$('#${name}').find('.person-title').each( function(){
    $(this).rules('add','genderTitle');
});
/* //REFINE: find a better way to call an individual rule check
    $('#${name}').find('.person-gender, .person-title').on('change', function(){
        $(this).closest('.content').find('.person-title').valid('genderTitle');
    }); */

// similar named function in validationAddress.js
$.validator.addMethod("matchStates",
    function(value, element) {
        return healthApplicationDetails.testStatesParity();
    },
    "Your address does not match the original state provided"
);

// privacy_optin.tag if statement specific to health
$.validator.addMethod('readPrivacyStatementMessage', function(value, element, param) {
    if( $(element).is(':checked') ){
        $('.readPrivacyStatementError').hide();
        return true;
    } else {
        $('.readPrivacyStatementError').show();
        return false;
    };
});

/* Masking sequences */
var field_credit_card_validation = {

    /* Masking types */
    dinersMask: '9999 999999 9999',
    dinersMaskCCV: '999',
    visaMask: '9999 9999 9999 9999',
    visaMaskCCV: '999',
    mcMask: '9999 9999 9999 9999',
    mcMaskCCV: '999',
    amexMask: '9999 999999 99999',
    amexMaskCCV: '9999',


    /* Apply the masking and validation rules onto a jquery obj */
    set: function(_type, $_obj, $_objCCV){

        if($_obj.length == 1 && _type != '') {
            field_credit_card_validation._remove( $_obj );
        } else {
            return false;
        };

        if(typeof $_objCCV === 'undefined'){
            $_objCCV = false;
        }

        switch( _type )
        {
            case 'a':
                $_obj.rules("add","ccNumberAmex");
                this._CCVmask($_objCCV, this.amexMaskCCV);
                break;
            case 'v':
                $_obj.rules("add","ccNumberVisa");
                this._CCVmask($_objCCV, this.visaMaskCCV);
                break;
            case 'd':
                $_obj.rules("add","ccNumberDiners");
                this._CCVmask($_objCCV, this.dinersMaskCCV);
                break;
            case 'm':
                $_obj.rules("add","ccNumberMC");
                this._CCVmask($_objCCV, this.mcMaskCCV);
                break;
            default:
                return false;
        }

        return true;
    },

    _CCVmask: function($_objCCV, mask) {
        if (!$_objCCV) return;
        var len = mask.length || 4;
        $_objCCV.attr('maxlength', len);
    },

    _remove: function($_obj) {
        $_obj.rules("remove","ccNumber");
        $_obj.rules("remove","ccNumberAmex");
        $_obj.rules("remove","ccNumberMC");
        $_obj.rules("remove","ccNumberVisa");
        $_obj.rules("remove","ccNumberDiners");
    }
};

/* Validation for Mastercard credit cards */
$.validator.addMethod("ccv", function(value, element) {
        var len = $(element).attr('maxlength') || 4;
        var regex = '^\\d{' + len + '}$';
        return value.search(regex) != -1;
    },
    $.validator.messages.ccv = 'Please enter a valid CCV number'
);

/* Validation for Mastercard credit cards */
$.validator.addMethod("ccNumberMC",
    function(value, element) {
        var regex = '^5[1-5][0-9]{14}$';
        return String( value.replace(/\s/g, '') ).search(regex) != -1; /* Will return true if card passes regex */
    },
    $.validator.messages.ccNumberMC = 'Please enter a valid Mastercard card number'
);

/* Validation for Visa credit cards */
$.validator.addMethod("ccNumberVisa",
    function(value, element) {
        var regex = '^4[0-9]{12}(?:[0-9]{3})?$';
        return String( value.replace(/\s/g, '') ).search(regex) != -1; /* Will return true if card passes regex */
    },
    $.validator.messages.ccNumberVisa = 'Please enter a valid Visa card number'
);

/* Validation for Amex credit cards */
$.validator.addMethod("ccNumberAmex",
    function(value, element) {
        var regex = '^3[47][0-9]{13}$';
        return String( value.replace(/\s/g, '') ).search(regex) != -1; /* Will return true if card passes regex */
    },
    $.validator.messages.ccNumberAmex = 'Please enter a valid American Express card number'
);

/* Validation for Diners credit cards */
$.validator.addMethod("ccNumberDiners",
    function(value, element) {
        var regex = '^3(?:0[0-5]|[68][0-9])[0-9]{11}$';
        return String( value.replace(/\s/g, '') ).search(regex) != -1; /* Will return true if card passes regex */
    },
    $.validator.messages.ccNumberDiners = 'Please enter a valid Diners Club card number'
);

$.validator.addMethod("ccNumber",
    function(value, elem, parm) {

        /* Strip non-numeric */
        value = value.replace(/[^0-9]/g, '');

        if(value.length == 16){
            return true;
        }else{
            return false;
        }
    },
    ""
);

$.validator.addMethod("ccNumber",
    function(value, elem, parm) {

        /* Strip non-numeric */
        value = value.replace(/[^0-9]/g, '');

        if(value.length == 16){
            return true;
        }else{
            return false;
        }
    },
    ""
);

$.validator.addMethod("medicareNumber",
    function(value, elem, parm) {

        var cardNumber = value.replace(/\s/g, ''); //remove spaces

        if (isNaN(cardNumber)){
            return false;
        }

        /* Ten is the length */
        if(cardNumber.length != 10){
            return false;
        };

        /* Must start between 2 and 6 */
        if( (cardNumber.substring(0,1) < 2) || (cardNumber.substring(0,1) > 6) ){
            return false;
        };

        var sumTotal =
            (cardNumber.substring(0,1) * 1)
            + (cardNumber.substring(1,2) * 3)
            + (cardNumber.substring(2,3) * 7)
            + (cardNumber.substring(3,4) * 9)
            + (cardNumber.substring(4,5) * 1)
            + (cardNumber.substring(5,6) * 3)
            + (cardNumber.substring(6,7) * 7)
            + (cardNumber.substring(7,8) * 9);

        /* Remainder needs to = the 9th number */
        if( sumTotal % 10 == cardNumber.substring(8,9) ){
            return true;
        } else {
            return false;
        };
    },
    $.validator.messages.medicareNumber = 'card number is not a valid Medicare number'
);

// Used in mcExp for medicare_number.tag
$.validator.addMethod("${rule}",
    function(value, elem, parm) {
        if ($('#${cardExpiryYear}').val() != '' && $('#${cardExpiryMonth}').val() != '') {

            var now_ym = parseInt(get_now_year() + '' + get_now_month());
            var sel_ym = parseInt('20' + $('#${cardExpiryYear}').val() + '' + $('#${cardExpiryMonth}').val());

            if (sel_ym >= now_ym) {
                return true;
                /*
                 Using this makes sense but breaks
                 var valid = $('#${cardExpiryMonth}').valid();
                 if (valid) {
                 $(elem).validate().ctm_unhighlight($('#${cardExpiryYear}').get(0), this.settings.errorClass, this.settings.validClass);
                 }
                 console.log('${rule} valid:', valid);
                 return valid;
                 */
            }
        }
        return false;
    }, ""
);

// Used in medicare_number.tag
$("#${cardExpiryMonth}").on('change', function(){
    var $year = $('#${cardExpiryYear}');
    if ($year.hasClass('has-error') || $year.hasClass('has-success')) {
        $('#${cardExpiryYear}').valid();
    }
});