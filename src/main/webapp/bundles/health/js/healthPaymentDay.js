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

    // Confirms the date provided is a weekend day
    function isWeekendDay(now) {
        return _.indexOf([0,6], now.getDay()) !== -1;
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
        if(meerkat.modules.healthFunds.getPayments().countFrom == countFrom.TODAY ) {
            _baseDate = today;
        } else {
            _baseDate = effectiveDate;
        }
        var _count = 0;

        var _days = 0;
        var _limit = meerkat.modules.healthFunds.getPayments().max;
        if(meerkat.modules.healthFunds.getPayments().minType == minType.FROM_TODAY ) {
            var difference = Math.round((effectiveDate-today)/(1000*60*60*24));
            if(difference < meerkat.modules.healthFunds.getPayments().min) {
                _days = meerkat.modules.healthFunds.getPayments().min - difference;
            }
        } else {
            _days = meerkat.modules.healthFunds.getPayments().min;
        }

        // Extend initial offset period if business days only and the initial offset period includes weekend days
        var businessDaysOnly = typeof(meerkat.modules.healthFunds.getPayments().businessDaysOnly) !== 'undefined' && meerkat.modules.healthFunds.getPayments().businessDaysOnly;
        if(businessDaysOnly) {
            var limit = _days;
            for(var i=0; i<limit; i++) {
                var now = new Date( _baseDate.getTime() + (i * 24 * 60 * 60 * 1000));
                if( isWeekendDay(now) ) {
                    _days++;
                }
            }
        }

        // Remove the default offset if flagged to do so and start date is after the default offset.
        // Flag is noMinAfterOffsetPassed
        var noMinAfterOffsetPassed = typeof(meerkat.modules.healthFunds.getPayments().noMinAfterOffsetPassed) !== 'undefined' && meerkat.modules.healthFunds.getPayments().noMinAfterOffsetPassed;
        if(noMinAfterOffsetPassed) {
            var offsetDate = new Date(new Date(meerkat.modules.utils.getUTCToday()).setHours(0,0,0,0) + (_days * 24 * 60 * 60 * 1000));
            if(effectiveDate.getTime() > offsetDate.getTime()) {
                _days = 0;
            }
        }

        var _html = '<option value="">Please choose...</option>';

        // The loop to create the payment days
        while (_count < _limit) {
            var _date = new Date( _baseDate.getTime() + (_days * 24 * 60 * 60 * 1000));
            var _isWeekend = isWeekendDay(_date);
            // Skips days after fix day limit
            if (typeof (meerkat.modules.healthFunds.getPayments().maxDay) !== 'undefined' && meerkat.modules.healthFunds.getPayments().maxDay < _date.getDate()) {
                _days++;
                _count++;
            // Parse out the weekends if not applicable
            } else if ( _isWeekend && ( businessDaysOnly || !meerkat.modules.healthFunds.getPayments().weekends ) ) {
                _days++;
                if (!businessDaysOnly) {
                    _count++;
                }
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
            meerkat.modules.healthFunds.setPayments({ 'min':0, 'max':5, 'weekends':false });
            _html = '<option value="">Please choose...</option>';
        }
        $_object.html(_html);
        $_object.parent().siblings('p').text( 'Your payment will be deducted on: ' + $_object.find('option').first().text() );
        $('.health_payment_bank_details-policyDay, .health_payment_credit-policyDay').html(_html);
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