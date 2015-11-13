(function($) {
    // homelan\details.tag
    var search_match = new RegExp(/^((\s)*[\w\-]+\s+)+\d{4}((\s)+(ACT|NSW|QLD|TAS|SA|NT|VIC|WA)(\s)*)$/);
    var LocationObj = {
        is_valid : function( location ) {

            value = $.trim(String(location));

            if( value !== '' ) {
                if( value.match(search_match) ) {
                    return true;
                }
            }

            return false;
        }
    };

    /* To proceed a user must select either a valid postcode or enter a suburb and
     select a valid suburb/postcode/state value from the autocomplete. This is to
     avoid suburbs that match multiple locations being sent with request only to be
     returned empty because can only search a single location (FUE-23). */
    $.validator.addMethod("validateSuburbPostcodeState",
         function(value, element) {

         if( LocationObj.is_valid(value) ) {

            /* Populate suburb, postcode, state fields */
            var location = $.trim(String(value));
            var pieces = location.split(' ');
            var state = pieces.pop();
            var postcode = pieces.pop();
            var suburb = pieces.join(' '),
                fieldName =  $(element).attr('id').replace("_location", "");


            $('#'+fieldName+'_state').val(state);
            $('#'+fieldName+'_postcode').val(postcode);
            $('#'+fieldName+'_suburb').val(suburb);

            return true;
        }

        return false;
    },
    "Replace this message with something else"
    );


    $.validator.addMethod('validateLoanAmount', function(value, element) {
        /* Need to use the entry fields because validation fires before the currency plugin pushes the unformatted values into the hidden fields */


        var fieldName = $(element).attr('id').replace("_loanAmountentry", ""),
            $loanAmount = $('#'+fieldName+'_loanAmountentry'),
            $purchasePrice = $('#'+fieldName+'_purchasePriceentry'),
            $propertyWorth = $('#homeloan_details_assetAmountentry'),
            $amountOwing = $('#homeloan_details_amountOwingentry');

        /* If the elements have the currency plugin applied */
        var loanAmount = typeof $loanAmount.asNumber === 'function' ? $loanAmount.asNumber() : 0,
            purchasePrice = typeof $purchasePrice.asNumber === 'function' ? $purchasePrice.asNumber() : 0,
            propertyWorth = typeof $propertyWorth.asNumber === 'function' ? $propertyWorth.asNumber() : 0,
            amountOwing = typeof $amountOwing.asNumber === 'function' ? $amountOwing.asNumber() : 0;

        if(!isNaN(loanAmount) && !isNaN(purchasePrice) && !isNaN(propertyWorth) && !isNaN(amountOwing)) {
            var lvr = ((loanAmount+amountOwing) / (purchasePrice+propertyWorth)) * 100;
            return lvr > 0 && lvr < 100;
        }

        return true;
    });
})(jQuery);