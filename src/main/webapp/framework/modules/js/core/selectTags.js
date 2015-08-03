/**
 * Select tags selection module
 *
 * Takes a list of values and adds them to a select element.
 * On selecting a value, the value of the chosen element is added
 * to a tag list and hidden input.
 *
 * If you need something similar but without countries, create a verticalSelectTags file and pass in a language object.
 */

;(function ($, undefined) {

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        log = meerkat.logging.info;

    var $selectObj = $('.select-tags'),
        selectedTagsListClass = '.selected-tags',
        fadeSpeed = 'fast',
        optionSelectedIcon = '[selected] ',
        selectedItems = {}; // cache of selected items per tag list

    function init() {

        $selectObj.each(function initializeSelectTagsObj() {
            var $this = $(this),
                variableName = $this.data('varname'),
                list = window[variableName];

            if ($this.is('select')) {
                if (typeof list !== 'undefined' && typeof list.options !== 'undefined' && _.isArray(list.options) && list.options.length) {
                    // Generic Selection
                    _addOptionsToList($this, list.options);
                }
                $this.on('change', function onSelectTagCallback() {
                    _onOptionSelect(this);
                });
            }

            selectedItems[$this.index()] = ["0000"];

        });


    }

    function _addOptionsToList($element, options) {
        var optionsHTML = "";

        for (var i = 0; i < options.length; i++) {
            var option = options[i];
            optionsHTML += '<option value="' + option.value + '">' + option.text + '</option>';
        }

        $element.append(optionsHTML);
    }

    function _onOptionSelect(selectElement) {
        var $select = $(selectElement),
            $selected = $select.find('option:selected'),
            value = $select.val(),
            $list = getListElement($select),
            selectedText = $selected.text(),
            selectedTextHTML = selectedText;

        if (selectedTextHTML.length > 25) {
            selectedTextHTML = selectedTextHTML.substr(0, 20) + '...';
        }

        selectedTextHTML = '<span>' + selectedTextHTML + '</span>';


        if ($selected.not('[readonly]').length && !isAlreadySelected(value)) {
            $select[0].selectedIndex = 0;

            // Find options by value because we may have multiple opt-groups which cause the same value
            // to be used multiple times
            $select.find('option[value="' + value + '"]').text(optionSelectedIcon + selectedText).attr('disabled', 'disabled');
            appendToTagList($list, selectedTextHTML, selectedText, value);
        }
    }


    function isAlreadySelected($list, selectedValue) {
        if(typeof $list == 'undefined') {
            return false;
        }
        var index = $list.index();
        if(typeof selectedItems[index] == 'undefined') {
            selectedItems[index] = ["0000"];
        }
        return selectedItems[index].indexOf(selectedValue) !== -1;
    }

    function appendToTagList($list, selectedTextHTML, selectedText, value) {
        _.defer(function delayTagAppearance() {

            if(typeof selectedItems[$list.index()] == 'undefined') {
                selectedItems[$list.index()] = ["0000"];
            }
            selectedItems[$list.index()].push(value);

            $list.append(
                $('<li>')
                    .html(selectedTextHTML)
                    .data('value', value)
                    .data('fulltext', selectedText)
                    .addClass('selected-tag')
                    .hide()
                    .append(
                    $('<button>')
                        .html('&times;')
                        .attr('type', 'button')
                        .addClass('btn')
                        .on('click', function onClickRemoveTagCallback() {
                            _onRemoveListItem(this);
                        })
                        .hover(function onSelectTagHoverIn() {
                            $(this).parents('li').addClass('hover');
                        }, function onSelectTagHoverOut() {
                            $(this).parents('li').removeClass('hover');
                        })
                ).fadeIn(fadeSpeed, function () {
                        _updateHiddenInputs();
                    })
            );
        });
    }

    function _onRemoveListItem(listItem) {
        var $this = $(listItem),
            $select = $this.closest('.row').prev('.select-tags-row').find(':input'),
            $listItem = $this.closest('li'),
            value = $listItem.data('value'),
            text = $listItem.data('fulltext');

            if($select.is('select')) {
                $select
                    .find('option[value="' + value + '"]')
                    .text(text)
                    .removeAttr('disabled');
            }

        // remove it from the obj.
        var $list = getListElement($select), index = $list.index();
        if(typeof selectedItems[index] == 'undefined') {
            selectedItems[index] = ["0000"];
        }
        var selectedItemIndex = selectedItems[index].indexOf(value);
        if(selectedItemIndex != -1) {
            selectedItems[index].splice(selectedItemIndex, 1);
        }

        $listItem.fadeOut(fadeSpeed, function removeTagFadeOutCallback() {
            $(this).remove();
            _updateHiddenInputs();
        });
    }

    function _updateHiddenInputs() {
        $selectObj.each(function updateHiddenInputsCallback() {
            var $this = $(this),
                $parent = $this.closest('.row'),
                $list = getListElement($this),
                $hiddenField = $parent.find('.validate'),
                selectedTags = [];

            $list.find('li').each(function () {
                selectedTags.push($(this).data('value'));
            });

            $hiddenField.val(selectedTags.join(','));
        });
    }

    function getListElement($el) {
        return $el.closest('.row').next(selectedTagsListClass + '-row').find(selectedTagsListClass);
    }

    function getItemsSelected(index) {
        return selectedItems[index];
    }

    meerkat.modules.register('selectTags', {
        init: init,
        getListElement: getListElement,
        appendToTagList: appendToTagList,
        isAlreadySelected: isAlreadySelected,
        getItemsSelected: getItemsSelected
    });

})(jQuery);