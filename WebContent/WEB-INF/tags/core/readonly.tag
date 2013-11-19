<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="ReadOnly with a dobody attribute - If read only, simply display value and store value into data bucket"%>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	rtexprvalue="true"	description="xpath to element" %>
<%@ attribute name="value" 		required="true" rtexprvalue="true" description="element value" %>
<%@ attribute name="displayValue" 		required="false" rtexprvalue="true" description="element value" %>
<%@ attribute name="readOnly" 	required="true" rtexprvalue="true" description="readOnly true or otherwise" %>

<c:set var="name" value="${go:nameFromXpath(xpath)}" />

<%-- IF READONLY, OUTPUT VALUE AND STORE IN READONLY BUCKET --%>
<c:choose>
	<c:when test="${readOnly == 'true'}">
		<input type="hidden" id="${name}" name="${name}" value="${value}">
		<c:choose>
			<c:when test="${not empty displayValue}" >
				<div class="field readonly">${displayValue}</div>
			</c:when>
			<c:otherwise>
				<div class="field readonly">${value}</div>
			</c:otherwise>
		</c:choose>
	</c:when>
	<%-- wrap the inner content of the tag as a body  --%>
	<c:otherwise><jsp:doBody  /></c:otherwise>
</c:choose>