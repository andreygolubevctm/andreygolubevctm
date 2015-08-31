/**
 * Description:
 * External documentation: https://developers.google.com/chart/interactive/docs/
 */

;(function ($, undefined) {

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        log = meerkat.logging.info;

    var events = {
            fuelCharts: {}
        },
        moduleEvents = events.fuelCharts,
        modalTemplate,
        modalId,
        chart,
        chartData,
        chartOptions;

    function initChartsApi() {
        google.load('visualization', '1', {packages: ['corechart', 'line'], callback: drawChart});
    }

    function getChart() {
        return chart;
    }

    function initFuelCharts() {

        $(document).ready(function () {
            applyEventListeners();
            modalTemplate = _.template($('#price-chart-template').html());
        });

    }

    function applyEventListeners() {
        $('.openPriceHistory').click(function () {
            initChartsApi();
        });

        meerkat.messaging.subscribe(meerkatEvents.device.RESIZE_DEBOUNCED, function () {
            if(typeof google !== 'undefined' && chartData && chartOptions && $('.fuelChart').length) {
                chart = new google.visualization.LineChart(document.getElementById('linechart_material'));
                chart.draw(chartData, chartOptions);
            }
        });
    }

    function squashDifferentFuelTypesToSingleDateArray(results) {
        return results.filter(function (element, index, array) {
            for (var i = 0; i < array.length; i++) {
                if(typeof array[i].amountObj == 'undefined') {
                    array[i].amountObj = {};
                    array[i].amountObj[array[i].type] = array[i].amount;
                }
                if (i == index) {
                    return true;
                }
                if (array[i].period == element.period) {
                    array[i].amountObj[element.type] = element.amount;
                    return false;
                }
            }
            return true;
        });
    }

    function getChartTitle() {
        var title = "Average daily prices <span class='hidden-xs'>for selected fuel types in and</span> around ";
        var location = $('#fuel_location').val();
        if (isNaN(location.substring(1, 5))) {
            title += location;
        } else {
            title += "the postcode: " + location;
        }

        return title;
    }

    var getFuelLabel = function (fuelid) {
        var labels = ['Unknown', 'Unknown', 'Unleaded', 'Diesel', 'LPG', 'Premium Unleaded 95', 'E10', 'Premium Unleaded 98', 'Bio-Diesel 20', 'Premium Diesel'];
        return labels[fuelid];
    }

    function drawChart() {

        createModal(function (modalId) {

            meerkat.modules.loadingAnimation.showInside($('#linechart_material'), true);
            var selectedFuelTypes = $('#fuel_hidden').val().split(',');

            // This part is here as when you select Diesel, it adds Premium Diesl to results.
            // If there are no Diesel, but premium diesel options, it won't show any graph for them.
            if(selectedFuelTypes.indexOf('3') != -1 && selectedFuelTypes.indexOf('9') == -1) {
                selectedFuelTypes.push('9');
            }
            meerkat.modules.comms.post({
                    url: "ajax/json/fuel_price_monthly_averages.jsp",
                    cache: true,
                    data: meerkat.modules.form.getSerializedData($('#mainform')),
                    errorLevel: "warning",
                    onSuccess: function onPriceHistorySuccess(result) {
                        chartData = new google.visualization.DataTable();
                        chartData.addColumn('date', 'Date');
                        chartData.addColumn('number', getFuelLabel(selectedFuelTypes[0]));
                        if (selectedFuelTypes[1]) {
                            chartData.addColumn('number', getFuelLabel(selectedFuelTypes[1]));
                        }
                        if (selectedFuelTypes[2]) {
                            chartData.addColumn('number', getFuelLabel(selectedFuelTypes[2]));
                        }
                        var prices = squashDifferentFuelTypesToSingleDateArray(result.results.prices);
                        for (var dataSet = [], i = 0; i < prices.length; i++) {
                            var row = [new Date(prices[i].period), Number(prices[i].amountObj[selectedFuelTypes[0]]) / 10];
                            if (selectedFuelTypes[1]) {
                                row.push(Number(prices[i].amountObj[selectedFuelTypes[1]]) / 10);
                            }
                            if (selectedFuelTypes[2]) {
                                row.push(Number(prices[i].amountObj[selectedFuelTypes[2]]) / 10);
                            }
                            dataSet.push(row);
                        }
                        chartData.addRows(dataSet);
                        chartOptions = {
                            height: 400,
                            legend: {
                                position: "bottom"
                            },
                            axisTitlesPosition: 'out',
                            hAxis: {
                                title: 'Collected Date',
                                format: 'EEE, MMM d'
                            },
                            tooltip: {
                                trigger: 'focus'
                            },
                            fontName: 'Source Sans Pro',
                            explorer: {
                                axis: 'horizontal',
                                actions: ['dragToZoom', 'rightClickToReset'],
                                keepInBounds: true
                            },
                            vAxis: {
                                title: 'Price Per Litre',
                                format: '###.#',
                                gridlines: {
                                    color: '#b2b2b2',
                                    count: -1
                                }
                            },
                            chartArea: {
                                top: 0
                            },
                            colors: ['#1c3e93', '#0db14b', '#b2b2b2']
                        };
                        chart = new google.visualization.LineChart(document.getElementById('linechart_material'));

                        chart.draw(chartData, chartOptions);
                        runTrackingCall(selectedFuelTypes);
                    }
                }
            )
            ;
        });
    }

    function runTrackingCall(selectedFuelTypes) {

        var location = $("#fuel_location").val().split(' ');
        for(var out= "", i = 0; i < selectedFuelTypes.length; i++) {
            out += ":" + getFuelLabel(selectedFuelTypes[i]);
        }
        meerkat.messaging.publish(meerkatEvents.tracking.EXTERNAL, {
            method: 'trackCustomPage',
            object: {
                customPage: "Fuel:PriceHistory" + out,
                state: location[location.length-1],
                postcode: location[location.length-2]
            }
        });
    }

    /**
     * The modal in this case is never destroyed. It is always kept and just shown using bootstraps own functions.
     * This is to avoid extra API calls to Google Maps.
     * This should only be run once per page load.
     */
    function createModal(onOpen) {
        var options = {
            htmlContent: modalTemplate({}),
            hashId: 'chart',
            className: 'fuelChart',
            onOpen: onOpen,
            title: getChartTitle()
        };
        modalId = meerkat.modules.dialogs.show(options);
    }

    function _handleError(e, page) {
        meerkat.modules.errorHandling.error({
            errorLevel: "warning",
            message: "An error occurred with loading the Fuel Price History. Please reload the page and try again.",
            page: page,
            description: "[Google Charts] Error Initialising API",
            data: {
                error: e.toString()
            },
            id: meerkat.modules.transactionId.get()
        });
    }

    meerkat.modules.register("fuelCharts", {
        initFuelCharts: initFuelCharts,
        events: events,
        getChart: getChart
    });

})
(jQuery);