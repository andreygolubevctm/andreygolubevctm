;(function($, undefined){

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,

    countFrom =  {
        TODAY: 'today' , NOCOUNT: '' , EFFECTIVE_DATE: 'effectiveDate'
    },
    minType = {
        FROM_TODAY: 'today' , FROM_EFFECTIVE_DATE: 'effectiveDate'
    };

    // Create payment day options on the fly - min and max are in + days from the selected date;
    //NOTE: max - min cannot be a negative number
    function paymentDays( effectiveDateString ){
        // main check for real value
        if( effectiveDateString == ''){
            return false;
        }
        var effectiveDate = meerkat.modules.utils.returnDate(effectiveDateString);
        var today = new Date();

        var _baseDate = null;
        if(healthFunds._payments.countFrom == countFrom.TODAY ) {
            _baseDate = today;
        } else {
            _baseDate = effectiveDate;
        }
        var _count = 0;

        var _days = 0;
        var _limit = healthFunds._payments.max;
        if(healthFunds._payments.minType == minType.FROM_TODAY ) {
            var difference = Math.round((effectiveDate-today)/(1000*60*60*24));
            if(difference < healthFunds._payments.min) {
                _days = healthFunds._payments.min - difference;
            }
        } else {
            _days = healthFunds._payments.min;
            _limit -= healthFunds._payments.min;
        }



        var _html = '<option value="">Please choose...</option>';

        // The loop to create the payment days
        var continueCounting = true;
        while (_count < _limit) {
            var _date = new Date( _baseDate.getTime() + (_days * 24 * 60 * 60 * 1000));
            var _day = _date.getDay();
            // up to certain payment day
            if( typeof(healthFunds._payments.maxDay) != 'undefined' && healthFunds._payments.maxDay < _date.getDate() ){
                _days++;
                // Parse out the weekends
            } else if( !healthFunds._payments.weekends && ( _day == 0 || _day == 6 ) ){
                _days++;
            } else {
                var _dayString = meerkat.modules.numberUtils.leadingZero( _date.getDate() );
                var _monthString = meerkat.modules.numberUtils.leadingZero( _date.getMonth() + 1 );
                _html += '<option value="'+ _date.getFullYear() +'-'+ _monthString +'-'+ _dayString +'">'+ healthFunds._getNiceDate(_date) +'</option>';
                _days++;
                _count++;
            };
        };

        // Return the html
        return _html;
    }

    // Renders the payment days text
    function paymentDaysRender($_object,_html){
        if(_html === false){
            healthFunds._payments = { 'min':0, 'max':5, 'weekends':false };
            _html = '<option value="">Please choose...</option>';
        }
        $_object.html(_html);
        $_object.parent().siblings('p').text( 'Your payment will be deducted on: ' + $_object.find('option').first().text() );
        $('.health-bank_details-policyDay, .health-credit-card_details-policyDay').html(_html);
    }


    meerkat.modules.register("healthPaymentDay", {
        events: moduleEvents,
        paymentDays : paymentDays,
        paymentDaysRender : paymentDaysRender,
        FROM_EFFECTIVE_DATE : minType.FROM_EFFECTIVE_DATE,
        EFFECTIVE_DATE : countFrom.EFFECTIVE_DATE
    });

})(jQuery);