/**
 * Description: This is done similar to cars carVehicleSelection js file.
 */

;(function ($, undefined) {

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        log = meerkat.logging.info;

    var events = {
            roadsideVehicleMake: {}
        },
        moduleEvents = events.roadsideVehicleMake;

    var makeData,
        $makeElement;

    function initRoadsideVehicleMake() {

        $(document).ready(function () {

            if(meerkat.site.vertical !== "roadside") {
                return;
            }

            // set up some variables.
            makeData = meerkat.site.vehicleSelectionDefaults.data;
            $makeElement = $("#roadside_vehicle_make");

            // apply listeners first so selecting the menu on load in will set makeDes field.
            applyEventListeners();

            renderSelectionMenu("makes");
        });

    }

    function applyEventListeners() {
        var $makeDes = $('#' + $makeElement.attr('id') + 'Des');
        $makeElement.on('change', function () {
            if ($(this).val() !== "") {
                $makeDes.val($(this).find('option:selected').text());
            }
        });
    }

    function renderSelectionMenu(type) {
        if (typeof makeData === 'undefined'
            || typeof makeData.makes === 'undefined') {
            return;
        }
        var obj = meerkat.site.vehicleSelectionDefaults,
            selected,
            options = [];

        if (obj.hasOwnProperty(type) && obj[type] !== '') {
            selected = obj[type];
        }
        options.push(
            $('<option/>', {
                text: "Please choose...",
                value: ''
            })
        );

        options.push(
            $('<optgroup/>', {label: "Top Makes"})
        );
        options.push(
            $('<optgroup/>', {label: "All Makes"})
        );

        for (var key in makeData.makes) {

            if (!makeData.makes.hasOwnProperty(key)) {
                continue;
            }


            var item = makeData.makes[key],
                option;
            option = $('<option/>', {
                text: item.label,
                value: item.code
            });

            if (selected == item.code) {
                option.prop('selected', true);
            }

            if (item.isTopMake === true) {
                option.appendTo(options[1], options[2]);
            } else {
                options[2].append(option);
            }

        }
        // Append all the options to the selector
        for (var o = 0; o < options.length; o++) {
            $makeElement.append(options[o]);
        }
        if(selected !== "") {
            $makeElement.trigger('change');
        }


    }

    meerkat.modules.register("roadsideVehicleMake", {
        init: initRoadsideVehicleMake,
        events: events
    });

})(jQuery);