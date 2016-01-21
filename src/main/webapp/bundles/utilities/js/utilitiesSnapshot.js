;(function($, undefined){

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        log = meerkat.logging.info;

    var events = {
            utilitiesSnapshot: {
            }
        };

    var $snapshotSituation,
        $productSnapshot,
        $energyComparison,
        $suburb,
        $elecBillingDays,
        $elecHowCharged,
        $elecPeakUsage,
        $gasUsage,
        $snapshotBox;

    function initUtilitiesSnapshot() {
        $snapshotSituation = $('.snapshotSituation');
        $productSnapshot = $(".product-snapshot");
    }

    function onEnterEnquire() {
        renderEnquireSnapshot();
        fillEnquireTemplate();
    }
    function onEnterResults() {
        renderResultsSnapshot();
    }

    function renderResultsSnapshot() {
        var template = _.template($("#results-summary-template").html()),
            data = {};

        data.postcode = "Postcode " + $("#utilities_householdDetails_location").val().match(/\d+/)[0];

        var whatToCompare = $(".what-to-compare :checked").val(),
            movingIn = $(".moving-in").find("input[type='radio']:checked").val(),
            recentElectricityBill = $(".recent-electricity-bill").find("input[type='radio']:checked").val(),
            recentGasBill = $(".recent-gas-bill").find("input[type='radio']:checked").val();

        if(whatToCompare === "E" || whatToCompare === "EG") {
            if(recentElectricityBill === 'Y') {
                var elecPeakVal = $("#utilities_estimateDetails_usage_electricity_peak_amount").val(),
                    elecOffpeakVal = $("#utilities_estimateDetails_usage_electricity_offpeak_amount").val(),
                    elecShoulderVal = $("#utilities_estimateDetails_usage_electricity_shoulder_amount").val();

                data.electricityPeak = elecPeakVal + "kWh";
                data.electricityOffPeak = (elecOffpeakVal !== "" ? elecOffpeakVal : 0) + "kWh";
                data.electricityShoulder = (elecShoulderVal !== "" ? elecShoulderVal + "kWh" : "");
            } else {
                data.electricitySpend = $('#utilities_estimateDetails_electricity_usage').find("input[type='radio']:checked").val();
            }
        }

        if(whatToCompare === "G" || whatToCompare === "EG") {
            if(recentGasBill === 'Y') {
                var gasPeakVal = $("#utilities_estimateDetails_usage_gas_peak_amount").val(),
                    gasOffpeakVal = $("#utilities_estimateDetails_usage_gas_offpeak_amount").val();

                data.gasPeak = gasPeakVal + "MJ";
                data.gasOffPeak = (gasOffpeakVal !== "" ? gasOffpeakVal : 0) + "MJ";
            } else {
                data.gasSpend = $('#utilities_estimateDetails_gas_usage').find("input[type='radio']:checked").val();
            }
        }

        data.recentElectricityBill = recentElectricityBill;
        data.recentGasBill = recentGasBill;

        var html = template(data);
        $("#results-summary-container").html(html);
        return html;
    }


    function renderEnquireSnapshot() {

        $snapshotSituation.html(renderResultsSnapshot());
        meerkat.modules.contentPopulation.render('.journeyEngineSlide:eq(2) .snapshot');
    }

    function fillEnquireTemplate() {
        var currentProduct = Results.getSelectedProduct();
        if(currentProduct !== false) {
            var productTemplate = $("#enquire-snapshot-template").html();
            var htmlTemplate = _.template(productTemplate);
            var htmlString = htmlTemplate(currentProduct);
            $productSnapshot.html(htmlString);
        } else {
            $productSnapshot.empty();
        }

    }

    function initYourDetailsSnapshot() {
        $energyComparison = $("input[name='utilities_householdDetails_whatToCompare']"),
        $suburb = $('#utilities_householdDetails_location'),
        $elecBillingDays = $('#utilities_estimateDetails_spend_electricity_days'),
        $elecHowCharged = $("input[name='utilities_estimateDetails_electricity_meter']"),
        $elecPeakUsage = $('#utilities_estimateDetails_usage_electricity_peak_amount'),
        $gasUsage = $("input[name='utilities_estimateDetails_gas_usage']"),
        $yourDetailsSnapshotRadioElements = $energyComparison.add($elecHowCharged).add($gasUsage),
        $yourDetailsSnapshotTextfieldElements = $suburb.add($elecBillingDays).add($('#utilities_estimateDetails_usage_electricity_peak_amount')),
        $snapshotBox = $('.yourDetailsSnapshot');

        $yourDetailsSnapshotRadioElements.on('click', function initYourDetailsSnapshotRadioElementsEventListener() {
            _.defer(renderSnapshot);
        });

        $yourDetailsSnapshotTextfieldElements.on('blur', function initYourDetailsSnapshotTextfieldEventListener() {
            _.defer(renderSnapshot);
        });

        meerkat.messaging.subscribe(meerkatEvents.journeyEngine.READY, function renderSnapshotOnJourneyReadySubscription() {
            _.defer(renderSnapshot);
        });
    }

    function renderSnapshot() {

        if ($energyComparison.is(':checked')) {
            $snapshotBox.removeClass('hidden');
        } else {
            $snapshotBox.addClass('hidden');
        }
        meerkat.modules.contentPopulation.render($snapshotBox);
    }

    function getComparisonType() {
        return $energyComparison.filter(':checked').next().find('.iconLabel').text();
    }

    function getElectricityUsage() {
        var howChargeContent = $elecHowCharged.filter(':checked').parent().text().trim();

        if ($elecPeakUsage.val() !== '' && $elecBillingDays.val() !== '' && howChargeContent !== '') {
            $snapshotBox.find('.electricityUsageContainer').removeClass('hidden').show();
            return $elecPeakUsage.val()+"" + $elecPeakUsage.siblings('.input-group-addon').text() + " over " + $elecBillingDays.val() + " " + $elecBillingDays.siblings('.input-group-addon').text() + ", " + howChargeContent;
        }

        if (!$snapshotBox.find('.electricityUsageContainer').hasClass('hidden')) {
            $snapshotBox.find('.electricityUsageContainer').addClass('hidden');
        }
        return '';
    }

    function getGasUsage() {
        var $selectedOptions = $gasUsage.filter(':checked').siblings('span:first');

        if ($selectedOptions.next().text() !== '' && $selectedOptions.text() !== '') {
            $snapshotBox.find('.gasUsageContainer').removeClass('hidden').show();
            return $selectedOptions.next().text() + ' for ' + $selectedOptions.text();
        }

        return '';
    }

    meerkat.modules.register('utilitiesSnapshot', {
        initUtilitiesSnapshot: initUtilitiesSnapshot,
        events: events,
        getComparisonType: getComparisonType,
        getElectricityUsage: getElectricityUsage,
        getGasUsage: getGasUsage,
        initYourDetailsSnapshot: initYourDetailsSnapshot,
        onEnterEnquire: onEnterEnquire,
        onEnterResults: onEnterResults
    });

})(jQuery);