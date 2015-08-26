/**
 * Do not know the purpose of this variable. It was ported over during refactor.
 * @type {boolean}
 */
var validation = false;

;(function ($, undefined) {
    var meerkat = window.meerkat;

    var events = {
        };

    function init() {

        if(typeof $.validator !== 'function') {
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

        $('.journeyEngineSlide form').each(function(){
            setupDefaultValidationOnForm( $(this) );
        });

    }

    /**
     *
     * @private
     */
    function _overrideValidatorPrototypes() {

        String.prototype.startsWith = function(prefix) {
            return (this.substr(0, prefix.length) === prefix);
        };
        String.prototype.endsWith = function(suffix) {
            return (this.substr(this.length - suffix.length) === suffix);
        };

        /**
         * Not sure why we need this one. TODO: test it
         */
        $.validator.prototype.hideErrors = function() {
            this.addWrapper( this.toHide );
        };

        /*$.validator.prototype.customMessage = function( name, method ) {
            console.log($.validator.messages);
            var m = this.settings.messages[ name ] || $.validator.messages[method];
            console.log(m);
            return m && ( m.constructor === String ? m : m[ method ]);
        };*/

        /**
         * CTM Custom Unhighlight function
         * We define this as a prototype, so that the function only needs to be in memory once.
         * Without this, it would be cloned on every init of the validator.
         * @param element
         * @param errorClass
         * @param validClass
         */
        $.validator.prototype.ctm_unhighlight = function( element, errorClass, validClass ) {
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
    function setupDefaultValidationOnForm( $formElement ) {
        $formElement.validate({
            submitHandler: function(form) {
                form.submit();
            },
            invalidHandler: function(form, validator) {

                if (!validator.numberOfInvalids()) return;
                if(jQuery.validator.scrollingInProgress) return;

                var $ele = $(validator.errorList[0].element),
                    $parent = $ele.closest('.row-content, .fieldrow_value');


                if($ele.attr('data-validation-placement') !== null && $ele.attr('data-validation-placement') !== ''){
                    var $ele2 = $($ele.attr('data-validation-placement'));
                    if ($ele2.length > 0) $ele = $ele2;
                }

                /** If the element has a row parent (where the error message gets inserted to), then scroll to that instead **/
                if ($parent.length > 0) $ele = $parent;
                jQuery.validator.scrollingInProgress = true;
                meerkat.modules.utils.scrollPageTo($ele,500,-50, function(){
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
                if(typeof $element.attr('data-validation-placement') !== 'undefined' &&
                    $element.attr('data-validation-placement') !== null && $element.attr('data-validation-placement') !== ''){
                    $referenceElement = $($element.attr('data-validation-placement'));
                }
                var parent = $referenceElement.closest('.row-content, .fieldrow_value');
                if(parent.length === 0) parent = $element.parent();

                var errorContainer = parent.children('.error-field');

                if (errorContainer.length === 0) {
                    parent.prepend('<div class="error-field"></div>');
                    errorContainer = parent.children('.error-field');
                    errorContainer.hide().slideDown(100);
                }
                errorContainer.append($error);
            },
            onkeyup: function(element) {
                var element_id = jQuery(element).attr('id');
                if ( !this.settings.rules.hasOwnProperty(element_id) || !this.settings.rules[element_id].onkeyup) {
                    return;
                }

                if (validation && element.name !== "captcha_code") {
                    this.element(element);
                }
            },
            onfocusout: function(element, event) {
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
            highlight: function( element, errorClass, validClass ) {
                /** console.log('highlight', element); **/

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
            unhighlight: function( element, errorClass, validClass ) {
                return this.ctm_unhighlight( element, errorClass, validClass );
            }
        });
    }


    function isValid( $element, displayErrors ){
        if( displayErrors )
            return $element.valid();

        var $journeyEngineForm = $(document).find(".journeyEngineSlide").eq(meerkat.modules.journeyEngine.getCurrentStepIndex()).children("form");
        if($journeyEngineForm.length)
            $form = $journeyEngineForm;
        else
            $form = $("#mainForm");

        try {
            return $form.validate().check( $element );
        } catch(e) {
            return true;
        }

    }

    meerkat.modules.register('jqueryValidate', {
        init: init,
        initJourneyValidator: initJourneyValidator,
        events: events,
        isValid: isValid,
        setupDefaultValidationOnForm: setupDefaultValidationOnForm
    });

    $.fn.extend({
        isValid: function( displayErrors ) {
            return meerkat.modules.jqueryValidate.isValid( $(this), displayErrors );
        }
    });

})(jQuery);

