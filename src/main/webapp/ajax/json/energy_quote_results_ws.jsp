<%@ page language="java" contentType="text/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<session:get settings="true" authenticated="true" verticalCode="UTILITIES" />
<c:set var="logger" value="${log:getLogger('jsp.ajax.json.utilities_quote_results')}" />

<%-- VARIABLES --%>
<c:set var="vertical" value="${pageSettings.getVerticalCode()}" />

<%-- Load the params into data --%>
<security:populateDataFromParams rootPath="${vertical}" />

<%-- RECOVER: if things have gone pear shaped --%>
<c:if test="${empty data.current.transactionId}">
	<error:recover origin="ajax/json/utilities_quote_results.jsp" quoteType="${vertical}" />
</c:if>

<%-- Save data --%>
<core:transaction touch="R" noResponse="true" />

<%-- Fetch the transaction id --%>
<c:set var="tranId" value="${data['current/transactionId']}" />
<c:if test="${empty tranId}"><c:set var="tranId" value="0" /></c:if>

<%-- COMPETITION APPLICATION START --%>
<c:set var="competitionEnabledSetting"><content:get key="competitionEnabled"/></c:set>
<c:set var="optedInForCompKey">${vertical}/resultsDisplayed/competition/optin</c:set>
<c:set var="optedInForComp" value="${data[optedInForCompKey] == 'Y' }" />

${logger.debug('Got settings for competition. {},{}',log:kv('competitionEnabledSetting', competitionEnabledSetting), log:kv('optedInForComp', optedInForComp))}

<c:if test="${competitionEnabledSetting eq 'Y' and not callCentre and optedInForComp}">
	<c:set var="competitionId"><content:get key="competitionId"/></c:set>
	<c:set var="competition_emailKey">${vertical}/resultsDisplayed/email</c:set>
	<c:set var="competition_firstnameKey">${vertical}/resultsDisplayed/firstName</c:set>
	<c:set var="competition_phoneKey">${vertical}/resultsDisplayed/phone</c:set>
	<c:import var="response" url="/ajax/write/competition_entry.jsp">
		<c:param name="secret">W8C6A452F9823ECBE719DBZFC196C3QB</c:param>
		<c:param name="competitionId" value="${competitionId}" />
		<c:param name="competition_email" value="${fn:trim(data[competition_emailKey])}" />
		<c:param name="competition_firstname" value="${fn:trim(data[competition_firstnameKey])}" />
		<c:param name="competition_lastname" value="" />
		<c:param name="competition_phone" value="${data[competition_phoneKey]}" />
		<c:param name="transactionId" value="${tranId}" />
	</c:import>
</c:if>
<%-- COMPETITION APPLICATION END --%>

<jsp:forward page="/spring/rest/energy/quote/get.json"/>