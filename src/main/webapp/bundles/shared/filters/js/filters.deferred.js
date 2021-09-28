/**
 * Functions in this file should only be called by the verticalFilters file e.g. healthFilters.deferred.js
 * to ensure there are no race conditions.
 */
(function ($, undefined) {

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        exception = meerkat.logging.exception;

    var moduleEvents = {
            filters: {
                FILTERS_UPDATED: "FILTERS_UPDATED",
                FILTER_CHANGED: "FILTER_CHANGED",
                FILTERS_CANCELLED: "FILTERS_CANCELLED",
                FILTERS_RENDERED: "FILTERS_RENDERED"
            }
        },
        settings = {
            filters: [
                {
                    template: '#filter-results-template',
                    container: '.results-filters'
                }
            ],

            updates: [
                {
                    template: '#filters-update-template',
                    container: '.filters-update-container'
                }
            ],

            events: {}
        },
        model = {},
        _htmlTemplate = {},
        $document,
        subscriptionHandles = {},
        resettingFilters = false,
        needToFetchFromServer = false;


    /**
     * Assign the vertical's model to the core filters internal model
     * Apply event subscriptions that are only need to be applied once e.g. re-render template
     * when entering results.
     * @param options
     * @param filterModel
     */
    function initFilters(options, filterModel) {
        $(document).ready(function () {
            $document = $(this);
            model = filterModel;

            for (var optionName in options) {
                if (_.isArray(settings[optionName])) {
                    $.merge(settings[optionName], options[optionName]);
                } else if(_.isString(settings[optionName]) && !_.isEmpty(settings[optionName])) {
                    settings[optionName] = options[optionName];
                } else {
                    $.extend(true, settings[optionName], options[optionName]);
                }
            }

            eventSubscriptions();
            applyEventListeners();
            resetFilters();
        });
    }

    /**
     * Resets the defaults to the model and renders the template.
     */
    function resetFilters() {
        setDefaultsToModel();
        render('filters');
    }

    /**
     * Sometimes we need to update the model after the page has loaded.
     * @param newModel
     */
    function setModel(newModel) {
        model = newModel;
    }

    function getModel() {
        return model;
    }

    /**
     * Find the default value from the source element or defaultValue e.g. hidden inputs or other form fields.
     * Run the init functions if necessary.
     */
    function setDefaultsToModel() {
        _.each(model, function (filterObject) {

            // Bind update events:
            if (filterObject.hasOwnProperty('events') && _.isFunction(filterObject.events.update)) {
                if (subscriptionHandles[filterObject.name]) {
                    meerkat.messaging.unsubscribe(moduleEvents.filters.FILTERS_UPDATED, subscriptionHandles[filterObject.name]);
                }
                subscriptionHandles[filterObject.name] = meerkat.messaging.subscribe(moduleEvents.filters.FILTERS_UPDATED, function () {
                    filterObject.events.update.apply(window, [filterObject]);
                });
            }
            // Run pre-init if exists
            //todo: add hasRun flag so beforeInit only needs to run once?
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
            var defaultValue = $defaultValueElement.val() ||
                (_.isFunction(filterObject.defaultValue.getDefaultValue) ? filterObject.defaultValue.getDefaultValue.apply(window, [filterObject]) : "") ||
                filterObject.defaultValue || "";
            if (filterObject.defaultValueType == 'csv') {
                defaultValue = defaultValue.split(',');
            }
            _.each(filterObject.values, function (valueObject) {
                if (defaultValue == valueObject.value ||
                    (_.isArray(defaultValue) && _.contains(defaultValue, valueObject.value))) {
                    valueObject.selected = true;
                } else {
                    delete valueObject.selected;
                }
            });

        });
    }

    /**
     * Allow us to render a different template with the same model
     * @param component
     */
    function render(component) {
        buildHtml(component);

        _.each(model, function (filterObject) {
            if (filterObject.hasOwnProperty('events') && _.isFunction(filterObject.events.init)) {
                filterObject.events.init.apply(window, [filterObject]);
            }
            if (filterObject.hasOwnProperty('events') && _.isFunction(filterObject.events.initAfterDefaultValue)) {
                filterObject.events.initAfterDefaultValue.apply(window);
            }
        });
        // Render the update template too.
        buildHtml('updates');

        meerkat.messaging.publish(moduleEvents.filters.FILTERS_RENDERED);
    }

    function buildHtml(component) {
        _.each(settings[component], function (setting) {
            $(setting.container).empty(); // empty all so if we switch breakpoint it still works
            $(setting.container).html(getTemplateHtml(setting.template));
        });
    }

    /**
     * Cache the htmlTemplate functions
     */
    function getTemplateHtml(template) {
        if (template && _htmlTemplate[template]) {
            return _htmlTemplate[template](model);
        }
        if (!$(template).length) {
            exception("This template does not exist: " + template);
        }

        _htmlTemplate[template] = _.template($(template).html(), { variable: "model" });
        return _htmlTemplate[template](model);
    }

    function eventSubscriptions() {

        // Every time we get to results, reset the filter model and re-render.
        meerkat.messaging.subscribe(meerkatEvents.journeyEngine.STEP_CHANGED, function journeyEngineSlideChange(eventObject) {
            if (eventObject.isForward && eventObject.navigationId == 'results') {
                resetFilters();
            }
        });

        meerkat.messaging.subscribe(moduleEvents.filters.FILTER_CHANGED, function (event) {
            if ($(event.target).parents('.filter').data('filterServerside') === true) {
                needToFetchFromServer = true;
            }

            if (!$(event.target).parents('.filter').data('dontToggleUpdate')) {
                $(settings.updates[0].container).slideDown();
            }
        });

        meerkat.messaging.subscribe(moduleEvents.filters.FILTERS_UPDATED, function (event) {
            $(settings.updates[0].container).slideUp();

            if (meerkat.modules.deviceMediaState.get() === 'xs') {
                meerkat.modules.navMenu.close();
            }

            var filteredClinicalBenefits = meerkat.modules.healthBenefitsStep.getFilteredClinicalBenefits();
            meerkat.modules.healthResults.setSelectedClinicalBenefitsList(filteredClinicalBenefits);

            _.defer(function () {
                if (needToFetchFromServer) {
                    settings.events.update.apply(window, [event]);
                } else {
                    meerkat.modules.resultsTracking.setResultsEventMode('Refresh');
                    Results.applyFiltersAndSorts(true);
                }
                needToFetchFromServer = false;
            });
        });

        meerkat.messaging.subscribe(moduleEvents.filters.FILTERS_CANCELLED, function (event) {
            resettingFilters = true;
            resetFilters();
            $(settings.updates[0].container).slideUp();
            resettingFilters = false;
        });
    }

    function applyEventListeners() {

        _.each(model, function (filterObject) {

            $document.on('change', ':input[name=' + filterObject.name + ']', function (e) {
                if (!resettingFilters) {
                    meerkat.messaging.publish(moduleEvents.filters.FILTER_CHANGED, e);
                }
            });
        });

        $document.on('click', '.filter-update-changes', function (e) {
            e.preventDefault();
            meerkat.messaging.publish(moduleEvents.filters.FILTERS_UPDATED, e);
            meerkat.modules.utils.scrollPageTo($("header"));
        }).on('click', '.filter-cancel-changes', function (e) {
            e.preventDefault();
            meerkat.messaging.publish(moduleEvents.filters.FILTERS_CANCELLED, e);
        });
    }

    meerkat.modules.register("filters", {
        initFilters: initFilters,
        events: moduleEvents,
        getModel: getModel,
        setModel: setModel,
        render: render
    });

})(jQuery);