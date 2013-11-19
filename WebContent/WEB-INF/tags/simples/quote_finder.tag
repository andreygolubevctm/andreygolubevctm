<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ tag description="Form to searching/displaying saved quotes"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<c:set var="dialogLabel" value="quoteFinderDialog" />

<ui:dialog id="${dialogLabel}" title="Quote Finder" width="500" height="700" draggable="${true}" resizable="${true}" titleDisplay="${false}">
	<div class="header">
		<div class="title">Quote Finder</div>
		<div class="finder">
			<button>find</button>
			<input type="text" name="findQuotesTerm" id="findQuotesTerm" class="default" />
		</div>
	</div>
	<div id="quote_finder_results"></div>
	<div class="content"></div>
</ui:dialog>

<go:script marker="js-href" href="common/js/InspectorJSON/underscore/1.3.3/underscore.js" />
<go:script marker="js-href" href="common/js/InspectorJSON/store/1.3.x/store.js" />
<go:script marker="js-href" href="common/js/InspectorJSON/inspector_json.js" />
<go:style marker="css-href" href="common/js/InspectorJSON/inspector_json.css" />

<go:script marker="js-head">
var QuoteFinder = function() {

	// Private members area
	var that			= this,
		default_text	= "email or transaction id",
		elements		= {};

	// Initialiser
	this.init = function() {
		elements = {
			root : $('#${dialogLabel}Dialog')
		};

		elements.input 		= elements.root.find('.header input').first();
		elements.find 		= elements.root.find('.header button').first();
		elements.results 	= elements.root.find('#quote_finder_results');

		elements.input.val( default_text );
		elements.input.on("focus", function(){
			if( elements.input.val() == default_text ) {
				elements.input.val('');
				elements.input.removeClass('default');
			}
		});
		elements.input.on("blur", function(){
			var validation = validateSearch(elements.input.val());
			if( !validation.valid ) {
				if( validation.term == '' || validation.term  == default_text ) {
					elements.input.val( default_text );
					elements.input.addClass('default');
					elements.input.removeClass('error');
				} else {
					elements.input.addClass('error');
				}
			} else {
				elements.input.removeClass('error');
			}
		});
		elements.input.on('keypress', function (e) {
			if (e.which == 13) {
				elements.find.trigger('click');
				return false;
			}
		});
		elements.find.on("click", function(){
			var validation = validateSearch(elements.input.val());
			if( !validation.valid ) {
				if( validation.term == '' || validation.term == default_text ) {
					elements.input.val( default_text );
					elements.input.addClass('default');
					elements.input.removeClass('error');
				} else {
					elements.input.addClass('error');
				}
			} else {
				elements.input.removeClass('error');
				find( validation );
			}
		});
	};

	// Open the Quote Finder dialog
	this.open = function() {
		${dialogLabel}Dialog.open(that.heightMatchResultsWithDialog);
	};

	// Perform search action
	var find = function( validation_obj ) {

		Loading.show("Finding Quotes...");

		var dat = validation_obj;

		$.ajax({
			url: "ajax/json/quote_finder.jsp",
			data: dat,
			type: "POST",
			async: true,
			dataType: "json",
			timeout:60000,
			cache: false,
			beforeSend : function(xhr,setting) {
				var url = setting.url;
				var label = "uncache",
				url = url.replace("?_=","?" + label + "=");
				url = url.replace("&_=","&" + label + "=");
				setting.url = url;
			},
			success: function(json){
				Loading.hide();
				render(json);
				return false;
			},
			error: function(data){
				Loading.hide();
				render(data);
				return false;
			}
		});
	};

	// Display results in the dialog
	var render = function( json ) {

		var results = false;
		if( json.hasOwnProperty('findQuotes') && typeof json.findQuotes == 'object' ) {
			var findQuotes = json.findQuotes;
			if( findQuotes.hasOwnProperty('quotes') && findQuotes.quotes.constructor == Array ) {
				results = findQuotes.quotes;
			} else if ( findQuotes.hasOwnProperty('quotes') && typeof findQuotes.quotes == 'object' ) {
				results = [];
				results.push(findQuotes.quotes);
			}
		}

		if( results !== false ) {
			var obj = {};
			for(var i in results) {
				if( results[i].hasOwnProperty('quote') ) {
					var id = results[i].id + " - Car";
					obj[id] = {};
					obj[id] = results[i].quote;
				} else if( results[i].hasOwnProperty('health') ) {
					var id = results[i].id + " - Health";
					obj[id] = {};
					obj[id] = results[i].health;
				} else if( results[i].hasOwnProperty('ip') ) {
					var id = results[i].id + " - IP";
					obj[id] = {};
					obj[id] = results[i].ip;
				} else if( results[i].hasOwnProperty('life') ) {
					var id = results[i].id + " - Life";
					obj[id] = {};
					obj[id] = results[i].life;
				} else if( results[i].hasOwnProperty('travel') ) {
					var id = results[i].id + " - Travel";
					obj[id] = {};
					obj[id] = results[i].travel;
				} else if( results[i].hasOwnProperty('utilities') ) {
					var id = results[i].id + " - Utilities";
					obj[id] = {};
					obj[id] = results[i].utilities;
				} else {
					// ignore
				}
			}

			if( typeof viewer == "object" && viewer instanceof InspectorJSON ) {
				viewer.destroy();
			}

			viewer = new InspectorJSON({
				element: '#quote_finder_results',
				collapsed: true,
				debug: false
			});

			viewer.view( obj );
		} else {
			var message = "";
			try {
				var errors = eval(json.responseText);
				for(var i in errors) {
					message += "<li>" + errors[i].error + "</li>";
				}
			} catch(e) {
				message = "<li>Apologies: There was a fatal error searching quotes.</li>";
			}

			elements.results.empty().append( "<ol class='response_errors'>" + message + "</ol>" );
		}
	};

	this.heightMatchResultsWithDialog = function() {
		//_.delay( function() {
			var height = Math.ceil($('#quoteFinderDialogDialog').height());
			elements.results.css({height:(height - 62)});
		//}, 500);
	};

	// Validate search term
	var validateSearch = function( term ) {
		var result = {
			valid : false,
			term : $.trim(term),
			type : false
		};

		if( term != '' ) {
			if( isValidEmailAddress(term) ) {
				result = $.extend(result, {valid:true,type:'email'});
			} else if( isTransactionId(term) ) {
				result = $.extend(result, {valid:true,type:'transactionid'});
			}
		}

		return result;
	};

	// Validate email address
	var isValidEmailAddress = function(emailAddress) {
		var pattern = new RegExp(/^((([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+(\.([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+)*)|((\x22)((((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(([\x01-\x08\x0b\x0c\x0e-\x1f\x7f]|\x21|[\x23-\x5b]|[\x5d-\x7e]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(\\([\x01-\x09\x0b\x0c\x0d-\x7f]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]))))*(((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(\x22)))@((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.?$/i);
		return pattern.test(emailAddress);
	};

	// Validate transaction ID
	var isTransactionId = function(tranId) {
		try {
			var test = parseInt(String(tranId), 10);
			return !isNaN(test);
		} catch(e) {
			return false;
		}
	};
};

var quoteFinder = new QuoteFinder();

$(document).ready(function(){
	quoteFinder.init();
});
</go:script>

<go:style marker="css-head">
#${dialogLabel}Dialog .header {
	height:				40px;
	padding:			0 5px;
	border-bottom:		1px solid #ccc;
}
#${dialogLabel}Dialog .header .title {
	float:				left;
	width:				25%;
	font-size:			120%;
	font-weight:		bold;
	margin-top:			5px;
}
#${dialogLabel}Dialog .header .finder {
	float:				right;
	width:				70%;
}
#${dialogLabel}Dialog .header .finder input,
#${dialogLabel}Dialog .header .finder button {
	float:				right;
}
#${dialogLabel}Dialog .header .finder input {
	font-size:			100%;
	width:				200px;
	padding:			2px 5px;
}
#${dialogLabel}Dialog .header .finder input.default {
	color:				#ccc;
	font-style:			italic;
}
#${dialogLabel}Dialog .header .finder input.error {
	border-color:		#ff0000;
}
#${dialogLabel}Dialog #quote_finder_results,
#${dialogLabel}Dialog #quote_finder_results.inspector-json {
	padding: 			10px 20px;
	width: 				432px;
	height:				auto;
	overflow-x: 		hidden;
	overflow-y: 		scroll;
}
#${dialogLabel}Dialog #quote_finder_results *,
#${dialogLabel}Dialog #quote_finder_results.inspector-json * {
	white-space: pre-wrap;
	word-wrap: break-word;
	font-family: monospace;
	font-size: 13px!important;
	line-height: 18px !important;
}
#${dialogLabel}Dialog #quote_finder_results ol.response_errors li {
	margin: 			0 0 9px 20px;
	padding: 			0 0 0 5px;
	list-style-type:	decimal;
	color:				#ff0000;
}
</go:style>