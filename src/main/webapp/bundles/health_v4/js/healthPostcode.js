;(function ($, undefined) {

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        moduleEvents = {
            healthPostcode: {
                POSTCODE_CHANGED: 'POSTCODE_CHANGED'
            }
        },

        $elements = {},
        _hasSelection = false;

    function initPostcode() {
        _hasSelection = meerkat.modules.healthLocation.getLocation() ? true : false;
        _setupFields();
        _applyEventListeners();
        _eventSubscriptions();

        if ($elements.input.val()) {
            _getResults($elements.input.val());
        }
    }

    function _setupFields() {
        $elements = {
            input: $('input.health_contact_details_postcode'),
            resultsWrapper: $('.health_contact_details_postcode_results_wrapper'),
            results: $('.health_contact_details_postcode_results'),
            editBtn: $('.postcode-items-btn-edit')
        };
    }

    function _applyEventListeners() {
        $elements.input
            .on('keyup', function() {
                console.log('postcodeValue: ',$(this).val());
                _hasSelection = false;
                editMode();

                if ($(this).isValid()) {
                    // do search
                    _getResults($(this).val());
                } else {
                    // clear search
                    _clearResults();
                }
            });

        $elements.results
            .on('click', 'button', function() {
                var $postItem = $(this).parent();

                $('.postcode-item, .postcode-item button').removeClass('selected');
                $postItem.addClass('selected').find('button').addClass('selected');

                _setLocation($postItem.attr('data-location'));
            });

        $elements.editBtn.on('click', function() {
           editMode(true);
        });
    }

    function _eventSubscriptions() {
        meerkat.messaging.subscribe(meerkatEvents.healthLocation.STATE_CHANGED, function onStateChanged() {
            _hasSelection = false;
            if (meerkat.modules.journeyEngine.getCurrentStep().navigationId !== 'contact') {
                $elements.input.val('');
                _clearResults();
            }
        });
    }

    function _getResults(postcode) {
        console.log('searching...');

        meerkat.modules.loadingAnimation.showInside($elements.input.parent(), true);

        var data = { term: postcode },
            request_obj = {
                url: 'ajax/json/get_suburbs.jsp',
                data: data,
                dataType: 'json',
                cache: true,
                errorLevel: "silent",
                onSuccess: function(res) {
                    if (res.length > 0) {
                        // show suburbs
                        _showResults(res);
                    } else {
                        // clear
                        _clearResults();
                    }
                },
                onComplete: function() {
                    // preselect location
                    _preselectLocation();

                    meerkat.modules.loadingAnimation.hide($elements.input.parent());
                }
            };

        meerkat.modules.comms.get(request_obj);
    }

    function _clearResults() {
        console.log('clear...');
        $elements.results.find('.postcode-item').remove();
    }

    function _showResults(locations) {
        console.log('show locations');
        locations.forEach(function(location) {
            var locationText = location.replace(' ' + $elements.input.val(), ', ');

            $elements.results
                .append('' +
                    '<div class="postcode-item" data-location="'+location+'">' +
                        '<button type="button" class="btn btn-secondary">' + locationText + '</button>' +
                        '<span>' + locationText + '</span>' +
                    '</div>'
                );
        });
    }

    function _setLocation(location) {
        meerkat.modules.healthLocation.setLocation(location);
        _hasSelection = true;
    }

    function _preselectLocation() {
        _.defer(function() {
            var location = meerkat.modules.healthLocation.getLocation(),
                $postcodeItemLocation = $elements.results.find('.postcode-item[data-location="' + location + '"]');

            if (location && $postcodeItemLocation.length === 1 && _hasSelection) {
                $postcodeItemLocation.find('button').trigger('click');
                editMode();
            }
        });
    }

    function editMode(forceHide) {
        $elements.resultsWrapper.toggleClass('edit-mode', forceHide ? false : _hasSelection);
    }

    meerkat.modules.register('healthPostcode', {
        initPostcode: initPostcode,
        events: moduleEvents,
        editMode: editMode
    });

})(jQuery);