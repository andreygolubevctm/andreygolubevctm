<%@ page language="java" contentType="text/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<c:set var="verticalCode" value="HEALTH" />

<core_new:no_cache_header/>

<session:get settings="true" authenticated="true" verticalCode="HEALTH" throwCheckAuthenticatedError="true" />
<jsp:useBean id="healthQuoteResults" class="com.ctm.services.health.HealthQuoteEndpointService" />
${healthQuoteResults.init(pageContext.request, pageSettings)}

<%-- Only continue if token is valid --%>
<c:if test="${healthQuoteResults.validToken}">

	<jsp:useBean id="soapdata" class="com.disc_au.web.go.Data" scope="request" />

	<%-- First check owner of the quote --%>
	<c:set var="clientUserAgent"><%=request.getHeader("user-agent")%></c:set>

	<c:set var="continueOnValidationError" value="${true}" />

	<%-- Load the params into data --%>
	<security:populateDataFromParams rootPath="health" />

	<%-- Test and or Increment ID if required --%>
	<c:choose>
		<%-- RECOVER: if things have gone pear shaped --%>
		<c:when test="${empty data.current.transactionId}">
			<error:recover origin="ajax/json/health_quote_results.jsp" quoteType="health" />
		</c:when>
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

	<%-- Set custom application date from data.jsp --%>
	<go:setData dataVar="data" xpath="health/applicationDate" value="${applicationService.getApplicationDate(pageContext.getRequest())}" />
	<jsp:useBean id="configResolver" class="com.ctm.utils.ConfigResolver" scope="application" />
	<%-- Removed specific email writing operations from here as they're handled in core:transaction above --%>
	<c:set var="config" value="${configResolver.getConfig(pageContext.request.servletContext, '/WEB-INF/aggregator/health/config_ALL.xml')}" />
	<%--Load the config and send quotes to the aggregator gadget--%>
	<go:soapAggregator config = "${config}"
					   transactionId = "${tranId}"
					   xml = "${go:getEscapedXml(data['health'])}"
					   var = "resultXml"
					   debugVar="debugXml"
					   validationErrorsVar="validationErrors"
					   continueOnValidationError="${continueOnValidationError}"
					   isValidVar="isValid"
					   verticalCode="HEALTH"
					   configDbKey="quoteService"
					   sendCorrelationId="true"
					   styleCodeId="${pageSettings.getBrandId()}" />

	<c:if test="${isValid || continueOnValidationError}">
		<c:if test="${!isValid}">
			<c:forEach var="validationError"  items="${validationErrors}">
				<error:non_fatal_error origin="health_quote_results.jsp"
									   errorMessage="${validationError.message} ${validationError.elementXpath}" errorCode="VALIDATION" />
			</c:forEach>
		</c:if>

		<agg:write_stats rootPath="health" tranId="${data.text['current/transactionId']}" debugXml="${debugXml}" />

		<%-- Add the results to the current session data --%>

		<go:setData dataVar="soapdata" xpath="soap-response" value="*DELETE" />
		<go:setData dataVar="soapdata" xml="${resultXml}" />

		<%-- !!IMPORTANT!! - ensure the trackingKey is passed back with results --%>
		<go:setData dataVar="soapdata" xpath="soap-response/results/info/trackingKey" value="${data.health.trackingKey}" />

		<%-- Add the results only if there is one version --%>
		<go:setData dataVar="data" xpath="healthConfirmation" value="*DELETE"/>
		<go:setData dataVar="data" xpath="confirmation/health" value="*DELETE"/>

		<c:if test="${data.health.showAll == 'N' && data.health.onResultsPage != 'Y'}">
			<%-- condition if soap-response does not match our criteria, we need to call the product data fresh --%>
			<c:import var="transferXml" url="/WEB-INF/xslt/healthConfirmation.xsl"/>
			<c:set var="priceXML">
				<x:transform doc="${resultXml}" xslt="${transferXml}" />
			</c:set>

			<c:set var="priceXML" value="<![CDATA[${go:XMLtoJSON(priceXML)}]]>" />

			<c:set var="priceXML" value="${fn:replace(priceXML,'\"price\":{', '')}" />
			<c:set var="priceXML" value="${fn:replace(priceXML,'}}]]>', '}]]>')}" />

			<go:setData dataVar="data" xpath="confirmation/health" value="${priceXML}" />
		</c:if>
	</c:if>

	<c:choose>
		<c:when test="${isValid || continueOnValidationError}" >
			<c:set var="outputXml">
				${go:getEscapedXml(soapdata['soap-response/results'])}
				<timeout>${sessionDataService.getClientSessionTimeout(pageContext.getRequest())}</timeout>
			</c:set>
			<c:set var="baseJsonResponse">${go:XMLtoJSON(outputXml)}</c:set>
			<%-- COMPETITION APPLICATION START --%>
			<c:choose>
				<c:when test="${not empty data['health/contactDetails/contactNumber/mobile']}">
					<c:set var="contactPhone" value="${data['health/contactDetails/contactNumber/mobile']}"/>
				</c:when>
				<c:otherwise>
					<c:set var="contactPhone" value="${data['health/contactDetails/contactNumber/other']}"/>
				</c:otherwise>
			</c:choose>

			<c:set var="competitionEnabledSetting"><content:get key="competitionEnabled"/></c:set>

			<c:set var="concat" value="${fn:trim(data['health/contactDetails/name'])}::${fn:trim(data['health/contactDetails/email'])}::${fn:trim(contactPhone)}" />
			<c:set var="notEntered" value="${concat != '::::' and data['health/contactDetails/competition/previous'] != concat}" />
			<c:set var="optedInForComp" value="${data['health/contactDetails/competition/optin'] == 'Y' }" />
			<c:set var="competitionEnabled" value="${competitionEnabledSetting eq 'Y'}" />

			<c:if test="${competitionEnabled && optedInForComp && notEntered}">
				<c:set var="firstname" value="${fn:trim(data['health/contactDetails/name'])}" />
				<c:set var="lastname" value="" />
				<c:if test="${fn:contains(firstname, ' ')}">
					<c:set var="firstname" value="${fn:substringBefore(firstname, ' ')}" />
					<c:set var="lastname" value="${fn:substringAfter(fn:trim(data['health/contactDetails/name']), ' ')}" />
				</c:if>

				<c:import var="response" url="/ajax/write/competition_entry.jsp">
					<c:param name="secret"><content:get key="competitionSecret" /></c:param>
					<c:param name="competition_email" value="${fn:trim(data['health/contactDetails/email'])}" />
					<c:param name="competition_firstname" value="${firstname}" />
					<c:param name="competition_lastname" value="${lastname}" />
					<c:param name="competition_phone" value="${contactPhone}" />
					<c:param name="transactionId" value="${tranId}" />
				</c:import>
				<go:setData dataVar="data" xpath="health/contactDetails/competition/previous" value="${concat}" />
			</c:if>
			<%-- COMPETITION APPLICATION END --%>
			${healthQuoteResults.createResponse(data.text['current/transactionId'], baseJsonResponse)}
		</c:when>
		<c:otherwise>
			<agg:outputValidationFailureJSON validationErrors="${validationErrors}"  origin="health_quote_results.jsp"/>
		</c:otherwise>
	</c:choose>
</c:if>
