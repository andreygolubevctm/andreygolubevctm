;(function ($, undefined) {

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        moduleEvents = {
            healthPostcode: {
                POSTCODE_CHANGED: 'POSTCODE_CHANGED'
            }
        },
        $elements = {},
        _postcode = '';

    function initPostcode() {
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
            location: $('#health_situation_location'),
            state: $('#health_situation_state'),
            suburb: $('#health_situation_suburb'),
            resultsWrapper: $('.health_contact_details_postcode_results_wrapper'),
            results: $('.health_contact_details_postcode_results')
        };
    }

    function _applyEventListeners() {
        $elements.input
            .on('keyup', function(event) {
                var value = $(this).val();

                if($elements.results.find('.suburb-item').length > 1) {
                    _postcode = '';
                }

                // if value valid and its not previously searched
                if ($(this).isValid() && value !== _postcode) {
                    // clear the results
                    _clearResults();

                    // do search
                    _getResults(value);
                } else {
                    if (value !== _postcode) {
                        $elements.location.val('');
                        $elements.location.attr('value', '');
                        $elements.state.val('');
                        $elements.results.find('.suburb-item, .suburb-item button').removeClass('selected');
                    }
                }
            });

        $elements.results
            .on('click', 'button', function() {
                var $suburbItem = $(this).parent();
                $elements.results.find('.suburb-item, .suburb-item button').removeClass('selected');
                $suburbItem.addClass('selected').find('button').addClass('selected');
                var location = _createLocationArray(_getLocationState($suburbItem.attr('data-location')));
                _setLocation(location);
            });
    }

    function _eventSubscriptions() {
        meerkat.messaging.subscribe(meerkatEvents.healthLocation.STATE_CHANGED, function onStateChanged() {
            _postcode = '';
            if (meerkat.modules.journeyEngine.getCurrentStep().navigationId !== 'contact') {
                $elements.input.val('');
                _clearResults();
            }
        });
    }

    function _getResults(postcode) {
        _postcode = postcode;
        meerkat.modules.loadingAnimation.showAfter($elements.input);
        $elements.results.hide();

        var data = { term: postcode },
            request_obj = {
                url: 'ajax/json/get_suburbs.jsp',
                data: data,
                dataType: 'json',
                cache: false,
                errorLevel: "silent",
                onSuccess: function(res) {
                    var resultCount = !_.isEmpty(res) && _.isArray(res) ? res.length : 0;
                    if (resultCount > 0) {
                        if(resultCount === 1) {
                            // set individual location
                            _setLocation(_createLocationArray(_getLocationState(res.pop())));
                        } else {
                            // show suburbs
                            _showResults(res);
                        }
                    } else {
                        _clearResults();
                    }
                },
                onComplete: function() {
                    meerkat.modules.loadingAnimation.hide($elements.input);
                }
            };

        meerkat.modules.comms.get(request_obj);
    }

    function _getLocationState(location) {
        var postCodeInput = $elements.input.val();
        return location.substr(location.indexOf(postCodeInput), location.length -1).replace(postCodeInput, '').trim();
    }

    function _clearResults() {
        $elements.results.find('.suburb-item').remove();
    }

    function _checkMultiStatePostcode(locations) {
        var multiStatePostCode;
        for (var i = 0; i < locations.length; i++ ) {
            if (i > 0 && _getLocationState(locations[i]) !== _getLocationState(locations[i - 1])) {
                return multiStatePostCode = true;
            }
        }
        return multiStatePostCode;
    }

    function _createLocationItem(cssSelector, location, buttonText) {
        $elements.results
            .append('' +
                '<div class="'+cssSelector+'" data-location="'+_createLocationString(location)+'">' +
                '<button type="button" class="btn btn-secondary">' + buttonText + '</button>' +
                '<span>' + buttonText + '</span>' +
                '</div>'
            );
    }

    function _showResults(locations) {
        var cssSelector = 'suburb-item';
        var multiStatePostCode = _checkMultiStatePostcode(locations);
        var states = [];

        for (var i = 0; i < locations.length; i++ ) {

            var state = _getLocationState(locations[i]);
            if (multiStatePostCode){
                // Create list of states without duplicates
                if ($.inArray(state, states) === -1) {
                    states.push(state);
                }
            } else {
                if (i === 0){
                    var location = _createLocationArray(state);
                    _setLocation(location);
                    _createLocationItem(cssSelector += ' selected', location, $elements.input.val());
                }
            }
        }

        if (multiStatePostCode) {
            for (i = 0; i < states.length; i++ ) {
                _createLocationItem(cssSelector, _createLocationArray(states[i]), states[i]);
            }
            $elements.results.show();
        }
    }

    function _createLocationString(location) {
        return location.toString().replace(/,/g , " ");
    }

    function _createLocationArray(state) {
        return ['NULL', $elements.input.val(), state];
    }

    function _setLocation(location) {
        $elements.state.val(location[2]);
        $elements.suburb.val(location[0]);
        var locationString = _createLocationString(location);
        meerkat.modules.healthLocation.setLocation(locationString);
        $elements.location.val(locationString);
        $elements.location.attr('value', locationString);
        $elements.location.valid();
    }

    meerkat.modules.register('healthPostcode', {
        initPostcode: initPostcode,
        events: moduleEvents
    });
})(jQuery);