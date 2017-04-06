;(function ($, undefined) {

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,

        _template = null,
        _options = {
            maxRadioItems: 6
        },
        _settings = [],
        $container = [];

    function initButtonTileDropdownSelector(settings) {
        _settings = settings;
        _setupFields();
        _applyEventListeners();
        _preselect();
    }

    function _setupFields() {
        _settings.forEach(function(setting) {
            var id = setting.$container[0].id;

            $container[id] = setting.$container;
            _template = _.template($('#buttonTileDropdownSelectorTemplate').html());

            $container[id].html(_template({
                id: $container[id].attr('data-selector'),
                items: setting.items,
                maxRadioItems: setting.maxRadioItems ? setting.maxRadioItems : _options.maxRadioItems
            }));

            _setSelectorValidation(id);
        });
    }

    function _applyEventListeners() {
        $('.button-tile-dropdown-selector-other').on('click', function() {
            // toggle other selector
            _toggleSelect($(this), true);

            var $dropdownSelector = _getDropdownSelectorEl($(this));

            if ($dropdownSelector.find('option').length === 2) {
                $dropdownSelector.prop('selectedIndex', 1);
                $dropdownSelector.trigger('change');
            }
        });

        // on button tile click
        $('.button-tile-selector').on('click', function() {
            var $this = $(this),
                $selectorLabel = _getButtonTileSelectorLabelEl($this),
                $dropdownSelector = _getDropdownSelectorEl($this);

            // deselect all of them
            $selectorLabel.removeClass('active');

            $this.parent().addClass('active');

            // deselect dropdown and show other link
            _toggleSelect($this, false);
            $dropdownSelector.prop('selectedIndex', 0);

            // update hidden value
            _setHiddenVal($this, $this.val());
        });

        // on dropdown selector click
        $('.drop-down-selector').on('change', function() {
            var $this = $(this),
                $selectorLabel = _getButtonTileSelectorLabelEl($this);

        	// deselect button tiles
            $selectorLabel.removeClass('active');

        	// update hidden value
        	_setHiddenVal($this, $this.val());
        });
    }

    function _preselect() {
        _settings.forEach(function(setting) {
            var id = setting.$container[0].id,
                hiddenVal = _getHiddenVal($container[id]);

            // if hidden element has a value
            if (hiddenVal) {
                if ($container[id].find('input[type=radio][value="' + hiddenVal + '"]').length) {
                    $container[id].find('input[type=radio][value="' + hiddenVal + '"]').trigger('click');

                    _toggleSelect($container[id].find('.button-tile-dropdown-selector'), false);
                } else {
                    // show other dropdown, trigger other link
                    _getOtherLinkEl($container[id]).trigger('click');
                    _getDropdownSelectorEl($container[id]).val(hiddenVal);
                }
            } else {
                _toggleSelect($container[id].find('.button-tile-dropdown-selector'), false);
            }
        });
    }

    function _toggleSelect($this, show) {
        _getOtherLinkEl($this).toggleClass('hidden', show);
        _getDropdownSelectorEl($this).parent().toggleClass('hidden', !show);
    }

    function _setSelectorValidation(id) {
        $('#'+$container[id].data('selector')).attr('data-validation-placement', $($container[id]).find('.errorField').selector);
    }

    function _getButtonTileDropDownWrapperEl($el) {
        var $wrapper = $el.hasClass('.button-tile-dropdown-selector') ? $el :
            ($el.find('.button-tile-dropdown-selector').length ? $el.find('.button-tile-dropdown-selector') : $el.closest('.button-tile-dropdown-selector'));

        return $wrapper;
    }

    function _getButtonTileSelectorLabelEl($el) {
        var $wrapper = _getButtonTileDropDownWrapperEl($el),
            $selectorLabel = $wrapper.find('.button-tile-selector-label');

        return $selectorLabel;
    }

    function _getDropdownSelectorEl($el) {
        var $wrapper = _getButtonTileDropDownWrapperEl($el),
            $selector = $wrapper.find('.drop-down-selector');

        return $selector;
    }

    function _getHiddenSelectorEl($el) {
        var $wrapper = _getButtonTileDropDownWrapperEl($el),
            $selector = $('#'+$wrapper.parent().data('selector'));

        return $selector;
    }

    function _getHiddenVal($el) {
        return _getHiddenSelectorEl($el).val();
    }

    function _setHiddenVal($this, val) {
        _getHiddenSelectorEl($this).val(val);

        // make valid
        _makeValid($this);
    }

    function _getOtherLinkEl($el) {
        var $wrapper = _getButtonTileDropDownWrapperEl($el),
            $link = $wrapper.find('.button-tile-dropdown-selector-other');

        return $link;
    }

    function _makeValid($el) {
        _getHiddenSelectorEl($el).valid();
    }

    meerkat.modules.register('buttonTileDropdownSelector', {
        initButtonTileDropdownSelector: initButtonTileDropdownSelector,
        events: moduleEvents
    });

})(jQuery);