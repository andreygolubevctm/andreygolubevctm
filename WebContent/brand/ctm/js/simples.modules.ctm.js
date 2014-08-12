/*!
 * CTM-Platform v0.8.3
 * Copyright 2014 Compare The Market Pty Ltd
 * http://www.comparethemarket.com.au/
 */

(function($, undefined) {
    var meerkat = window.meerkat, log = meerkat.logging.info;
    var modalId = false, currentTransactionId = false, currentMessage = false, templateComments = false, templatePostpone = false, $actionsDropdown = false, $homeButton = false;
    function init() {
        $(document).ready(function() {
            $homeButton = $("nav .simples-homebutton");
            var $checkHasActionsDropdown = $("[data-provide='simples-quote-actions']");
            if ($checkHasActionsDropdown.length > 0) {
                $checkHasActionsDropdown.each(function() {
                    $actionsDropdown = $(this);
                    $actionsDropdown.on("click", ".action-complete", function() {
                        if ($(this).parent("li").hasClass("disabled")) return false;
                        actionFinish("complete");
                    });
                    $actionsDropdown.on("click", ".action-unsuccessful", function() {
                        if ($(this).parent("li").hasClass("disabled")) return false;
                        actionFinish("unsuccessful");
                    });
                    $actionsDropdown.on("click", ".action-postpone", function(event) {
                        if ($(this).parent("li").hasClass("disabled")) return false;
                        actionPostpone();
                    });
                    $actionsDropdown.on("click", ".action-comment", function(event) {
                        if ($(this).parent("li").hasClass("disabled")) return false;
                        actionComments();
                    });
                });
                meerkat.messaging.subscribe(meerkat.modules.events.simplesInterface.TRANSACTION_ID_CHANGE, function tranIdChange(obj) {
                    currentTransactionId = obj || false;
                    updateMenu();
                });
                meerkat.messaging.subscribe(meerkat.modules.events.simplesMessage.MESSAGE_CHANGE, function idChange(obj) {
                    currentMessage = obj || false;
                    updateMenu();
                });
                $e = $("#simples-template-comments");
                if ($e.length > 0) {
                    templateComments = _.template($e.html());
                }
                $e = $("#simples-template-postpone");
                if ($e.length > 0) {
                    templatePostpone = _.template($e.html());
                }
            }
            var $checkSimplesHome = $(".simples-home");
            if ($checkSimplesHome.length > 0) {
                $(".message-getnext").on("click", function clickNext(event) {
                    event.preventDefault();
                    if (window.top.meerkat && window.top.meerkat.modules.simplesMessage) {
                        window.top.meerkat.modules.simplesMessage.getNextMessage();
                    } else {
                        meerkat.modules.simplesMessage.getNextMessage();
                    }
                });
            }
        });
    }
    function updateMenu() {
        var showMenu = false;
        var $tranId = $actionsDropdown.find(".simples-show-transactionid");
        var $msgId = $actionsDropdown.find(".simples-show-messageid");
        var $actionCompleteParent = $actionsDropdown.find(".action-complete").parent("li");
        var $actionUnsuccessfulParent = $actionsDropdown.find(".action-unsuccessful").parent("li");
        var $actionPostponeParent = $actionsDropdown.find(".action-postpone").parent("li");
        var $actionCommentParent = $actionsDropdown.find(".action-comment").parent("li");
        if (currentTransactionId !== false) {
            showMenu = true;
            $tranId.text(currentTransactionId);
            $actionCommentParent.removeClass("disabled");
        } else {
            showMenu = false;
            $tranId.text("None");
            $actionCommentParent.addClass("disabled");
        }
        if (currentMessage === false || isNaN(currentMessage.messageId)) {
            if (showMenu === false) showMenu = false;
            $msgId.text("None");
            $actionCompleteParent.addClass("disabled");
            $actionUnsuccessfulParent.addClass("disabled");
            $actionPostponeParent.addClass("disabled");
        } else {
            showMenu = true;
            $msgId.text(currentMessage.messageId);
            $actionCompleteParent.removeClass("disabled");
            $actionUnsuccessfulParent.removeClass("disabled");
            if (currentMessage.hasOwnProperty("canPostpone") && currentMessage.canPostpone === true) {
                $actionPostponeParent.removeClass("disabled");
            } else {
                $actionPostponeParent.addClass("disabled");
            }
        }
        if (showMenu) {
            $actionsDropdown.removeClass("hidden");
        } else {
            $actionsDropdown.addClass("hidden");
        }
    }
    function actionFinish(type) {
        if (!type) return;
        var parentStatusId = 0;
        if (type === "complete") {
            parentStatusId = 2;
        } else if (type === "unsuccessful") {
            parentStatusId = 6;
        }
        modalId = meerkat.modules.dialogs.show({
            title: " ",
            url: "simples/ajax/message_statuses.html.jsp?parentStatusId=" + parentStatusId,
            buttons: [ {
                label: "Cancel",
                className: "btn-cancel",
                closeWindow: true
            }, {
                label: "OK",
                className: "btn-cta message-savebutton",
                closeWindow: false
            } ],
            onOpen: function(id) {
                modalId = id;
                var $button = $("#" + modalId).find(".message-savebutton");
                $button.prop("disabled", true);
            },
            onLoad: function() {
                var $modal = $("#" + modalId);
                var $button = $modal.find(".message-savebutton");
                $modal.find("input[type=radio]").on("change", function() {
                    $button.prop("disabled", false);
                });
                $button.on("click", function loadClick() {
                    $button.prop("disabled", true);
                    meerkat.modules.loadingAnimation.showInside($button, true);
                    var statusId = $modal.find("input[type=radio]:checked").val();
                    meerkat.modules.simplesMessage.performFinish(type, {
                        reasonStatusId: statusId
                    }, function performCallback() {
                        if ($homeButton.length > 0) $homeButton[0].click();
                        meerkat.modules.dialogs.close(modalId);
                    });
                });
            }
        });
    }
    function actionPostpone() {
        meerkat.modules.dialogs.show({
            title: "Postpone message",
            buttons: [ {
                label: "Cancel",
                className: "btn-cancel",
                closeWindow: true
            }, {
                label: "OK",
                className: "btn-save message-savebutton",
                closeWindow: false
            } ],
            onOpen: function(id) {
                modalId = id;
                var $modal = $("#" + modalId);
                var $button = $modal.find(".message-savebutton");
                $button.prop("disabled", true);
                meerkat.modules.dialogs.changeContent(modalId, meerkat.modules.loadingAnimation.getTemplate());
                meerkat.modules.comms.get({
                    url: "simples/ajax/message_statuses.json.jsp?parentStatusId=4",
                    dataType: "json",
                    cache: true,
                    errorLevel: "silent",
                    onSuccess: function onSuccess(json) {
                        updateModal(json, templatePostpone);
                    },
                    onError: function onError(obj, txt, errorThrown) {
                        updateModal(null, templatePostpone);
                    },
                    onComplete: function onComplete() {
                        $button.prop("disabled", false);
                        var $picker = $modal.find("#postponedate");
                        $picker.datepicker({
                            clearBtn: false,
                            format: "dd/mm/yyyy"
                        });
                        $picker.siblings(".input-group-addon").on("click", function() {
                            $picker.datepicker("show");
                        });
                        $button.on("click", function loadClick() {
                            $button.prop("disabled", true);
                            meerkat.modules.loadingAnimation.showInside($button, true);
                            var data = {
                                postponeDate: $modal.find("#postponedate").val(),
                                postponeTime: $modal.find("#postponetime").val(),
                                reasonStatusId: $modal.find("select").val(),
                                comment: $modal.find("textarea").val(),
                                assignToUser: $modal.find("#assigntome").is(":checked")
                            };
                            meerkat.modules.simplesMessage.performFinish("postpone", data, function performCallback() {
                                if ($homeButton.length > 0) $homeButton[0].click();
                                meerkat.modules.dialogs.close(modalId);
                            }, function callbackError() {
                                $button.prop("disabled", false);
                                meerkat.modules.loadingAnimation.hide($button);
                            });
                        });
                    }
                });
            }
        });
    }
    function actionComments() {
        openModal(function() {
            meerkat.modules.dialogs.changeContent(modalId, meerkat.modules.loadingAnimation.getTemplate());
        });
        meerkat.modules.comms.get({
            url: "simples/comments/list.json",
            cache: false,
            errorLevel: "silent",
            data: {
                transactionId: currentTransactionId
            },
            onSuccess: function onSuccess(json) {
                updateModal(json, templateComments);
            },
            onError: function onError(obj, txt, errorThrown) {
                var json = {
                    errors: [ {
                        message: txt + " " + errorThrown
                    } ]
                };
                updateModal(json, templateComments);
            }
        });
    }
    function openModal(callbackOpen) {
        modalId = meerkat.modules.dialogs.show({
            title: " ",
            fullHeight: true,
            onOpen: function(id) {
                modalId = id;
                if (typeof callbackOpen === "function") {
                    callbackOpen();
                }
            }
        });
    }
    function updateModal(data, template) {
        var htmlContent = "No template found.";
        data = data || {};
        if (typeof template === "function") {
            htmlContent = template(data);
        }
        meerkat.modules.dialogs.changeContent(modalId, htmlContent);
    }
    meerkat.modules.register("simplesActions", {
        init: init
    });
})(jQuery);

(function($, undefined) {
    var meerkat = window.meerkat, log = meerkat.logging.info;
    var events = {
        simplesInterface: {
            TRANSACTION_ID_CHANGE: "TRANSACTION_ID_CHANGE"
        }
    }, moduleEvents = events.simplesInterface;
    var $iframe = $("#simplesiframe");
    function resizeIframe() {
        if ($iframe.length === 0) return;
        var buffer = 8;
        var height = window.innerHeight || document.body.clientHeight || document.documentElement.clientHeight;
        height -= $iframe.position().top + buffer;
        height = height < 50 ? 50 : height;
        $iframe.height(height);
    }
    function receiveMessage(event) {
        try {
            if (event.data.eventType === "transactionId") {
                meerkat.messaging.publish(moduleEvents.TRANSACTION_ID_CHANGE, event.data.transactionId);
            }
        } catch (e) {
            log("Error receiving postMessage", e);
        }
    }
    function init() {
        $(document).ready(resizeIframe);
        window.onresize = resizeIframe;
        window.addEventListener("message", receiveMessage, false);
    }
    meerkat.modules.register("simplesInterface", {
        init: init,
        events: events
    });
})(jQuery);

(function($, undefined) {
    var meerkat = window.meerkat, log = meerkat.logging.info;
    var $iframe = $("#simplesiframe");
    var baseUrl = "";
    function init() {
        $(document).ready(function() {
            if (meerkat.site && typeof meerkat.site.urls !== "undefined" && typeof meerkat.site.urls.base !== "undefined") {
                baseUrl = meerkat.site.urls.base;
            }
            $(document.body).on("click", ".needs-loadsafe", function loadsafeClick(event) {
                event.preventDefault();
                var $this = $(this);
                var addBaseUrlToHref = false;
                if ($this.parent().parent().hasClass("dropdown")) {
                    $this.parent().parent().find(".dropdown-toggle").dropdown("toggle");
                }
                if ($this.hasClass("needs-baseurl")) addBaseUrlToHref = true;
                loadsafe($this.attr("href"), addBaseUrlToHref);
            });
        });
    }
    function loadsafe(href, addBaseUrlToHref) {
        if (!href || href.length === 0) return;
        addBaseUrlToHref = addBaseUrlToHref || false;
        href += href.indexOf("?") >= 0 ? "&" : "?";
        href += "ts=" + new Date().getTime();
        if (addBaseUrlToHref === true) {
            href = baseUrl + href;
        }
        var loadingUrl = baseUrl + "simples/loading.jsp?url=" + encodeURIComponent(href);
        if ($iframe.length > 0) {
            $iframe.attr("src", loadingUrl);
        } else {
            window.location = loadingUrl;
        }
    }
    meerkat.modules.register("simplesLoadsafe", {
        init: init,
        loadsafe: loadsafe
    });
})(jQuery);

(function($, undefined) {
    var meerkat = window.meerkat, log = meerkat.logging.info;
    var events = {
        simplesMessage: {
            MESSAGE_CHANGE: "MESSAGE_CHANGE"
        }
    }, moduleEvents = events.simplesMessage;
    var modalId = false, templateMessageDetail = false, currentMessage = false;
    function init() {
        $(document).ready(function() {
            $e = $("#simples-template-messagedetail");
            if ($e.length > 0) {
                templateMessageDetail = _.template($e.html());
            }
            $("#dynamic_dom").on("click", ".messagedetail-loadbutton", function(event) {
                event.preventDefault();
                loadMessage();
            });
        });
    }
    function loadMessage() {
        if (currentMessage === false || !currentMessage.hasOwnProperty("messageId")) {
            alert("Message details have not been stored correctly - can not load.");
            return;
        }
        var $button = $("#" + modalId).find(".messagedetail-loadbutton");
        $button.prop("disabled", true);
        meerkat.modules.loadingAnimation.showInside($button, true);
        meerkat.modules.comms.post({
            url: "simples/ajax/message_set_inprogress.jsp",
            dataType: "json",
            cache: false,
            errorLevel: "silent",
            data: {
                messageId: currentMessage.messageId
            },
            onSuccess: function onSuccess(json) {
                if (json.hasOwnProperty("errors") && json.errors.length > 0) {
                    alert("Could not set message to In Progress...\n" + json.errors[0].message);
                    $button.prop("disabled", false);
                    meerkat.modules.loadingAnimation.hide($button);
                    return;
                }
                var url = "simples/loadQuote.jsp?brandId=" + currentMessage.styleCodeId + "&verticalCode=" + currentMessage.vertical + "&transactionId=" + currentMessage.transactionId + "&action=amend";
                meerkat.modules.simplesLoadsafe.loadsafe(url, true);
                meerkat.messaging.publish(moduleEvents.MESSAGE_CHANGE, currentMessage);
                meerkat.modules.dialogs.close(modalId);
            },
            onError: function onError(obj, txt, errorThrown) {
                alert("Could not set message to In Progress...\n" + txt + " " + errorThrown);
                $button.prop("disabled", false);
                meerkat.modules.loadingAnimation.hide($button);
            }
        });
    }
    function getNextMessage() {
        modalId = meerkat.modules.dialogs.show({
            title: "Message assigned to you:",
            buttons: [ {
                label: "Cancel",
                className: "btn-cancel",
                closeWindow: true
            }, {
                label: "Load",
                className: "btn-save messagedetail-loadbutton",
                closeWindow: false
            } ],
            onOpen: function(id) {
                modalId = id;
                $("#" + modalId).find(".modal-closebar").addClass("hidden");
                meerkat.modules.dialogs.changeContent(modalId, meerkat.modules.loadingAnimation.getTemplate());
                $("#" + modalId).find(".messagedetail-loadbutton").prop("disabled", true);
                meerkat.modules.comms.get({
                    url: "simples/messages/next.json",
                    cache: false,
                    errorLevel: "silent",
                    onSuccess: function onSuccess(json) {
                        updateModal(json, templateMessageDetail);
                        currentMessage = json;
                        if (json.hasOwnProperty("errors") === false || json.errors.length === 0) {
                            if (currentMessage.messageId > 0) {
                                $("#" + modalId).find(".messagedetail-loadbutton").prop("disabled", false);
                            }
                        }
                    },
                    onError: function onError(obj, txt, errorThrown) {
                        var json = {
                            errors: [ {
                                message: txt + " " + errorThrown
                            } ]
                        };
                        updateModal(json, templateMessageDetail);
                    }
                });
            },
            onClose: function() {}
        });
    }
    function performFinish(type, data, callbackSuccess, callbackError) {
        if (!type) return;
        if (currentMessage === false || !currentMessage.hasOwnProperty("messageId")) {
            alert("Message details have not been stored correctly - can not load.");
            return;
        }
        if (currentMessage.messageId === false || isNaN(currentMessage.messageId)) {
            alert("No Message ID is currently known, so can not set as complete.");
            return;
        }
        data = data || {};
        data.messageId = currentMessage.messageId;
        meerkat.modules.comms.post({
            url: "simples/ajax/message_set_" + type + ".jsp",
            dataType: "json",
            cache: false,
            errorLevel: "silent",
            data: data,
            onSuccess: function onSuccess(json) {
                if (json.hasOwnProperty("errors") && json.errors.length > 0) {
                    alert("Could not set to " + type + "...\n" + json.errors[0].message);
                    if (typeof callbackError === "function") callbackError();
                    return;
                }
                meerkat.messaging.publish(moduleEvents.MESSAGE_CHANGE, false);
                currentMessage = false;
                if (typeof callbackSuccess === "function") callbackSuccess();
            },
            onError: function onError(obj, txt, errorThrown) {
                alert("Could not set to " + type + "...\n" + txt + " " + errorThrown);
                if (typeof callbackError === "function") callbackError();
            }
        });
    }
    function updateModal(data, template) {
        var htmlContent = "No template found.";
        data = data || {};
        if (typeof template === "function") {
            htmlContent = template(data);
        }
        meerkat.modules.dialogs.changeContent(modalId, htmlContent);
    }
    meerkat.modules.register("simplesMessage", {
        init: init,
        events: events,
        getNextMessage: getNextMessage,
        performFinish: performFinish
    });
})(jQuery);

(function($, undefined) {
    var meerkat = window.meerkat, log = meerkat.logging.info;
    var modalId = false, searchTerm = false, templateQuoteDetails = false;
    function init() {
        $(document).ready(function() {
            $('[data-provide="simples-quote-finder"]').on("click", "a", function(event) {
                event.preventDefault();
                launch();
            });
            $("#dynamic_dom").on("submit", "form.simples-search-quotedetails", function searchModalSubmit(event) {
                event.preventDefault();
                searchTerm = $(this).find(":input[name=keywords]").val();
                performSearch();
            });
            var $e = $("#simples-template-quotedetails");
            if ($e.length > 0) {
                templateQuoteDetails = _.template($e.html());
            }
        });
    }
    function launch() {
        modalId = meerkat.modules.dialogs.show({
            title: " ",
            fullHeight: true,
            onOpen: function(id) {
                modalId = id;
                performSearch();
            },
            onClose: function() {}
        });
    }
    function performSearch() {
        updateModal();
        if (searchTerm === false || searchTerm === "") return;
        var validatedData = validateSearch(searchTerm);
        if (validatedData.valid === false) {
            validatedData.errorMessage = "The search term is not valid. Must be valid email or transaction ID";
            updateModal(validatedData);
            return;
        }
        meerkat.modules.comms.post({
            url: "simples/ajax/quote_finder.jsp",
            dataType: "json",
            cache: false,
            errorLevel: "silent",
            data: validatedData,
            onSuccess: function onSearchSuccess(json) {
                var data = {};
                if (typeof window.InspectorJSON === "undefined") {
                    data.errorMessage = "InspectorJSON plugin is not available.";
                } else if (json.hasOwnProperty("findQuotes") && json.findQuotes.hasOwnProperty("quotes")) {
                    data.results = json.findQuotes.quotes;
                    if (!_.isArray(data.results)) {
                        data.results = [ json.findQuotes.quotes ];
                    }
                } else if (json.hasOwnProperty("errors")) {
                    data.errorMessage = json.errors[0].error;
                }
                updateModal(data);
                if (data.hasOwnProperty("errorMessage") === false) {
                    jsonViewer(data.results);
                }
            },
            onError: function onError(obj, txt, errorThrown) {
                updateModal({
                    errorMessage: txt + " " + errorThrown
                });
            }
        });
    }
    function jsonViewer(results) {
        var obj = {};
        var id;
        for (var i in results) {
            if (results[i].hasOwnProperty("quote")) {
                id = results[i].id + " - Car";
                obj[id] = {};
                obj[id] = results[i].quote;
            } else if (results[i].hasOwnProperty("health")) {
                id = results[i].id + " - Health";
                obj[id] = {};
                obj[id] = results[i].health;
            } else if (results[i].hasOwnProperty("ip")) {
                id = results[i].id + " - IP";
                obj[id] = {};
                obj[id] = results[i].ip;
            } else if (results[i].hasOwnProperty("life")) {
                id = results[i].id + " - Life";
                obj[id] = {};
                obj[id] = results[i].life;
            } else if (results[i].hasOwnProperty("travel")) {
                id = results[i].id + " - Travel";
                obj[id] = {};
                obj[id] = results[i].travel;
            } else if (results[i].hasOwnProperty("utilities")) {
                id = results[i].id + " - Utilities";
                obj[id] = {};
                obj[id] = results[i].utilities;
            } else if (results[i].hasOwnProperty("home")) {
                id = results[i].id + " - Home & Contents";
                obj[id] = {};
                obj[id] = results[i].home;
            } else {
                id = results[i].id + " - Unhandled vertical";
                obj[id] = {};
            }
        }
        if (typeof viewer === "object" && viewer instanceof InspectorJSON) {
            viewer.destroy();
        }
        viewer = new InspectorJSON({
            element: $("#quote-details-container")[0],
            collapsed: true,
            debug: false,
            json: obj
        });
    }
    function updateModal(data) {
        var htmlContent = "No template found.";
        data = data || {};
        if (typeof templateQuoteDetails === "function") {
            data.results = data.results || "";
            data.keywords = data.keywords || searchTerm || "";
            if (data.errorMessage && data.errorMessage.length > 0) {} else if (data.keywords === "") {
                data.errorMessage = "Please enter something to search for.";
            } else if (data.results === "") {
                data.results = meerkat.modules.loadingAnimation.getTemplate();
            }
            htmlContent = templateQuoteDetails(data);
        }
        meerkat.modules.dialogs.changeContent(modalId, htmlContent, function simplesSearchModalChange() {
            $("#" + modalId + " .modal-header").empty().prepend($("#" + modalId + "#simples-search-modal-header"));
        });
    }
    function validateSearch(term) {
        var result = {
            valid: false,
            term: $.trim(term),
            type: false
        };
        if (term.length > 0) {
            if (isTransactionId(term)) {
                result = $.extend(result, {
                    valid: true,
                    type: "transactionid"
                });
            } else if (isValidEmailAddress(term)) {
                result = $.extend(result, {
                    valid: true,
                    type: "email"
                });
            }
        }
        return result;
    }
    function isValidEmailAddress(emailAddress) {
        var pattern = new RegExp(/^((([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+(\.([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+)*)|((\x22)((((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(([\x01-\x08\x0b\x0c\x0e-\x1f\x7f]|\x21|[\x23-\x5b]|[\x5d-\x7e]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(\\([\x01-\x09\x0b\x0c\x0d-\x7f]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]))))*(((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(\x22)))@((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.?$/i);
        return pattern.test(emailAddress);
    }
    function isTransactionId(tranId) {
        try {
            var test = parseInt(String(tranId), 10);
            return !isNaN(test);
        } catch (e) {
            return false;
        }
    }
    meerkat.modules.register("simplesQuoteFinder", {
        init: init
    });
})(jQuery);

(function($, undefined) {
    var meerkat = window.meerkat, log = meerkat.logging.info;
    var moduleEvents = {};
    var modalId = false, templateSearch = false, templateMoreInfo = false, templateComments = false, searchResults = false, searchTerm = "";
    function init() {
        $(document).ready(function() {
            eventDelegates();
            var $e = $("#simples-template-search");
            if ($e.length > 0) {
                templateSearch = _.template($e.html());
            }
            $e = $("#simples-template-moreinfo");
            if ($e.length > 0) {
                templateMoreInfo = _.template($e.html());
            }
            $e = $("#simples-template-comments");
            if ($e.length > 0) {
                templateComments = _.template($e.html());
            }
        });
    }
    function eventDelegates() {
        $("#simples-search-navbar").on("submit", function navbarSearchSubmit(event) {
            event.preventDefault();
            searchTerm = $(this).find(":input[name=keywords]").val();
            openModal();
        });
        $("#dynamic_dom").on("submit", "form.simples-search", function searchModalSubmit(event) {
            event.preventDefault();
            searchTerm = $(this).find(":input[name=keywords]").val();
            performSearch();
        });
        $("#dynamic_dom").on("click", ".search-quotes-results .btn[data-action]", searchModalResultButton);
        $("#dynamic_dom").on("click", ".comment-hideshow", function showAddComment(event) {
            event.preventDefault();
            var $this = $(this);
            $this.addClass("hidden");
            $this.siblings(".comment-inputfields").slideToggle(200);
        });
        $("#dynamic_dom").on("click", ".comment-addcomment", clickAddComment);
    }
    function searchModalResultButton(event) {
        event.preventDefault();
        var $button = $(this), action = $button.attr("data-action"), $resultRow = $button.parents(".search-quotes-result-row"), transactionId;
        if ("amend" === action) {
            transactionId = $resultRow.attr("data-id");
            var vertical = $resultRow.attr("data-vertical");
            _.defer(function closeModal() {
                meerkat.modules.dialogs.close(modalId);
            });
        } else if ("moreinfo" === action) {
            if ($resultRow.hasClass("open")) {
                $resultRow.removeClass("open");
                $button.text($button.attr("data-originaltext"));
                $resultRow.find("div.moreinfo-container").slideUp(200);
            } else {
                $resultRow.addClass("open");
                $button.attr("data-originaltext", $button.text());
                $button.text("Close");
                $resultRow.parent().children().not(".open").removeClass("bg-success");
                $resultRow.addClass("bg-success");
                $resultRow.find("div.moreinfo-container").remove();
                $resultRow.append('<div class="moreinfo-container"></div>');
                var $container = $resultRow.find("div.moreinfo-container");
                transactionId = $resultRow.attr("data-id");
                var resultIndex = $resultRow.attr("data-index");
                var resultData = searchResults[resultIndex] || false;
                fetchMoreInfo(transactionId, $container, resultData);
            }
        }
    }
    function fetchMoreInfo(transactionId, $container, extraData) {
        if (typeof transactionId == "undefined" || transactionId.length === 0) {
            $container.html("Could not get more info: transaction ID not known");
            return;
        }
        extraData = extraData || {};
        $container.html(meerkat.modules.loadingAnimation.getTemplate());
        $container.slideDown(200);
        meerkat.modules.comms.get({
            url: "simples/transactions/details.json",
            cache: false,
            errorLevel: "silent",
            data: {
                transactionId: transactionId
            },
            onSuccess: function onSearchSuccess(json) {
                var htmlContent = "";
                if (typeof templateMoreInfo !== "function") {
                    htmlContent = "Could not get more info: template not configured.";
                } else {
                    $.extend(true, json, extraData);
                    htmlContent = templateMoreInfo(json);
                }
                $container.html(htmlContent);
            },
            onError: function onError(obj, txt, errorThrown) {
                $container.html("Could not get more info: " + txt + " " + errorThrown);
            }
        });
    }
    function performSearch() {
        searchResults = false;
        updateModal();
        if (searchTerm === false || searchTerm === "") return;
        $("#simples-search-navbar").find(":input[name=keywords]").val(searchTerm);
        meerkat.modules.comms.post({
            url: "simples/ajax/search_quotes.jsp",
            dataType: "json",
            cache: false,
            errorLevel: "silent",
            data: {
                simples: true,
                search_terms: searchTerm
            },
            onSuccess: function onSearchSuccess(json) {
                var data = {};
                if (json.hasOwnProperty("search_results") && json.search_results.hasOwnProperty("quote")) {
                    data.results = json.search_results.quote;
                    if (!_.isArray(data.results)) {
                        data.results = [ json.search_results.quote ];
                    }
                    searchResults = data.results;
                } else if (json.hasOwnProperty("errors")) {
                    data.errorMessage = json.errors[0].error;
                }
                updateModal(data);
            },
            onError: function onError(obj, txt, errorThrown) {
                updateModal({
                    errorMessage: txt + " " + errorThrown
                });
            }
        });
    }
    function openModal() {
        meerkat.modules.dialogs.show({
            title: " ",
            fullHeight: true,
            onOpen: function(id) {
                modalId = id;
                performSearch();
            },
            onClose: function() {}
        });
    }
    function updateModal(data) {
        var htmlContent = "No template found.";
        data = data || {};
        if (typeof templateSearch === "function") {
            data.results = data.results || "";
            data.keywords = data.keywords || searchTerm || "";
            if (data.errorMessage && data.errorMessage.length > 0) {} else if (data.keywords === "") {
                data.errorMessage = "Please enter something to search for.";
            } else if (data.results === "") {
                data.results = meerkat.modules.loadingAnimation.getTemplate();
            }
            htmlContent = templateSearch(data);
        }
        meerkat.modules.dialogs.changeContent(modalId, htmlContent, function simplesSearchModalChange() {
            $("#" + modalId + " .modal-header").empty().prepend($("#" + modalId + "#simples-search-modal-header"));
        });
    }
    function clickAddComment(event) {
        event.preventDefault();
        var $resultRow = $(this).parents(".comment-container");
        var transactionId = $resultRow.attr("data-id");
        var $comment = $resultRow.find("textarea");
        var $error = $resultRow.find(".comment-error");
        if (transactionId === undefined || transactionId.length === 0) {
            $error.text("Transaction ID not found or not defined.");
            return;
        }
        if (!$comment.val || $comment.val().length === 0) {
            $error.text("Comment length can not be zero.");
            return;
        }
        var $button = $resultRow.find(".comment-addcomment");
        $button.prop("disabled", true);
        meerkat.modules.loadingAnimation.showInside($button, true);
        $error.text("");
        addComment(transactionId, $comment.val(), function addCommentOk(json) {
            $button.prop("disabled", false);
            meerkat.modules.loadingAnimation.hide($button);
            $comment.val("");
            $resultRow.find(".comment-hideshow").removeClass("hidden");
            $resultRow.find(".comment-inputfields").slideUp(200);
            if (typeof templateComments === "function") {
                $resultRow.html(templateComments(json));
            }
        }, function addCommentErr(obj, txt, errorThrown) {
            $button.prop("disabled", false);
            meerkat.modules.loadingAnimation.hide($button);
            $error.text("Error: " + txt + " " + errorThrown);
        });
    }
    function addComment(transactionId, comment, callbackSuccess, callbackError) {
        if (!transactionId || transactionId.length === 0) {
            alert("transactionId must be defined.");
            return;
        }
        meerkat.modules.comms.post({
            url: "simples/ajax/comment_add_then_get.jsp",
            dataType: "json",
            cache: false,
            errorLevel: "silent",
            data: {
                transactionId: transactionId,
                comment: comment
            },
            onSuccess: function(json) {
                if (json && json.errors && json.errors.length > 0) {
                    if (typeof callbackError === "function") callbackError(json, "", json.errors[0].message);
                } else {
                    if (typeof callbackSuccess === "function") callbackSuccess(json);
                }
            },
            onError: function(obj, txt, errorThrown) {
                if (typeof callbackError === "function") callbackError(obj, txt, errorThrown);
            }
        });
    }
    meerkat.modules.register("simplesSearch", {
        init: init,
        events: moduleEvents
    });
})(jQuery);

(function($, undefined) {
    var meerkat = window.meerkat, log = meerkat.logging.info;
    var currentTransactionId = 0, intervalSeconds = 300, timer;
    function init() {
        if ($('[data-provide="simples-tickler"]').length === 0) return;
        meerkat.messaging.subscribe(meerkat.modules.events.simplesInterface.TRANSACTION_ID_CHANGE, function tranIdChange(obj) {
            if (obj === undefined) {
                currentTransactionId = 0;
            } else {
                currentTransactionId = obj;
            }
        });
        start(intervalSeconds);
    }
    function start(_intervalSeconds) {
        var intervalMs = _intervalSeconds * 1e3;
        clearInterval(timer);
        timer = setInterval(tickle, intervalMs);
        log("Tickler started @ " + _intervalSeconds + " second interval.");
    }
    function stop() {
        clearInterval(timer);
        log("Tickler stopped.");
    }
    function tickle() {
        meerkat.modules.comms.post({
            url: "simples/ajax/tickle.jsp",
            cache: false,
            errorLevel: "silent",
            timeout: 5e3,
            data: {
                transactionId: currentTransactionId
            },
            onSuccess: function onSuccess(json) {},
            onError: function onError(obj, txt, errorThrown) {
                var message = "";
                if (obj.status === 401) {
                    alert("Oh bother, it looks like your session is no longer active. Please click OK and log in again.");
                    window.top.location.href = "simples.jsp";
                } else {
                    alert("Something bad happened when trying to keep your session active. If this occurs again please restart your browser.");
                }
            }
        });
    }
    meerkat.modules.register("simplesTickler", {
        init: init,
        start: start,
        stop: stop
    });
})(jQuery);

(function($, undefined) {
    var meerkat = window.meerkat, log = meerkat.logging.info;
    var $refreshButton = false, templateUsers = false, $container = false, baseUrl = "";
    function init() {
        $(document).ready(function() {
            var $elements = $("[data-provide='simples-consultant-status']");
            if ($elements.length === 0) return;
            if (meerkat.site && typeof meerkat.site.urls !== "undefined" && typeof meerkat.site.urls.base !== "undefined") {
                baseUrl = meerkat.site.urls.base;
            }
            $elements.each(function() {
                var $this = $(this);
                $refreshButton = $(".simples-status-refresh");
                $container = $(".simples-status");
                refresh();
            });
            var $e = $("#simples-template-consultantstatus");
            if ($e.length > 0) {
                templateUsers = _.template($e.html());
            }
        });
    }
    function refresh() {
        meerkat.modules.loadingAnimation.showAfter($refreshButton);
        meerkat.modules.comms.get({
            url: baseUrl + "simples/users/list_online.json",
            cache: false,
            errorLevel: "silent",
            onSuccess: function onSuccess(json) {
                var htmlContent = "";
                if (typeof templateUsers !== "function") {
                    htmlContent = "Unsuccessful because: template not configured.";
                } else {
                    htmlContent = templateUsers(json);
                }
                $container.html(htmlContent);
            },
            onError: function onError(obj, txt, errorThrown) {
                $container.html("Unsuccessful because: " + txt + " " + errorThrown);
            },
            onComplete: function onComplete() {
                meerkat.modules.loadingAnimation.hide($refreshButton);
            }
        });
    }
    meerkat.modules.register("simplesUserStatus", {
        init: init
    });
})(jQuery);