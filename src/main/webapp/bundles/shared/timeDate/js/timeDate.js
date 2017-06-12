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
            display = h + ':' + _checkTime(m) + ampm + ', ' + day + ' ' + date + ' ' + month;

        $elements.container.text(display);

        var t = setTimeout(_startTime, 1000);
    }

    function _checkTime(i) {
        if (i < 10) {
            i = "0" + i;
        }
        return i;
    }

    meerkat.modules.register('timeDate', {
        initTimeDate: initTimeDate
    });
})(jQuery);