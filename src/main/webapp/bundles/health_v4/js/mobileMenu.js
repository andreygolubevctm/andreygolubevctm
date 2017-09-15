;(function ($, undefined) {

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events;

    var moduleEvents = {
        ON_RESET: 'ON_RESET',
        FOOTER_BUTTON_UPDATE: 'FOOTER_BUTTON_UPDATE',
        BACK_BUTTON_CLICKED: 'BACK_BUTTON_CLICKED'
    };

    var defaultSettings = {
            title: '',
            footerButtonCloseText: 'Close',
            footerButtonUpdateText: 'Update..',
            footerButtonUpdateCB: null,
            templates: {
                container:
                    '<div class="mobile-menu-container">' +
                        '<div class="overlay"></div>' +
                        '<div class="cross-container"><span class="icon icon-cross"></span></div>' +
                        '<div class="mobile-menu">' +
                            '<div class="mobile-menu-header">' +
                                '<span class="icon icon-angle-left mobile-menu-header-back-btn"></span>' +
                                '<span class="mobile-menu-header-title">{{= title}}</span>' +
                            '</div>' +
                            '<div class="mobile-menu-body"></div>' +
                            '<div class="mobile-menu-footer">' +
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

    function initMobileMenu(instanceSettings) {
        _settings = $.extend({}, defaultSettings, instanceSettings);
        var htmlTemplate = _.template(_settings.templates.container);
        var htmlString = htmlTemplate(_settings);

        $('body').append(htmlString);

        _setupElements();
        _applyEventListeners();
        _eventSubscriptions();
        _calcBodyHeight();

        $elements.menuBody.html(_settings.template.html());

        reset();
    }

    function _setupElements() {
        $elements = {
            body: $('body'),
            container: $('.mobile-menu-container'),
            overlay: $('.mobile-menu-container .overlay'),
            cross: $('.mobile-menu-container .icon-cross'),
            header: $('.mobile-menu-header'),
            backBtn: $('.mobile-menu-header-back-btn'),
            title: $('.mobile-menu-header-title'),
            menuBody: $('.mobile-menu-body'),
            footer: $('.mobile-menu-footer'),
            footerBtn: $('.mobile-menu-footer button')
        };
    }

    function _applyEventListeners() {
        $elements.overlay
            .add($elements.cross)
            .on('click', function() {
                close();
            });

        $(document).on('click', '.mobile-menu-footer button[data-action=close]', function() {
            close();
        });

        $elements.container.on('transitionend webkitTransitionEnd oTransitionEnd', function() {
           if ($elements.container.hasClass('closing')) {
               $elements.container.removeClass('opened closing');

               if (_callUpdateCB && _settings.footerButtonUpdateCB) {
                   _settings.footerButtonUpdateCB();
               }

               reset();
           }
        });

        $(document).on('click', '.mobile-menu-footer button[data-action=update]', function() {
            _callUpdateCB = true;
            close();
        });

        $elements.backBtn.on('click', function() {
            meerkat.messaging.publish(meerkatEvents.BACK_BUTTON_CLICKED);
            hideBackBtn();
            updateHeaderTitle(_settings.title);
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
    }

    function close() {
        $elements.body.css('overflow', 'initial');
        $elements.container.addClass('closing');
    }

    function reset() {
        meerkat.messaging.publish(meerkatEvents.ON_RESET);
        hideBackBtn();
        updateHeaderTitle(_settings.title);
        _resetFooterButton();
        _callUpdateCB = false;
    }

    function _resetFooterButton() {
        $elements.footerBtn
            .attr('data-action', 'close')
            .removeClass('btn-call')
            .text(_settings.footerButtonCloseText);
    }

    function updateHeaderTitle(title) {
        $elements.title.text(title);
    }

    function showBackBtn() {
        $elements.backBtn.fadeIn();
    }

    function hideBackBtn() {
        $elements.backBtn.fadeOut();
    }

    meerkat.modules.register('mobileMenu', {
        initMobileMenu: initMobileMenu,
        events: moduleEvents,
        open: open,
        close: close,
        updateHeaderTitle: updateHeaderTitle,
        showBackBtn: showBackBtn,
        hideBackBtn: hideBackBtn
    });
})(jQuery);