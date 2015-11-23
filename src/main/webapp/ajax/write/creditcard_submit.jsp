<%@ page language="java" contentType="text/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<session:get settings="true" verticalCode="${fn:toUpperCase(param.quoteType)}"/>
<security:populateDataFromParams rootPath="${pageSettings.getVerticalCode()}" />
<core:transaction touch="A" noResponse="true" writeQuoteOverride="Y" productId="${data[pageSettings.getVerticalCode()].handover.productCode}" />

<c:set var="competitionEnabledSetting"><content:get key="competitionEnabled" /></c:set>
<c:set var="optedInForComp" value="${data['creditcard/competition/optIn'] eq 'Y' }" />
<c:set var="serviceResponse" value="{}" />
<c:set var="tranId" value="${data['current/transactionId']}" />

<c:if test="${competitionEnabledSetting eq 'Y' and optedInForComp eq true}">

	<jsp:useBean id="creditCardService" class="com.ctm.web.creditcards.services.creditcards.CreditCardService" scope="page" />
	<c:set var="serviceResponse" value="${creditCardService.validate(pageContext.request, data)}" />

	<c:if test="${creditCardService.isValid()}">
		<c:set var="competitionId"><content:get key="competitionId"/></c:set>

		<c:set var="fullName" value="${fn:trim(data['creditcard/name'])}" />
		<c:set var="firstName" value="${fullName}" />
		<c:set var="lastName" value="" />
		<c:set var="nameParts" value="${fn:split(fullName, ' ')}" />

		<c:if test="${fn:length(nameParts) > 1}">
			<c:set var="lastName" value="${nameParts[fn:length(nameParts)-1]}" />
			<c:set var="firstName" value="${fn:replace(fn:join(nameParts, ' '), lastName , '' )}" />
		</c:if>

		<c:import var="response" url="/ajax/write/competition_entry.jsp">
			<c:param name="secret">yfIOyxdBzXw7CjVcNWuX</c:param>
			<c:param name="competitionId" value="${competitionId}" />
			<c:param name="competition_email" value="${fn:trim(data['creditcard/email'])}" />
			<c:param name="competition_firstname" value="${firstName}" />
			<c:param name="competition_lastname" value="${lastName}" />
			<c:param name="competition_phone" value="" />
			<c:param name="competition_required_phone" value="N" />
			<c:param name="transactionId" value="${tranId}" />
		</c:import>
	</c:if>
</c:if>
${serviceResponse}