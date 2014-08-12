<%@page import="java.util.Date"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:choose>
	<c:when test="${param.quoteType eq 'car'}">
		<c:set var="quoteType" value="${param.quoteType}" />
	</c:when>
	<c:when test="${param.quoteType eq 'utilities'}">
		<c:set var="quoteType" value="${param.quoteType}" />
	</c:when>
	<c:when test="${param.quoteType eq 'life'}">
		<c:set var="quoteType" value="${param.quoteType}" />
	</c:when>
	<c:when test="${param.quoteType eq 'ip'}">
		<c:set var="quoteType" value="${param.quoteType}" />
	</c:when>
	<c:when test="${param.quoteType eq 'health'}">
		<c:set var="quoteType" value="${param.quoteType}" />
	</c:when>
	<c:when test="${param.quoteType eq 'travel'}">
		<c:set var="quoteType" value="${param.quoteType}" />
	</c:when>
	<c:otherwise>
	</c:otherwise>
</c:choose>

<session:get settings="true" authenticated="true" verticalCode="${fn:toUpperCase(quoteType)}" />

<c:if test="${not empty quoteType}">
	<c:if test="${empty data.current.transactionId}">
		<error:recover origin="ajax/write/request_callback.jsp" quoteType="${quoteType}" />
	</c:if>

	<c:if test="${param.source != 'leadGen'}">
		<security:populateDataFromParams rootPath="${quoteType}" />
	</c:if>

	<c:set var="timeOfDayXpath" >${quoteType}/callmeback/timeOfDay</c:set>
	<go:callCenterHours timeOfDay="${data[timeOfDayXpath]}" callBackVar="callBack" vertical="health" />

	<fmt:formatDate var="date" value="${callBack}" pattern="YYYY-MM-dd"/>
	<fmt:formatDate var="time" value="${callBack}" pattern="HH:mm:ss"/>

	<c:set var="timeXpath" >${quoteType}/callmeback/time</c:set>
	<c:set var="dateXpath" >${quoteType}/callmeback/date</c:set>
	<go:setData dataVar="data" xpath="${dateXpath}" value="${date}" />
	<go:setData dataVar="data" xpath="${timeXpath}" value="${time}" />

	<core:transaction touch="S" noResponse="true"  />
</c:if>

<c:if test="${param.source != 'leadGen'}">
{
	"time" : "${time}" ,
	"date" : "${date}"
}
</c:if>

