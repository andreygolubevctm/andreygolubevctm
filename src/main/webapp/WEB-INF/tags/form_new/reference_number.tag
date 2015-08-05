<%@ tag description="The reference number aka transaction number for the quote"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="label" 				required="false" rtexprvalue="true"	 	description="Label for the field - defaults to 'Reference Number'" %>
<%@ attribute name="className" 			required="false" rtexprvalue="true"	 	description="additional css class attribute" %>

<c:if test="${empty label}">
	<c:set var="label" value="Reference no. " />
</c:if>

<c:choose>
	<c:when test="${empty className}">
		<c:set var="className" value="transactionId" />
	</c:when>
	<c:otherwise>
		<c:set var="className">transactionId ${className}</c:set>
	</c:otherwise>
</c:choose>

<%-- HTML --%>
<div class="transactionIdContainer">
	${label}<span class="${className}">${data.current.transactionId}</span>
	<span class="rootId hidden">${data.current.rootId}</span>
	<simples:snapshot />
</div>