<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ tag description="Form to searching/displaying saved quotes"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%-- ATTRIBUTES --%>
<%@ attribute name="quoteType" required="true" rtexprvalue="true"	description="The vertical this quote is associated with" %>

<go:script marker="js-head">
<%--
	Class submits the mainForm for writing at each step of a user journey
	to ensure current details are always captured
--%>
var WriteQuoteOnStep = function() {

	<%-- Private members area --%>
	var that			= this;

	<%-- Register listener for slide change to call the write quote --%>
	$(document).ready(function(){
		if( QuoteEngine._options.lastSlide ) {
			slide_callbacks.register({
				mode:		"before",
				slide_id:	-1,
				callback: 	function() {
					writeQuoteOnStep.write();
				}
			});
		<%-- Cases where everything on the one slide (eg fuel, travel) --%>
		} else {
			$('#next-step, #content .updatebtn').on('click', function(){
				writeQuoteOnStep.write();
			});
		}
	});

	<%-- Write quote data --%>
	this.write = function( options ) {
		var dat = serialiseWithoutEmptyFields('#mainform') + "&quoteType=${quoteType}";

		var result = false;

		var request = $.extend({
			url: "ajax/write/write_quote.jsp",
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
				result = true;
				return true;
			},
			error: function(data){
				result = false;
				return false;
			}
		}, options);

		$.ajax(request);

		return result;
	};
};

var writeQuoteOnStep = new WriteQuoteOnStep();
</go:script>