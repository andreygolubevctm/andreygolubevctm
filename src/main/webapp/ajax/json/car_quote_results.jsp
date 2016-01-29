<%@ page language="java" contentType="text/json; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<session:get settings="true" authenticated="true" verticalCode="CAR" />

<c:choose>
	<c:when test="${not empty param.action and param.action == 'latest'}">
		<c:set var="writeQuoteOverride" value="N" />
	</c:when>
	<c:otherwise>
		<security:populateDataFromParams rootPath="quote" />
		<c:set var="writeQuoteOverride" value="Y" />
	</c:otherwise>
</c:choose>

<%-- RECOVER: if things have gone pear shaped --%>
<c:if test="${empty data.current.transactionId}">
	<error:recover origin="ajax/json/car_quote_results.jsp" quoteType="car" />
</c:if>

<%-- Save data --%>
<core_v1:transaction touch="R" noResponse="true" writeQuoteOverride="${writeQuoteOverride}" />

<%-- Fetch and store the transaction id --%>
<c:set var="tranId" value="${data['current/transactionId']}" />

<jsp:forward page="/spring/rest/car/quote/get.json"/>