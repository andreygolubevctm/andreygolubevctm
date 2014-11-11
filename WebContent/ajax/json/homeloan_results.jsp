<%@ page language="java" contentType="text/json; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<session:get settings="true" authenticated="true" verticalCode="HOMELOAN" />

<%-- VARIABLES --%>
<c:set var="vertical" value="${pageSettings.getVerticalCode()}" />

<%-- Load the params into data --%>
<security:populateDataFromParams rootPath="${vertical}" />

<%-- RECOVER: if things have gone pear shaped --%>
<c:if test="${empty data.current.transactionId}">
	<error:recover origin="ajax/json/homeloan_results.jsp" quoteType="${vertical}" />
</c:if>

<%-- Save data --%>
<core:transaction touch="R" noResponse="true" />

<%-- Fetch the transaction id --%>
<c:set var="tranId" value="${data['current/transactionId']}" />
<c:if test="${empty tranId}"><c:set var="tranId" value="0" /></c:if>



<%-- Execute the results service --%>
<jsp:useBean id="quoteService" class="com.ctm.services.homeloan.HomeLoanResultsService" scope="page" />
<c:set var="results" value="${quoteService.getResults(pageContext.getRequest())}" />



<c:choose>
	<c:when test="${empty results}">
		<c:set var="json" value='{"info":{"transactionId":${tranId}}},"errors":[{"message":"getResults is empty"}]}' />
	</c:when>
	<c:otherwise>
		<%-- crappy hack to inject the tranId --%>
		<c:set var="json" value="${fn:substringAfter(results.toString(), '{')}" />
		<c:set var="json" value='{"info":{"transactionId":${tranId}},${json}' />
	</c:otherwise>
</c:choose>

<c:out value="${json}" escapeXml="false" />