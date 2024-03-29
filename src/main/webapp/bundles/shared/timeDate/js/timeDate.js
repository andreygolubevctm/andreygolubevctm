;(function ($, undefined) {

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        log = meerkat.logging.info;

    var $elements = {};

    function initTimeDate($container) {
        $elements.container = $container;
        _startTime();
    }

    function _startTime() {
        var today = new Date(),
            todayParts = today.toString().split(' '),
            h = today.getHours(),
            m = today.getMinutes(),
            ampm = today.toLocaleTimeString().indexOf('AM') > 0 ? 'am' : 'pm',
            day = todayParts[0],
            date = todayParts[2],
            month = todayParts[1],
            display = _checkHour(h) + ':' + _checkTime(m) + ampm + ', ' + day + ' ' + date + ' ' + month;

        $elements.container.text(display);

        var t = setTimeout(_startTime, 1000);
    }

    function _checkHour(h) {
        return h > 12 ? h - 12 : h;
    }

    function _checkTime(i) {
        return i < 10 ? "0" + i : i;
    }

    meerkat.modules.register('timeDate', {
        initTimeDate: initTimeDate
    });
})(jQuery);