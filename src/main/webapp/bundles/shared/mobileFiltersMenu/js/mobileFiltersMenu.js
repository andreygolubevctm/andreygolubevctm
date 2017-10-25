;(function ($, undefined) {

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events;

    var moduleEvents = {
        ON_RESET: 'ON_RESET',
        FOOTER_BUTTON_UPDATE: 'FOOTER_BUTTON_UPDATE',
        BACK_BUTTON_CLICKED: 'BACK_BUTTON_CLICKED',
        RIGHT_BUTTON_CLICKED: 'RIGHT_BUTTON_CLICKED'
    };

    var defaultSettings = {
            title: 'Mobile Filters Menu',
            headerRightBtnCB: null,
            footerButtonCloseText: 'Close',
            footerButtonUpdateText: 'Update..',
            footerButtonUpdateCB: null,
            rightButtonCB: null,
            templates: {
                container:
                '<div class="mobile-filters-menu">' +
                '<div class="overlay"></div>' +
                '<div class="cross-container"><span class="icon icon-cross"></span></div>' +
                '<div class="mobile-filters-menu__container">' +
                '<div class="mobile-filters-menu__header">' +
                '<span class="mobile-filters-menu__header-back-btn icon icon-angle-left fade"></span>' +
                '<span class="mobile-filters-menu__header-title">{{= title }}</span>' +
                '<span class="mobile-filters-menu__header-right-btn fade"></span>' +
                '</div>' +
                '<div class="mobile-filters-menu__body"></div>' +
                '<div class="mobile-filters-menu__footer">' +
                '<button class="btn btn-block btn-back btn-lg" data-action="close">' +
                '{{= footerButtonCloseText }}' +
                '</button>' +
                '</div>' +
                '</div>' +
                '</div>'
            }
        },
        $elements = {},
        _settings = {},
        _status = {
            callUpdateCB: false,
            opened: false
        };

    function initMobileFiltersMenu(instanceSettings) {
        _settings = $.extend({}, defaultSettings, instanceSettings);
        var htmlTemplate = _.template(_settings.templates.container);
        var htmlString = htmlTemplate(_settings);

        $('body').append(htmlString);

        _setupElements();
        _applyEventListeners();
        _eventSubscriptions();
        _calcBodyHeight();

        reset();

        return this;
    }

    function _setupElements() {
        $elements = {
            body: $('html, body'),
            menu: $('.mobile-filters-menu'),
            overlay: $('.mobile-filters-menu .overlay'),
            cross: $('.mobile-filters-menu .icon-cross'),
            header: $('.mobile-filters-menu__header'),
            backBtn: $('.mobile-filters-menu__header-back-btn'),
            title: $('.mobile-filters-menu__header-title'),
            rightBtn: $('.mobile-filters-menu__header-right-btn'),
            menuBody: $('.mobile-filters-menu__body'),
            footer: $('.mobile-filters-menu__footer'),
            footerBtn: $('.mobile-filters-menu__footer button')
        };
    }

    function _applyEventListeners() {
        $elements.overlay
            .add($elements.cross)
            .on('click', function() {
                close();
            });

        $(document).on('click', '.mobile-filters-menu__footer button[data-action=close]', function() {
            close();
        });

        $elements.menu.on('transitionend webkitTransitionEnd oTransitionEnd', function() {
            if ($elements.menu.hasClass('closing')) {
                $elements.menu.removeClass('opened closing');

                if (_status.callUpdateCB && (_.isFunction(_settings.footerButtonUpdateCB) && _settings.footerButtonUpdateCB)) {
                    _settings.footerButtonUpdateCB();
                }

                reset();
            }
        });

        $(document).on('click', '.mobile-filters-menu__footer button[data-action=update]', function() {
            _status.callUpdateCB = true;
            close();
        });

        $elements.backBtn.on('click', function() {
            meerkat.messaging.publish(meerkatEvents.BACK_BUTTON_CLICKED);
            hideBackBtn();
            updateHeaderTitle(_settings.title);
        });

        $elements.rightBtn.on('click', function() {
            meerkat.messaging.publish(meerkatEvents.RIGHT_BUTTON_CLICKED);

            if (_.isFunction(_settings.rightButtonCB && _settings.rightButtonCB)) {
                _settings.rightButtonCB();
            }
        });
    }

    function _eventSubscriptions() {
        meerkat.messaging.subscribe(meerkatEvents.FOOTER_BUTTON_UPDATE, function() {
            $elements.footerBtn
                .attr('data-action', 'update')
                .addClass('btn-call')
                .text(_settings.footerButtonUpdateText);
        });


        meerkat.messaging.subscribe(meerkatEvents.ADDRESS_CHANGE, function() {
            if (_status.open) {
                close();
            }
        });


        meerkat.messaging.subscribe(meerkatEvents.device.STATE_LEAVE_XS, function() {
            if (_status.open) {
                close();
            }
        });
    }

    function _calcBodyHeight() {
        var height = $(window).height() - $elements.header[0].getBoundingClientRect().height - $elements.footer[0].getBoundingClientRect().height;

        $elements.menuBody.css('height', height);
    }

    function open() {
        _status.open = true;
        $elements.body.css({ overflow: 'hidden', height: $(window).height() });
        $elements.menu.addClass('opened');

        return this;
    }

    function close() {
        _status.open = false;
        $elements.body.css({ overflow: 'initial', height: 'initial' });
        $elements.menu.addClass('closing');

        return this;
    }

    function reset() {
        meerkat.messaging.publish(meerkatEvents.ON_RESET);
        hideBackBtn();
        hideRightBtn();
        updateHeaderTitle(_settings.title);
        _resetFooterButton();
        _status.callUpdateCB = false;

        return this;
    }

    function _resetFooterButton() {
        $elements.footerBtn
            .attr('data-action', 'close')
            .removeClass('btn-call')
            .text(_settings.footerButtonCloseText);
    }

    function updateHeaderTitle(title) {
        $elements.title.text(title);

        return this;
    }

    function showBackBtn() {
        $elements.backBtn.addClass('in');

        return this;
    }

    function hideBackBtn() {
        $elements.backBtn.removeClass('in');

        return this;
    }

    function showRightBtn() {
        $elements.rightBtn.addClass('in');

        return this;
    }

    function hideRightBtn() {
        $elements.rightBtn.removeClass('in');

        return this;
    }

    function updateMenuBodyHTML(htmlContent) {
        $elements.menuBody.html(htmlContent);

        return this;
    }

    function updateRightBtnText(text) {
        $elements.rightBtn.text(text);

        return this;
    }

    meerkat.modules.register('mobileFiltersMenu', {
        initMobileFiltersMenu: initMobileFiltersMenu,
        events: moduleEvents,
        open: open,
        close: close,
        updateHeaderTitle: updateHeaderTitle,
        showBackBtn: showBackBtn,
        hideBackBtn: hideBackBtn,
        showRightBtn: showRightBtn,
        hideRightBtn: hideRightBtn,
        updateRightBtnText: updateRightBtnText,
        updateMenuBodyHTML: updateMenuBodyHTML
    });
})(jQuery);