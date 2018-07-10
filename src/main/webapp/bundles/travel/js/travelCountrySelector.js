/**
 * This has to be one of the hackiest, most annying things I've ever coded as a result of having to work with typeahead 0.9.3.
 * A lot of the code wouldn't be required with the latest version of typeahead.
 */

;(function ($, undefined) {

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        log = meerkat.logging.info;

    var events = {
            travelCountrySelector: {}
        },
        moduleEvents = events.travelCountrySelector;

    var $countrySelector,
        $unknownDestinations,
        selectedCountryObj = {},
        selectedTextHTML,
        showingError = false,
        initialised = false,
        inputPlaceholder = meerkat.modules.deviceMediaState.get() !== 'xs' ? 'Please select or start typing country name.' : 'Please start typing country name.';

    function findCountryNameByIsoCode(isoCode) {
        var countryList = window.countrySelectionList.isoLocations;
        for (var i = 0; i < countryList.length; i++) {
            if (countryList[i].isoCode === isoCode) {
                return countryList[i].countryName;

            }
        }
    }

    function initTravelCountrySelector() {
        if(!initialised) {
            initialised = true;
            $countrySelector = $('#travel_destinations');
            $unknownDestinations = $('#travel_unknownDestinations');
            applyEventListeners();
            setDefaultsFromDataBucket();
        }
    }

    function setDefaultsFromDataBucket() {
        if (meerkat.site.countrySelectionDefaults
            && meerkat.site.countrySelectionDefaults.length) {

            var locations = meerkat.site.countrySelectionDefaults.split(',');
            var $list = meerkat.modules.selectTags.getListElement($countrySelector);
            for (var i = 0; i < locations.length; i++) {
                if (locations[i].length) {
                    // will not work to re-set cities for example.
                    var locationName = findCountryNameByIsoCode(locations[i]);
                    var selectedLocation = locationName.length > 25 ? locationName.substr(0, 20) + '...' : locationName;
                    meerkat.modules.selectTags.appendToTagList($list, selectedLocation, locationName, locations[i]);
                    $countrySelector.val('');
                }
            }
        }
    }

    function applyEventListeners() {
        $countrySelector.on('keydown', function (e) {
            if (e.which == 13) { // if it's the enter key
                $(".tt-suggestion:first-child").trigger('click'); // select the first item in the dropdown
                $countrySelector.focus(); // reset the focus back on the input field
            } else {
                $countrySelector.data('ttView').datasets[0].valueKey = 'countryName';
            }
        }).on('typeahead:opened', function () {
            selectedCountryObj = {};
            $countrySelector.val("");
        }).on('typeahead:selected', function typeAheadSelected(obj, datum, name) {
            selectedCountryObj = datum;

            var $list = meerkat.modules.selectTags.getListElement($(this));
            if (typeof datum.countryName !== 'undefined' && !meerkat.modules.selectTags.isAlreadySelected($list, datum.isoCode)) {
                selectedTextHTML = datum.countryName;
                var selectedLocation = selectedTextHTML.length > 25 ? selectedTextHTML.substr(0, 20) + '...' : selectedTextHTML;
                meerkat.modules.selectTags.appendToTagList($list, selectedLocation, datum.countryName, datum.isoCode);
                _.defer(function () {
                    if (!$countrySelector.is(':focus')) {
                        $countrySelector.focus();
                    }
                });
            }
            showingError = false;
        }).on('click focus', function (event) {
            $countrySelector.data('ttView').datasets[0].valueKey = 'id';
            // bit of a hack to prevent the number 1 from being shown. It seems to be a bug from within typeahead itself. The chained version works here.
            // Still need the .val("") call after setQuery as the 1 still appears if removed
            $countrySelector.val("").typeahead("setQuery", "1").val("");
            $('.tt-hint').hide();
        }).on('blur', function (event) {
            // bit of a hack to prevent the number 1 from being shown. It seems to be a bug from within typeahead itself. Did try to chain it in between
            // the $countrySelector and .typeahead call below but that didn't work. Still need the .val("") call after setQuery as the 1 still appears if removed
            $countrySelector.val("");
            if (!selectedCountryObj)
                $countrySelector.typeahead('setQuery', '').val('');

        }).attr('placeholder', inputPlaceholder);
    }

    function addValueToCountriesForDefaultFocusEvent() {
        var countries = countrySelectionList.countries;
        if (typeof countries === 'object' && countries.length) {
            for (var i = 0; i < countries.length; i++) {
                countries[i].id = '1';
            }
        } else {
            countries = [];
        }
        return countries;
    }

    /**
     *
     * @param $component
     * @returns {{name: *, valueKey: string, displayKey: string, template: Function, local: Array, remote: {beforeSend: Function, filter: Function, url: string}, limit: number}}
     */
    function getCountrySelectorParams($component) {
        // currently if you focus on an empty input field in IE 11, selecting a country fails but
        // if we type in at least 1 character and select from the dropdown, it works in IE 11.
        // This code below prevents the dropdown from appearing for IE 11 if there is no value in the input field
        var localCountries = meerkat.modules.performanceProfiling.isIE11() ? [] : addValueToCountriesForDefaultFocusEvent();

        var url = $component.attr('data-source-url'),
            urlAppend = (url.indexOf('?') == -1 ? '?' : '&') + 'transactionId='+ meerkat.modules.transactionId.get(),
            $list = meerkat.modules.selectTags.getListElement($component);
        return {
            cache: true,
            name: $component.attr('name'),
            valueKey: "id", // the duplicate name
            template: function (data) {
                var isSelected = meerkat.modules.selectTags.isAlreadySelected($list, data.isoCode);
                if (isSelected && data.isoCode != "0000") {
                    return "<del class='selected'>" + data.countryName + "</del>";
                }
                // Log if isoCode is 0000, meaning no results were returned.
                if(data.isoCode == "0000") {
                    $unknownDestinations.val($unknownDestinations.val() + ($unknownDestinations.val().length ? ',' : '') + $countrySelector.data('ttView').inputView.query);
                }
                return "<p>" + data.countryName + "</p>";
            },
            local: localCountries, // for default focus event.
            remote: {
                maxParallelRequests: 1,
                rateLimitWait: 500,
                beforeSend: function (xhr, opts) {
                    if ($countrySelector.data('ttView').inputView.getQuery() == 1) {
                        xhr.abort();
                        return false;
                    }

                    // replace the old transactionid with a new one
                    opts.url =  opts.url.replace( /\btransactionId\b[=]\d+/g, 'transactionId=' + meerkat.modules.transactionId.get());

                    meerkat.modules.autocomplete.autocompleteBeforeSend($component);
                },
                filter: function (parsedResponse) {
                    meerkat.modules.autocomplete.autocompleteComplete($component);

                    var collection = parsedResponse.isoLocations;
                    if(!collection.length) {
                        return [{
                           id: 1,
                            isoCode: "0000",
                            countryName: "Sorry, we could not find that location..."
                        }];
                    }
                    return $.map(collection, function (country) {
                        return {
                            id: 1,
                            isoCode: country.isoCode,
                            countryName: country.countryName
                        };
                    });
                },
                // it is duplication but this allows the typeahead library to do a proper search rather than defaulting to the value 1. it's something that's inherint this typeahead version.
                url: url + '%QUERY' + urlAppend,
                error: function (xhr, status) {
                    if (!showingError) {
                        // Throw a pop up error
                        meerkat.modules.errorHandling.error({
                            page: "travelCountrySelector.js",
                            errorLevel: "silent",
                            title: "An error occurred...",
                            message: "Sorry, an error occurred while finding the country you are looking for. Please try again or reload the page.",
                            description: "Could not complete lookup: " + status,
                            data: xhr
                        });
                        meerkat.modules.session.poke();
                        showingError = true;
                    }
                    meerkat.modules.autocomplete.autocompleteComplete($component);
                }
            },
            limit: 300
        };
    }

    meerkat.modules.register('travelCountrySelector', {
        initTravelCountrySelector: initTravelCountrySelector,
        events: events,
        getCountrySelectorParams: getCountrySelectorParams
    });

})(jQuery);