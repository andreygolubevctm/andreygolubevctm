;(function($, undefined) {
    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        log = meerkat.logging.info;
    var events = {};

    var today;

    function initAge() {
        today = new Date();
    }

    function getAge(day, month, year) {
        day = Number(day);
        month = Number(month) - 1;
        year = Number(year);

        var age = today.getFullYear() - year;

        if(today.getMonth() < month || (today.getMonth() == month && today.getDate() < day)){
            age--;
        }

        return age;
    }

    /**
     * Accepts date in the format DD/MM/YYYY
     * @param _dobString
     * @param round
     * @returns {number}
     */
    function returnAge(_dobString, round) {
        var _now = new Date();
        _now.setHours(0,0,0);
        var _dob = meerkat.modules.dateUtils.returnDate(_dobString);
        var _years = _now.getFullYear() - _dob.getFullYear();

        if(_years < 1){
            return (_now - _dob) / (1000 * 60 * 60 * 24 * 365);
        }

        //leap year offset
        var _leapYears = _years - ( _now.getFullYear() % 4);
        _leapYears = (_leapYears - ( _leapYears % 4 )) /4;
        var _offset1 = ((_leapYears * 366) + ((_years - _leapYears) * 365)) / _years;

        //birthday offset - as it's always so close
        var _offset2 = +0.005;
        if(  (_dob.getMonth() == _now.getMonth()) && (_dob.getDate() > _now.getDate()) ){
            _offset2 = -0.005;
        }

        var _age = (_now - _dob) / (1000 * 60 * 60 * 24 * _offset1) + _offset2;
        return round ? Math.floor(_age) : _age;
    }


    meerkat.modules.register("age", {
        init: initAge,
        events: events,
        get: getAge,
        returnAge : returnAge
    });
})(jQuery);