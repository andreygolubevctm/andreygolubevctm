/**
 * Functions in this file should only be called by the verticalFilters file e.g. healthFilters.deferred.js
 * to ensure there are no race conditions.
 */
(function ($, undefined) {

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events;

    var moduleEvents = {
            filters: {
                FILTERS_UPDATED: "FILTERS_UPDATED",
                FILTER_CHANGED: "FILTER_CHANGED",
                FILTERS_CANCELLED: "FILTERS_CANCELLED"
            }
        },
        settings = {
            filters: [
                {
                    template: '#filter-results-template',
                    container: '.results-filters',
                    context: '#results-sidebar'
                }
            ],

            updates: [
                {
                    template: '#filters-update-template',
                    container: '.filters-update-container'
                }
            ]
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
    function initFilters(options, filterModel, optionNode) {
        $(document).ready(function () {
            $document = $(this);
            model = filterModel;
            if(optionNode){
                $.merge(settings[optionNode], options[optionNode]);
            } else {
                settings = $.extend(true, settings, options);
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
        // setDefaultsToModel();
    }

    function getModel() {
        return model;
    }

    function updateModel(newModel) {
        model = newModel;
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
                    if (needToFetchFromServer) {
                        _.defer(function(){
                            meerkat.modules.journeyEngine.loadingShow('...updating your quotes...', true);
                            // Had to use a 100ms delay instead of a defer in order to get the loader to appear on low performance devices.
                            _.delay(function(){
                                meerkat.modules.healthResults.get();
                            },100);
                        });
                    }else{
                        Results.applyFiltersAndSorts();
                    }
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
        });

        // Render the update template too.
        buildHtml('updates');
    }

    function buildHtml(component) {
        _.each(settings[component], function(setting) {
            $(setting.container, setting.context).empty().html(getTemplateHtml(setting.template));
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

        _htmlTemplate[template] = _.template($(template).html(), {variable: "model"});
        return _htmlTemplate[template](model);
    }

    function eventSubscriptions() {

        // Every time we get to results, reset the filter model and re-render.
        meerkat.messaging.subscribe(meerkatEvents.journeyEngine.STEP_CHANGED, function journeyEngineSlideChange(eventObject) {
            if (eventObject.isForward && eventObject.navigationId == 'results') {
                resetFilters(model);
            }
        });

        meerkat.messaging.subscribe(moduleEvents.filters.FILTER_CHANGED, function (event) {
            $(settings.updates[0].container).slideDown();
        });
        meerkat.messaging.subscribe(moduleEvents.filters.FILTERS_UPDATED, function (event) {
            $(settings.updates[0].container).slideUp();
        });
        meerkat.messaging.subscribe(moduleEvents.filters.FILTERS_CANCELLED, function (event) {
            resetFilters();
            $(settings.updates[0].container).slideUp();
            resettingFilters = false;
        });
    }

    function applyEventListeners() {

        $('#navbar-main').on('click', '.slide-feature-filters a, .slide-feature-benefits a', function (e) {
            e.preventDefault();
            /**
             * If not rendered, render the template in the XS container (not yet defined in the settings..)
             * If rendered, shouldn't need to do anything? Or should it always re-render on open because
             * data could have changed.
             *
             */
        });

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
        }).on('click', '.filter-cancel-changes', function (e) {
            e.preventDefault();
            resettingFilters = true;
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