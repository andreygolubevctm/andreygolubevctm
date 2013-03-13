<%@ tag language="java" pageEncoding="ISO-8859-1" %>
<%@ tag description="Returns true/false if the person has achieved their birthday this year" %>
<jsp:useBean id="now" class="java.util.Date"/>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="dob" 		required="true"	 rtexprvalue="true"	 description="DOB = DD/MM/YYY" %>

<fmt:formatNumber var="dobMonth" value="${fn:substring(dob, 3, 5)+0}" pattern="##" minIntegerDigits="2" />
<fmt:formatNumber var="dobDay" value="${fn:substring(dob, 0, 2)+0}" pattern="##" minIntegerDigits="2" />

<fmt:formatDate var="nowMonth" value="${now}" pattern="MM"/>
<fmt:formatDate var="nowDay" value="${now}" pattern="dd"/>

<c:set var="birthday" value="${false}" />

<%-- The person hasn't reached the date yet so take a year off the total --%>
<c:if test="${ (dobMonth < nowMonth) || (dobMonth == nowMonth && dobDay <= nowDay) }">
	<c:set var="birthday" value="${true}" />
</c:if>

${birthday}