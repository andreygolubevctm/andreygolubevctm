;
(function($, undefined) {
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

        var age = today.getFullYear() - year

        if(today.getMonth() < month || (today.getMonth() == month && today.getDate() < day)){
            age--;
        }

        return age;
    }

    function getAgeAtNextBirthday(day, month, year) {
        return getAge(day, month, year) + 1;
    }

    meerkat.modules.register("age", {
        init: initAge,
        events: events,
        get: getAge,
        getNextBirthday: getAgeAtNextBirthday
    });
})(jQuery);