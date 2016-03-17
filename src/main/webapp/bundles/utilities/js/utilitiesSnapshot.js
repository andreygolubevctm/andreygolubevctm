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
        $elecHowChargedParent,
        $elecPeakUsage,
        $gasUsage,
        $snapshotBox,
        $elecBill,
        $elecUsage,
        $gasBill,
        $gasStandardUsage,
        $gasBillingDays,
        $energyComparisonLabel;

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
        $energyComparisonLabel = $('#utilities_householdDetails_whatToCompare'),
        $suburb = $('#utilities_householdDetails_location'),
        $elecBillingDays = $('#utilities_estimateDetails_spend_electricity_days'),
        $elecHowCharged = $("input[name='utilities_estimateDetails_electricity_meter']"),
        $elecHowChargedParent = $elecHowCharged.closest('.additional-estimate-details-row'),
        $elecPeakUsage = $("input[name='utilities_estimateDetails_usage_electricity_peak_amount']"),
        $elecBill = $("input[name='utilities_householdDetails_recentElectricityBill']"),
        $elecUsage = $("input[name='utilities_estimateDetails_electricity_usage']"),
        $gasUsage = $("input[name='utilities_estimateDetails_gas_usage']"),
        $gasBill = $("input[name='utilities_householdDetails_recentGasBill']"),
        $gasStandardUsage = $('#utilities_estimateDetails_usage_gas_peak_amount'),
        $gasBillingDays = $('#utilities_estimateDetails_spend_gas_days'),
        $yourDetailsSnapshotRadioElements = $energyComparison.add($elecHowCharged).add($gasUsage).add($elecUsage).add($gasUsage),
        $yourDetailsSnapshotTextfieldElements = $suburb.add($elecBillingDays).add($elecPeakUsage).add($gasBill).add($gasBillingDays).add($gasStandardUsage),
        $snapshotBox = $('.yourDetailsSnapshot');

        $yourDetailsSnapshotRadioElements.on('click', function initYourDetailsSnapshotRadioElementsEventListener() {
            _.defer(renderYourDetailsSnapshot);
        });

        $yourDetailsSnapshotTextfieldElements.on('blur', function initYourDetailsSnapshotTextfieldEventListener() {
            _.defer(renderYourDetailsSnapshot);
        });

        meerkat.messaging.subscribe(meerkatEvents.journeyEngine.READY, function renderSnapshotOnJourneyReadySubscription() {
            _.defer(renderYourDetailsSnapshot);
        });
    }

    function renderYourDetailsSnapshot() {
        var template = _.template($("#your-details-snapshot-template").html()),
        data = {},
        $selectedEnergyType = $energyComparison.filter(':checked');

        data.whatToCompare = typeof $selectedEnergyType.val() != 'undefined' ? jQuery.trim($energyComparisonLabel.find('label.active').text()) : '';
        data.showWhatToCompare = typeof $selectedEnergyType.val() != 'undefined';
        data.livingIn = $suburb.val();
        data.showLivingIn = $.trim($suburb.val()) !== '';
        data.electricityUsage = getElectricityUsage();
        data.showElectricityUsage = (($selectedEnergyType.val() === 'E' || $selectedEnergyType.val() === 'EG') && $.trim(data.electricityUsage) !== '');
        data.gasUsage = getGasUsage();
        data.showGasUsage = (($selectedEnergyType.val() === 'G' || $selectedEnergyType.val() === 'EG') && $.trim(data.gasUsage) !== '');

        var html = template(data);

        $('.yourDetailsSnapshotContainer').html(html);
    }

    function getElectricityUsage() {

        // various fields input
        if ($elecBill.filter(':checked').val() === 'Y') {
            var howChargeContent = $.trim($elecHowCharged.filter(':checked').parent().text()),
                $elecUsageEls = 0;
                $elecHowChargedParent.siblings('.usage:visible').each(function() {
                    var usage = parseInt($(this).find('input').val());
                    if(!_.isNaN(usage)) {
                        $elecUsageEls += usage;
                    }
                });

            if ($elecUsageEls !== 0 && $elecBillingDays.val() !== '' && howChargeContent !== '') {
                return $elecUsageEls + "kWh over " + $elecBillingDays.val() + " days, " + howChargeContent;
            }
        } else {
            // or the radio button group
            if (meerkat.modules.deviceMediaState.get() === 'lg') {
                return $elecUsage.filter(':checked').siblings('h3').text();
            } else {
                return $elecUsage.filter(':checked').val();
            }
        }
        return '';
    }

    function getGasUsage() {
        if ($gasBill.filter(':checked').val() === 'N') {
            var $selectedOptions = $gasUsage.filter(':checked');

            if (typeof $selectedOptions.val() == 'undefined') {
                return '';
            }

            if (meerkat.modules.deviceMediaState.get() === 'lg') {
                return $selectedOptions.filter(':checked').siblings('h3').text();
            } else {
                return $selectedOptions.filter(':checked').val();
            }
        } else {
            if ($gasBill.filter(':checked').val() === 'Y') {
                if ($gasStandardUsage.val() !== '' && $gasBillingDays.val() !== '') {
                    return $gasStandardUsage.val() + "" + $gasStandardUsage.siblings('.input-group-addon').text() + " over " + $gasBillingDays.val() + " " + $gasBillingDays.siblings('.input-group-addon').text();
                }
            }
        }
    }

    meerkat.modules.register('utilitiesSnapshot', {
        initUtilitiesSnapshot: initUtilitiesSnapshot,
        events: events,
        initYourDetailsSnapshot: initYourDetailsSnapshot,
        onEnterEnquire: onEnterEnquire,
        onEnterResults: onEnterResults
    });

})(jQuery);