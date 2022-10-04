var Track = new Object();
Track = {
    _type: '',
    _lastTouch: '',
    _pageName: '',
    _transactionID: 0,

    init: function (type, pageName) {
        this._type = type;
        this.setPageName(pageName);
        this._addLastTouch();
        if (!typeof s === 'undefined') {
            s.pageName = pageName;
        }
    },
    saveRetrieve: function (action, tranId) {
        Track.runTrackingCall('trackQuoteEvent', {
            action: action,
            transactionID: tranId
        });
    },
    transferInit: function (phoneOnline, quoteRef, tranId, prodId) {
        alert('If you see this, we need Track.transferInit.');
    },
    transfer: function (quoteRef, tranId, prodId, brandCode, prodName) {
        Track.runTrackingCall('trackQuoteHandoverClick', {
            quoteReferenceNumber: quoteRef,
            transactionID: tranId,
            productID: prodId,
            productBrandCode: brandCode,
            productName: prodName
        });
    },
    offerTerms: function (prodId) {
        Track.runTrackingCall('trackOfferTerms', {
            productID: prodId
        });
    },
    resultsShown: function (eventType) {
        var prodArray = new Array();
        for (var i in Results._currentPrices) {
            prodArray[i] = {
                productID: Results._currentPrices[i].productId,
                ranking: i + 1
            };
        }

        Track.runTrackingCall('trackQuoteResultsList', {
            products: prodArray
        });

        Track.runTrackingCall('trackQuoteForms', {
            paymentPlan: '',
            preferredExcess: '',
            sortEnvironment: '',
            sortDriveLessPayLess: '',
            sortBestPrice: '',
            sortOnlineOnlyOffer: '',
            sortHouseholdName: '',
            event: '',
            emailID: null
        });
    },
    lastTouch: function (fld) {
        this._lastTouch = $(fld).attr('title') ? $(fld).attr('title') : $(fld).attr('name');
    },
    _addLastTouch: function () {
        $('input, select, textarea').filter(':input').focus(function () {
            Track.lastTouch(this);
        });
    },
    setPageName: function (pageName) {
        this._pageName = pageName;
    },
    getPageName: function () {
        return s.pageName;
    },

    runTrackingCall: function (method, object) {

        if (typeof method !== 'string') {
            return;
        }
        if (typeof object !== 'object') {
            return;
        }

        // Add defaults to values if required
        var values = this.addCoreTrackingData(object);

        // Set a resolved promise to start with.
        var deferred = $.Deferred().resolve().promise();

        if (values.email !== null && values.email !== '' && values.emailID === null) {
            // Reset var deferred to the deferred result of the XHR object
            deferred = Track._getEmailId(values.email, values.marketOptIn, values.okToCall).done(function (result) {
                if (typeof result.emailId !== 'undefined') {
                    values.emailID = result.emailId;
                    values.email = null;
                }
            });
        }

        // run when it is either resolved OR rejected (emailID would just be null if failed).
        deferred.always(function () {
            if (Settings.superTagEnabled === true) {
                Track.recordSupertag(method, values);
            }

            if (Settings.DTMEnabled === true) {
                Track.recordDTM(method, values);
            }
            if (Settings.GTMEnabled === true) {
                Track.recordGoogle(method, values);
            }
        });

    },

    addCoreTrackingData: function (object) {

        if (typeof object.brandCode === "undefined") {
            object.brandCode = Settings.brand;
        }

        if (typeof object.transactionID === "undefined") {
            object.transactionID = typeof referenceNo.getTransactionID == 'function' ? referenceNo.getTransactionID(false) : null;
        }

//		if (typeof object.rootID === "undefined") {
//			object.rootID = "";
//		}

        if (typeof object.vertical === "undefined") {
            object.vertical = Settings.vertical;
        }

        if (typeof object.simplesUser === "undefined") {
            object.simplesUser = UserData.callCentre || false;
        }
        if (typeof object.contactCentreID === "undefined") {
            object.contactCentreID = UserData.contactCentreID || null;
        }

        if (typeof object.verticalFilter === "undefined") {
            object.verticalFilter = null;
        }

        object.trackingKey = null;

        object.lastFieldTouch = this._lastTouch;

        return object;
    },

    recordSupertag: function (method, value) {
        try {
            if (typeof superT === 'undefined') {
                throw "Supertag is undefined";
            }

            superT[method](value);
            Track.log("Supertag", method, value);

        } catch (e) {
            Track.log("Supertag catch", method, value, e);
        }
    },

    recordDTM: function (method, value) {
        try {
            if (typeof _satellite === 'undefined') {
                throw "_satellite is undefined";
            }

            for (var key in value) {
                if (value.hasOwnProperty(key)
                    && typeof value[key] !== 'function') {
                    if (value[key] !== null) {
                        var setVarValue = typeof value[key] === 'string' ? value[key].toLowerCase() : value[key];
                        _satellite.setVar(key, setVarValue);
                    } else {
                        _satellite.setVar(key, "");
                    }
                }
            }
            Track.log("DTM", method, value);
            _satellite.track(method);
        } catch (e) {
            Track.log("_satellite catch", method, value, e);
        }
    },

    /**
     * https://developers.google.com/tag-manager/quickstart
     * @param {String} method
     * @param {POJO} value
     */
    recordGoogle: function (method, value) {
        try {
            if (typeof window.dataLayer === 'undefined') {
                throw "Google Data Layer is undefined";
            }
            var data = {"event": method};
            var values = _.keys(value);
            for (var i = 0; i < values.length; i++) {
                var key = values[i];
                if (value[key] !== null) {
                    data[key] = typeof value[key] === 'string' ? value[key].toLowerCase() : value[key];
                }
            }
            Track.log("Google", method, value);
            window.dataLayer.push(data);

        } catch (e) {
            Track.log("Google catch", method, value, e);
        }
    },

    _getEmailId: function (emailAddress, marketing, oktocall, callback) {
        return $.ajax({
            url: "ajax/json/get_email_id.jsp",
            data: {
                vertical: Settings.vertical,
                email: emailAddress,
                m: marketing,
                o: oktocall,
                transactionId: referenceNo.getTransactionID()
            },
            type: "POST",
            cache: true,
            dataType: "json"
        });
    },

    log: function () {
        if (typeof console !== 'undefined' && typeof console.log === 'function'
            && Settings.environment == 'localhost' || Settings.environment == 'NXI') {
            console.log(arguments[0], arguments[1], arguments[2], (arguments[3] || ''));
        }
    }
};