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
            title: '',
            headerRightBtnCB: null,
            footerButtonCloseText: 'Close',
            footerButtonUpdateText: 'Update..',
            footerButtonUpdateCB: null,
            rightButtonCB: null,
            htmlContent: '',
            templates: {
                container:
                '<div class="mobile-filters-menu-container">' +
                    '<div class="overlay"></div>' +
                    '<div class="cross-container"><span class="icon icon-cross"></span></div>' +
                    '<div class="mobile-filters-menu">' +
                        '<div class="mobile-filters-menu-header">' +
                            '<span class="icon icon-angle-left mobile-filters-menu-header-back-btn"></span>' +
                            '<span class="mobile-filters-menu-header-title">{{= title }}</span>' +
                            '<span class="mobile-filters-menu-header-right-btn"></span>' +
                        '</div>' +
                        '<div class="mobile-filters-menu-body"></div>' +
                        '<div class="mobile-filters-menu-footer">' +
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
        _callUpdateCB = false;

    function initMobileFiltersMenu(instanceSettings) {
        _settings = $.extend({}, defaultSettings, instanceSettings);
        var htmlTemplate = _.template(_settings.templates.container);
        var htmlString = htmlTemplate(_settings);

        $('body').append(htmlString);

        _setupElements();
        _applyEventListeners();
        _eventSubscriptions();
        _calcBodyHeight();

        // $elements.menuBody.html(_settings.htmlContent);
        updateMenuBodyHTML(_settings.htmlContent);

        reset();
    }

    function _setupElements() {
        $elements = {
            body: $('body'),
            container: $('.mobile-filters-menu-container'),
            overlay: $('.mobile-filters-menu-container .overlay'),
            cross: $('.mobile-filters-menu-container .icon-cross'),
            header: $('.mobile-filters-menu-header'),
            backBtn: $('.mobile-filters-menu-header-back-btn'),
            title: $('.mobile-filters-menu-header-title'),
            rightBtn: $('.mobile-filters-menu-header-right-btn'),
            menuBody: $('.mobile-filters-menu-body'),
            footer: $('.mobile-filters-menu-footer'),
            footerBtn: $('.mobile-filters-menu-footer button')
        };
    }

    function _applyEventListeners() {
        $elements.overlay
            .add($elements.cross)
            .on('click', function() {
                close();
            });

        $(document).on('click', '.mobile-filters-menu-footer button[data-action=close]', function() {
            close();
        });

        $elements.container.on('transitionend webkitTransitionEnd oTransitionEnd', function() {
            if ($elements.container.hasClass('closing')) {
                $elements.container.removeClass('opened closing');

                if (_callUpdateCB && (_.isFunction(_settings.footerButtonUpdateCB) && _settings.footerButtonUpdateCB)) {
                    _settings.footerButtonUpdateCB();
                }

                reset();
            }
        });

        $(document).on('click', '.mobile-filters-menu-footer button[data-action=update]', function() {
            _callUpdateCB = true;
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
    }

    function _calcBodyHeight() {
        var height = $(window).height() - $elements.header[0].getBoundingClientRect().height - $elements.footer[0].getBoundingClientRect().height;

        $elements.menuBody.css('height', height);
    }

    function open() {
        $elements.body.css('overflow', 'hidden');
        $elements.container.addClass('opened');

        return this;
    }

    function close() {
        $elements.body.css('overflow', 'initial');
        $elements.container.addClass('closing');

        return this;
    }

    function reset() {
        meerkat.messaging.publish(meerkatEvents.ON_RESET);
        hideBackBtn();
        hideRightBtn();
        updateHeaderTitle(_settings.title);
        _resetFooterButton();
        _callUpdateCB = false;

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
        $elements.backBtn.fadeIn();

        return this;
    }

    function hideBackBtn() {
        $elements.backBtn.fadeOut();

        return this;
    }

    function showRightBtn() {
        $elements.rightBtn.fadeIn();

        return this;
    }

    function hideRightBtn() {
        $elements.rightBtn.fadeOut();

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