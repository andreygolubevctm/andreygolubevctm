<%@ tag description="The top-most header"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="quoteType" 			required="false"	 rtexprvalue="true"	description="The vertical this quote is associated with" %>
<%@ attribute name="hasReferenceNo" 	required="false" rtexprvalue="true"	description="Flag whether to create a reference number" %>
<%@ attribute name="showReferenceNo" 	required="false" rtexprvalue="true"	description="Flag whether to display the reference number" %>
<%@ attribute name="showReducedHoursMessage" 	required="false" rtexprvalue="true"	description="Whether show holiday message" %>

<c:choose>
	<c:when test="${fn:contains('car,ip,life', quoteType)}">
		<c:set var="saveQuoteText">Save Quote</c:set>
	</c:when>
	<c:otherwise>
		<c:set var="saveQuoteText">Email Quote</c:set>
	</c:otherwise>
</c:choose>
<%-- HTML --%>
<div id="header" class="clearfix normal-header">
	<div class="inner-header">
		<h1><a href="${pageSettings.getSetting('exitUrl')}" title="${pageSettings.getSetting('brandName')}">${pageSettings.getSetting('brandName')}</a></h1>
		<c:if test="${not empty hasReferenceNo and hasReferenceNo != false}">
			<go:log source="form:header">${quoteType} header param: ${param}</go:log>
			<%-- ID being sorted in core:quote_check so just use current one --%>
			<form:reference_number quoteType="${quoteType}" showReferenceNo="${showReferenceNo}" />
		</c:if>
		<form:contact_panel quoteType="${quoteType}" isCallCentre="${callCentre}" showReducedHoursMessage="${showReducedHoursMessage}" />
		<div id="navigation">
			<a href="javascript:void(0);" id="save-quote" class="smlbtn" title="${saveQuoteText}">
				<span>${saveQuoteText}</span>
			</a>
		</div>
	</div>
</div>
<%-- CSS --%>
<go:style marker="css-head">
	#save-quote { display: none; }
</go:style>

<%-- JAVASCRIPT --%>
<go:script marker="onready">

<%-- Define callback for the Save Quote button which will update the questionset with updated
	 marketing choice. Presently only applies to Car Quotes - other verticals use the save
	 button that exists in the ReferenceNumber tag. --%>
$('#save-quote').on('click', function() {
	<%-- Default callback is just an empty function --%>
	var callback = function(){};
<c:choose>
	<c:when test="${quoteType eq 'car'}">
	callback = function( mktg ) {
		var mktg = mktg || false;		
		$('#marketing').find('input').removeAttr('checked');
		$('#marketing').find('input[value='+ (mktg === false || mktg == 'Y' ? 'Y' : 'N') +']').attr('checked', true);
		$('#marketing').find('input').button('refresh');
	};
	</c:when>
</c:choose>
		SaveQuote.show(false, false, callback, '#slide' + QuoteEngine.getCurrentSlide());
});

	if(typeof SaveQuote !== 'undefined') {
		$(document).on(SaveQuote.confirmedEvent, function(event) {
			$('#save-quote').text(SaveQuote.resaveText);
		});
	}
</go:script>
