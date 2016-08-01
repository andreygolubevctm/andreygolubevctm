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

    var events = {
            selectTags: {
                SELECTED_TAG_ADDED: "SELECTED_TAG_ADDED",
                SELECTED_TAG_REMOVED: "SELECTED_TAG_REMOVED"
            }
        },
        moduleEvents = events.selectTags;

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

    function _trim(text) {
        return (text.length > 25) ? text.substr(0, 20) + '...' : text;
    }

    function getHTML(text) {
        return '<span>' + _trim(text) + '</span>';
    }

    function _onOptionSelect(selectElement) {
        var $select = $(selectElement),
            $selected = $select.find('option:selected'),
            value = $select.val(),
            $list = getListElement($select),
            selectedText = $selected.text(),
            selectedTextHTML = getHTML(selectedText);

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
        var selectLimit = $list.data('selectlimit');

        if (selectLimit === 0 || (!!selectLimit && $list.find('li').length < selectLimit)) {
            _.defer(function delayTagAppearance() {

                if (typeof selectedItems[$list.index()] == 'undefined') {
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
                        .hover(function onSelectTagHoverIn() {
                            $(this).addClass('hover');
                            $(this).find('button').addClass('icon-cross');

                        }, function onSelectTagHoverOut() {
                            $(this).removeClass('hover');
                            $(this).find('button').removeClass('icon-cross');
                        })
                        .on('click', function onClickRemoveTagCallback() {
                            _onRemoveListItem(this);
                        })
                        .append(
                            $('<button>')
                                .attr('type', 'button')
                                .addClass('btn icon icon-tick')
                        )
                        .fadeIn(fadeSpeed, function selectTagFadeIn() {
                            _updateHiddenInputs();
                            meerkat.messaging.publish(moduleEvents.SELECTED_TAG_ADDED, value);
                        })
                );
            });
        }
    }

    function _onRemoveListItem(listItem) {
        var $this = $(listItem),
            $select = $this.closest('.row').find(':input'),
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
            meerkat.messaging.publish(moduleEvents.SELECTED_TAG_REMOVED, value);
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
        return $el.closest('.row').parent().find(selectedTagsListClass);
    }

    function getItemsSelected(index) {
        return selectedItems[index];
    }

    meerkat.modules.register('selectTags', {
        init: init,
        events: events,
        getListElement: getListElement,
        appendToTagList: appendToTagList,
        isAlreadySelected: isAlreadySelected,
        getItemsSelected: getItemsSelected,
        getHTML: getHTML
    });

})(jQuery);