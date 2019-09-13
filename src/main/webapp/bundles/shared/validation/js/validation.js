/**
 * Do not know the purpose of this variable. It was ported over during refactor.
 * @type {boolean}
 */
var validation = false;

;(function ($, undefined) {
    var meerkat = window.meerkat,
        log = meerkat.logging.info;

    var events = {};

    function init() {

        if (typeof $.validator !== 'function') {
            return;
        }

        $(document).ready(function () {
            _overrideValidatorPrototypes();
        });
    }

    /**
     * This will need to init after dom ready
     */
    function initJourneyValidator() {

        /**
         * Initialise by default on journey engine forms.
         * To initialise on other forms,  do the same thing
         * and replace $(this) with the form element.
         */
        $('.journeyEngineSlide form').each(function () {
            setupDefaultValidationOnForm($(this));
        });

    }

    /**
     *
     * @private
     */
    function _overrideValidatorPrototypes() {

        String.prototype.startsWith = function (prefix) {
            return (this.substr(0, prefix.length) === prefix);
        };
        String.prototype.endsWith = function (suffix) {
            return (this.substr(this.length - suffix.length) === suffix);
        };

        /**
         * Not sure why we need this one. TODO: test it
         */
        $.validator.prototype.hideErrors = function () {
            this.addWrapper(this.toHide);
        };

        /**
         * CTM Custom Unhighlight function
         * We define this as a prototype, so that the function only needs to be in memory once.
         * Without this, it would be cloned on every init of the validator.
         * @param element
         * @param errorClass
         * @param validClass
         */
        $.validator.prototype.ctm_unhighlight = function (element, errorClass, validClass) {
            if (!element) return;
            errorClass = errorClass || this.settings.errorClass;
            validClass = validClass || this.settings.validClass;


            if (element.type === "radio") {
                this.findByName(element.name).removeClass(errorClass).addClass(validClass);
            } else {
                $(element).removeClass(errorClass).addClass(validClass);
            }

            var $wrapper = $(element).closest('.row-content, .fieldrow_value');
            var $errorContainer = $wrapper.find('.error-field');


            $errorContainer.find('label[for="' + element.name + '"]').remove();

            if ($wrapper.find(':input.has-error').length > 0) {
                return;
            }

            $wrapper.removeClass(errorClass).addClass(validClass);

            if ($errorContainer.find('label').length > 0) {
                if ($errorContainer.is(':visible')) {
                    $errorContainer.stop().slideUp(100);
                }
                else {
                    $errorContainer.hide();
                }
            }
        };

    }

    /**
     * This one will replace core/validation.js
     * @param $formElement
     */
    function setupDefaultValidationOnForm($formElement) {
        $formElement.validate(getDefaultValidationObj(), true);
    }

    function getDefaultValidationObj() {
        var validationObj = {
            submitHandler: function (form) {
                form.submit();
            },
            invalidHandler: function (form, validator) {

                if (!validator.numberOfInvalids()) return;
                if (jQuery.validator.scrollingInProgress) return;

                var $ele = $(validator.errorList[0].element),
                    $parent = $ele.closest('.row-content, .fieldrow_value');


                if ($ele.attr('data-validation-placement') !== null && $ele.attr('data-validation-placement') !== '') {
                    var $ele2 = $($ele.attr('data-validation-placement'));
                    if ($ele2.length > 0) $ele = $ele2;
                }

                /** If the element has a row parent (where the error message gets inserted to), then scroll to that instead **/
                if ($parent.length > 0) $ele = $parent;
                jQuery.validator.scrollingInProgress = true;

                var offsetFromTop = -50,
                    $headerTopFixed = $('.header-top.navMenu-row-fixed'),
                    $productSummaryAffixed = $('.productSummary-affix'),
                    $progressBarAffix = $('.progress-bar-row.navbar-affix');

                if (meerkat.modules.deviceMediaState.get() === 'xs') {
                    if ($headerTopFixed.length > 0) {
                        offsetFromTop -= $headerTopFixed.find('.container').height();
                    }

                    if ($productSummaryAffixed.length > 0) {
                        offsetFromTop -= $productSummaryAffixed.height();
                    }
                }

                if ($progressBarAffix.length > 0) {
                    offsetFromTop -= $progressBarAffix.height();
                }

                meerkat.modules.utils.scrollPageTo($ele, 500, offsetFromTop, function () {
                    jQuery.validator.scrollingInProgress = false;
                });
            },
            ignore: ':hidden',
            meta: 'validate',
            debug: true,
            errorClass: 'has-error',
            validClass: 'has-success',
            errorPlacement: function ($error, $element) {
                /** Inline validation
                 An error message placeholder will be injected above the form element, generally inside the parent .row-content
                 **/
                var $referenceElement = $element;
                if ($element.data('disable-error-container') !== true) {
                    if (typeof $element.attr('data-validation-placement') !== 'undefined' &&
                        $element.attr('data-validation-placement') !== null && $element.attr('data-validation-placement') !== '') {
                        $referenceElement = $($element.attr('data-validation-placement'));
                    }
                    var parent = $referenceElement.closest('.row-content, .fieldrow_value');
                    if (parent.length === 0) parent = $element.parent();

                    var errorContainer = parent.children('.error-field');

					var position = 'prepend';
                    if (errorContainer.length === 0) {

						if (typeof $element.attr('data-validation-position') !== 'undefined' &&
                        	$element.attr('data-validation-position') !== null && $element.attr('data-validation-position') !== '') {
                        	position = $element.attr('data-validation-position');
                    	}

                    	if (position === 'append') {
	                        parent.append('<div class="error-field"></div>');
                    	} else {
	                        parent.prepend('<div class="error-field"></div>');
                    	}
                        errorContainer = parent.children('.error-field');
                        errorContainer.hide().slideDown(100);
                    }
                    errorContainer.append($error);
                }
            },
            onkeyup: function (element) {
                var element_id = jQuery(element).attr('id');
                if (!this.settings.rules.hasOwnProperty(element_id) || !this.settings.rules[element_id].onkeyup) {
                    return;
                }

                if (validation) {
                    this.element(element);
                }
            },
            onfocusout: function (element, event) {
                /** Autocomplete-specific rule: do not perform validation if the autocomplete menu is open.
                 This prevents the issue of focus leaving the input when clicking a menu option which triggers validation and reports an error on the input.
                 **/
                var $ele = $(element);
                if ($ele.hasClass('tt-query')) {
                    var $menu = $ele.nextAll('.tt-dropdown-menu');
                    if ($menu.length > 0 && $menu.first().is(':visible')) {
                        return false;
                    }
                }

                /** Call the default onfocusout **/
                $.validator.defaults.onfocusout.call(this, element, event);
            },
            highlight: function (element, errorClass, validClass) {

                /** Apply correct classes to element **/
                if (element.type === "radio") {
                    this.findByName(element.name).addClass(errorClass).removeClass(validClass);
                } else {
                    $(element).addClass(errorClass).removeClass(validClass);
                }

                /** Apply correct classes to row **/
                var $wrapper = $(element).closest('.row-content, .fieldrow_value');
                $wrapper.addClass(errorClass).removeClass(validClass);

                /** If the error container is not visible, show it.
                 Delay/animation is used to return back to the event loop so that interactions still behave nicely
                 e.g. you're focused into an input, then click on a radio button - if an error message appeared immediately your click could miss the radio.
                 **/
                var errorContainer = $wrapper.find('.error-field');
                if (errorContainer.find('label:visible').length === 0) {
                    if (errorContainer.is(':visible')) {
                        errorContainer.stop();
                    }
                    errorContainer.delay(10).slideDown(100);
                }
            },
            unhighlight: function (element, errorClass, validClass) {
                return this.ctm_unhighlight(element, errorClass, validClass);
            }
        };

        return validationObj;
    }

    function isValid($element, displayErrors) {
        if (displayErrors)
            return $element.valid();

        var $form,
            $journeyEngineForm = $(document).find(".journeyEngineSlide").eq(meerkat.modules.journeyEngine.getCurrentStepIndex()).children("form");
        if ($journeyEngineForm.length)
            $form = $journeyEngineForm;
        else
            $form = $("#mainForm");

        try {
            return $form.validate(getDefaultValidationObj(), true).check($element);
        } catch (e) {
            return true;
        }

    }

    meerkat.modules.register('jqueryValidate', {
        init: init,
        initJourneyValidator: initJourneyValidator,
        events: events,
        isValid: isValid,
        setupDefaultValidationOnForm: setupDefaultValidationOnForm,
        getDefaultValidationObj: getDefaultValidationObj
    });

    /**
     * To reduce duplication of code.
     * @param element
     * @private
     */
    function _logDebug(element) {
        if(!element) {
            return;
        }
        log("[Validator] Modifying Rule on Element: " + (element.attr('id') || element.attr('name')));
    }

    $.fn.extend({
        isValid: function (displayErrors) {
            return meerkat.modules.jqueryValidate.isValid($(this), displayErrors);
        },
        /**
         * Required is a special case, as it is a property based rule.
         * If there is a data-rule-required attribute, it will be duplicated on an element, and thus have to be removed in both locations e.g. via $el.data().ruleRequired=false AND $el[0].required=false. Simply remove data-rule-required attribute instead.
         * @param required
         * @param message
         */
        setRequired: function (required, message) {
            return this.each(function () {

                var $el = $(this);
                $el[0].required = required;
                $el.prop('required', required);
                // For safety, lets remove or add attributes as well...
                if(!required) {
                    $el.removeAttr('required').removeAttr('aria-required');
                } else {
                    $el.attr('required', 'required').attr('aria-required','true');
                }
                if(message && required) {
                    $el.data('msgRequired', message);
                }
            });
        },
        /**
         * Messages are ok to stay when removing a rule, as they are simply not used.
         * @param ruleName
         * @returns {*}
         */
        removeRule: function (ruleName) {
            return this.each(function () {
                // format is e.g. ruleRequired ruleYoungestdob (instead of ruleyoungestDOB)
                var $el = $(this),
                    ruleString = ruleName.charAt(0).toUpperCase() + ruleName.substring(1).toLowerCase(),
                    rule = "rule" + ruleString;
                $el.data()[rule] = false;
                $el.removeAttr('data-rule-' + ruleString);
                //_logDebug($el);
            });

        },
        /**
         * This is instead of the jquery.validate plugins .rules("add", "rule") function.
         * This is because the .rules() method does not support adding or removing dataAttribute rules.
         * Rules are normalised, and e.g. if we have "required"
         * @param {String} ruleName
         * @param {String|Number|POJO} param
         * @param {String} message
         */
        addRule: function (ruleName, param, message) {
            return this.each(function () {
                var $el = $(this),
                    ruleString = ruleName.charAt(0).toUpperCase() + ruleName.substring(1).toLowerCase(),
                    rule = "rule" + ruleString;
                $el.data()[rule] = param || true;
                $el.attr('data-rule-' + ruleString, (param || true));
                if(message && message.length) {
                    var msg = "msg" + ruleString;
                    $el.data()[msg] = message;
                    $el.attr('data-msg-' + ruleString, message);
                    $.validator.messages[ruleName] = message;
                }
                //_logDebug($el);
            });
        }
    });


})(jQuery);

