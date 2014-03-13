<%@ tag description="The reference number aka transaction number for the quote"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="quoteType" 			required="true" rtexprvalue="true"	 	description="The vertical the quote is associated with" %>
<%@ attribute name="id" 				required="false" rtexprvalue="true"	 	description="ID for the element - defaults to 'reference_number'" %>
<%@ attribute name="className" 			required="false" rtexprvalue="true"	 	description="additional css class attribute" %>
<%@ attribute name="label" 				required="false" rtexprvalue="true"	 	description="Label for the field - defaults to 'Reference Number'" %>
<%@ attribute name="showReferenceNo" 	required="false" rtexprvalue="true"		description="Flag whether to display the reference number" %>

<%--
	@todo This needs to be converted to a module and rewritten (to use data attributes etc) and decoupled from save quote...
--%>
<go:script href="common/js/referenceNumber.js" marker="js-href" />

<c:if test="${empty id}">
	<c:set var="id" value="reference_number" />
</c:if>

<c:if test="${empty label}">
	<c:set var="label" value="Reference no. " />
</c:if>

<c:choose>
	<c:when test="${empty showReferenceNo}">
		<c:set var="showReferenceNo" value="true" />
	</c:when>
	<c:otherwise>
		<c:set var="showReferenceNo" value="${showReferenceNo eq 'true'}" />
	</c:otherwise>
</c:choose>


<%-- HTML --%>
<%--
	display:none is there because referenceNumber.js is dumb and renders the hide/show twice with fades
--%>
<div id="${id}" class="${className}" style="display:none">
	${label}<span>${data.current.transactionId}</span>
</div>


<%-- JAVASCRIPT --%>
<go:script marker="js-head">
	var referenceNo = new ReferenceNo('${id}', ${showReferenceNo}, '${quoteType}');
</go:script>

<go:script marker="onready">
	referenceNo.init();
	referenceNo.setTransactionId(${data.current.transactionId});
</go:script>
