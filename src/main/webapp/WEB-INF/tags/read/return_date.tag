<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Returns a date format, which can be altered by supplied values" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%@ attribute name="date" 				required="false" rtexprvalue="false"	description="Provide a date, must be in a value of yyyy-MM-dd" %>
<%@ attribute name="addDays"			required="false" rtexprvalue="false"	description="Days to add, e.g. 30 or subtract using a negative, e.g. -30" %>
<%@ attribute name="returnDatePattern"	required="false" rtexprvalue="false"	description="formatDate pattern to output, e.g. yyyy-MM-dd (default)" %>

<c:if test="${empty returnDatePattern}">
	<c:set var="returnDatePattern" value="yyyy-MM-dd" />
</c:if>

<%-- Set the current Date Object --%>
<fmt:setLocale value="en_GB" scope="page" />
<jsp:useBean id="now" class="java.util.GregorianCalendar" />


<%-- Reset the date object using the supplied date --%>
<c:if test="${not empty date}">
	<fmt:parseDate pattern="yyyy-MM-dd" var="setDate" value="${date}" type="date" dateStyle="full"/>
	<jsp:setProperty name="now" property="time" value="${setDate}" />
</c:if>


<%-- Adjust the date and time if required --%>
<c:if test="${not empty addDays}">
	<%
	int adjustedDays = Integer.parseInt( jspContext.getAttribute("addDays").toString() );
	now.add(java.util.GregorianCalendar.DAY_OF_MONTH, adjustedDays);
	%>
</c:if>


<%-- Return the final date --%>
<fmt:formatDate value="${now.time}" pattern="${returnDatePattern}" var="returnDate" />
${returnDate}