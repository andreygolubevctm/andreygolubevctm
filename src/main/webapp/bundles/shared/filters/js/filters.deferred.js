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
                FILTER_CHANGED: "FILTER_CHANGED"
            }
        },
        settings = {
            templates: {
                filters: '#filter-results-template',
                updates: '#filters-update-template'
            },
            containers: {
                filters: '#results-sidebar .results-filters', // todo needs to change if changed to xs so it can render off canvas..
                updates: '.filters-update-container'
            }
        },
        model = {},
        _htmlTemplate = {},
        $document;


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
            settings = $.extend(true, settings, options);

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
                //todo: if this is run more than once, make sure we don't double subscribe!!!
                meerkat.messaging.subscribe(moduleEvents.FILTERS_UPDATED, function() {
                    filterObject.events.update.apply(window, [filterObject]);
                });
            }
            // Run pre-init if exists
            if (filterObject.hasOwnProperty('events') && _.isFunction(filterObject.events.beforeInit)) {
                //todo: if this is run more than once, make sure we don't double up on this function!!!
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

    /**
     * Allow us to render a different template with the same model
     * @param template
     */
    function render(template) {
        $(settings.containers[template]).empty().html(getTemplateHtml(template));

        _.each(model, function (filterObject) {
            if (filterObject.hasOwnProperty('events') && _.isFunction(filterObject.events.init)) {
                filterObject.events.init.apply(window, [filterObject]);
            }
        });
        // Render the update template too.
        $(settings.containers.updates).empty().html(getTemplateHtml('updates'));
    }

    /**
     * Cache the htmlTemplate functions
     */
    function getTemplateHtml(template) {
        if (template && _htmlTemplate[template]) {
            return _htmlTemplate[template](model);
        }
        if (!$(settings.templates[template]).length) {
            exception("This template does not exist: " + template);
        }

        _htmlTemplate[template] = _.template($(settings.templates[template]).html(), {variable: "model"});
        return _htmlTemplate[template](model);
    }

    function update() {
        //resets the models defaultValueSoruces to the current value in the filter/form so update hidden fields etc.
    }

    function eventSubscriptions() {

        // Every time we get to results, reset the filter model and re-render.
        meerkat.messaging.subscribe(meerkatEvents.journeyEngine.STEP_CHANGED, function journeyEngineSlideChange(eventObject) {
            if (eventObject.isForward && eventObject.navigationId == 'results') {
                resetFilters(model);
            }
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

        $document.on('click', '.filter-update-changes', function() {
            meerkat.messaging.publish(moduleEvents.FILTERS_UPDATED, model);
            
        }
    );
}

    meerkat.modules.register("filters", {
        initFilters: initFilters,
        events: {},
        getModel: getModel,
        setModel: setModel,
        render: render
    });

})(jQuery);