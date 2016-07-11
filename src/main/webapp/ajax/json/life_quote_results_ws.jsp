<%@ page language="java" contentType="text/json; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<c:set var="logger" value="${log:getLogger('jsp.ajax.json.life_quote_result')}" />

<session:get settings="true" authenticated="true" verticalCode="${fn:trim(fn:toUpperCase(param.vertical))}" />

<%-- Load the params into data --%>
<c:set var="vertical" value="${pageSettings.getVerticalCode()}" />
<security:populateDataFromParams rootPath="${vertical}" />

<%-- RECOVER: if things have gone pear shaped --%>
<c:if test="${empty data.current.transactionId}">
	<error:recover origin="ajax/json/life_quote_results.jsp" quoteType="${vertical}" />
</c:if>

<core_v1:transaction touch="R" noResponse="true" />


<jsp:forward page="/spring/rest/life/quote/get.json"/>