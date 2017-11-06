$(document).ready(function () {
    // PNG Fix for the obsolete trashpile that is IE6
    if ($.browser.msie && $.browser.version < 7) {
        $(document).pngFix();
    }

    // force the radio button to be checked when using the tab key to navigate
    /* Disabled as per PRJHNC-129
     * $('input[type=radio]').on('focus', function(){
     $(this).trigger('click');
     });*/

    // make sure that when the checked radio changes, the other radio buttons don't have the focus state anymore
    $('input[type=radio]').on('change', function () {
        var notCheckedRadios = $(this).not(":checked");
        notCheckedRadios.each(function () {
            var radioId = $(this).attr('id');
            $("label[for=" + radioId + "]").removeClass('ui-state-focus');
        });
    });

});

QuoteEngine = new Object();
QuoteEngine = {

    _options: {},
    _onResults: false,
    _allowNavigation: true,
    _callbackIfNavigationIsDisabled: function () {
    },

    _init: function (options) {

        QuoteEngine._options = $.extend({
            currentSlide: 0,
            prevSlide: -1,
            animating: false,
            nav: true,
            lastSlide: 5,
            speed: "fast",
            noAnimation: false,
            trackOnStep: true
        }, options);

        $('#save-quote').hide();

        // Set up the Scrollable windows
        var root = $('#qe-wrapper').scrollable({
            'items': '#qe-main',
            'item': '.qe-screen',
            'keyboard': false
        }).navigator();

        // add support for the enter key to validate and submit the form of the current slide
        root.on("keydown", function (e) {
            if (e.keyCode == 13 || e.keyCode == 108) {
                // seeks to next tab by executing our validation routine
                $("#next-step").trigger("click");
                e.preventDefault();
            }
        });


        slide_callbacks.register({
            mode: 'before',
            slide_id: -1,
            callback: function () {

                // before changing slide, make all the slides visible
                $(".qe-screen").css("visibility", "visible");

                QuoteEngine.resetValidation();
                $("#mainform").find("*").removeClass("errorGroup");

            }
        });

        // after changing slide animation is done, hide all slides except the current one
        // => avoids the Ctrl+F/Find in page to break the layout of the slider
        // => also avoids the use of the tab key to change slide and break the layout of the slider
        slide_callbacks.register({
            mode: 'after',
            slide_id: -1,
            callback: function () {

                $(".qe-screen").removeClass("currentSlide");
                $("#slide" + QuoteEngine.getCurrentSlide()).addClass("currentSlide");
                $(".qe-screen:not(.currentSlide)").css("visibility", "hidden");

            }
        });


        slide_callbacks.call('after', 0, -1);

        this._options.nav = $("#qe-wrapper").data("scrollable");
        if (this._options.nav) {
            // Just after click and just before scroll
            this._options.nav.onBeforeSeek(function (elm, idx) {
                // don't navigate if the user is on the confirmation page or an application is pending
                if (!QuoteEngine._allowNavigation) {
                    if (QuoteEngine._callbackIfNavigationIsDisabled) {
                        QuoteEngine._callbackIfNavigationIsDisabled();
                    }
                    return false;
                }
                QuoteEngine._options.animating = true;
                QuoteEngine._options.trackOnStep = true;

                QuoteEngine._options.prevSlide = QuoteEngine._options.currentSlide;
                QuoteEngine._options.currentSlide = idx;

                slide_callbacks.call('before', idx, QuoteEngine._options.prevSlide ? QuoteEngine._options.prevSlide : 0);

                if (QuoteEngine._options.noAnimation) {
                    $('#slide' + QuoteEngine._options.prevSlide).css({'max-height': '300px'});
                    $('#slide' + QuoteEngine._options.currentSlide).css({'max-height': '5000px'});
                } else {
                    $('#slide' + QuoteEngine._options.prevSlide).animate({'max-height': '300px'}, 750);
                    $('#slide' + QuoteEngine._options.currentSlide).animate({'max-height': '5000px'}, 750);
                }
                if (idx == 0) {
                    $('.prev').fadeOut("fast");
                } else {
                    $('.prev').fadeIn("fast");
                }
            });
            this._options.nav.onSeek(function (elm, idx) {
                QuoteEngine.updateAddress(idx);
                QuoteEngine.ProgressBarUpdate(idx);
                if (QuoteEngine._options.trackOnStep) {
                    Track.nextClicked(idx);
                }

                if (idx == QuoteEngine._options.lastSlide) {
                    if (typeof Captcha !== 'undefined' && $("#captcha_code").val() != "") {
                        Captcha.reload();
                    }
                }
                if (QuoteEngine._options.prevSlide > -1) {
                    $('body').removeClass('stage-' + QuoteEngine._options.prevSlide);
                }
                $('body').addClass('stage-' + QuoteEngine._options.currentSlide);

                QuoteEngine._options.animating = false;

                slide_callbacks.call('after', idx, QuoteEngine._options.prevSlide ? QuoteEngine._options.prevSlide : 0);
            });
        }
        $(".prev").hide();

        $("#live-help").click(function () {
            this._options.nav.next();
        });

        $('.text input, textarea').addClass('ui-widget ui-widget-content ui-corner-left ui-corner-right');

        this._options.lastSlide = $('#qe-main .qe-screen').length - 1;

    },
    nextSlide: function (callback) {
        if (callback) {
            this._nextCallback = callback;
            return;
        } else if (this._options.animating) {
            return;
        }
        var ok = true;
        if (this._nextCallback) {
            ok = this._nextCallback(this._options.currentSlide);
        }
        if (ok) {
            if (this._options.currentSlide < this._options.lastSlide) {
                this._options.nav.next(QuoteEngine._options.noAnimation ? 1 : QuoteEngine._options.speed);
                this.scrollTo('html');
            } else {
                QuoteEngine.completed();
            }
        }
    },
    prevSlide: function (callback) {
        if (callback) {
            this._prevCallback = callback;
            return;
        } else if (this._options.animating) {
            return;
        }

        var ok = true;
        if (this._prevCallback) {
            ok = this._prevCallback(this._options.currentSlide);
        }
        if (ok) {
            if (this._options.currentSlide > 0) {
                this._options.nav.prev(QuoteEngine._options.noAnimation ? 1 : QuoteEngine._options.speed);
                this.scrollTo('html');
            }
        }
    },
    gotoSlide: function (options) {

        options = $.extend({
            index: 0,
            speed: QuoteEngine._options.speed,
            callback: false,
            noAnimation: QuoteEngine._options.noAnimation
        }, options);

        if (this._options.animating) {
            return;
        }

        if (options.index < 0 || options.index > this._options.lastSlide) {
            return;
        }

        this._options.nav.seekTo(options.index, options.speed, options.callback);

        $.address.parameter("stage", (options.index == 0 ? "start" : options.index), false);
        FormElements.errorContainer.hide();
    },
    updateAddress: function (stage) {
        if (!stage) {
            stage = this._options.currentSlide == 0 ? "start" : this._options.currentSlide;
            $.address.parameter("stage", stage, false);
        } else {
            $.address.parameter("stage", stage, false);
        }
    },
    getCurrentSlide: function () {
        return this._options.currentSlide;
    },
    setOnResults: function (onResults) {
        this._onResults = onResults;
    },
    getOnResults: function () {
        return this._onResults;
    },
    ProgressBarUpdate: function (idx) {
        var _count = 0;
        $('#steps').find('li').each(function () {
            if (_count == idx) {
                $(this).removeClass('complete').addClass('current');
            } else if (_count < idx) {
                $(this).removeClass('current').addClass('complete');
            } else {
                $(this).removeClass('complete current');
            }
            ;
            _count++;
        });
    },
    completed: function (callback) {
        if (document.severSideValidation) {
            $('#slideErrorContainer ul').empty();
            $('#slideErrorContainer').hide();
            $('.error').removeClass("error");
            $('.errorGroup').removeClass("errorGroup");
            document.severSideValidation = false;
        }
        if (callback) {
            this._completedCallback = callback;
        } else if (this._completedCallback) {
            this._completedCallback();
        }
    },
    validate: function (submitOnValid) {
        var isValid = true;
        $("#mainform").validate().resetNumberOfInvalids();

        // Validate the form
        var inputs;
        if ($('#qe-wrapper') && $('#qe-wrapper').length) {
            inputs = $('#slide' + QuoteEngine._options.currentSlide + ' :input');
        } else {
            inputs = $('#content :input');
        }

        inputs.each(function (index) {
            var id = $(this).attr("id");
            if (id && ((!$(this).not('.validate').is(':hidden') && typeof $(this).attr("disabled") == 'undefined') || $(this).hasClass('state-force-validate'))) {
                $("#mainform").validate().element("#" + id);
            }
        });

        isValid = ($("#mainform").validate().numberOfInvalids() == 0);
        if(!isValid) {
            try {
                QuoteEngine.logValidationErrors();
            } catch(e) {
                // do nothing
            }
        }
        if (isValid && submitOnValid) {
            QuoteEngine.completed();
        }
        return isValid;
    },
    getValueFromElement: function ($el) {
        if ($el.attr('type') == 'radio' || $el.attr('type') == 'checkbox') {
            return $('input[name=' + $el.attr('name') + ']:checked').val() || "";
        }
        return $el.val() || "";
    },
    logValidationErrors: function () {
        var data = [], i = 0;

        data.push({
            name: 'stepId',
            value: QuoteEngine._options.currentSlide
        });
        data.push({
            name: 'transactionId',
            value: referenceNo.getTransactionID()
        });

        data.push({
            name: 'hasPrivacyOptin',
            value: $('#' + Settings.vertical + '_privacyoptin').prop('checked')
        });

        $('.error:visible', '.slideErrorContainer').each(function () {
            var xpath = $(this).attr('for');
            if (typeof xpath === 'undefined') {
                return;
            }
            var value = QuoteEngine.getValueFromElement($(':input[name=' + xpath + ']')),
                message = $(this).text();
            data.push({
                name: xpath,
                value: value + "::" + message
            });

            if (i < 5) {
                Track.runTrackingCall('errorTracking', {
                    method: 'errorTracking',
                    object: {
                        error: {
                            name: xpath,
                            validationMessage: message
                        }
                    }
                });
            }

            i++;
        });

        if (i === 0) {
            return false;
        }

        return $.ajax({
            type: 'POST',
            url: "logging/validation.json?brandCode=" + meerkat.site.urlStyleCodeId,
            data: data,
            dataType: 'json',
            cache: true
        });
    },
    resetValidation: function () {
        $("#mainform").validate().resetNumberOfInvalids();
        $("#mainform").validate().resetForm();
        if (!$("#helpToolTip").is(':hidden')) $("#helpToolTip").fadeOut(100);
        FormElements.errorContainer.hide();
    },
    scrollTo: function (id, time) {
        if (time == undefined) {
            var time = 500
        }
        ;
        if (id == undefined) {
            var id = 'html'
        }
        ;
        var $_x = $('#loading-popup:visible');
        if ($_x) {
            $_x.css('position', 'fixed').css('top', ($(window).height() - $_x.height()) / 2 + 'px');
        }
        ;
        $('html, body').animate({scrollTop: $(id).offset().top}, time);
    },
    poke: function () {
        if (typeof sessionExpiry != 'undefined') {
            sessionExpiry.poke();
        }
        ;
    }
};

$(document).ready(function () {
    QuoteEngine._init({
        currentSlide: 0,
        prevSlide: -1,
        animating: false,
        nav: true,
        lastSlide: 5,
        speed: "fast",
        noAnimation: false
    });
});


// Results Page Basket
var Basket = new Object();
Basket = {
    prefix: 'basket-item-', // HTML prefix
    basketItems: [], // Internal item IDs

    create: function (container) {
        this.container = (container || $('#basket'));

        var self = this;

        $('a.remove')
            .live('click', function () {
                self.removeItem($(this).closest('.item').attr('id'));
            });
    },

    addItem: function (identifier, hideOnEmpty) {
        if (!this.isFull() && !this.hasItem(identifier)) {
            this.basketItems.push(identifier);

            if ($(this.container).not(':visible')) {
                $(this.container).slideDown('fast');
            }

            // Now create the item and append it
            var item = this._createItem(identifier);
            $(this.container).find('.basket-items').append(item);

            // Animate the fakery
            var trigger = $('#' + identifier);
            var target = $(this.container); // From above

            var mockItem = $('<div class="animation-mock-item">').appendTo('body').css({
                width: trigger.width(),
                height: trigger.height(),
                top: trigger.offset().top,
                left: trigger.offset().left,
                'z-index': 30
            });

            mockItem.animate({
                width: Math.max(target.width(), 200),
                height: Math.max(target.height(), 80),
                top: target.offset().top,
                left: target.offset().left,
                opacity: '0.20'
            }, 400, "easeInOutQuint", function () {
                $(item).slideDown("fast");
                $(this).remove();
            });

            // IE6,7 don't like the animate function, so never show the element
            // In this case, we are punishing ie8,9 as well
            if ($.browser.msie && !$(item).is(':visible')) {
                $(item).slideDown(400);
            }
            if (hideOnEmpty) {
                if (this.basketItems.length == 3) {
                    $('.compare-selected').removeClass("compareInActive");
                } else {
                    $('.compare-selected').addClass("compareInActive");
                }
            }

            return true;
        }

        return false;
    },

    _createItem: function (identifier) {
        var elm = $('#' + identifier);

        var item =
            '<div class="item" id="' + this.prefix + identifier + '" style="display:none;">' +
            '	<a href="javascript:void(0);" class="remove">Remove</a>' +
            '	<div class="thumb"><img src="' + elm.find('.companyLogo').css('background-image').replace(/^url\((.*?)\)$/, '$1');
        +'" alt="" /></div>' +
        '	<div class="description"><h3>' + elm.find('h3').html() + '	</h3></div>' +
        '</div>';

        return $(item);
    },

    removeItem: function (identifier, hideOnEmpty) {

        // Clean the ID. We have 2 sources for it, so we need to ensure no prefix
        var _pre = new RegExp(this.prefix);
        var _identifier = identifier.replace(_pre, '');

        this.basketItems = $.map(this.basketItems, function (elm) {
            var _elm = elm.replace(_pre, '');

            if (_elm != _identifier) {
                return elm;
            }
        });

        // Uncheck the compare button in the table
        $('#' + _identifier).find('a.compare').removeClass('compare-on');

        // Update the "compare" button
        if (hideOnEmpty) {
            switch (this.basketItems.length) {
                case 1:
                    $(".compare-selected").slideUp(400);
                    $(".compare-pick-one").slideUp(400);
                    $(".compare-pick-two").slideDown(400);
                    break;
                case 2:
                    $(".compare-pick-one").slideDown(400);
                    break;
            }
        }

        if (this.isEmpty() && hideOnEmpty) {
            $(this.container).slideUp(400);
        }

        return true;
    },

    clear: function (hide) {
        while (this.basketItems.length > 0) {
            this.removeItem(this.basketItems.pop());
        }
        if (hide) {
            $(this.container).hide();
        }
    },

    isFull: function () {
        return (this.basketItems.length == 3);
    },

    isEmpty: function () {
        return (this.basketItems.length == 0);
    },

    hasItem: function (identifier) {
        return (!!($.inArray(identifier, this.basketItems) > -1));
    },
    itemPosition: function (identifier) {
        return (($.inArray(identifier, this.basketItems)) + 1);
    }
};

var RegisteredSlideCallback = function (params) {
    var that = this,
        params = $.extend({
            mode: "after", // Before / After
            direction: false, // false, forward or reverse
            slide_id: 0, // negative number for any slide
            callback: null
        }, params);

    var canCall = function (mode, slide_id, current_slide) {
        return mode == params.mode &&
            (params.slide_id < 0 || (params.slide_id == slide_id && typeof params.callback == 'function')) &&
            (params.direction === false || ((params.direction == 'forward' && current_slide < slide_id) || (params.direction == 'reverse' && current_slide > slide_id)));
    };

    this.call = function (mode, slide_id, current_slide) {
        if (canCall(mode, slide_id, current_slide)) {
            params.callback();
        }
    };
};

var SlideCallbacks = function () {
    var that = this,
        callbacks = [];

    this.register = function (params) {
        callbacks.push(new RegisteredSlideCallback(params));
    };

    this.call = function (mode, slide_id, current_slide) {
        for (var i in callbacks) {
            if (typeof callbacks[i] == "object" && callbacks[i].constructor === RegisteredSlideCallback) {
                callbacks[i].call(mode, slide_id, current_slide);
            }
        }
    };
};

var slide_callbacks = new SlideCallbacks();

var Rankings = function () {

    this.writeRanking = function (rootPath, sortedPrices, sortBy, sortDir, includePremium) {
        var qs = "rootPath=" + rootPath + "&rankBy=" + sortBy + "-" + sortDir +
            "&rank_count=" + sortedPrices.length + "&transactionId" + referenceNo.getTransactionID() + "&";
        for (var i = 0; i < sortedPrices.length; i++) {
            var price = sortedPrices[i];
            var prodId = price.productId.replace('PHIO-HEALTH-', '');
            ;
            qs += "rank_productId" + i + "=" + prodId + "&";
            if (includePremium) {
                qs += "rank_premium" + i + "=" + price.premium.monthly.value + "&";
            }
        }
        $.ajax({
            url: "ajax/write/quote_ranking.jsp",
            data: qs,
            type: 'POST'
        });
    };
};

var rankings = new Rankings();
var Health = new Object();
Write = {
    touchQuote: function (touchtype, callback, comment, allData) {
        comment = comment || false;
        allData = allData || false;

        var dat = {
            touchtype: touchtype,
            quoteType: Settings.vertical
        };

        if (allData === false) {
            dat.transactionId = referenceNo.getTransactionID();
        }

        if (comment != null && comment !== false && comment.length > 0) {
            dat.comment = comment;
        }

        var slideId = '#slide' + QuoteEngine.getCurrentSlide();
        var slideFields = $(slideId + ' input ,' + slideId + ' select,' + slideId + ' textarea');
        slideFields.each(function () {
            if ($(this).is(":visible")) {
                $(this).attr("data-visible", "true");
            } else {
                $(this).removeAttr("data-visible");
            }
        });

        //Send form data unless recording a Fail
        if (allData === true) {
            dat = $.param(dat) + '&' + serialiseWithoutEmptyFields('#mainform');
        }

        $.ajax({
            url: "ajax/json/access_touch.jsp",
            data: dat,
            dataType: "json",
            type: "POST",
            async: true,
            timeout: 60000,
            cache: false,
            beforeSend: function (xhr, setting) {
                var url = setting.url;
                var label = "uncache",
                    url = url.replace("?_=", "?" + label + "=");
                url = url.replace("&_=", "&" + label + "=");
                setting.url = url;
            },
            success: function (jsonResult) {
                var success = Number(jsonResult.result.success);
                var transactionId = Number(jsonResult.result.transactionId);
                if (transactionId > 0) {
                    referenceNo.setTransactionId(transactionId);
                }
                if (typeof callback == "function") {
                    callback(success, transactionId);
                }
                if (!success) {
                    FatalErrorDialog.exec({
                        message: jsonResult.result.message,
                        page: "quote-engine.js",
                        description: "Write.touchQuote(). JSON result was not successful: " + jsonResult.result.message,
                        data: dat
                    });
                }
            },
            error: function (obj, txt) {
                FatalErrorDialog.exec({
                    message: "An undefined error has occurred - please try again later.",
                    page: "quote-engine.js",
                    description: "Write.touchQuote(). AJAX request failed: " + txt,
                    data: dat
                });
            }
        });

        return true;
    }
}

Object.byString = function (o, s) {
    s = s.replace(/\[(\w+)\]/g, '.$1'); // convert indexes to properties
    s = s.replace(/^\./, '');           // strip a leading dot
    var a = s.split('.');
    while (a.length) {
        var n = a.shift();
        if (typeof(o) == "object") {
            if (n in o) {
                o = o[n];
            } else {
                return;
            }
        } else return false;
    }
    return o;
}
