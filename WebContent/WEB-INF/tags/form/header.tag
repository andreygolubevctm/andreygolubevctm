<%@ tag description="The top-most header"%>
<%@ tag language="java" pageEncoding="ISO-8859-1" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="quoteType" 			required="false"	 rtexprvalue="true"	description="The vertical this quote is associated with" %>
<%@ attribute name="hasReferenceNo" 	required="false" rtexprvalue="true"	description="Flag whether to create a reference number" %>
<%@ attribute name="showReferenceNo" 	required="false" rtexprvalue="true"	description="Flag whether to display the reference number" %>

<%-- HTML --%>
<div id="header" class="clearfix">
	<div class="inner-header">
		<h1><a href="${data['settings/exit-url']}" title="Compare the Market">Compare the Market</a></h1>
		<c:if test="${not empty hasReferenceNo}">
			<go:log>${quoteType} header param: ${param}</go:log>
			<%-- ID being sorted in core:quote_check so just use current one --%>
			<form:reference_number quoteType="${quoteType}" showReferenceNo="${showReferenceNo}" />
		</c:if>
		<form:contact_panel quoteType="${quoteType}" isCallCentre="${callCentre}" />
		<div id="navigation">
			<a href="javascript:void(0)" id="save-quote" class="smlbtn" title="Save Quote"><span>Save Quote</span></a>
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
	SaveQuote.show(false, false, callback);
});
</go:script>
