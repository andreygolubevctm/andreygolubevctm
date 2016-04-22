/**
 * Description: External documentation:
 */
(function ($, undefined) {

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events;

    var moduleEvents = {
            filters: {}
        },
        model = {};



    function initFilterModel(filterModel) {
        model = filterModel;
        setDefaultsToModel();
        render();
        eventSubscriptions();
    }

    /**
     *
     */
    function setDefaultsToModel() {
        _.each(model, function (filterObject) {

            // Run pre-init if exists
            if (filterObject.hasOwnProperty('events') && _.isFunction(filterObject.events.beforeInit)) {
                filterObject.events.beforeInit.apply(window, [filterObject]);
            }
            // Set default values onto the model.
            if (!filterObject.hasOwnProperty('defaultValueSourceSelector')) {
                return;
            }
            var $defaultValueElement = $(filterObject.defaultValueSourceSelector);
            if (!$defaultValueElement.length) {
                return;
            }
            var defaultValue = $defaultValueElement.val() || filterObject.defaultValue || "";
            if (filterObject.defaultValueType == 'array') {
                defaultValue = defaultValue.split(',');
            }
            _.each(filterObject.values, function (valueObject) {
                if (defaultValue == valueObject.value ||
                    (_.isArray(defaultValue) && _.contains(defaultValue, valueObject.value))) {
                    valueObject.selected = true;
                }
            });

        });
    }

    function render() {
        var htmlTemplate = _.template($("#filter-results-template").html(), {variable: "model"});
        $('.results-filters:first').html(htmlTemplate(model));
        _.each(model, function (filterObject) {
            if (filterObject.hasOwnProperty('events') && _.isFunction(filterObject.events.init)) {
                filterObject.events.init.apply(window, [filterObject]);
            }
        });
    }

    function update() {
        //resets the models defaultValueSoruces to the current value in the filter/form so update hidden fields etc.
    }

    function eventSubscriptions() {
        meerkat.messaging.subscribe(meerkatEvents.journeyEngine.STEP_CHANGED, function journeyEngineSlideChange(eventObject) {
            if (eventObject.isForward && eventObject.navigationId == 'results') {
                initFilterModel(model);
            }
        });
    }

    meerkat.modules.register("filters", {
        initFilterModel: initFilterModel,
        events: {}
    });

})(jQuery);