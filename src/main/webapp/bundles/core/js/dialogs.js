////////////////////////////////////////////////////////////
//// SIMPLE DIALOG                                      ////
////----------------------------------------------------////
//// This allows you to display a simple dialog modal   ////
//// window using bootstrap								////
////////////////////////////////////////////////////////////
/*

 USAGE EXAMPLE: Call directly

 // Open the modal
 var modalId = meerkat.modules.dialogs.show({
 htmlContent: '<p>Hello!</p>',
 buttons: [{
 label: 'Close',
 className: 'btn-cancel',
 closeWindow: true
 }],
 onOpen: function(id) {
 // Switch content
 meerkat.modules.dialogs.changeContent(id, '<iframe src="ajax/html/example.jsp"></iframe>');
 }
 });

 // Close and destroy the modal
 meerkat.modules.dialogs.close(modalId);

 */

;(function ($, undefined) {

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        log = meerkat.logging.info,
        isXS;

    var windowCounter = 0,
        dialogHistory = [],
        openedDialogs = [],
        defaultSettings = {
            title: '',
            htmlContent: null,
            url: null,
            externalUrl: null,
            cacheUrl: false,
            buttons: [],
            className: '',
            leftBtn: {
                label: 'Back',
                icon: '',
                className: 'btn-sm btn-close-dialog',
                callback: null
            },
            rightBtn: {
                label: '',
                icon: '',
                className: '',
                callback: null
            },
            showCloseBtn: true,
            tabs: [],
            htmlHeaderContent: '',
            hashId: null,
            destroyOnClose: true,
            closeOnHashChange: false,
            openOnHashChange: true,
            fullHeight: false, // By default, a modal shorter than the viewport will be centred. Set to true to vertically fill the viewport.
            forceShowFooter: false,
            templates: {
                dialogWindow: '<div id="{{= id }}" class="modal" tabindex="-1" role="dialog" aria-labelledby="{{= id }}_title" aria-hidden="true"{{ if(fullHeight===true){ }} data-fullheight="true"{{ } }}>' +
                '<div class="modal-dialog {{= className }}">' +

                '<div class="modal-content">{{ if(showCloseBtn == true) { }}' +
                '<div class="modal-closebar">' +
                '	<a href="javascript:;" class="btn btn-close-dialog"><span class="icon icon-cross"></span></a>' +
                '</div>{{ } }}' +
                '<div class="navbar navbar-default xs-results-pagination visible-xs">' +
                '<div class="container">' +
                '<ul class="nav navbar-nav">' +
                '<li>' +
                '<button data-button="leftBtn" class="btn btn-back {{= leftBtn.className }}">{{= leftBtn.icon }} {{= leftBtn.label }}</button>' +
                '</li>' +
                '<li class="navbar-text modal-title-label">' +
                '	{{= title }}' +
                '</li>' +
                '{{ if(rightBtn.label != "" || rightBtn.icon != "") { }}' +
                '<li class="right">' +
                '<button data-button="rightBtn" class="btn btn-save {{= rightBtn.className }}">{{= rightBtn.label }} {{= rightBtn.icon }}</button>' +
                '</li>' +
                '{{ } }}' +
                '</ul>' +
                '</div>' +
                '</div>' +
                '{{ if(title != "" || tabs.length > 0 || htmlHeaderContent != "" ) { }}' +
                '<div class="modal-header">' +
                '{{ if (tabs.length > 0) { }}' +
                '<ul class="nav nav-tabs tab-count-{{= tabs.length }}">' +
                '{{ _.each(tabs, function(tab, iterator) { }}' +
                '<li><a href="javascript:;" data-target="{{= tab.targetSelector }}" title="{{= tab.xsTitle }}">{{= tab.title }}</a></li>' +
                '{{ }); }}' +
                '</ul>' +
                '{{ } else if(title != "" ){ }}' +
                '<h4 class="modal-title hidden-xs" id="{{= id }}_title">{{= title }}</h4>' +
                '{{ } else if(htmlHeaderContent != "") { }}' +
                '{{= htmlHeaderContent }}' +
                '{{ } }}' +
                '</div>' +
                '{{ } }}' +
                '<div class="modal-body">' +
                '{{= htmlContent }}' +
                '</div>' +
                '{{ if(typeof buttons !== "undefined" && buttons.length > 0 ){ }}' +
                '<div class="modal-footer {{ if(buttons.length > 1 || forceShowFooter === true ){ }} mustShow {{ } }}">' +
                '{{ _.each(buttons, function(button, iterator) { }}' +
                '<button data-index="{{= iterator }}" type="button" class="btn {{= button.className }} ">{{= button.label }}</button>' +
                '{{ }); }}' +
                '</div>' +
                '{{ } }}' +
                '</div>' +
                '</div>' +
                '</div>'
            },
            /*jshint +W112 */
            onOpen: function (dialogId) {
            },
            onClose: function (dialogId) {
            },
            onLoad: function (dialogId) {
            }
        };

    function show(instanceSettings) {

        var settings = $.extend({}, defaultSettings, instanceSettings);
        isXS = meerkat.modules.deviceMediaState.get() === "xs" ? true : false;

        var id = "mkDialog_" + windowCounter;
        if (!_.isUndefined(settings.id)) {
            if (isDialogOpen(settings.id)) {
                close(settings.id);
            }
        } else {
            settings.id = id;
            windowCounter++;
        }

        if (settings.hashId != null) {
            // append the dialogs hash id to the window hash.
            meerkat.modules.address.appendToHash(settings.hashId);
        }
        var htmlTemplate = _.template(settings.templates.dialogWindow);

        if (settings.url != null || settings.externalUrl != null) {
            // Load content from dynamic source, insert loading icon until content loads
            settings.htmlContent = meerkat.modules.loadingAnimation.getTemplate();
        }

        var htmlString = htmlTemplate(settings);
        $("#dynamic_dom").append(htmlString);

        var $modal = $('#' + settings.id);

        // Launch the Bootstrap modal. The backdrop setting determines if the backdrop is clickable (to close) or not.
        $modal.modal({
            show: true,
            backdrop: settings.buttons && settings.buttons.length > 0 ? 'static' : true,
            keyboard: false
        });

        // Stack those backdrops.
        $modal.css('z-index', parseInt($modal.eq(0).css('z-index')) + (openedDialogs.length * 10));
        var $backdrop = $('.modal-backdrop');
        $backdrop.eq($backdrop.length - 1).css('z-index', parseInt($backdrop.eq(0).css('z-index')) + (openedDialogs.length * 10));

        // Wait for Bootstrap to tell us it has closed a modal, then run our own close functions.
        $modal.on('hidden.bs.modal', function (event) {
            if (typeof event.target === 'undefined') return;
            var $target = $(event.target);
            if ($target.length === 0 || $target.hasClass('modal') === false) return;

            // Run our close functions
            doClose($target.attr('id'));
        });

        // When changing tabs, resize the modal to accommodate the content.
        $modal.on('shown.bs.tab', function (event) {
            resizeDialog(settings.id);
        });

        $modal.find('button').on('click', function onModalButtonClick(eventObject) {
            var button = settings.buttons[$(eventObject.currentTarget).attr('data-index')];

            if (!_.isUndefined(button)) {
                // If this is a close button, tell Bootstrap to close the modal
                if (button.closeWindow === true) {
                    $(eventObject.currentTarget).closest('.modal').modal('hide');
                }

                // Run the callback
                if (typeof button.action === 'function') button.action(eventObject);
            }
        });

        // todo, shouldn't need to off the previous call... can't use settings.buttons as it can't be $.extend'ed
        $modal.find('.navbar-nav button').off().on('click', function onModalTitleButtonClick(eventObject) {
            var button = settings[$(eventObject.currentTarget).attr('data-button')];
            if (typeof button != 'undefined' && typeof button.callback == 'function')
                button.callback(eventObject);
        });

        if (settings.url !== null) {
            meerkat.modules.comms.get({
                url: settings.url,
                cache: settings.cacheUrl,
                errorLevel: "warning",
                onSuccess: function dialogSuccess(result) {
                    changeContent(settings.id, result);

                    // Run the callback
                    if (typeof settings.onLoad === 'function') settings.onLoad(settings.id);
                }
            });
        }

        if (settings.externalUrl != null) {
            var iframe = '<iframe class="displayNone" id="' + settings.id + '_iframe" width="100%" height="100%" frameborder="0" scrolling="no" allowtransparency="true" src="' + settings.externalUrl + '"></iframe>';
            appendContent(settings.id, iframe);

            $('#' + settings.id + '_iframe').on("load", function () {

                // calculate size of iframe content
                // console.log("scoll height", this.contentWindow.document.body.scrollHeight);
                //console.log("height", this.contentWindow.document.body.height);

                // show the iframe
                $(this).show();

                // remove the loading
                meerkat.modules.loadingAnimation.hide($('#' + settings.id));

            });
        }

        /**
         * Had to add a slight delay before calculating heights as it seems the DOM is not
         * always ready after the previous DOM manipulations (either 0 or incorrect height)
         * see window.setTimout after this.
         */
        window.setTimeout(function () {
            resizeDialog(settings.id);
        }, 0);

        // Run the callback
        if (typeof settings.onOpen === 'function') settings.onOpen(settings.id);

        openedDialogs.push(settings);

        return settings.id;
    }

    // Tell Bootstrap to close this modal
    // Our follow-up close/destroy methods will run when we receive the hidden.bs.modal event
    function close(dialogId) {
        $('#' + dialogId).modal('hide');
    }

    function doClose(dialogId) {
        // If there are still other modals open we need to retain the modal-open class
        // Bootstrap removes the class so we need to add it back.
        if (openedDialogs.length > 1) {
            // Defer because Bootstrap's removeClass executes after our event
            _.defer(function () {
                // Double check
                if (openedDialogs.length > 0 && openedDialogs[0].id !== dialogId) {
                    $(document.body).addClass('modal-open');
                }
            });
        }

        // Run the callback
        var settings = getSettings(dialogId);
        if (settings !== null && typeof settings.onClose === 'function') {
            settings.onClose(dialogId);
        }
        if (settings.destroyOnClose === true) {
            destroyDialog(dialogId);
        } else {
            meerkat.modules.address.removeFromHash(settings.hashId);
        }
    }

    function calculateLayout(eventObject) {
        $("#dynamic_dom .modal").each(function resizeModalItem(index, element) {
            resizeDialog($(element).attr('id'));
        });
    }

    function parseTooltipXml(content) {
        var html = '', title = '';
        $(content).find("help").each(function () {
            if (title === '') title = $(this).attr("header");
            html += $(this).text();
        });
        return html;
    }

    function changeContent(dialogId, htmlContent, callback) {
        if ($.isXMLDoc(htmlContent)) {
            htmlContent = parseTooltipXml(htmlContent);
        }
        $('#' + dialogId + ' .modal-body').html(htmlContent);

        if (typeof callback === 'function') {
            callback();
        }

        calculateLayout();
    }

    function appendContent(dialogId, htmlContent) {
        $('#' + dialogId + ' .modal-body').append(htmlContent);
        calculateLayout();
    }

    function resizeDialog(dialogId) {
        isXS = meerkat.modules.deviceMediaState.get() === "xs";

        var $dialog = $("#" + dialogId);

        if ($dialog.find(".modal-header").outerHeight(true) === 0) {
            window.setTimeout(function () {
                resizeDialog(dialogId);
            }, 20);
        } else {
            var viewport_height,
                content_height,
                dialogTop,
                $modalContent = $dialog.find(".modal-content"),
                $modalBody = $dialog.find(".modal-body"),
                $modalDialog = $dialog.find(".modal-dialog");

            viewport_height = window.innerHeight;

            if (!isXS) {
                viewport_height -= 60; // top and bottom margin.
            }

            content_height = viewport_height;
            content_height -= $dialog.find(".modal-header").outerHeight(true);
            content_height -= $dialog.find(".modal-footer").outerHeight(true);
            content_height -= $dialog.find(".modal-closebar").outerHeight(true);

            // On XS, the modal fills the whole viewport.
            // Put the modals to the top of XS so the "X" close icon overlaps the navbar correctly.
            if (isXS) {
                $modalContent.css('height', viewport_height);
                $dialog.find(".modal-body").css('max-height', 'none').css('height', content_height);

                dialogTop = 0;
                $modalDialog.css('top', dialogTop);
            }
            else {
                // Set the max height for the modal overall, so it fits in the viewport
                $modalContent.css('max-height', viewport_height);

                // If specified, default the modal to vertically fill the viewport
                if ($dialog.attr('data-fullheight') === "true") {
                    $modalContent.css('height', viewport_height);
                    $modalBody.css('height', content_height);
                } else {
                    // Reset the forced height applied when in XS
                    $modalContent.css('height', 'auto');
                    $modalBody.css('height', 'auto');
                }

                // Set the max height on the body of the modal so it is scrollable
                $dialog.find(".modal-body").css('max-height', content_height);

                // Position the modal vertically centred
                dialogTop = (viewport_height / 2) - ($modalDialog.height() / 2);

                if ($modalContent.height() < viewport_height) {
                    dialogTop = dialogTop / 2;
                }

                $modalDialog.css('top', dialogTop);
            }

        }

    }

    function destroyDialog(dialogId) {
        if (!dialogId || dialogId.length === 0) return;

        var $dialog = $("#" + dialogId);
        $dialog.find('button').off().end().remove();

        var settings = getSettings(dialogId);

        if (settings != null) {
            if (settings.hashId != null) {
                meerkat.modules.address.removeFromHash(settings.hashId);

                var previousInstance = _.findWhere(dialogHistory, {hashId: settings.hashId});
                if (previousInstance == null) dialogHistory.push(settings);
            }

            openedDialogs.splice(settings.index, 1);
        }

    }

    function getSettings(dialogId) {
        var index = getDialogSettingsIndex(dialogId);
        if (index !== null) {
            openedDialogs[index].index = index;
            return openedDialogs[index];
        }
        return null;
    }

    function getDialogSettingsIndex(dialogId) {
        for (var i = 0; i < openedDialogs.length; i++) {
            if (openedDialogs[i].id == dialogId) return i;
        }
        return null;
    }

    function isDialogOpen(dialogId) {
        return !_.isNull(getDialogSettingsIndex(dialogId));
    }

    // Initialise Dev helpers
    function initDialogs() {

        // Set up touch events on touch devices
        $(document).ready(function () {

            // Bind the default close button
            $(document).on('click', '.btn-close-dialog', function () {
                window.history.back();
                // $(this).closest('.modal').modal('hide');
            });

            if (!Modernizr.touch) return;

            // Stop the background page being scrollable when a modal is open (doesn't work on mobiles really)
            $(document).on('touchmove', '.modal', function (e) {
                e.preventDefault();
            });
            // Allow the modal body to be scrollable
            $(document).on('touchmove', '.modal .modal-body', function (e) {
                e.stopPropagation();
            });
        });

        var self = this;

        meerkat.messaging.subscribe(meerkatEvents.dynamicContentLoading.PARSED_DIALOG, function dialogClicked(event) {

            var dialogInfoObject;

            var hashValue = event.element.attr('data-dialog-hash-id');
            var hashId = null;
            var closeOnHashChange = event.element.attr('data-close-on-hash-change') === 'false' ? false : true;
            if (hashValue !== '') hashId = hashValue;

            if (event.contentType === 'url') {

                dialogInfoObject = {
                    title: event.element.attr('data-title'),
                    url: event.contentValue,
                    cacheUrl: (event.element.attr('data-cache') ? true : false)
                };
            } else if (event.contentType === 'externalUrl') {

                dialogInfoObject = {
                    title: event.element.attr('data-title'),
                    externalUrl: event.contentValue
                };

            } else {

                dialogInfoObject = {
                    title: $(event.contentValue).attr('data-title'),
                    htmlContent: event.contentValue
                };

            }

            var instanceSettings = $.extend({
                    hashId: hashId,
                    closeOnHashChange: closeOnHashChange,
                    className: event.element.attr('data-class')
                },
                dialogInfoObject
            );

            show(instanceSettings);

        });

        // Listen for window resizes to reposition and resize dialog windows.
        var lazyLayout = _.debounce(calculateLayout, 300);
        $(window).resize(lazyLayout);

        // Listen for hash changes and close any dialog which requested to be closed on hash change.
        meerkat.messaging.subscribe(meerkatEvents.ADDRESS_CHANGE, function dialogHashChange(event) {
            // find windows which need to be closed.
            for (var i = openedDialogs.length - 1; i >= 0; i--) {
                var dialog = openedDialogs[i];
                if (dialog.closeOnHashChange === true) {
                    if (_.indexOf(event.hashArray, dialog.hashId) == -1) {
                        self.close(dialog.id);
                    }
                }
            }

            // find windows which need to be opened.
            for (var j = 0; j < event.hashArray.length; j++) {
                var windowOpen = _.findWhere(openedDialogs, {hashId: event.hashArray[j]});
                if (windowOpen == null) {
                    var previousInstance = _.findWhere(dialogHistory, {hashId: event.hashArray[j]});
                    if (previousInstance != null) {
                        if (previousInstance.openOnHashChange === true) {
                            meerkat.modules.dialogs.show(previousInstance);
                        }
                    }
                }
            }

        }, window);

    }

    meerkat.modules.register('dialogs', {
        init: initDialogs,
        show: show,
        changeContent: changeContent,
        close: close,
        isDialogOpen: isDialogOpen,
        resizeDialog: resizeDialog
    });


})(jQuery);