$.validator.addMethod("${fieldXpathName}_percent",
    function(value, elem, parm) {
        var parmsArray = parm.split(",");
        var percentage = parmsArray[1];
        var percentRule = parmsArray[2];
        var val = $(elem).val();
        var thisVal = Number(val.replace(/[^0-9\.]+/g,""));
        var parmVal = $('#'+parmsArray[0]).val();
        var ratio = thisVal / parmVal;
        var percent = ratio * 100;
        if (percent >= percentage && percentRule == "GT" ) {
            $('.specifiedValues').removeClass('has-error').addClass('has-success').parent().removeClass('has-error').addClass('has-success');
            return true;
        }
        else if (percent <= percentage && percentRule == "LT" ) {
            $('.specifiedValues').removeClass('has-error').addClass('has-success').parent().removeClass('has-error').addClass('has-success');
            return true;
        }
        else {
            $('.specifiedValues').addClass('has-error').removeClass('has-success').parent().addClass('has-error').removeClass('has-success');
            return false;
        }
    },
    "Custom message"
);
$.validator.addMethod("${fieldXpathName}_total",
    function(value, elem) {
        if ($(elem).val() === "0")  {
            $('.specifiedValues').addClass('has-error').removeClass('has-success').parent().addClass('has-error').removeClass('has-success');
            return false;
        }
        else {
            $('.specifiedValues').removeClass('has-error').addClass('has-success').parent().removeClass('has-error').addClass('has-success');
            return true;
        }
    },
    "Custom message"
);

$.validator.addMethod("yearBuiltAfterMoveInYear",
    function(value, element, param) {
        var moveInField = $(".whenMovedInYear");
        var moveInYear = moveInField.first().find(":selected").val();
        if( !isNaN(moveInYear) && moveInYear < $(element).find(":selected").val() && moveInField.css("display") == 'block' ){
            return false;
        }
        return true;

    },
    "Custom message"
);

$.validator.addMethod("oldestPersonOlderThanPolicyHolders",
    function(value, element, param) {

        var dob = $("#${name}_dob").val().split("/").reverse().join("");
        var oldestPersonDob = $("#${name}_oldestPersonDob").val().split("/").reverse().join("");

        var jointDobVis = $("#${name}_jointDob");
        if (jointDobVis.is(":visible")){
            var jointDob = $("#${name}_jointDob").val().split("/").reverse().join("");
        }

        if( oldestPersonDob > dob || (jointDobVis.is(":visible") && oldestPersonDob > jointDob)){
            return false;
        }
        return true;

    },
    "Custom message"
);