/**
 * This module uses data attributes to populate empty content areas with html, text, values, AJAX results from a specific source.
 * It is initially developed to only function for CARAMS-12, and will be extended for CARAMS-7
 */
;(function ($, undefined) {

	var meerkat = window.meerkat,
		meerkatEvents = meerkat.modules.events,
		log = meerkat.logging.info;

	var events = {
			contentPopulation: {}
		},
		moduleEvents = events.contentPopulation;

	/* Variables */


	/* main entrypoint for the module to run first */
	function init() {

	}

	/**
	 * Empty the values in the template. Needed to prevent ensure each refresh updates properly
	 * @param {String} container - Pass in a jQuery selector as the parent element wrapping the div template.
	 */
	function empty(container) {
		$('[data-source]', $(container)).each(function () {
			// it's possibly that we will want to reset a value/radio button/
			$(this).empty();
		});
	}

    /**
     * Loop through each element with data-source attribute within the container
     * Fill it with the content retrieved from the data-source
     * Can be used to retrieve any type of content, just add more conditions.
     * @param {String} container - Pass in a jQuery selector as the parent element wrapping the div template.
     * @param hasTitle - if true, toggle the display of the parent elment
     */
	function render(container, hasTitle) {
		var $container = $(container);
		$('[data-source]', $container).each(function () {
			var output = '',
				$el = $(this),
                dataType = $el.attr('data-type'),
				$sourceElement = dataType == 'object' ? $el : $($el.attr('data-source')),
				$alternateSourceElement = $($el.attr('data-alternate-source')); // used primarily with prefill data.

			// If the source element doesn't exist, continue
			if (!$sourceElement.length)
				return; // same as "continue" http://api.jquery.com/jquery.each/

			// setup variables
			var sourceType = $sourceElement.get(0).tagName.toLowerCase(),
				callback = $el.attr('data-callback');
			/**
			 * You can perform a callback function to create the output by adding: data-callback="meerkat.modules...."
			 * You can just let it handle it based on the elements tagName
			 * You can specify a data-type, and handle them differently e.g. radiogroup, list, JSON object etc (or create your own)
			 */
			if(callback) {
				/** To run a function. Can handle namespaced functions e.g. meerkat.modules... and global functions.
				 * Argument passed in to function is $sourceElement.
				 * If you wish to add another parameter,
				 * add it as a data attribute and include it in both .apply calls below as an additional array element.
				 **/
				try {
					var namespaces = callback.split('.');

					if(namespaces.length) {
						var func = namespaces.pop(),
						context = window;
						for(var i= 0; i < namespaces.length; i++) {
							context = context[namespaces[i]];
						}
						output = context[func].apply(context, [$sourceElement]);
					} else {
						output = callback.apply(window, [$sourceElement]);
					}
				} catch (e) {
					meerkat.modules.errorHandling.error({
						message:	"Unable to perform render Content Population Callback properly.",
						page:		"contentPopulation.js:render()",
						errorLevel:	"silent",
						description:"Unable to perform contentPopulation callback labelled: " + callback,
						data:		{"error": e.toString(), "sourceElement": $el.attr('data-source')}
					});
					output = '';
				}
			} else if (!dataType) {
				switch (sourceType) {
				case 'select':
					// to prevent a "please choose" from displaying.
					var $selected = $sourceElement.find('option:selected');
					if($selected.val() === '') {
						output = '';
					} else {
						// We generally want to see the options text content, rather than it's value.
						output = $selected.text() || '';
						// If there's an alternate source.
						if(output === '' && $alternateSourceElement.length) {
							$selected = $alternateSourceElement.find('option:selected');
							if($selected.val() === '') {
								output = '';
							} else {
								output = $selected.text() || '';
							}
						}
					}
					break;
				case 'input':
					output = $sourceElement.val() || $alternateSourceElement.val() || '';
					break;
				default:
					output = $sourceElement.html() || $alternateSourceElement.html() || '';
					break;
				}
			} else {
				var selectedParent;
				switch (dataType) {
					case 'checkboxgroup':
						selectedParent = $sourceElement.parent().find(':checked').next('label');
						if(selectedParent.length) {
							output = selectedParent.text() || '';
						}
					break;
					case 'radiogroup':
						selectedParent = $sourceElement.find(':checked').parent('label');
						if (selectedParent.length) {
							output = selectedParent.text() || '';
						}
						break;
					case 'list':
						// get it from a source ul, but text only
						// assumes the first span is the one with the text in it
						var $listElements = $sourceElement.find('li');
						if ($listElements.length > 0) {
							$listElements.each(function() {
								output += '<li>' + $(this).find('span:eq(0)').text() + '</li>';
							});
						} else {
							output += '<li>None selected</li>';
						}
						break;
					case 'optional':
						output = $sourceElement.val() || $alternateSourceElement.val() || '';
						// If we get even one output, we remove the no details element.
						if (output !== '') {
							$('.noDetailsEntered').remove();
						}
						break;
					case 'object':
						var object = $el.attr('data-source').split('.');
						output = window;
						try {
							for (var k = 0; k < object.length; k++) {
                                output = output[object[k]];
                            }
						} catch(e) {
							output = "";
						}
						break;
				}
			}

			// Santise the output
			var regex = /(<([^>]+)>)/ig;
			output = output.replace(regex, "");

			// currently we only want to replace the elements html, potential to replace value, select options...? extend this with further data options.
			$el.html(output);

            // If each snapshot has a heading/title, hide the parent element when it has no value
            // default implementation of the html in jsp should follow car/snapshot.tag to make this work
            if (hasTitle) {
                var $parent = $el.parent();
                $parent.toggle(output !== '' || hasData($parent));
            }
		});

        // Check if the container has value for at least one [data-source]. Hide the container if false.
		$container.toggle(hasData($container));
	}

    function hasData($container) {
        var hasData = false;
        $container.find('[data-source]').each( function() {
            if ($(this).html() !== '') {
                hasData = true;
                return false; // get out of the jQuery.each..
            }
        });
        return hasData;
    }

	meerkat.modules.register('contentPopulation', {
		init: init,
		events: events,
		render: render,
		empty: empty
		//here you can optionally expose functions for use on the 'meerkat.modules.example' object
	});

})(jQuery);