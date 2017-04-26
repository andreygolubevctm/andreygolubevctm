;(function ($, undefined) {

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        moduleEvents = {
            healthPostcode: {
                POSTCODE_CHANGED: 'POSTCODE_CHANGED'
            }
        },

        $elements = {},
        _postcode = '',
        _hasSelection = false,
        _minResultsForScrollView = 10,
        _resultsCount = 0;

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
            location: $('#health_situation_location'),
            resultsWrapper: $('.health_contact_details_postcode_results_wrapper'),
            results: $('.health_contact_details_postcode_results'),
            editBtn: $('.suburb-items-btn-edit')
        };
    }

    function _applyEventListeners() {
        $elements.input
            .on('keyup', function(event) {
                var value = $(this).val();

                editMode(true);
                _hasSelection = false;

                // if value valid and its not previously searched
                if ($(this).isValid() && value !== _postcode) {
                    // clear the results
                    _clearResults();

                    // do search
                    _getResults(value);
                } else {
                    if (value !== _postcode) {
                        $elements.location.val('');
                        $elements.results.find('.suburb-item, .suburb-item button').removeClass('selected');
                    }
                }
            });

        $elements.results
            .on('click', 'button', function() {
                var $suburbItem = $(this).parent();

                $elements.results.find('.suburb-item, .suburb-item button').removeClass('selected');
                $suburbItem.addClass('selected').find('button').addClass('selected');

                _setSuburb($suburbItem.attr('data-location'));
            });

        $elements.editBtn.on('click', function() {
           editMode(true);
        });
    }

    function _eventSubscriptions() {
        meerkat.messaging.subscribe(meerkatEvents.healthLocation.STATE_CHANGED, function onStateChanged() {
            _hasSelection = false;
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
        $elements.resultsWrapper.height(0);

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
                            _setSuburb(res.pop());
                        } else {
                            // show suburbs
                            _showResults(res);
                        }
                    } else {
                        // clear
                        _clearResults();
                    }

                    _scrollView(resultCount > _minResultsForScrollView);

                    _resultsCount = resultCount;
                },
                onComplete: function() {
                    // preselect suburb
                    _preselectSuburb();

                    meerkat.modules.loadingAnimation.hide($elements.input);
                }
            };

        meerkat.modules.comms.get(request_obj);
    }

    function _scrollView(isScrollView) {
        $elements.resultsWrapper.toggleClass('scroll-view', isScrollView);
    }

    function _clearResults() {
        $elements.results.find('.suburb-item').remove();
    }

    function _getSuburbState(suburb){
        var state = suburb.substr(suburb.indexOf($elements.input.val()), suburb.length - 1);
        state = state.replace($elements.input.val(), '').trim();
        return state;
    }

    function _checkMultiStatePostcode(suburbs) {
        var initialState;
        var multiStatePostCode = false;

        for (var i = 0; i < suburbs.length; i++ ) {
            var state = _getSuburbState(suburbs[i]);

            if (i === 0) initialState = state;

            if (initialState !== state) {
                multiStatePostCode = true;
                break;
            }
        }
        return multiStatePostCode;
    }

    function createSuburbItem(cssSelector, suburb, suburbText) {
        $elements.results
            .append('' +
                '<div class="'+cssSelector+'" data-location="'+suburb+'">' +
                '<button type="button" class="btn btn-secondary">' + suburbText + '</button>' +
                '<span>' + suburbText + '</span>' +
                '</div>'
            );
    }

    function _showResults(suburbs) {
        var multiStatePostCode = _checkMultiStatePostcode(suburbs);
        var states = [];

        for (var i = 0; i < suburbs.length; i++ ) {
            var suburbText = suburbs[i].replace(' ' + $elements.input.val(), ', ');
            var cssSelector = 'suburb-item';
            var state = _getSuburbState(suburbs[i]);

            if (multiStatePostCode){
                if ($.inArray(state, states) === -1) states.push(state);
            } else {
                var suburb = 'NULL ' + $elements.input.val() + ' '+ state;
                if(i === 0){
                    cssSelector += ' selected';
                    _setSuburb(suburb);
                }
                createSuburbItem(cssSelector, suburb, suburbText); // maybe delete
            }
        }

        if (multiStatePostCode) {
            for (i = 0; i < states.length; i++ ) 
                createSuburbItem('suburb-item', 'NULL ' + $elements.input.val() + ' '+ states[i], states[i]);
            $elements.results.show();
        }
    }

    function _setSuburb(suburb) {
        meerkat.modules.healthLocation.setLocation(suburb);
        _hasSelection = true;
        $elements.location.valid();
    }

    function _preselectSuburb() {
        _.defer(function() {
            var suburb = meerkat.modules.healthLocation.getLocation(),
                $suburbItem = $elements.results.find('.suburb-item[data-location="' + suburb + '"]');

            if (suburb && $suburbItem.length === 1 && _hasSelection) {
                $suburbItem.find('button').trigger('click');
                editMode();
            }
        });
    }

    function editMode(forceHide) {
        var isEditMode = forceHide ? false : _hasSelection;
        $elements.resultsWrapper.toggleClass('edit-mode', isEditMode);

        _scrollView(!isEditMode && _resultsCount > _minResultsForScrollView);
    }

    meerkat.modules.register('healthPostcode', {
        initPostcode: initPostcode,
        events: moduleEvents,
        editMode: editMode
    });

})(jQuery);