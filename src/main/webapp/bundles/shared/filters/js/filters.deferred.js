/**
 * Functions in this file should only be called by the verticalFilters file e.g. healthFilters.deferred.js
 * to ensure there are no race conditions.
 */
(function ($, undefined) {

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events;

    var moduleEvents = {
            filters: {}
        },
        settings = {
            templates: {
                filters: '#filter-results-template',
                updates: '#filters-update-template'
            },
            containers: {
                filters: '#results-sidebar .results-filters', // todo needs to change if changed to xs
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
                $(document).on('filters.update', filterObject.events.update.apply(window, [filterObject]));
            }
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

    /**
     * Allow us to render a different template with the same model
     * @param template
     */
    function render(template) {
        $(settings.containers[template]).html(getTemplateHtml(template));

        _.each(model, function (filterObject) {
            if (filterObject.hasOwnProperty('events') && _.isFunction(filterObject.events.init)) {
                filterObject.events.init.apply(window, [filterObject]);
            }
        });

        $(settings.containers.updates).html(getTemplateHtml('updates')).slideDown();
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
        meerkat.messaging.subscribe(meerkatEvents.journeyEngine.STEP_CHANGED, function journeyEngineSlideChange(eventObject) {
            if (eventObject.isForward && eventObject.navigationId == 'results') {
                resetFilters(model);
            }
        });
    }

    function applyEventListeners() {
        $('#navbar-main').on('click', '.slide-feature-filters a, .slide-feature-benefits a', function (e) {
            e.preventDefault();
            //?? do stuff? render it?
        });

        $document.on('click', '.filter-update-changes', function() {
            $.trigger('filters.update');
            // or publish filters update and make each subscribe?
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