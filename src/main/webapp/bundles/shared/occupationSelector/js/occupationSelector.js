/**
 * This has to be one of the hackiest, most annying things I've ever coded as a result of having to work with typeahead 0.9.3.
 * A lot of the code wouldn't be required with the latest version of typeahead.
 */
;(function ($, undefined) {

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        log = meerkat.logging.info;

    var events = {
            travelOccupationSelector: {}
        },
        moduleEvents = events.travelOccupationSelector;

    var initialised = false;
    var $occupationSelector;
    var $unknownDestinations;
    var selectedOccupationObj = {};
    var selectedTextHTML;
    var showingError = false;

    //
    //function findOccupationNameByIsoCode(isoCode) {
    //    var occupationList = window.occupationSelectionList.isoLocations;
    //    for (var i = 0; i < occupationList.length; i++) {
    //        if (occupationList[i].isoCode == isoCode) {
    //            return occupationList[i].occupationName;
    //
    //        }
    //    }
    //}

    function initOccupationSelector() {
        if(!initialised) {
            initialised = true;
            $occupationSelector = $('input[type="text"][id$="_occupations"]');
            $unknownDestinations = $('input[type="hidden"][id$="_unknownOccupations"]');
            applyEventListeners();
            setDefaultsFromDataBucket();
        }
    }

    function setDefaultsFromDataBucket() {
        $occupationSelector.each(function() {
            var $hidden = $('#' + $(this).attr('id').slice(0, -1));

            if(!!$hidden.val()) {
                // Get the tag list
                var $list = $hidden.parents('.row').next('.row').find('.selected-tags');

                if(!!occupationSelectionList) {
                    var selectedOccupation = occupationSelectionList.filter(function (val) {
                        return val.code === $hidden.val();
                    });

                    if(_.isArray(selectedOccupation) && selectedOccupation.length) {
                        var occ = selectedOccupation[0];
                        var descriptionHTML = meerkat.modules.selectTags.getHTML(occ.description);
                        meerkat.modules.selectTags.appendToTagList($list, descriptionHTML, occ.description, occ.code);
                    }
                }
            }
        });
    }

    function applyEventListeners() {
        $occupationSelector
            .on('keydown', function (e) {
                var $this = $(this);

                if (e.which == 13) { // if it's the enter key
                    $(".tt-suggestion:first-child").trigger('click'); // select the first item in the dropdown
                    $this.focus(); // reset the focus back on the input field
                } else {
                    $this.data('ttView').datasets[0].valueKey = 'occupationName';
                }
            }).on('typeahead:opened', function () {
                selectedOccupationObj = {};
                $(this).val("");
            })
            .on('typeahead:selected', function typeAheadSelected(obj, datum, name) {
                var $this = $(this);

                selectedOccupationObj = datum;

                var $list = meerkat.modules.selectTags.getListElement($this);

                if (typeof datum.description !== 'undefined' && !meerkat.modules.selectTags.isAlreadySelected($list, $this.attr('id') + datum.code)) {
                    selectedTextHTML = datum.description;
                    var selectedOccupation = selectedTextHTML.length > 25 ? selectedTextHTML.substr(0, 20) + '...' : selectedTextHTML;
                    meerkat.modules.selectTags.appendToTagList($list, selectedOccupation, datum.description, datum.code);
                }

                showingError = false;
            })
            .on('click focus', function (event) {
                var $this = $(this);

                $this.data('ttView').datasets[0].valueKey = 'id';
                // bit of a hack to prevent the number 1 from being shown. It seems to be a bug from within typeahead itself. The chained version works here.
                // Still need the .val("") call after setQuery as the 1 still appears if removed
                $this.val("").typeahead("setQuery", "1").val("");
                $('.tt-hint').hide();
            })
            .on('blur', function (event) {
                var $this = $(this);

                // bit of a hack to prevent the number 1 from being shown. It seems to be a bug from within typeahead itself. Did try to chain it in between
                // the $occupationSelector and .typeahead call below but that didn't work. Still need the .val("") call after setQuery as the 1 still appears if removed
                $this.val("");
                if (!selectedOccupationObj)
                    $this.typeahead('setQuery', '').val('');

            }).attr('placeholder', 'Please type in your occupation');
    }

    function addValueToOccupationsForDefaultFocusEvent() {
        var occupations = occupationSelectionList;
        if (typeof occupations  === 'object' && occupations .length) {
            for (var i = 0; i < occupations .length; i++) {
                occupations[i].id = '1';
            }
        } else {
            occupations = [];
        }

        return occupations;
    }


    /**
     *
     * @param $component
     * @returns {{name: *, valueKey: string, displayKey: string, template: Function, local: Array, remote: {beforeSend: Function, filter: Function, url: string}, limit: number}}
     */
    function getOccupationSelectorParams($component) {
        var localOccupations = meerkat.modules.performanceProfiling.isIE11() ? [] : addValueToOccupationsForDefaultFocusEvent();

        var $list = meerkat.modules.selectTags.getListElement($component);
        var componentName = $component.attr('name');

        return {
            cache: true,
            name: componentName,
            valueKey: "description", // the duplicate name
            template: function (data) {
                var isAlreadySelected = meerkat.modules.selectTags.isAlreadySelected($list, $component.attr('id') + data.code);
                if (isAlreadySelected) {
                    return "<del class='selected'>" + data.description + "</del>";
                }

                return "<p>" + data.description + "</p>";
            },
            local: localOccupations, // for default focus event.
            limit: 1000
        };
    }

    meerkat.modules.register('occupationSelector', {
        initOccupationSelector: initOccupationSelector,
        events: events,
        getOccupationSelectorParams: getOccupationSelectorParams
    });

})(jQuery);