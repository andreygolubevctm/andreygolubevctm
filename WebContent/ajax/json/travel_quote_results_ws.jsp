<%@ page language="java" contentType="text/json; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<session:get settings="true" authenticated="true" verticalCode="TRAVEL" />

<%-- RECOVER: if things have gone pear shaped --%>
<c:if test="${empty data.current.transactionId}">
    <error:recover origin="ajax/json/travel_quote_results_ws.jsp" quoteType="car" />
</c:if>

<%-- Save data --%>
<core:transaction touch="R" noResponse="true" writeQuoteOverride="${writeQuoteOverride}" />

<%-- Fetch and store the transaction id --%>
<c:set var="tranId" value="${data['current/transactionId']}" />
<go:log>TEST</go:log>
<jsp:forward page="/rest/travel/quote/get.json"/>