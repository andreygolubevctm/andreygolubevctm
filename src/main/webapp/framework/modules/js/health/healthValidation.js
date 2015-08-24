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