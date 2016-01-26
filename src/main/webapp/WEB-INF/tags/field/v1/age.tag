<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Returns the age of a person from a DOB (DD/MM/YYYY)" %>
<jsp:useBean id="now" class="java.util.Date"/>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="dob" 		required="true"	 rtexprvalue="true"	 description="DOB = DD/MM/YYY" %>

<fmt:formatNumber var="dobYear" value="${fn:substring(dob, 6, 12)+0}" pattern="####" minIntegerDigits="4" />
<fmt:formatNumber var="dobMonth" value="${fn:substring(dob, 3, 5)+0}" pattern="##" minIntegerDigits="2" />
<fmt:formatNumber var="dobDay" value="${fn:substring(dob, 0, 2)+0}" pattern="##" minIntegerDigits="2" />

<fmt:formatDate var="nowYear" value="${now}" pattern="yyyy"/>
<fmt:formatDate var="nowMonth" value="${now}" pattern="MM"/>
<fmt:formatDate var="nowDay" value="${now}" pattern="dd"/>

<c:set var="age" value="${nowYear - dobYear}" />

<%-- The person hasn't reached the date yet so take a year off the total --%>
<c:if test="${dobMonth > nowMonth || (dobMonth == nowMonth && dobDay > nowDay) }">
	<c:set var="age" value="${age -1}" />
</c:if>

${age}