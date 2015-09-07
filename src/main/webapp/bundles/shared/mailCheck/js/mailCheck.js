;(function($, undefined){

	var meerkat = window.meerkat,
		meerkatEvents = meerkat.modules.events,
		log = meerkat.logging.info,
		msg = meerkat.messaging;

	var events = {},
	moduleEvents = events;

	var emailDomains = null,
		secondLevelDomains = null,
		$emailField = null,
		$attemptsField = null,
		$selectionsField = null,
		$outputField = null,
		lastEmailEntered = null;

	function init(){
		$(document).ready(function(){
			var $dataField = $("#mailCheckData");
			if($dataField.length) {
				var data = JSON.parse($dataField.val());
				emailDomains = data.emailDomains;
				secondLevelDomains = [];
				for(var i=0; i<emailDomains.length; i++) {
					secondLevelDomains.push(emailDomains[i].split(".")[0]);
				}
				$emailField = $(data.emailField);
				$attemptsField = $(data.attemptsField);
				$selectionsField = $(data.selectionsField);
				$outputField = $(data.outputField);
				addListener();
			}
		});
	}

	var levenshteinDistance = function(s,t) {
		// Determine the Levenshtein distance between s and t
		if (!s || !t) {
			return 99;
		}
		var m = s.length;
		var n = t.length;

		/* For all i and j, d[i][j] holds the Levenshtein distance between
		 * the first i characters of s and the first j characters of t.
		 * Note that the array has (m+1)x(n+1) values.
		 */
		var d = [];
		for (var i = 0; i <= m; i++) {
			d[i] = [];
			d[i][0] = i;
		}
		for (var j = 0; j <= n; j++) {
			d[0][j] = j;
		}

		// Determine substring distances
		var cost = 0;
		for (j = 1; j <= n; j++) {
			for (i = 1; i <= m; i++) {
				cost = (s.charAt(i-1) == t.charAt(j-1)) ? 0 : 1;  // Subtract one to start at strings' index zero instead of index one
				d[i][j] = Math.min(d[i][j-1] + 1,                 // insertion
					Math.min(d[i-1][j] + 1,        // deletion
						d[i-1][j-1] + cost)); // substitution
			}
		}

		// Return the strings' distance
		return d[m][n];
	}

	var addListener = function() {
		$emailField.on('blur', function(event) {
			var email = $(this).val();
			$(this).mailcheck({
				domains: emailDomains,
				secondLevelDomains: secondLevelDomains,
				topLevelDomains: null,
				distanceFunction: levenshteinDistance,
				suggested: function(element, suggestion) {
					if(!_.isEmpty(email) && email != lastEmailEntered) {
						lastEmailEntered = email;
						appendEmailTo($attemptsField, email);
					}

					$link = $("<a/>",{
						title:	"use " + suggestion.full + " instead?",
						text:	suggestion.full
					});
					$link.on("click", _.bind(useSuggestion, this, suggestion.full));

					$outputField.empty().append("Did you mean ")
					.append($link)
					.append("&nbsp;?");
				},
				empty: function(element) {
					$outputField.empty();
				}
			});
		});
	};

	var useSuggestion = function(suggestion) {
		appendEmailTo($selectionsField, suggestion);
		$emailField.val(suggestion).trigger("blur");
	};

	var appendEmailTo = function($field, email) {
		var emails = $field.val();
		emails = _.isEmpty(emails) ? email : emails + "," + email;
		$field.val(emails);
	};

	meerkat.modules.register("mailCheck", {
		init: init,
		events: events
	});

})(jQuery);