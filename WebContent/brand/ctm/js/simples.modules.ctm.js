/*!
 * CTM-Platform v0.8.3
 * Copyright 2014 Compare The Market Pty Ltd
 * http://www.comparethemarket.com.au/
 */

(function($, undefined) {
    var meerkat = window.meerkat, log = meerkat.logging.info;
    function getBaseUrl() {
        if (meerkat.site && typeof meerkat.site.urls !== "undefined") {
            if (typeof meerkat.site.urls.context !== "undefined") {
                return meerkat.site.urls.context;
            } else if (typeof meerkat.site.urls.base !== "undefined") {
                return meerkat.site.urls.base;
            }
        }
    }
    meerkat.modules.register("simples", {
        getBaseUrl: getBaseUrl
    });
})(jQuery);

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
                meerkat.messaging.subscribe(meerkat.modules.events.simplesMessage.MESSAGE_CHANGE, function messageChange(obj) {
                    currentMessage = obj || false;
                    if (currentMessage.hasOwnProperty("transactionId")) {
                        currentTransactionId = currentMessage.transactionId;
                    }
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
            title: " ",
            buttons: [ {
                label: "Cancel",
                className: "btn-cancel",
                closeWindow: true
            }, {
                label: "Postpone",
                className: "btn-save btn-cta message-savebutton",
                closeWindow: false
            } ],
            onOpen: function postponeModalOpen(id) {
                modalId = id;
                var $modal = $("#" + modalId);
                var $button = $modal.find(".message-savebutton");
                $button.prop("disabled", true);
                meerkat.modules.dialogs.changeContent(modalId, meerkat.modules.loadingAnimation.getTemplate());
                meerkat.modules.comms.get({
                    url: "simples/ajax/message_statuses.json.jsp?parentStatusId=4",
                    dataType: "json",
                    cache: true,
                    errorLevel: "silent"
                }).done(function onSuccess(json) {
                    updateModal(json, templatePostpone);
                }).fail(function onError(obj, txt, errorThrown) {
                    updateModal(null, templatePostpone);
                }).always(function onComplete() {
                    $button.prop("disabled", false);
                    $("#postponehour").val("04");
                    var $picker = $modal.find("#postponedate_calendar");
                    $picker.datepicker({
                        startDate: "+0d",
                        endDate: "+6m",
                        clearBtn: false,
                        format: "yyyy-mm-dd"
                    }).find("table").addClass("table");
                    $modal.on("changeDate", $picker, function picker(e) {
                        $modal.find("#postponedate").val(e.format("yyyy-mm-dd"));
                    });
                    $button.on("click", function saveClick() {
                        $button.prop("disabled", true);
                        meerkat.modules.loadingAnimation.showInside($button, true);
                        var data = {
                            postponeDate: $modal.find("#postponedate").val(),
                            postponeTime: $modal.find("#postponehour").val() + ":" + $modal.find("#postponeminute").val(),
                            postponeAMPM: $modal.find('input[name="postponeampm"]:checked').val(),
                            reasonStatusId: $modal.find('select[name="reason"]').val(),
                            comment: $modal.find("textarea").val(),
                            assignToUser: $modal.find("#assigntome").is(":checked")
                        };
                        if (!_.isString(data.postponeDate) || data.postponeDate.length === 0 || (!_.isString(data.postponeAMPM) || data.postponeAMPM.length === 0)) {
                            meerkat.modules.dialogs.show({
                                title: " ",
                                htmlContent: "Please check fields: date, time and AM/PM.",
                                buttons: [ {
                                    label: "OK",
                                    className: "btn-cta",
                                    closeWindow: true
                                } ]
                            });
                            $button.prop("disabled", false);
                            meerkat.modules.loadingAnimation.hide($button);
                            return;
                        }
                        meerkat.modules.simplesMessage.performFinish("postpone", data, function performCallback() {
                            if ($homeButton.length > 0) $homeButton[0].click();
                            meerkat.modules.dialogs.close(modalId);
                        }, function callbackError() {
                            $button.prop("disabled", false);
                            meerkat.modules.loadingAnimation.hide($button);
                        });
                    });
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
                        message: txt + ": " + errorThrown
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
    var modalId = false, templateBlackList = false, action = false, $targetForm = false;
    function init() {
        $(document).ready(function() {
            $('[data-provide="simples-blacklist-action"]').on("click", "a", function(event) {
                event.preventDefault();
                action = $(this).data("action");
                var $e = $("#simples-template-blacklist-" + action);
                if ($e.length > 0) {
                    templateBlackList = _.template($e.html());
                }
                openModal();
            });
            $("#dynamic_dom").on("click", '[data-provide="simples-blacklist-submit"]', function(event) {
                event.preventDefault();
                performSubmit();
            });
        });
    }
    function openModal() {
        modalId = meerkat.modules.dialogs.show({
            title: " ",
            fullHeight: true,
            onOpen: function(id) {
                modalId = id;
                updateModal();
            },
            onClose: function() {}
        });
    }
    function updateModal(data) {
        var htmlContent = "No template found.";
        data = data || {};
        if (typeof templateBlackList === "function") {
            if (data.errorMessage && data.errorMessage.length > 0) {}
            htmlContent = templateBlackList(data);
        }
        meerkat.modules.dialogs.changeContent(modalId, htmlContent);
    }
    function performSubmit() {
        $targetForm = $("#simples-" + action + "-blacklist");
        if (validateForm()) {
            var formData = {
                action: action,
                value: $targetForm.find('input[name="phone"]').val().trim().replace(/\s+/g, ""),
                channel: $targetForm.find('select[name="channel"]').val().trim(),
                comment: $targetForm.find('textarea[name="comment"]').val().trim()
            };
            meerkat.modules.comms.post({
                url: "simples/ajax/blacklist_action.jsp",
                dataType: "json",
                cache: false,
                errorLevel: "silent",
                timeout: 5e3,
                data: formData,
                onSuccess: function onSuccess(json) {
                    updateModal(json);
                },
                onError: function onError(obj, txt, errorThrown) {
                    updateModal({
                        errorMessage: txt + ": " + errorThrown
                    });
                }
            });
        }
    }
    function validateForm() {
        if ($targetForm === false) return false;
        var phoneNumber = $targetForm.find('input[name="phone"]').val().trim().replace(/\s+/g, "");
        console.log(phoneNumber);
        var channel = $targetForm.find('select[name="channel"]').val().trim();
        var comment = $targetForm.find('textarea[name="comment"]').val().trim();
        var $error = $targetForm.find(".form-error");
        if (phoneNumber === "" || !isValidPhoneNumber(phoneNumber)) {
            $error.text("Please enter a valid phone number.");
            return false;
        }
        if (channel === "" || channel !== "phone" && channel !== "sms") {
            $error.text("Channel has to be either [Phone] or [SMS].");
            return false;
        }
        if (comment === "") {
            $error.text("Comment length can not be zero.");
            return false;
        }
        $error.text("");
        return true;
    }
    function isValidPhoneNumber(phone) {
        if (phone.length === 0) return true;
        var valid = true;
        var strippedValue = phone.replace(/[^0-9]/g, "");
        if (strippedValue.length === 0 && phone.length > 0) {
            return false;
        }
        var phoneRegex = new RegExp("^(0[234785]{1}[0-9]{8})$");
        valid = phoneRegex.test(strippedValue);
        return valid;
    }
    meerkat.modules.register("simplesBlackList", {
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
        $(window).resize(_.debounce(resizeIframe));
        if (window.addEventListener) {
            window.addEventListener("message", receiveMessage, false);
        }
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
            baseUrl = meerkat.modules.simples.getBaseUrl();
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
    var templateMessageDetail = false, currentMessage = false, $messageDetailsContainer, baseUrl = "";
    function init() {
        $(document).ready(function() {
            baseUrl = meerkat.modules.simples.getBaseUrl();
            $e = $("#simples-template-messagedetail");
            if ($e.length > 0) {
                templateMessageDetail = _.template($e.html());
            }
            $(".simples-menubar .simples-homebutton").on("click.simplesMessage", function clickHome(event) {
                setCurrentMessage(false);
                meerkat.messaging.publish(meerkat.modules.events.simplesInterface.TRANSACTION_ID_CHANGE, false);
            });
            var $checkSimplesHome = $(".simples-home");
            if ($checkSimplesHome.length > 0) {
                $(".message-getnext").on("click.simplesMessage", function clickNext(event) {
                    event.preventDefault();
                    var $button = $(event.target);
                    if ($button.prop("disabled") === true) {
                        return;
                    }
                    $button.prop("disabled", true).addClass("disabled");
                    $messageDetailsContainer.empty();
                    meerkat.modules.loadingAnimation.showInside($messageDetailsContainer);
                    getNextMessage(function nextComplete() {
                        $button.prop("disabled", false).removeClass("disabled");
                    });
                });
            }
            $messageDetailsContainer = $(".simples-message-details-container");
            if ($messageDetailsContainer.length > 0) {
                renderMessageDetails(false, $messageDetailsContainer);
                meerkat.messaging.subscribe(meerkat.modules.events.simplesMessage.MESSAGE_CHANGE, function messageChange(obj) {
                    renderMessageDetails(obj, $messageDetailsContainer);
                });
                $messageDetailsContainer.on("click", ".messagedetail-loadbutton", loadMessage);
            }
        });
    }
    function loadMessage(event) {
        event.preventDefault();
        if (currentMessage === false || !currentMessage.hasOwnProperty("messageId")) {
            alert("Message details have not been stored correctly - can not load.");
            return;
        }
        var $button = $(event.target);
        $button.prop("disabled", true).addClass("disabled");
        meerkat.modules.loadingAnimation.showAfter($button);
        meerkat.modules.comms.post({
            url: baseUrl + "simples/ajax/message_set_inprogress.jsp",
            dataType: "json",
            cache: false,
            errorLevel: "silent",
            data: {
                messageId: currentMessage.messageId
            },
            onSuccess: function onSuccess(json) {
                if (json.hasOwnProperty("errors") && json.errors.length > 0) {
                    alert("Could not set message to In Progress...\n" + json.errors[0].message);
                    $button.prop("disabled", false).removeClass("disabled");
                    meerkat.modules.loadingAnimation.hide($button);
                    return;
                }
                var url = "simples/loadQuote.jsp?brandId=" + currentMessage.styleCodeId + "&verticalCode=" + currentMessage.vertical + "&transactionId=" + encodeURI(currentMessage.newestTransactionId) + "&action=amend";
                log(url);
                meerkat.modules.simplesLoadsafe.loadsafe(url, true);
            },
            onError: function onError(obj, txt, errorThrown) {
                alert("Could not set message to In Progress...\n" + txt + ": " + errorThrown);
                $button.prop("disabled", false).removeClass("disabled");
                meerkat.modules.loadingAnimation.hide($button);
            }
        });
    }
    function getNextMessage(callbackComplete) {
        meerkat.modules.comms.get({
            url: baseUrl + "simples/messages/next.json",
            cache: false,
            errorLevel: "silent",
            onSuccess: function onSuccess(json) {
                if (json.messageId === 0) {
                    $messageDetailsContainer.html(templateMessageDetail(json));
                } else {
                    setCurrentMessage(json);
                }
            },
            onError: function onError(obj, txt, errorThrown) {
                var json = {
                    errors: [ {
                        message: txt + ": " + errorThrown
                    } ]
                };
                $messageDetailsContainer.html(templateMessageDetail(json));
            },
            onComplete: function onComplete() {
                if (typeof callbackComplete === "function") {
                    callbackComplete();
                }
            }
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
            url: baseUrl + "simples/ajax/message_set_" + type + ".jsp",
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
                setCurrentMessage(false);
                if (typeof callbackSuccess === "function") callbackSuccess();
            },
            onError: function onError(obj, txt, errorThrown) {
                alert("Could not set to " + type + "...\n" + txt + ": " + errorThrown);
                if (typeof callbackError === "function") callbackError();
            }
        });
    }
    function getCurrentMessage() {
        return currentMessage;
    }
    function setCurrentMessage(message) {
        if (window.self !== window.top) {
            window.top.meerkat.modules.simplesMessage.setCurrentMessage(message);
        }
        currentMessage = message;
        meerkat.messaging.publish(moduleEvents.MESSAGE_CHANGE, currentMessage);
    }
    function renderMessageDetails(message, $destination) {
        $destination = $destination || false;
        if ($destination === false || $destination.length === 0) return;
        if (message === false) {
            $(".simples-home-buttons, .simples-notice-board").removeClass("hidden");
        } else {
            $(".simples-home-buttons, .simples-notice-board").addClass("hidden");
        }
        $destination.html(templateMessageDetail(message));
    }
    meerkat.modules.register("simplesMessage", {
        init: init,
        events: events,
        getNextMessage: getNextMessage,
        getCurrentMessage: getCurrentMessage,
        setCurrentMessage: setCurrentMessage,
        performFinish: performFinish,
        renderMessageDetails: renderMessageDetails
    });
})(jQuery);

(function($, undefined) {
    var meerkat = window.meerkat, log = meerkat.logging.info;
    var templatePQ = false, $container = false, baseUrl = "", viewMessageInProgress = false;
    function init() {
        $(document).ready(function() {
            $container = $(".simples-postpone-queue-container");
            if ($container.length === 0) return;
            baseUrl = meerkat.modules.simples.getBaseUrl();
            initDateStuff();
            var $e = $("#simples-template-postponed-queue");
            if ($e.length > 0) {
                templatePQ = _.template($e.html());
            }
            $container.on("click.viewMessage", ".simples-postponed-message", viewMessage);
            meerkat.messaging.subscribe(meerkat.modules.events.simplesMessage.MESSAGE_CHANGE, function messageChange(obj) {
                var $messages = $container.find(".simples-postponed-message");
                $messages.removeClass("active");
                if (obj !== false) {
                    $messages.filter('[data-messageId="' + obj.messageId + '"]').addClass("active");
                }
            });
            refresh();
        });
    }
    function initDateStuff() {
        Date.locale = {
            month_names: [ "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December" ],
            month_names_short: [ "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec" ],
            day_of_week: [ "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday" ],
            day_of_week_short: [ "Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat" ]
        };
        Date.prototype.getMonthName = function(asUTC) {
            if (asUTC === true) {
                return Date.locale.month_names[this.getUTCMonth()];
            } else {
                return Date.locale.month_names[this.getMonth()];
            }
        };
        Date.prototype.getMonthNameShort = function(asUTC) {
            if (asUTC === true) {
                return Date.locale.month_names_short[this.getUTCMonth()];
            } else {
                return Date.locale.month_names_short[this.getMonth()];
            }
        };
        Date.prototype.getDayName = function(asUTC) {
            if (asUTC === true) {
                return Date.locale.day_of_week[this.getUTCDay()];
            } else {
                return Date.locale.day_of_week[this.getDay()];
            }
        };
        Date.prototype.getDayNameShort = function(asUTC) {
            if (asUTC === true) {
                return Date.locale.day_of_week_short[this.getUTCDay()];
            } else {
                return Date.locale.day_of_week_short[this.getDay()];
            }
        };
    }
    function viewMessage(event) {
        event.preventDefault();
        var $element = $(event.target);
        if (!$element.hasClass("simples-postponed-message")) {
            $element = $element.parents(".simples-postponed-message");
        }
        if (viewMessageInProgress === true || $element.hasClass("disabled") || $element.hasClass("active")) {
            return;
        }
        var messageId = $element.attr("data-messageId");
        viewMessageInProgress = true;
        meerkat.modules.loadingAnimation.showInside($element);
        $element.addClass("disabled");
        meerkat.modules.comms.get({
            url: baseUrl + "simples/messages/get.json?messageId=" + encodeURI(messageId),
            cache: false,
            errorLevel: "silent",
            useDefaultErrorHandling: false
        }).done(function onSuccess(json) {
            if (!json.hasOwnProperty("transactionId")) {
                alert("Failed to load message: invalid response");
            } else {
                meerkat.modules.simplesMessage.setCurrentMessage(json);
            }
        }).fail(function onError(obj, txt, errorThrown) {
            if (obj.hasOwnProperty("responseJSON") && obj.responseJSON.hasOwnProperty("errors") && obj.responseJSON.errors.length > 0) {
                alert("Failed to load message\n" + obj.responseJSON.errors[0].message);
            } else {
                alert("Unsuccessful because: " + txt + ": " + errorThrown);
            }
        }).always(function onComplete() {
            viewMessageInProgress = false;
            meerkat.modules.loadingAnimation.hide($element);
            $element.removeClass("disabled");
        });
    }
    function refresh() {
        if ($container === false || $container.length === 0) return;
        $container.html("Fetching postponed queue...");
        meerkat.modules.comms.get({
            url: baseUrl + "simples/messages/postponed.json",
            cache: false,
            errorLevel: "silent",
            useDefaultErrorHandling: false
        }).done(function onSuccess(json) {
            var htmlContent = "";
            if (typeof templatePQ !== "function") {
                htmlContent = "Unsuccessful because: template not configured.";
            } else {
                htmlContent = templatePQ(json);
            }
            $container.html(htmlContent);
        }).fail(function onError(obj, txt, errorThrown) {
            $container.html("Unsuccessful because: " + txt + ": " + errorThrown);
        });
    }
    meerkat.modules.register("simplesPostponedQueue", {
        init: init
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
            useDefaultErrorHandling: false,
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
                }
                updateModal(data);
                if (data.hasOwnProperty("errorMessage") === false) {
                    jsonViewer(data.results);
                }
            },
            onError: function onError(obj, txt, errorThrown) {
                updateModal({
                    errorMessage: txt + ": " + errorThrown
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
            } else if (results[i].hasOwnProperty("homeloan")) {
                id = results[i].id + " - Home Loan";
                obj[id] = {};
                obj[id] = results[i].homeloan;
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
            $("#" + modalId + " .modal-header").empty().prepend($("#" + modalId + " #simples-search-modal-header"));
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
                $button.text("Less details");
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
            useDefaultErrorHandling: false,
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
                }
                updateModal(data);
            },
            onError: function onError(obj, txt, errorThrown) {
                updateModal({
                    errorMessage: txt + ": " + errorThrown
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
            $("#" + modalId + " .modal-header").empty().prepend($("#" + modalId + " #simples-search-modal-header"));
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
    var currentTransactionId = 0, intervalSeconds = 1500, timer;
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
        meerkat.modules.comms.get({
            url: "simples/tickle",
            cache: false,
            errorLevel: "silent",
            useDefaultErrorHandling: false,
            timeout: 5e3,
            data: {
                transactionId: currentTransactionId
            },
            onError: function onError(obj, txt, errorThrown) {
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
            useDefaultErrorHandling: false,
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
                $container.html("Unsuccessful because: " + txt + ": " + errorThrown);
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