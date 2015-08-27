<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<c:set var="verticalCode" value="HOME" />
<c:set var="vertical" value="${fn:toLowerCase(verticalCode)}" />

<session:get settings="true" authenticated="true" verticalCode="${verticalCode}" />

<c:set var="touch" value="R" />
<c:set var="valid" value="true" />

<c:choose>
    <c:when test="${not empty param.action and param.action == 'latest'}">
        <c:set var="writeQuoteOverride" value="N" />
    </c:when>
    <c:otherwise>
        <security:populateDataFromParams rootPath="${vertical}" />
        <c:set var="writeQuoteOverride" value="Y" />
    </c:otherwise>
</c:choose>

<%-- RECOVER: if things have gone pear shaped --%>
<c:if test="${empty data.current.transactionId}">
    <error:recover origin="ajax/json/home/results_ws.jsp" quoteType="${verticalCode}" />
</c:if>

<%-- Save client data --%>
<core:transaction touch="${touch}" noResponse="true" writeQuoteOverride="${writeQuoteOverride}" />

<c:set var="tranId" value="${data['current/transactionId']}" />

<jsp:forward page="/rest/home/quote/get.json"/>