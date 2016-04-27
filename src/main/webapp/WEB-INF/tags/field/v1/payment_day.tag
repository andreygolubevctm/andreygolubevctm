<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Represents a checkbox input."%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 				required="true"		rtexprvalue="true"	description="variable's xpath" %>
<%@ attribute name="required" 			required="true"		rtexprvalue="true"	description="is this field required?" %>
<%@ attribute name="className" 			required="false"	rtexprvalue="true"	description="additional css class attribute" %>
<%@ attribute name="title" 				required="true"		rtexprvalue="true"	description="The title"%>
<%@ attribute name="message" 			required="false"	rtexprvalue="true"	description="Optional message to display underneath"%>
<%@ attribute name="messageClassName"	required="false"	rtexprvalue="true"	description="Optional message ClassName"%>
<%@ attribute name="startOfMonth"		required="false"	rtexprvalue="true"  description="Use start of the month instead of today, true/false" %>

<c:if test="${empty exclude}">
	<c:set var="exclude" value="${31}" />
</c:if>
<c:if test="${empty buffer}">
	<c:set var="buffer" value="${0}" />
</c:if>


<%-- VARIABLES --%>
<c:set var="name" value="${go:nameFromXpath(xpath)}" />

<%-- Create the Array --%>
<fmt:setLocale value="en_GB" scope="session" />
<jsp:useBean id="now" class="java.util.Date" scope="page" />

<c:choose>
	<c:when test="${startOfMonth eq true}">
		<fmt:formatDate value="${now}" pattern="d" var="dayOfMonth" />
		<c:set var="now" value="${go:AddDays(now,1-dayOfMonth)}" />
	</c:when>
	<c:otherwise>
		<c:set var="now" value="${go:AddDays(now,buffer)}" />
	</c:otherwise>
</c:choose>

<%-- HTML --%>
<field_v2:array_select items="=Please choose..." required="${required}" xpath="${xpath}" delims="||" className="field_payment_day ${className}" title="${title}" />
<c:if test="${not empty message}">
	<p class="${messageClassName}">${message}</p>
</c:if>
