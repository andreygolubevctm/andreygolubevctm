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
        if (_dob) {
            var _years = _now.getFullYear() - _dob.getFullYear();

            if (_years < 1) {
                return (_now - _dob) / (1000 * 60 * 60 * 24 * 365);
            }

            //leap year offset
            var _leapYears = _years - ( _now.getFullYear() % 4);
            _leapYears = (_leapYears - ( _leapYears % 4 )) / 4;
            var _offset1 = ((_leapYears * 366) + ((_years - _leapYears) * 365)) / _years;

            //birthday offset - as it's always so close
            var _offset2 = +0.005;
            if ((_dob.getMonth() == _now.getMonth()) && (_dob.getDate() > _now.getDate())) {
                _offset2 = -0.005;
            }

            var _age = (_now - _dob) / (1000 * 60 * 60 * 24 * _offset1) + _offset2;
            return round ? Math.floor(_age) : _age;
        }
    }

    /**
     * isLessThan31Or31AndBeforeJuly1() test whether the dob provided makes the user less than
     * 31 or is currently 31 but the current datea is before 1st July following their birthday.
     *
     * @param _dobString	String representation of a birthday (eg 24/02/1986)
     * @returns {Boolean}
     */
    function isLessThan31Or31AndBeforeJuly1(_dobString) {
        if(_dobString === '') return false;
        var age = Math.floor(meerkat.modules.age.returnAge(_dobString));
        if( age < 31 ) {
            return true;
        } else if( age == 31 ){
            var dob = meerkat.modules.dateUtils.returnDate(_dobString);
            var birthday = meerkat.modules.dateUtils.returnDate(_dobString);
            birthday.setFullYear(dob.getFullYear() + 31);
            var now = new Date();
            if ( dob.getMonth() + 1 < 7 && (now.getMonth() + 1 >= 7 || now.getFullYear() > birthday.getFullYear()) ) {
                return false;
            } else if (dob.getMonth() + 1 >= 7 && now.getMonth() + 1 >= 7 && now.getFullYear() > birthday.getFullYear()) {
                return false;
            } else {
                return true;
            }
        } else if(age > 31){
            return false;
        } else {
            return false;
        }
    }

    /**
     * isTooOldForLHC() test whether the dob provided makes the user too old for LHC
     * if you were born on or before 1st of july 1934 you are exempt from LHC.
     *
     * @param _dobString	String representation of a birthday (eg 24/02/1986)
     * @returns {Boolean}
     */
    function isTooOldForLHC(_dobString) {
        if(_dobString === '') return false;

        var _now = new Date();
        _now.setHours(0,0,0);
        var _dob = meerkat.modules.dateUtils.returnDate(_dobString);

        if (_dob) {

            if (_dob.getFullYear() > 1934) {
                return false;
            } else if (_dob.getFullYear() < 1934) {
                return true;
            } else {
                //born in 1934

                //javascript dates returns 0 for jan and 11 for dec
                if (_dob.getMonth() > 6) {
                    return false;
                } else if (_dob.getMonth() < 6) {
                    return true;
                } else {
                    //javascript dates returns 0 for the first day of the month
                    if (_dob.getDay() === 0) {
                        return true;
                    } else {
                        return false;
                    }
                }
            }
        }
        return false;
    }

    function isAgeLhcApplicable(_dobString) {
        return ((!isTooOldForLHC(_dobString)) && (!isLessThan31Or31AndBeforeJuly1(_dobString)));
    }

    meerkat.modules.register("age", {
        init: initAge,
        events: events,
        get: getAge,
        returnAge : returnAge,
        isLessThan31Or31AndBeforeJuly1: isLessThan31Or31AndBeforeJuly1,
        isTooOldForLHC: isTooOldForLHC,
        isAgeLhcApplicable: isAgeLhcApplicable
    });
})(jQuery);