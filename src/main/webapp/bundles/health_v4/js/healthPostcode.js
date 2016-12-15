;(function ($, undefined) {

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        moduleEvents = {
            healthPostcode: {
                POSTCODE_CHANGED: 'POSTCODE_CHANGED'
            }
        },

        $elements = {};

    function initPostcode() {
        _setupFields();
        _eventSubscriptions();

        if ($elements.postcode.val()) {
            _doSearch($elements.postcode.val());
        }
    }

    function _setupFields() {
        $elements = {
            postcode: $('#health_contactDetails_postcode')
        };
    }

    function _eventSubscriptions() {
        $elements.postcode.on('keyup', function() {
            if ($(this).isValid()) {
                // do search
                _doSearch($(this).val());
            } else {
                // clear search
                _clearSearch();
            }
        });
    }

    function _doSearch(postcode) {
        console.log('searching...');

        var data = { term: postcode },
            request_obj = {
            url: 'ajax/json/get_suburbs.jsp',
            data: data,
            dataType: 'json',
            cache: true,
            errorLevel: "silent"
        };

        meerkat.modules.comms
            .get(request_obj)
            .done(function onSuccess(res) {
                console.log('res', res);
                if (res.length > 0) {
                    // show suburbs
                    _showSuburbs(res);
                } else {
                    // clear
                    _clearSearch();
                }
            });
    }

    function _clearSearch() {
        console.log('clear...');
        $('.postcode-item').remove();
    }

    function _showSuburbs(results) {
        console.log('show results');
        results.forEach(function(item) {
           $elements.postcode.parent().append('<span class="postcode-item btn btn-save-quote-trigger" style="font-size: 12px;">'+item+'</span>');
        });
    }

    meerkat.modules.register('healthPostcode', {
        initPostcode: initPostcode,
        events: moduleEvents
    });

})(jQuery);