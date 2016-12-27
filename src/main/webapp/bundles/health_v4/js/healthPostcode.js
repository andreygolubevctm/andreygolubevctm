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
            if (meerkat.modules.journeyEngine.getCurrentStep().navigationId !== 'contact') {
                $elements.input.val('');
                _clearResults();
            }
        });
    }

    function _getResults(postcode) {
        _postcode = postcode;
        meerkat.modules.loadingAnimation.showAfter($elements.input);

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

                    _scrollView(res.length > _minResultsForScrollView);

                    _resultsCount = res.length;
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

    function _showResults(suburbs) {
        suburbs.forEach(function(suburb) {
            var suburbText = suburb.replace(' ' + $elements.input.val(), ', ');

            $elements.results
                .append('' +
                    '<div class="suburb-item" data-location="' + suburb + '">' +
                        '<button type="button" class="btn btn-secondary">' + suburbText + '</button>' +
                        '<span>' + suburbText + '</span>' +
                    '</div>'
                );
        });
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