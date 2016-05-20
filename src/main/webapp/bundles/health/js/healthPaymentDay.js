;(function($, undefined){

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,

    countFrom =  {
        TODAY: 'today' , NOCOUNT: '' , EFFECTIVE_DATE: 'effectiveDate'
    },
    minType = {
        FROM_TODAY: 'today' , FROM_EFFECTIVE_DATE: 'effectiveDate'
    };

    /*
    * Create paymet days of the months drop down html
    * */
    function paymentDaysOfTheMonth (minimumDate, maxDayOfTheMonth) {
        if (!maxDayOfTheMonth) {
            maxDayOfTheMonth = 31;
        }

        var html = '<option value="">Please choose...</option>';

        for (var i = 1;  i <= maxDayOfTheMonth; i++) {
            var childDateOriginal = new Date();
                childDateOriginal.setDate(i);
            var childDateNew = compareAndAddMonth(childDateOriginal, minimumDate);

            html += '<option value="' + meerkat.modules.dateUtils.dateValueServerFormat(childDateNew) + '">' + i + '</option>';
        }

        return html;
    }

    // Create payment day options on the fly - min and max are in + days from the selected date;
    //NOTE: max - min cannot be a negative number
    function paymentDays( effectiveDateInput){
        // main check for real value
        if( effectiveDateInput === ''){
            return false;
        }
        var effectiveDate = meerkat.modules.dateUtils.returnDate(effectiveDateInput);
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
        while (_count < _limit) {
            var _date = new Date( _baseDate.getTime() + (_days * 24 * 60 * 60 * 1000));
            var _day = _date.getDay();
            // up to certain payment day
            if( typeof(healthFunds._payments.maxDay) != 'undefined' && healthFunds._payments.maxDay < _date.getDate() ){
                _days++;
                // Parse out the weekends
            } else if( !healthFunds._payments.weekends && ( _day === 0 || _day === 6 ) ){
                _days++;
            } else {
                _html += '<option value="'+ meerkat.modules.dateUtils.dateValueServerFormat(_date) +'">'+
                    meerkat.modules.dateUtils.dateValueLongFormat(_date) +'</option>';
                _days++;
                _count++;
            }
        }

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

    /*
    * Helper function toe add a month to the date if it is smaller then the minimum date
    * */
    function compareAndAddMonth(oldDate, minDate) {
        if (oldDate < minDate){
            var newDate = new Date(oldDate.setMonth(oldDate.getMonth() +  1 ));
            return compareAndAddMonth(newDate, minDate);
        }else{
            return oldDate;
        }
    }


    meerkat.modules.register("healthPaymentDay", {
        events: moduleEvents,
        paymentDaysOfTheMonth: paymentDaysOfTheMonth,
        paymentDays : paymentDays,
        paymentDaysRender : paymentDaysRender,
        FROM_EFFECTIVE_DATE : minType.FROM_EFFECTIVE_DATE,
        EFFECTIVE_DATE : countFrom.EFFECTIVE_DATE
    });

})(jQuery);