;(function ($, undefined) {

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events;

    var rowContainerTemplate,
        verticalTemplates = {};

    function initRetrievequotesListQuotes() {
        _registerEventListeners();
        $(document).ready(function() {
            var $resultsTemplate = $("#retrieve-quotes-container-template");
            if ($resultsTemplate.length) {
                rowContainerTemplate = _.template($resultsTemplate.html());
            }

            // to enable a new vertical to save quotes, create a new template_vertical.tag
            // and also include it in template_rows.tag.
            // TODO: Generate this object dynamically so all we have to do is include the tag in JSP
            verticalTemplates = {
                quote: $("#retrieve-car-template").html(),
                health: $("#retrieve-health-template").html(),
                life: $("#retrieve-life-template").html(),
                ip: $("#retrieve-ip-template").html(),
                home: $("#retrieve-home-template").html(),
                utilities: $("#retrieve-utilities-template").html()
            };
        });
    }

    function _registerEventListeners() {
        $(document)
            .on("click", "#logout-user", _onClickLogoutUser)
            .on("click", "#new-quote", _onClickNewQuote)
            .on("click", ".btn-latest", _onClickLatest)
            .on("click", ".btn-amend", _onClickAmend)
            .on("click", ".btn-pending", _onClickPending)
            .on("click", ".btn-start-again", _onClickStartAgain)
            .on("click", ".btn-start-again-fresh", _onClickStartAgainFresh);
    }

    function _onClickPending(e) {

        var data = _getClickElementData(e.target);
        var vertical  = data.vertical;
        if(vertical === 'home'){
            vertical  = 'home_contents';
        }
        var url = vertical + "_quote.jsp?action=confirmation&PendingID=" + encodeURIComponent(data.pendingID);
        window.location.href = url;
    }

    function _onClickLogoutUser(e) {
        meerkat.modules.utils.scrollPageTo("html, body");
        meerkat.modules.journeyEngine.loadingShow("Logging you out...");

        var $ajax = meerkat.modules.comms.get({
            url: "generic/logout_user.json",
            errorLevel: "silent",
            dataType: "json"
        });

        var onFail = function() {
            meerkat.modules.dialogs.show({
                title: "Unable to log out",
                htmlContent: "Sorry, we could not log you out at this time",
                buttons: [
                    {
                        label: 'OK',
                        className: 'btn-close-dialog'
                    }
                ]
            });

            meerkat.modules.journeyEngine.loadingHide();
        };

        $ajax
            .done(function(data) {
                if(typeof data === "string")
                    data = JSON.parse(data);

                if(data.success && data.success === true) {
                    window.location.href = "retrieve_quotes.jsp";
                    return;
                }

                onFail();
            })
            .fail(function() {
                onFail();
            });
    }

    function noResults() {
        meerkat.modules.dialogs.show({
            htmlContent: $("#new-quote-template").html(),
            buttons: [false],
            onOpen: function(dialogId) {
                $("#" + dialogId).find(".btn-close-dialog, .modal-footer").remove();
            }
        });
    }

    function _onClickNewQuote(e) {
        meerkat.modules.dialogs.show({
            htmlContent: $("#new-quote-template").html(),
            className: "new-quote-dialog"
        });
    }

    function _getClickElementData(element) {
        var $element = $(element);

        if(typeof $element.attr("data-vertical") === "undefined")
            $element = $element.closest("a");

        var data = {
            $element: $element,
            isLandlord: ('true' == $element.attr("data-islandlord")),
            vertical: $element.attr("data-vertical"),
            transactionId: $element.attr("data-transactionid"),
            inPast: $element.attr("data-inpast") || false
        };

        if($element.attr("data-pendingid"))
            data.pendingID = $element.attr("data-pendingid");

        return data;
    }

    function _onClickLatest(e) {
        var data = _getClickElementData(e.target);
        if(data.inPast === "Y") {
            meerkat.modules.dialogs.show({
                title: "Enter New Commencement Date",
                htmlContent: $("#new-commencement-date-template").html(),
                buttons: [
                    {
                        label: 'Cancel',
                        className: 'btn-close-dialog'
                    }, {
                        label: 'Get Latest Results',
                        className: 'btn-cta btn-submit'
                    }
                ],
                onOpen: function (dialogId) {
                    meerkat.modules.datepicker.setDefaults();
                    meerkat.modules.datepicker.initModule();

                    $(document).on("click", "#" + dialogId + " .btn-submit", function () {
                        var newDate = $("#newCommencementDate").val();
                        meerkat.modules.dialogs.close(dialogId);
                        _retrieveQuote(data.vertical, "latest", data.transactionId, newDate);
                    });
                }
            });
        } else {
            _retrieveQuote(data.vertical, "latest", data.transactionId);
        }
    }

    function _onClickStartAgainFresh(e) {
        var data = _getClickElementData(e.target);
        _retrieveQuote(data.vertical, "start-again-fresh", data.transactionId);
    }

    function _onClickStartAgain(e) {
        var data = _getClickElementData(e.target);
        _retrieveQuote(data.vertical, "start-again", data.transactionId);
    }

    function _onClickAmend(e) {
        var data = _getClickElementData(e.target);
        _retrieveQuote(data.vertical, "amend", data.transactionId, null, data.isLandlord);
    }

    function _retrieveQuote(vertical, action, transactionId, newDate, isLandlord) {
        if(vertical === "quote")
            vertical = "car";

        meerkat.modules.utils.scrollPageTo("html, body");
        meerkat.modules.journeyEngine.loadingShow("Retrieving your quote...");

        var data = {
            vertical: vertical,
            action: action,
            transactionId: transactionId
        };

        if (newDate)
            data.newDate = newDate;
        var $ajax = meerkat.modules.comms.post({
            url: "ajax/json/load_quote.jsp",
            errorLevel: "silent",
            dataType: "json",
            data: data
        });

        var onFail = function(message) {
            message = message || "A problem occurred when trying to load your quote.";

            meerkat.modules.dialogs.show({
                title: "Unable to load your quote",
                htmlContent: "<p>" + message + "</p>",
                buttons: [{
                    label: 'OK',
                    className: 'btn-secondary btn-close-dialog'
                }]
            });

            meerkat.modules.journeyEngine.loadingHide();
        };

        $ajax
            .done(function(data) {
                if(typeof data === "string")
                    data = JSON.parse(data);

                if(data && data.result) {
                    var result = data.result;
                    var landlord = isLandlord ? '&landlord=true' : '';
                    if(result.destUrl) {
                        window.location.href = result.destUrl + landlord + '&ts=' + Number(new Date());
                        return;
                    } else {
                        if(result.showToUser && result.error) {
                            onFail(result.error);
                            return;
                        }
                    }
                }

                onFail();
            })
            .fail(function() {
                onFail();
            });
    }

    function renderQuotes() {
        $("#quote-result-list").html(rowContainerTemplate(meerkat.site.responseJson));
    }

    function renderTemplate(vertical, data) {
        if(!vertical || vertical == "generic") {
            return "";
        }
        try {
            var htmlTemplate = _.template(verticalTemplates[vertical]);
            return htmlTemplate(data);
        } catch(e) {
            meerkat.modules.errorHandling.error({
                errorLevel: "silent",
                page: "retrievequotesListQuotes.js",
                description: "Unable to render template [" + vertical + "]",
                message: "Unable to render template",
                data: {
                    vertical: vertical,
                    providedData: data
                }
            });

            return "";
        }
    }

    function getVerticalFromObject(obj) {
        var keys = _.keys(obj);
        for (var k = 0; k < keys.length; k++) {
            if (keys[k] != 'id') {
                return keys[k];
            }
        }
        return false;
    }

    function getGenderString(gender) {
        return gender == 'M' ? 'Male' : 'Female';
    }

    function carFormatNcd(value) {
        var rating;
        switch (value) {
            case 5:
                rating = 1;
                break;
            case 4:
                rating = 2;
                break;
            case 3:
                rating = 3;
                break;
            case 2:
                rating = 4;
                break;
            case 1:
                rating = 5;
                break;
            case 0:
                rating = 6;
                break;
        }
        // No NCD if 6
        if(rating == 6) {
            return "Rating 6 No NCD";
        }
        return typeof rating == 'undefined' ? "" : "Rating " + rating + " ("+value+" Years) NCD";
    }

    function healthBenefitsList(data) {
        if(typeof data == 'undefined' || typeof data.benefitsExtras == 'undefined') {
            return "";
        }
        var keys = Object.keys(data.benefitsExtras),
            outList = [];
        for(var i = 0; i < keys.length; i++) {
            if(data.benefitsExtras[keys[i]] == "Y") {
                outList.push(keys[i]);
            }
        }
        return outList.join(', ');
    }

    meerkat.modules.register("retrievequotesListQuotes", {
        init: initRetrievequotesListQuotes,
        renderQuotes: renderQuotes,
        renderTemplate: renderTemplate,
        getVerticalFromObject: getVerticalFromObject,
        noResults: noResults,

        getGenderString: getGenderString,
        carFormatNcd: carFormatNcd,
        healthBenefitsList: healthBenefitsList
    });

})(jQuery);