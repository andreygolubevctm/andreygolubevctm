<%@ page language="java" contentType="text/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<session:get settings="true" verticalCode="${fn:toUpperCase(param.quoteType)}"/>
<security:populateDataFromParams rootPath="${pageSettings.getVerticalCode()}" />
<core:transaction touch="A" noResponse="true" writeQuoteOverride="Y" />

<c:set var="competitionEnabledSetting"><content:get key="competitionEnabled" /></c:set>
<c:set var="optedInForComp" value="${data['creditcard/optIn'] == 'Y' }" />

<c:if test="${competitionEnabledSetting eq 'Y' and optedInForComp}">
	<c:set var="competitionId"><content:get key="competitionId"/></c:set>
	<c:import var="response" url="/ajax/write/competition_entry.jsp">
		<c:param name="secret">yfIOyxdBzXw7CjVcNWuX</c:param>
		<c:param name="competitionId" value="${competitionId}" />
		<c:param name="competition_email" value="${fn:trim(data['creditcard/email'])}" />
		<c:param name="competition_firstname" value="${fn:trim(data['creditcard/name'])}" />
		<c:param name="competition_lastname" value="" />
		<c:param name="competition_phone" value="${fn:trim(data['creditcard/phone'])}" />
	</c:import>
</c:if>
{}