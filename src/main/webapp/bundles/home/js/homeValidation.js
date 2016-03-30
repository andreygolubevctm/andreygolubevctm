(function ($) {


    $.validator.addMethod("coverAmountsPercentage", function (value, elem, param) {
            var percentage = Number(param.p);
            var percentRule = param.r;
            var val = $(elem).val();
            var thisVal = Number(val.replace(/[^0-9\.]+/g, ""));
            var parmVal = $('#' + param.e).val();
            var ratio = thisVal / parmVal;
            var percent = ratio * 100;
            if (percent >= percentage && percentRule == "GT") {
                $('.specifiedValues').removeClass('has-error').addClass('has-success').parent().removeClass('has-error').addClass('has-success');
                return true;
            }
            else if (percent <= percentage && percentRule == "LT") {
                $('.specifiedValues').removeClass('has-error').addClass('has-success').parent().removeClass('has-error').addClass('has-success');
                return true;
            }
            else {
                $('.specifiedValues').addClass('has-error').removeClass('has-success').parent().addClass('has-error').removeClass('has-success');
                return false;
            }
        },
        "Total sum of the Specified Personal Effects must be less than the Total Contents Replacement Value"
    );

    $.validator.addMethod("coverAmountsTotal", function (value, elem) {
            if ($(elem).val() === "0") {
                $('.specifiedValues').addClass('has-error').removeClass('has-success').parent().addClass('has-error').removeClass('has-success');
                return false;
            }
            else {
                $('.specifiedValues').removeClass('has-error').addClass('has-success').parent().removeClass('has-error').addClass('has-success');
                return true;
            }
        },
        "Add specified personal effects amounts below or select No to the question above"
    );

    $.validator.addMethod("yearBuiltAfterMoveInYear", function (value, element, param) {
            var moveInField = $(".whenMovedInYear");
            var moveInYear = moveInField.first().find(":selected").val();
            return !(!isNaN(moveInYear) && moveInYear < $(element).find(":selected").val() && moveInField.css("display") == 'block');
        },
        "Please change the building year so that it is prior or equal to the year you moved in"
    );

    $.validator.addMethod("oldestPersonOlderThanPolicyHolders", function (value, element, param) {
            var elementPath = param;
            var dob = $("#"+elementPath+"_dob").val().split("/").reverse().join("");
            var oldestPersonDob = $("#"+elementPath+"_oldestPersonDob").val().split("/").reverse().join("");

            var jointDobVis = $("#"+elementPath+"_jointDob"), jointDob;
            if (jointDobVis.is(":visible")) {
                jointDob = $("#"+elementPath+"_jointDob").val().split("/").reverse().join("");
            }

            if (oldestPersonDob > dob || (jointDobVis.is(":visible") && oldestPersonDob > jointDob)) {
                return false;
            }
            return true;

        },
        "Please confirm that the oldest person living at the home is older than the policy holder."
    );
})(jQuery);