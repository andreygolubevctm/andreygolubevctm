$.validator.addMethod("validate_${name}",
    function(value, elem, parm) {
        try{
            var val = $(elem).val();

            if( isNaN(val) )
            {
                val = val.replace(/[^\d.-]/g, '');
            }

            if( val != '' && val > 0 )
            {
                return true;
            }

            return false;
        }
        catch(e)
        {
            return false;
        }
    },

    $.validator.messages.currencyNumber = ' is not a valid number.'
);

$.validator.addMethod("${name}_minCurrency",
    function(value, elem, parm) {

        var val = $(elem).val();

        if( isNaN(val) )
        {
            val = val.replace(/[^\d.-]/g, '');
        }

        <c:if test="${not empty defaultValue}">
            if( val == ${defaultValue} ){
                return true;
            }
        </c:if>

        if( val < parm){
            return false;
        }

        return true;
    },
    "Custom message"
);

$.validator.addMethod("${name}_maxCurrency",
    function(value, elem, parm) {

        var val = $(elem).val();

        if( isNaN(val) )
        {
            val = val.replace(/[^\d.-]/g, '');
        }

        <c:if test="${not empty defaultValue}">
            if( val == ${defaultValue} ){
                return true;
            }
        </c:if>

        if( val > parm){
            return false;
        }

        return true;
    },
    "Custom message"
);

$.validator.addMethod("${name}_percent",
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
            return true;
        }
        else if (percent <= percentage && percentRule == "LT" ) {
            return true;
        }
        else {
            return false;
        }

    },
    "Custom message"
);
