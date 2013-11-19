<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Builds an accordion container"%>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- JavaScript --%>
<go:script marker="js-head">

<%--
	UI:POPUP_WINDOW.tag
	------------------------------------------------------------
	This tag simply provides a standard javascript object for
	which to launch popup windows from (windows, NOT dialogs).

	It has one public method ui_popup_window.open() which requires
	only 2 arguments - a label and a URL to open. You can also pass
	it optional arguments for name, specs and replace.

	When opening a window it will first check if a window (based
	on the label) already exists and close it.

	This was created in response to LIF-38 to solve an IE issue
	where the popup window remained opened behind the main
	window and wouldn't come back to the front when same link was
	clicked again... leaving the user utterly mystified.
--%>

var UIPopupWindowObject = function() {

	var that		= this,
		defaults	= {
			location :		1,
			menubar :		1,
			resizable :		1,
			scrollbars :	1,
			status :		1
		},
		popup		= [];

	<%--
	(public) this.open: public function to open a popup window. Only the label and url are mandatory and must
						be supplied in order. The balance are optional and can be provided in any order.

		param (required 1):	label (string) 		- internal identifier for the window
		param (required 2):	url (string) 		- the url to be opened
		param (optional ?):	spec (object) 		- an object containing window specifications
		param (optional ?):	replace (boolean) 	- flag to indicate whether to replace entry in the history list

		Refer here for more info: http://www.w3schools.com/jsref/met_win_open.asp

	--%>
	this.open = function() {

		<%-- Default options --%>
		var options = {
			label:		null,
			url:		null,
			specs:		getDefaults(),
			replace:	''
		};

		<%-- Loops through function arguments to work out what options have been provided --%>
		for (var i = 0; i < arguments.length; i++) {

			var arg = arguments[i];

			<%-- First arg should be a string for the window identifier aka label --%>
			if( i == 0 && (typeof arg == "string" || (typeof arg == "object" && arg.constructor === String)) ) {
				options.label = arg;
			<%-- Second should then be a string for the URL to be opened --%>
			} else if( i == 1 && (typeof arg == "string" || (typeof arg == "object" && arg.constructor === String)) ) {
				options.url = arg;
			<%-- Check upto 2 subsequent arguments --%>
			} else if ( i > 1 && i < 4 ) {
				<%-- If an object then should be the window specs option --%>
				if( typeof arg == "object" && arg.constructor === Object ) {
					options.specs = $.extend(options.specs, arg);
				<%-- If a boolean then should be the replace option --%>
				} else if ( typeof arg == "boolean" || (typeof arg == "object" && arg.constructor === Boolean) ) {
					options.replace = arg;
				}
			}
		}

		<%-- label and url are the minimum options required --%>
		if( options.label != null && options.url != null ) {
			open( options );
		} else {
			// Do nothing;
		}
	};

	<%--
	(private) open: receives the list of window options and opens the window.
		param (required):	options (object) 	- list of window properties

	--%>
	var open = function(options) {

		<%-- Flatten the list of window spec to a comma separated string --%>
		options.specs = getFlattenedSpecs(options.specs);

		<%-- This is an IE specific fix as IE somehow loses its reference
			to the window object and fails when trying to focus on the
			existing window. Only solution is to open a window of the same
			name and close it before moving on. --%>
		if($.browser.msie && parseInt($.browser.version, 10) < 10){ //do this only in IE
			var tmp = window.open("", options.label, options.specs);
			tmp.close();
		}

		if (typeof(popup[options.label]) != "object"){
			popup[options.label] = window.open(
				options.url,
				options.label,
				options.specs,
				options.replace
			);
		} else {
			if (!popup[options.label].closed){
				popup[options.label].location.href = options.url;
			} else {
				popup[options.label] = window.open(
					options.url,
					options.label,
					options.specs,
					options.replace
				);
			}
		}

		popup[options.label].focus();
	};

	<%-- Returns the window specs provided in the flattened format required for the window.open call --%>
	var getFlattenedSpecs = function( specs ) {
		var output = "";
		if( specs != null ) {
			var temp = [];
			for( var i in specs ){
				if( specs.hasOwnProperty(i) ) {
					temp.push(i + "=" + specs[i]);
				}
			}
			output = temp.join(',');
		}
		return output;
	};

	<%-- Returns a copy of the defaults variable --%>
	var getDefaults = function() {
		return $.extend({}, defaults);
	};
}

var ui_popup_window = new UIPopupWindowObject();

</go:script>