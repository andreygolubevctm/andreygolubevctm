<%@ page language="java" contentType="text/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<core_new:no_cache_header/>

<session:get settings="true" authenticated="true" verticalCode="HEALTH" throwCheckAuthenticatedError="true" />

<%-- Test and or Increment ID if required --%>
<c:choose>
	<%-- RECOVER: if things have gone pear shaped --%>
	<c:when test="${empty data.current.transactionId}">
		<error:recover origin="ajax/json/health_quote_results_ws.jsp" quoteType="health" />
	</c:when>
	<%--
	This is now getting triggered by the new Results.js code which adds the querystring params.
	Increment is already done in core:transaction below.

	<c:when test="${param.health_incrementTransactionId}">
		<c:set var="id_return">
			<core:get_transaction_id quoteType="health" id_handler="increment_tranId" />
		</c:set>
	</c:when>
	--%>
	<c:otherwise>
		<%-- All is good --%>
	</c:otherwise>
</c:choose>
		<%-- Save client data --%>
		<c:choose>
			<c:when test="${param.health_showAll == 'N'}">
				<core:transaction touch="Q" noResponse="true" />
			</c:when>
			<c:otherwise>
				<core:transaction touch="R" noResponse="true" />
			</c:otherwise>
		</c:choose>

		<%-- Collect the tranIDs after they've potentially been incremented --%>
		<go:setData dataVar="data" xpath="health/transactionId" value="${data.current.transactionId}" />
		<c:set var="tranId" value="${data.current.transactionId}" />

<jsp:forward page="/rest/health/quote/get.json"/>