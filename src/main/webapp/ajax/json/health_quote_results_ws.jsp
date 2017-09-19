<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<core_v2:no_cache_header/>

<session:get settings="true" authenticated="true" verticalCode="HEALTH" throwCheckAuthenticatedError="true" />

<security:populateDataFromParams rootPath="health" />

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
			<core_v1:get_transaction_id quoteType="health" id_handler="increment_tranId" />
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
				<core_v1:transaction touch="Q" noResponse="true" />
			</c:when>
			<c:otherwise>
				<core_v1:transaction touch="R" noResponse="true" />
			</c:otherwise>
		</c:choose>

		<%-- Collect the tranIDs after they've potentially been incremented --%>
		<go:setData dataVar="data" xpath="health/transactionId" value="${data.current.transactionId}" />
		<c:set var="tranId" value="${data.current.transactionId}" />

<c:choose>
<c:when test="${pageSettings.getSetting('rememberMeEnabled') eq 'Y' and
				pageSettings.getVerticalCode() eq 'health' and
                param.health_journey_stage eq 'results' and
                empty authenticatedData.login.user.uid}">
<jsp:useBean id="rememberMeService" class="com.ctm.web.core.rememberme.services.RememberMeService" />
<c:set var="rememberMe" value="${rememberMeService.setCookie(pageSettings.getVerticalCode(), data.current.transactionId, pageContext.response)}" scope="request"  />
</c:when>
</c:choose>

<jsp:forward page="/spring/rest/health/quote/get.json"/>