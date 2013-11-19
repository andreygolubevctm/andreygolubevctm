<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ tag description="Form to searching/displaying saved quotes"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%-- ATTRIBUTES --%>
<%@ attribute name="quoteType" required="true" rtexprvalue="true"	description="The vertical this quote is associated with" %>

<go:script marker="js-head">
<%--
	Class submits the mainForm for writing the current quote form to the database via ajax
--%>
var WriteQuoteAjax = function() {

	<%-- Private members area --%>
	var that				= this,
		last_fatal_thrown	= 0,
		last_fatal_timeout	= 5 * 60 * 1000 /* 5 mins */;

	<%-- Public write method - receives an object that is appended to the ajax data query string --%>
	this.write = function( qs_object ) {
		qs_object = typeof qs_object == "object" ? qs_object : {};
		writeQuote(qs_object);
	};

	<%-- Private write method --%>
	var writeQuote = function( qs_object ) {

		<%-- Check if fatalerror request and ignore if within time specified in var last_fatal_timeout --%>
		if( typeof qs_object == "object" && qs_object.hasOwnProperty("triggeredsave") && qs_object.triggeredsave == "fatalerror" ) {
			var timestamp = new Date().getTime();
			if( timestamp < last_fatal_thrown + last_fatal_timeout ) {
				return false;
			}

			last_fatal_thrown = timestamp;
		}

		var data = serialiseWithoutEmptyFields('#mainform') + "&quoteType=${quoteType}&stage=" + $.address.parameter("stage");

		for(var i in qs_object) {
			if( qs_object.hasOwnProperty(i) ) {
				data += "&" + i + "=" + qs_object[i]
			}
		}

		var result = false;

		var request = {
			url: "ajax/write/write_quote.jsp",
			data: data,
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
				return true;
			},
			error: function(obj){
				FatalErrorDialog.exec({
					silent:			true, <%-- Make silent as user doesn't need to know if this failed --%>
					message:		"An error occurred when attempting to save your quote data.",
					page:			"agg:write_quote_ajax.tag",
					description:	"WriteQuoteAjax.writeQuote(). " + getErrorMessage(obj),
					data:			data
				});
				return false;
			}
		};

		$.ajax(request);

		return false;
	};

	var getErrorMessage = function( obj ) {
		var error = "";
		if( typeof obj == "object" && obj.hasOwnProperty("responseText") ) {
			try {
				var errors = eval(obj.responseText);
				if(typeof errors == "object" && errors.length) {
					for( var i in errors ) {
						if( errors.hasOwnProperty(i) ) {
							error += " " + errors[i].error;
						}
					}
				} else {
					error = errors;
				}
			} catch(e) {
				// ignore
			}
		}

		if( error == "" ) {
			return "An error was thrown however no error message content was provided.";
		} else {
			return error;
		}
	};
};

var write_quote_ajax = new WriteQuoteAjax();
</go:script>