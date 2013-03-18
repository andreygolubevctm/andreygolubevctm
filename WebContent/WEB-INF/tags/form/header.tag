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
			<a href="javascript:SaveQuote.show();" id="save-quote" class="smlbtn" title="Save Quote"><span>Save Quote</span></a>
		</div>
	</div>
</div>
<%-- CSS --%>
<go:style marker="css-head">
	#save-quote { display: none; }
</go:style>

<%-- JAVASCRIPT --%>
<go:script marker="onready">
</go:script>
