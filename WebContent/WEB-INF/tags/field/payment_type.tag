<%@ tag language="java" pageEncoding="ISO-8859-1" %>
<%@ tag description="Payment Type (Annual/Instalment)"%>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="variable's xpath" %>
<%@ attribute name="className" 	required="false" rtexprvalue="true"	 description="additional css class attribute" %>
<%@ attribute name="title" 		required="true"  rtexprvalue="true"	 description="title of the radio buttons" %>

<%-- VARIABLES --%>
<c:set var="name" value="${go:nameFromXpath(xpath)}" />
<c:set var="thisVal" value="${data[xpath]}" />
<c:if test="${thisVal == ''}">
	<c:set var="thisVal" value="A" />
</c:if>

<%-- HTML --%>
<select name="${name}" id="${name}" class="paymentType ${className}">
	<c:choose>
		<c:when test="${data[xpath]=='I'}">
			<option value="A">Annual Payment</option>
			<option value="I" selected="selected">Instalment Payments</option>
		</c:when>
		<c:otherwise>
			<option value="A" selected="selected">Annual Payment</option>
			<option value="I">Instalment Payments</option>
		</c:otherwise>
	</c:choose>
</select>



