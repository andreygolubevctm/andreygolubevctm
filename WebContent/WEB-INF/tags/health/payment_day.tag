<%@ tag language="java" pageEncoding="ISO-8859-1" %>
<%@ tag description="Represents a checkbox input."%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="variable's xpath" %>
<%@ attribute name="required" 	required="true"	 rtexprvalue="true"  description="is this field required?" %>
<%@ attribute name="className" 	required="false" rtexprvalue="true"	 description="additional css class attribute" %>
<%@ attribute name="title" 		required="true"	 rtexprvalue="true"	 description="The title"%>

<%-- VARIABLES --%>
<c:set var="name" value="${go:nameFromXpath(xpath)}" />

<%-- Create the Array --%>
<fmt:setLocale value="en_GB" scope="session" />
<jsp:useBean id="now" class="java.util.GregorianCalendar" scope="page" />
<% now.add(java.util.GregorianCalendar.DAY_OF_MONTH, 7); %>

<c:set var="days">=Please Choose...
<c:forEach step="1" begin="1" end="${20}" var="itemArray" varStatus="status">
	<% now.add(java.util.GregorianCalendar.DAY_OF_MONTH, 1); %>
	<fmt:formatDate value="${now.time}" pattern="d" var="nowDate" />
	<fmt:formatDate value="${now.time}" pattern="EEEE, d MMMM yyyy" var="displayDate" />
	<fmt:formatDate value="${now.time}" pattern="yyyy-MM-dd" var="valueDate" />
	<c:if test="${(nowDate + 0) < 27}">
	||${valueDate}=${displayDate}
	</c:if>
</c:forEach>
</c:set>


<%-- HTML --%>
<field:array_select items="${days}" required="${required}" xpath="${xpath}" delims="||" className="health_payment_day ${className}" title="${title}" />