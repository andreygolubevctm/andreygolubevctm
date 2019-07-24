(function ($, window, document, undefined) {

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        exception = meerkat.logging.exception,
        log = meerkat.logging.info;

    var events = {
            elasticAddress: {}
        },
        moduleEvents = events.elasticAddress;

    var baseURL = '';

    /**
     * List of elements that are referenced by this plugin
     * @type {{autofilllessSearchInput: string, autofilllessSearchFieldRow: string, nonStdCheckbox: string, lastSearchHidden: string, fullAddressLineOneHidden: string, fullAddressHidden: string, allNonStdFieldRows: string, lookupStreetNameHidden: string, lookupStreetIdHidden: string, lookupUnitTypeHidden: string, lookupPostCodeHidden: string, lookupUnitSelHidden: string, lookupHouseNoSelHidden: string, lookupSuburbNameHidden: string, lookupStateHidden: string, lookupDpIdHidden: string, nonStdPostCodeInput: string, nonStdSuburbInput: string, nonStdStreetNameInput: string, nonStdStreetNumInput: string, nonStdUnitShopInput: string, nonStdUnitTypeInput: string}}
     */
    var selectorSuffix = {
        autofilllessSearchInput: "_autofilllessSearch",
        autofilllessSearchFieldRow: "_autofilllessSearchRow",
        nonStdCheckbox: "_nonStd",
        lastSearchHidden: "_lastSearch",
        fullAddressLineOneHidden: "_fullAddressLineOne",
        fullAddressHidden: "_fullAddress",
        allNonStdFieldRows: "_nonStdFieldRow",
        lookupStreetNameHidden: "_streetName",
        lookupStreetIdHidden: "_streetId",
        lookupUnitTypeHidden: '_unitType',
        lookupPostCodeHidden: "_postCode",
        lookupUnitSelHidden: "_unitSel",
        lookupHouseNoSelHidden: "_houseNoSel",
        lookupSuburbNameHidden: "_suburbName",
        lookupStateHidden: "_state",
        lookupDpIdHidden: "_dpId",
        nonStdPostCodeInput: "_nonStdPostCode",
        nonStdSuburbInput: "_suburb",
        nonStdStreetNameInput: "_nonStdStreet",
        nonStdStreetNumInput: "_streetNum",
        nonStdUnitShopInput: "_unitShop",
        nonStdUnitTypeInput: '_nonStdUnitType'
    };

    function initElasticAddress() {

        $(document).ready(function ($) {
            setupElasticAddressPlugin();
        });

    }

    function setupElasticAddressPlugin(baseURL) {
        $('.elasticSearchTypeaheadComponent').each(function () {
            var $el = $(this);
            var options = {
                name: $el.attr('data-address-id'),
                addressType: $el.attr('data-search-type'),
                streetNum: $el.attr('data-address-streetNum'),
                unitShop: $el.attr('data-address-unitShop'),
                baseURL: baseURL || ''
            };
            if($el.attr('data-suburbSeqNo') !== "" && typeof $el.attr('data-suburbSeqNo') != "undefined") {
                options.suburbSeqNo = $el.attr('data-suburbSeqNo');
            }
            $el.elasticAddress(options);
        });
    }

    meerkat.modules.register("elasticAddress", {
        init: initElasticAddress,
        setupElasticAddressPlugin: setupElasticAddressPlugin,
        events: events,
    });

    /**
     * Store the plugin name in a variable. It helps you if later decide to
     * change the plugin's name
     * @type {String}
     */
    var pluginName = 'elasticAddress';

    /**
     * The plugin constructor
     * @param {DOM Element} element The DOM element where plugin is applied
     * @param {Object} options Options passed to the constructor
     */
    function Plugin(element, options) {

        // Store a reference to the source element
        this.el = element;

        // Store a jQuery reference  to the source element
        this.$el = $(element);

        // Set the instance options extending the plugin defaults and
        // the options passed by the user
        this.options = $.extend({}, $.fn[pluginName].defaults, options);
        this.address = {hasUnits: false};

        // Initialize the plugin instance
        this.init();
    }

    /**
     * Set up your Plugin protptype with desired methods.
     * It is a good practice to implement 'init' and 'destroy' methods.
     */
    Plugin.prototype = {

        /**
         * Initialize the plugin instance.
         * Set any other attribtes, store any other element reference, register
         * listeners, etc
         *
         * When bind listeners remember to name tag it with your plugin's name.
         * Elements can have more than one listener attached to the same event
         * so you need to tag it to unbind the appropriate listener on destroy:
         *
         * @example
         * this.$someSubElement.on('click.' + pluginName, function() {
         *      // Do something
         * });
         *
         */
        init: function () {
            this.initAddressFields();
            this.applyEventListeners();
            this.eventSubscriptions();

        },

        initAddressFields: function () {
            var keys = _.keys(selectorSuffix),
                elements = {};
            for (var i = 0; i < keys.length; i++) {
                elements[keys[i]] = $('#' + this.options.name + selectorSuffix[keys[i]]);
            }
            // This one is a class.
            elements.allNonStdFieldRows = $('.' + this.options.name + "_nonStdFieldRow");
            this.elements = elements;

            elements.nonStdPostCodeInput.data('previous', elements.nonStdPostCodeInput.val());

            this.updateSuburb(elements.nonStdPostCodeInput.val());

            if (this.isNonStdAddress()) {
                elements.autofilllessSearchFieldRow.hide();
                elements.allNonStdFieldRows.show();
            }

            elements.nonStdStreetNumInput.val(this.options.streetNum);
            elements.nonStdUnitShopInput.val(this.options.unitShop);

        },

        toggleValidationStyles: function (element, state) {
            if (state === true) {
                element.removeClass('has-error').addClass('has-success');
                element.closest('.form-group').find('.row-content').removeClass('has-error').addClass('has-success')
                    .end().find('.error-field').remove();
            } else if (state === false) {
                element.removeClass('has-success').addClass('has-error');
                element.closest('.form-group').find('.row-content').removeClass('has-success').addClass('has-error');
            } else {
                element.removeClass('has-success has-error');
                element.closest('.form-group').find('.row-content').removeClass('has-success has-error')
                    .end().find('.error-field').remove();
            }
        },
        eventSubscriptions: function () {
            var self = this;
            meerkat.messaging.subscribe(meerkatEvents.autocomplete.CANT_FIND_ADDRESS, function handleCantFindAddress(eventObject) {
                var elements = self.elements;
                // As this is subscribed for x number of instances on the page, it can be triggered from one instance and thus trigger the other instance to go to non std as well.
                // This check stops that from happening.
                if (elements.nonStdCheckbox.attr('id').indexOf(eventObject.fieldgroup) != -1) {
                    elements.nonStdCheckbox.prop('checked', true).trigger('change.' + pluginName);
                    elements.nonStdPostCodeInput.trigger('focus.' + pluginName);
                }
            });
        },
        applyEventListeners: function () {

            var self = this,
                elements = self.elements;

            /**
             * Apply events to the autofill elastic search inputs
             */
            elements.autofilllessSearchInput.on('typeahead:selected', function streetFldAutocompleteSelected(obj, datum) {
                if (typeof datum.text !== 'undefined') {
                    var fullAddressLineOneValue = datum.text.substring(0, datum.text.indexOf(','));
                    elements.fullAddressLineOneHidden.val(fullAddressLineOneValue);
                    elements.fullAddressHidden.val(datum.text);
                    elements.autofilllessSearchInput.typeahead('setQuery', datum.text);
                }
            }).on('focus.' + pluginName, function () {
                self.options.userStartedTyping = true;
            }).on('getSearchURL', function (event) {
                self.getSearchURLStreetFld(event, self);
            }).on('keyup.' + pluginName + ' blur.' + pluginName + ' focus.' + pluginName, function (event) {
                self.clearValidationOnEmpty(event, self);
            });

            /**
             * Street Number input
             */
            elements.nonStdStreetNumInput.on("change." + pluginName + " blur." + pluginName, function () {
                elements.lookupHouseNoSelHidden.val("");
                self.nonStdAddressUpdate();
            });

            ///////////////////////////////////////////////////////////////////////////
            elements.nonStdUnitShopInput.on('change.' + pluginName + ' blur.' + pluginName, function (event) {
                self.nonStdAddressUpdate(event, self);
            });
            elements.nonStdUnitTypeInput.on('change.' + pluginName + ' blur.' + pluginName, function (event) {
                self.nonStdAddressUpdate(event, self);
            });
            $(document).on('validStreetSearchAddressEnteredEvent', function (event, name, jsonResult) {
                self.populateFullAddressStreetSearch(event, name, jsonResult, self);
            });
            $(document).on('customAddressEnteredEvent', function (event, name) {
                self.populateFullAddress(event, name, self);
            });
            elements.nonStdCheckbox.on('change.' + pluginName, function (event) {
                self.swapInputsCleanValidation(event, self);
            });
            elements.nonStdPostCodeInput.on('change.' + pluginName + ' keyup.' + pluginName, function (event) {
                self.postCodeLookup(event, self);
            });
            elements.nonStdSuburbInput.on('change.' + pluginName, function (event) {
                self.setSuburbName(event, self);
            });
        },
        clearValidationOnEmpty: function (event, context) {
            var elements = context.elements;
            // Remove the validation if the input is empty.
            // Always remove the error validation, this prevents autofill from happening when a partial entry has been made.
            if (elements.autofilllessSearchInput.val() === '' || elements.autofilllessSearchInput.closest('.row-content').hasClass('has-error')) {
                context.toggleValidationStyles(elements.autofilllessSearchInput);
            }

            if (elements.autofilllessSearchInput.val() != elements.fullAddressHidden.val()) {
                context.resetSelectAddress();
                context.toggleValidationStyles(elements.autofilllessSearchInput);
            }
        },
        getSearchURLStreetFld: function (event, context) {

            var elements = context.elements;
            var streetSearch = _getFormattedStreet($(event.target).val(), true);
            var lastSearch = _getFormattedStreet(elements.lastSearchHidden.val(), true);
            if (lastSearch != streetSearch || context.options.userStartedTyping) {
                context.options.userStartedTyping = false;

                // STREET
                var url = this.options.baseURL + "address/search.json?query=" + elements.autofilllessSearchInput.val();

                elements.lastSearchHidden.val(elements.autofilllessSearchInput.val());

                elements.autofilllessSearchInput.data('source-url', url);
            }
        },

        setHouseNo: function () {
            this.elements.nonStdStreetNumInput.val(this.address.houseNo);
            this.elements.lookupHouseNoSelHidden.val(this.address.houseNo);
        },
        setUnitType: function () {
            var address = this.address, elements = this.elements;
            if (address.unitType !== "") {
                address.unitTypeText = elements.nonStdUnitTypeInput.find('option[value="' + address.unitType + '"]').text();
                elements.nonStdUnitTypeInput.val(address.unitType);
                this.toggleValidationStyles(elements.nonStdUnitTypeInput, true);
            } else {
                address.unitTypeText = "";
                elements.nonStdUnitTypeInput.val("");
            }
        },
        setSuburbName: function () {
            this.address.suburbSeq = this.elements.nonStdSuburbInput.val();
            var emptySuburbSeq = this.address.suburbSeq === "";
            this.address.suburb = emptySuburbSeq ? "" : this.elements.nonStdSuburbInput.find("option:selected").text();
            this.elements.lookupSuburbNameHidden.val(emptySuburbSeq ? "" : this.address.suburb);
        },
        isNonStdAddress: function () {
            return this.elements.nonStdCheckbox.prop("checked");
        },
        nonStdAddressUpdate: function (event, context) {
            context = context || this;
            if (!context.isNonStdAddress()) {
                return;
            }
            var elements = context.elements;
            context.populateStreetAndHouseNum();
            context.address = $.extend(context.address, {
                    unitNo: elements.nonStdUnitShopInput.val(),
                    unitType: elements.nonStdUnitTypeInput.val(),
                    unitTypeText: elements.nonStdUnitTypeInput.find('option[value="' + elements.nonStdUnitTypeInput.val() + '"]').text()
                }
            );
            elements.fullAddressHidden.val(context.getFullAddress(context.address));
            elements.fullAddressLineOneHidden.val(context.address.fullAddressLineOne);
        },

        populateStreetAndHouseNum: function () {

            if (this.isNonStdAddress()) {
                this.address.streetName = _getFormattedStreet(this.elements.nonStdStreetNameInput.val(), false);
                this.address.houseNo = this.elements.nonStdStreetNumInput.val();
            } else {
                this.address.streetName = _getFormattedStreet(this.elements.lookupStreetNameHidden.val(), false);
                this.address.houseNo = this.elements.lookupHouseNoSelHidden.val();
            }

        },

        populateFullAddress: function (event, name, context) {

            if (name != context.options.name) {
                return;
            }

            var address = context.address, elements = context.elements;

            address.unitNo = $.trim(elements.nonStdUnitShopInput.val().toUpperCase().replace(/\s{2,}/g, " "));
            if (context.isNonStdAddress()) {
                address.unitType = $.trim(elements.nonStdUnitTypeInput.val());
            }
            context.setUnitType();
            context.setSuburbName();
            address.state = elements.lookupStateHidden.val().toUpperCase();
            address.houseNo = $.trim(elements.nonStdStreetNumInput.val().toUpperCase().replace(/\s{2,}/g, " "));
            if (this.isNonStdAddress()) {
                address.streetName = _getFormattedStreet(elements.nonStdStreetNameInput.val(), false);
            } else {
                address.streetName = _getFormattedStreet(elements.lookupStreetNameHidden.val(), false);
            }

            var suburb = elements.nonStdSuburbInput.val();
            var postcode = elements.nonStdPostCodeInput.val();
            address.suburbSequence = typeof suburb == 'undefined' ? "" : suburb.toUpperCase();
            address.postCode = typeof postcode == 'undefined' ? "" : postcode.toUpperCase();
            if (address.suburbSequence !== "" && address.streetName !== "") {
                meerkat.modules.comms.get({
                    url: "spring/rest/address/streetsuburb/get.json",
                    data: {
                        addressLine: context.getFullAddressLineOne(),
                        postCodeOrSuburb: address.suburb
                    },
                    errorLevel: "silent",
                    useDefaultErrorHandling: false,
                    dataType: "json",
                    async: true,
                    cache: false,
                    timeout: 6000
                }).then(function (jsonResult) {
                    if (jsonResult.length === 1) {
                        address = jsonResult[0];
                        context.setUnitType();
                        if (jsonResult.text === "") {
                            jsonResult.text = context.getFullAddress(address);
                            jsonResult.fullAddressLineOne = context.getFullAddressLineOne();
                        }
                        elements.fullAddressHidden.val(context.getFullAddress(address));
                        elements.fullAddressLineOneHidden.val(context.getFullAddressLineOne());
                    } else {
                        address.streetName = _getFormattedStreet(elements.lookupStreetNameHidden.val(), false);
                        address.fullAddressLineOne = context.getFullAddressLineOne();
                        elements.fullAddressLineOneHidden.val(context.getFullAddressLineOne());
                        elements.fullAddressHidden.val(context.getFullAddress(address));
                    }
                }).catch(function (obj, txt, errorThrown) {
                    address.streetName = _getFormattedStreet(elements.lookupStreetNameHidden.val(), false);
                    address.fullAddressLineOne = context.getFullAddressLineOne();
                    elements.fullAddressLineOneHidden.val(address.fullAddressLineOne);
                    elements.fullAddressHidden.val(context.getFullAddress(address));
                    meerkat.modules.errorHandling.error({
                        message: "An error occurred checking the address: " + txt + ' ' + errorThrown,
                        page: "ajax/json/address/get_address.jsp",
                        description: "elastic_address:populateFullAddress(): " + txt + ' ' + errorThrown,
                        errorLevel: "silent"
                    });
                });
            }
        },
        populateFullAddressStreetSearch: function (event, name, jsonAddress, context) {

            if (name != context.options.name) {
                return;
            }

            var address = context.address;

            address = _.extend(address, jsonAddress);
            if (address.fullAddress === "") {
                context.setUnitType();
                address.fullAddress = context.getFullAddress(jsonAddress);
            }
            if (address.fullAddressLineOne === "") {
                address.fullAddressLineOne = context.getFullAddressLineOne();
            }
            context.elements.lookupDpIdHidden.val(address.dpId);
            context.elements.fullAddressHidden.val(address.fullAddress);
            context.elements.fullAddressLineOneHidden.val(address.fullAddressLineOne);
        },
        getFullAddress: function (jsonAddress) {
            var unitType = this.address.unitType;

            this.address = _.extend(this.address, jsonAddress);

            if(!jsonAddress.unitType && unitType) {
                this.address.unitType = unitType;
            }

            var fullAddressLineOne = jsonAddress.fullAddressLineOne;
            if (this.isNonStdAddress() || typeof fullAddressLineOne == 'undefined' || fullAddressLineOne === "") {
                fullAddressLineOne = this.getFullAddressLineOne();
            }

            return fullAddressLineOne + ", " + (jsonAddress.suburb || jsonAddress.suburbName) + " " + jsonAddress.state + " " + jsonAddress.postCode;
        },
        getFullAddressLineOne: function () {

            var address = this.address;

            if (this.isNonStdAddress()) {
                this.populateStreetAndHouseNum();
            } else if (typeof(address.streetName) == 'undefined') {
                address.streetName = "";
            }

            var fullAddressLineOneValue = "";
            if (address.unitNo !== "" && address.unitNo !== '0') {
                if (address.unitType != "OT" && address.unitType !== "" && typeof address.unitType != 'undefined') {
                    fullAddressLineOneValue += address.unitTypeText + " ";
                }
                fullAddressLineOneValue += address.unitNo + " ";
            }

            if (address.houseNo !== "" && address.houseNo !== '0') {
                fullAddressLineOneValue += address.houseNo + " " + address.streetName;
            } else {
                fullAddressLineOneValue += address.streetName;
            }

            return fullAddressLineOneValue;
        },
        postCodeLookup: function (event, context) {
            var postCodeField = $(event.target);

            if (postCodeField.val().length !== 4) {
                context.resetNonStdFields(true, true);
                return;
            }
            // Clear associated fields if value changes
            context.reset();
            context.elements.autofilllessSearchInput.val("");
            context.elements.nonStdStreetNameInput.val("");
            postCodeField.data('previous', postCodeField.val());
            context.elements.lookupPostCodeHidden.val(postCodeField.val());

            context.updateSuburb($(event.target).val(), function validatePostCode(valid) {
                postCodeField.toggleClass("invalidPostcode", !valid).valid();
            });
        },
        updateSuburb: function (code, callback) {

            this.resetNonStdFields(false, false);

            if (!isValidPostcode(code)) {
                this.elements.nonStdSuburbInput.html("<option value=''>Enter Postcode</option>").attr("disabled", "disabled");
                if (typeof callback === 'function') {
                    callback(false);
                }
                return false;
            }

            var self = this;
            meerkat.modules.comms.get({
                url: "spring/rest/address/suburbs/get.json",
                cache: true,
                dataType: 'json',
                errorLevel: "silent",
                useDefaultErrorHandling: false,
                data: { postCode: code }
            }).then(function (data, textStatus, xhr) {
                getSuburbsSuccess.apply(self, [data, callback]);
            })
            .catch(function onError(obj, txt, errorThrown) {
                exception(txt + ': ' + errorThrown);
            });

        },
        isResidential: function () {
            return this.options.addressType == "R";
        },
        reset: function () {
            this.resetSelectAddress();
            this.options.selectedStreetFld = "";
            var elements = this.elements;
            elements.lookupStreetIdHidden.val("");
            elements.nonStdSuburbInput.val("");
            elements.lookupStreetNameHidden.val("");
            elements.lookupSuburbNameHidden.val("");
            elements.nonStdStreetNumInput.val("");
            elements.lookupHouseNoSelHidden.val("");
            elements.nonStdUnitShopInput.val("");
            elements.lookupUnitSelHidden.val("");
            elements.nonStdUnitTypeInput.val("");
            elements.lookupPostCodeHidden.val("");
            elements.lookupStateHidden.val("");
            elements.streetNumFldLastSelected = null;
            this.address = {hasUnits: false};
        },
        resetNonStdFields: function (cleanData, ignorePostCode) {
            var elements = this.elements;
            if (cleanData) {
                if (!ignorePostCode) {
                    this.toggleValidationStyles(elements.nonStdPostCodeInput.val(''));
                }
                this.toggleValidationStyles(elements.nonStdSuburbInput.val(''));
                this.toggleValidationStyles(elements.nonStdStreetNameInput.val(''));
                this.toggleValidationStyles(elements.nonStdStreetNumInput.val(''));
                this.toggleValidationStyles(elements.nonStdUnitShopInput.val(''));
                this.toggleValidationStyles(elements.nonStdUnitTypeInput.val(''));
                elements.fullAddressLineOneHidden.val('');
                elements.fullAddressHidden.val('');

            } else {
                this.toggleValidationStyles(elements.nonStdPostCodeInput);
                this.toggleValidationStyles(elements.nonStdSuburbInput);
                this.toggleValidationStyles(elements.nonStdStreetNameInput);
                this.toggleValidationStyles(elements.nonStdStreetNumInput);
                this.toggleValidationStyles(elements.nonStdUnitShopInput);
                this.toggleValidationStyles(elements.nonStdUnitTypeInput);
            }
            if (!ignorePostCode) {
                elements.nonStdSuburbInput.html("<option value=''>Enter Postcode</option>").attr("disabled", "disabled");
            }
        },
        resetSelectAddress: function () {
            this.address.dpId = "";
            this.elements.lookupDpIdHidden.val("");
            this.elements.fullAddressLineOneHidden.val("");
            this.elements.fullAddressHidden.val("");
        },
        resetElasticSearchFields: function () {
            var elements = this.elements;
            this.toggleValidationStyles(elements.autofilllessSearchInput);
            elements.autofilllessSearchInput.val('');
            elements.lookupStreetNameHidden.val('');
            elements.lookupStreetIdHidden.val('');
            elements.lookupUnitTypeHidden.val('');
            elements.lookupPostCodeHidden.val('');
            elements.lookupUnitSelHidden.val('');
            elements.lookupHouseNoSelHidden.val('');
            elements.lookupSuburbNameHidden.val('');
            elements.lookupStateHidden.val('');
            elements.lookupDpIdHidden.val('');
        },
        swapInputsCleanValidation: function (event, context) {
            var $errorContainer = $("#elasticsearch-std-error-container");
            if ($(event.target).prop('checked')) {
                // Hide street search fields
                context.elements.autofilllessSearchFieldRow.hide();
                // Show non-standard fields
                context.elements.allNonStdFieldRows.show();

                // Reset the selected address.
                context.resetNonStdFields(true, false);
                context.resetElasticSearchFields();

                $errorContainer.hide();
            } else {
                // Show street search fields
                context.elements.autofilllessSearchFieldRow.show();
                // Show non-standard fields
                context.elements.allNonStdFieldRows.hide();

                // Reset the selected address.
                context.resetNonStdFields(true, false);
                context.resetElasticSearchFields();

                $errorContainer.show();
            }
        }
    };


    /**
     *
     * @param code
     * @returns {boolean}
     */
    function isValidPostcode(code) {
        return /[0-9]{4}/.test(code) === true;
    }

    /**
     * @param {{}} suburbs Response object
     * @param {Number} suburbSeqNo The default suburb number provided in a preload/retrieve quote.
     * @returns {string}
     */
    function buildSuburbOptionList(suburbs, suburbSeqNo) {
        var options = '';
        if (suburbs.length != 1) {
            options = '<option value="">Suburb</option>';
        }
        for (var i = 0; i < suburbs.length; i++) {
            var sel = suburbs.length == 1 || (typeof suburbSeqNo !== 'undefined' && suburbSeqNo !== null && suburbs[i].id == suburbSeqNo)
                ? " selected='selected'" : "";
            options += '<option value="' + suburbs[i].suburb + '"' + sel + '>' + suburbs[i].suburb + '</option>';
        }
        return options;
    }

    /**
     *
     * @param {{}} data
     * @param {Function} callback
     */
    var getSuburbsSuccess = function (data, callback) {

        var elements = this.elements;
        if (data && data.length > 0) {
            elements.nonStdSuburbInput.removeAttr("disabled").html(buildSuburbOptionList(data, this.options.suburbSeqNo));
            if (typeof callback == 'function') {
                callback(true);
            }
            if (data.postBoxOnly && !elements.nonStdCheckbox.prop('checked')) {
                elements.nonStdCheckbox.prop('checked', true).trigger('change.' + pluginName);
                elements.nonStdSuburbInput.trigger('focus.' + pluginName);
            }
        } else {
            elements.nonStdSuburbInput.html("<option value=''>Invalid Postcode</option>").attr("disabled", "disabled");
            if (typeof callback === 'function') {
                callback(false);
            }
        }
        elements.lookupStateHidden.val((data.length > 0 ? data[0].state : ""));
        this.setSuburbName();
    };

    /**
     *
     * @param street
     * @param convertToUppercase
     * @returns {*}
     * @private
     */
    function _getFormattedStreet(street, convertToUppercase) {
        var formattedStreet = street;
        if (convertToUppercase) {
            formattedStreet = street.toUpperCase();
        }
        formattedStreet = $.trim(formattedStreet.replace(/\s{2,}/g, " "));
        // eg "The Place" but not "The Yachtsmans Dr"
        var hasThe = formattedStreet.split(" ") == 1 && formattedStreet.toUpperCase().substring(0, 4) == "THE ";
        if (!hasThe && formattedStreet.indexOf(" ") != -1) {
            street = formattedStreet.substring(0, formattedStreet.lastIndexOf(" ") + 1);
            var suffix = formattedStreet.substring(formattedStreet.lastIndexOf(" ") + 1, formattedStreet.length).toUpperCase();
            var suffixes = [];

            suffixes[0] = ["Arc", ':ARC:ARC.:ARCADE:'];
            suffixes[1] = ["Accs", ':ACCS:ACCS.:ACCESS:'];
            suffixes[2] = ["Ally", ':ALLEY:ALLY.:ALLY:'];
            suffixes[3] = ["Boulevard", ':BLVD:BOULEVARD:BLVD.:'];
            suffixes[4] = ["Ct", ':CT:COURT:CT.:'];
            suffixes[5] = ["Cct", ':CCT.:CIRCUIT:CCT:'];
            suffixes[6] = ["Cl", ':CL.:Close:CL:'];
            suffixes[7] = ["Cres", ':CRES.:CRESCENT:CRES:'];
            suffixes[8] = ["Dr", ':DR.:DRIVE:DR:'];
            suffixes[9] = ["Gr", ':GR.:GROVE:GR:'];
            suffixes[10] = ["Pde", ':PDE.:PARADE:PDE:'];
            suffixes[11] = ["Rd", ':RD:ROAD:RD.:'];
            suffixes[12] = ["St", ':ST:STREET:ST.:'];
            suffixes[13] = ["Ave", ':AVE:AVENUE:AV:AV.:AVE.:'];
            suffixes[14] = ["Hwy", ':HIGHWAY:HWY:HWY.:HIGH:'];

            for (var i = 0; i < suffixes.length; i++) {
                var suffixMappings = suffixes[i];
                var suffixMapping = suffixMappings[1];
                if (suffixMapping.indexOf(":" + suffix + ":") >= 0) {
                    if (convertToUppercase) {
                        formattedStreet = street + suffixMappings[0].toUpperCase();
                    } else {
                        formattedStreet = street + suffixMappings[0];
                    }
                    break;
                }
            }
        }
        return formattedStreet;
    }

    /**
     * This is were we register our plugin withint jQuery plugins.
     * It is a plugin wrapper around the constructor and prevents agains multiple
     * plugin instantiation (soteing a plugin reference within the element's data)
     * and avoid any function starting with an underscore to be called (emulating
     * private functions).
     *
     * @example
     * $('#element').jqueryPlugin({
     *     defaultOption: 'this options overrides a default plugin option',
     *     additionalOption: 'this is a new option'
     * });
     */
    $.fn[pluginName] = function (options) {
        var args = arguments;

        if (options === undefined || typeof options === 'object') {
            // Creates a new plugin instance, for each selected element, and
            // stores a reference withint the element's data
            return this.each(function () {
                if (!$.data(this, pluginName)) {
                    $.data(this, pluginName, new Plugin(this, options));
                }
            });
        } else if (typeof options === 'string' && options[0] !== '_' && options !== 'init') {
            // Call a public plugin method (not starting with an underscore) for each
            // selected element.
            if (Array.prototype.slice.call(args, 1).length === 0 && $.inArray(options, $.fn[pluginName].getters) != -1) {
                // If the user does not pass any arguments and the method allows to
                // work as a getter then break the chainability so we can return a value
                // instead the element reference.
                var instance = $.data(this[0], pluginName);
                return instance[options].apply(instance, Array.prototype.slice.call(args, 1));
            } else {
                // Invoke the speficied method on each selected element
                return this.each(function () {
                    var instance = $.data(this, pluginName);
                    if (instance instanceof Plugin && typeof instance[options] === 'function') {
                        instance[options].apply(instance, Array.prototype.slice.call(args, 1));
                    }
                });
            }
        }
    };

    /**
     * Default options
     */
    $.fn[pluginName].defaults = {
        name: "",
        suburbSeqNo: null,
        streetNum: "",
        unitShop: "",
        addressType: "R",
        selectedStreetFld: "",
        userStartedTyping: true,
        streetNumFldLastSelected: null
    };

})(jQuery, window, document);