<%@ page language="java" contentType="text/json; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<c:set var="logger" value="${log:getLogger('jsp.ajax.json.utilities_submit_application')}" />

<session:get settings="true" authenticated="true" verticalCode="UTILITIES" />

<%-- Load the params into data --%>
<security:populateDataFromParams rootPath="utilities" />

<c:set var="continueOnValidationError" value="${false}" />

<c:if test="${empty data.utilities.application.details.address.streetNum && empty data.utilities.application.details.address.houseNoSel}">
	<go:setData dataVar="data" xpath="utilities/application/details/address/streetNum" value="0" />
</c:if>

<jsp:useBean id="utilitiesApplicationService" class="com.ctm.services.utilities.UtilitiesApplicationService" scope="request" />
<c:set var="serviceResponse" value="${utilitiesApplicationService.validate(pageContext.request, data)}" />

<c:choose>
	<c:when test="${empty data.utilities.application.thingsToKnow.termsAndConditions != 'Y'}">
		ERROR - NO TERMS AND CONDITIONS
	</c:when>
	<c:when test="${!utilitiesApplicationService.isValid()}">
		<c:out value="${serviceResponse}" escapeXml="false" />
	</c:when>
	<c:otherwise>
		<%-- RECOVER: if things have gone pear shaped --%>
		<c:if test="${empty data.current.transactionId}">
			<error:recover origin="ajax/json/utilities_submit_application.jsp" quoteType="utilities" />
		</c:if>

		<%-- Save client data: ***FIX: before using this a 'C' status needs to be identified.
		<core:transaction touch="A" noResponse="true" />
		--%>

		<agg:write_email
			brand="CTM"
			vertical="UTILITIES"
			source="QUOTE"
			emailAddress="${data['utilities/application/details/email']}"
			emailPassword=""
			firstName="${data['utilities/application/details/firstName']}"
			lastName="${data['utilities/application/details/lastName']}"
			items="marketing=${data['utilities/application/thingsToKnow/receiveInfo']}" />

		<c:set var="tranId" value="${data['current/transactionId']}" />
		${logger.info('Utilities retrieved Tran Id from data object.')}

		<c:set var="results" value="${utilitiesApplicationService.submitFromJsp(pageContext.getRequest(), data)}" scope="request"  />

		<c:choose>
			<c:when test="${empty results}">
				<c:set var="json" value='{"info":{"transactionId":${tranId}}},"errors":[{"message":"getResults is empty"}]}' />
			</c:when>
			<c:otherwise>
				<c:set var="json" value="${results}"/>
			</c:otherwise>
		</c:choose>

		<c:set var="xmlData" value="<data>${go:JSONtoXML(json)}</data>" />
		<x:parse var="parsedXml" doc="${xmlData}" />		

		<c:set var="confirmationkey" value="${pageContext.session.id}-${tranId}" />
		<go:setData dataVar="data" xpath="utilities/confirmationkey" value="${confirmationkey}" />

		<agg:write_confirmation transaction_id="${tranId}" confirmation_key="${confirmationkey}" vertical="${vertical}" xml_data="${xmlData}" />
		<agg:write_quote productType="UTILITIES" rootPath="utilities" />
		<agg:write_touch touch="C" transaction_id="${tranId}" />

		<c:out value="${json}" escapeXml="false" />

	</c:otherwise>
</c:choose>


