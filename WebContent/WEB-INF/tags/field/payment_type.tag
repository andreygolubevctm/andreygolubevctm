<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Payment Type (Annual/Instalment)"%>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="variable's xpath" %>
<%@ attribute name="className" 	required="false" rtexprvalue="true"	 description="additional css class attribute" %>
<%@ attribute name="title" 		required="true"  rtexprvalue="true"	 description="title of the radio buttons" %>

<%-- VARIABLES --%>
<c:set var="name" value="${go:nameFromXpath(xpath)}" />
<c:set var="thisVal"><c:out value="${data[xpath]}" escapeXml="true"/></c:set>
<c:if test="${thisVal == ''}">
	<c:set var="thisVal" value="A" />
</c:if>

<%-- CSS --%>
<go:style marker="css-head">
	.paymentType {
		font-size: 1.1em;
		line-height: 1.1;
	}
</go:style>

<%-- HTML --%>
<select name="${name}" id="${name}" class="paymentType ${className}">
	<c:choose>
		<c:when test="${data[xpath]=='I'}">
			<option value="A">Annual</option>
			<option value="I" selected="selected">Monthly</option>
		</c:when>
		<c:otherwise>
			<option value="A" selected="selected">Annual</option>
			<option value="I">Monthly</option>
		</c:otherwise>
	</c:choose>
</select>



