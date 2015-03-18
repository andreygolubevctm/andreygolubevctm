<%@ page language="java" contentType="text/json; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<session:get settings="true" authenticated="true" verticalCode="TRAVEL" />

<%-- Load the params into data --%>
<security:populateDataFromParams rootPath="travel" />

<jsp:useBean id="travelService" class="com.ctm.services.travel.TravelService" scope="page" />
<c:set var="serviceResponse" value="${travelService.validateFields(pageContext.request)}" />

<c:choose>
	<c:when test="${travelService.isValid()}">

<jsp:useBean id="soapdata" class="com.disc_au.web.go.Data" scope="request" />

<c:set var="clientUserAgent"><%=request.getHeader("user-agent")%></c:set>


<c:set var="continueOnValidationError" value="${true}" />

<%-- Calc the duration from the passed start/end dates for SOAP service call providers use only --%>
<c:set var="duration">
<c:choose>
	<c:when test="${data.travel.policyType == 'A'}">365</c:when>
	<c:otherwise>

			<fmt:parseDate type="DATE" value="${data.travel.dates.fromDate}" var="startdate" pattern="dd/MM/yyyy" parseLocale="en_AU"/>
			<fmt:formatDate var="reqStartDate" value="${startdate}" pattern="yyyy-MM-dd" />
			
			<fmt:parseDate type="DATE" value="${data.travel.dates.toDate}" var="enddate" pattern="dd/MM/yyyy" parseLocale="en_AU"/>
			<fmt:formatDate var="reqEndDate" value="${enddate}" pattern="yyyy-MM-dd" />
			
			<jsp:useBean id="utilCalc" class="com.ctm.utils.travel.DurationCalculation" scope="request" />
			${utilCalc.calculateDayDuration(reqStartDate, reqEndDate)}
	</c:otherwise>
</c:choose>
</c:set>

<go:setData dataVar="data" xpath="travel/soapDuration" value="${duration}" />

<%-- Test and or Increment ID if required --%>
<c:choose>
	<%-- RECOVER: if things have gone pear shaped --%>
	<c:when test="${empty data.current.transactionId}">
		<error:recover origin="ajax/json/travel_quote_results.jsp" quoteType="travel" />
	</c:when>
	<c:when test="${param.incrementTransactionId == true}">
		<c:set var="id_return">
			<core:get_transaction_id quoteType="travel" id_handler="increment_tranId" transactionId="${data.current.transactionId}" />
		</c:set>
	</c:when>
	<c:otherwise>
		<%-- All is good --%>
	</c:otherwise>
</c:choose>

<%-- Save Client Data --%>
<core:transaction touch="R" noResponse="true" />

<%-- add external testing ip address checking and loading correct config and send quotes --%>
<c:set var="clientIpAddress" value="${sessionScope.userIP }" />

<%--<c:set var="amexIpAddress" value="10.132.168.247" />--%>

<%-- for declans home ip address --%>
<c:set var="amexIpAddress" value="10.132.168.247" />

<c:set var="wldcIpAddress1" value="203.42.115.13" />
<c:set var="wldcIpAddress2" value="203.42.119.13" />
<c:set var="wldcIpAddress3" value="61.88.76.13" />

<c:set var="otisIpAddress1" value="203.42.115.13" />
<c:set var="otisIpAddress2" value="203.42.119.13" />
<c:set var="otisIpAddress3" value="61.88.76.13" />

<c:set var="easyIpAddress" value="49.177.87.252" />

<c:set var="onefowIpAddress" value="0:0:0:0:0:0:0:2" />
<c:set var="agisIpAddress" value="0:0:0:0:0:0:0:2" />

<c:set var="tranId" value="${data['current/transactionId']}" />
<go:setData dataVar="data" xpath="travel/transactionId" value="${tranId}" />

<c:import var="config" url="/WEB-INF/aggregator/travel/config.xml" />

		<jsp:useBean id="providerFilter" class="com.ctm.services.ProviderFilter" scope="page" />
		<c:set var="config" value="${providerFilter.getXMLConfig(pageContext.getRequest(), config)}" />

		<%-- Dirty hack for travel as we're using both the db and config*.xml files at the same time. I need a shower.
		removed authToken until CAR-863 goes into NXQ
		<c:set var="authToken">
			<c:if test="${not empty data['travel/filter/providerKey'] and data['travel/filter/providerKey'] eq 'budd_1FyoO9TN0t'}">
				${data['travel/filter/providerKey']}
			</c:if>
		</c:set> --%>

<%-- Load the config and send quotes to the aggregator gadget --%>
<go:soapAggregator config = "${config}"
					configDbKey="quoteService"
					verticalCode="TRAVEL"
					styleCodeId="${pageSettings.getBrandId()}"
					transactionId = "${tranId}"
					xml = "${data.xml['travel']}"
					var = "resultXml"
					debugVar="debugXml"
					validationErrorsVar="validationErrors"
					continueOnValidationError="${continueOnValidationError}"
					isValidVar="isValid" />
					
<c:choose>
	<c:when test="${isValid || continueOnValidationError}">
		<c:if test="${!isValid}">
			<c:forEach var="validationError"  items="${validationErrors}">
				<error:non_fatal_error origin="travel_quote_results.jsp"
									errorMessage="${validationError.message} ${validationError.elementXpath}" errorCode="VALIDATION" />
			</c:forEach>
		</c:if>
<%-- Write to the stats database --%>
<agg:write_stats rootPath="travel" tranId="${tranId}" debugXml="${debugXml}" />

<%-- Add the results to the current session data --%>
		<%-- This change was made to allow me to set the the transactionId for the new framework --%>
		<go:setData dataVar="soapdata" xpath="soap-response" value="*DELETE" />
		<go:setData dataVar="soapdata" xpath="soap-response" xml="${resultXml}" />
		<go:setData dataVar="soapdata" xpath="soap-response/results/info/transactionId" value="${tranId}" />
		<%-- !!IMPORTANT!! - ensure the trackingKey is passed back with results --%>
		<go:setData dataVar="soapdata" xpath="soap-response/results/info/trackingKey" value="${data.travel.trackingKey}" />
		<go:log level="TRACE" source="travel_quote_results_jsp">${resultXml}</go:log>
		<go:log level="TRACE" source="travel_quote_results_jsp">${debugXml}</go:log>

		<agg:write_result_details transactionId="${tranId}" recordXPaths="quoteUrl" baseXmlNode="soap-response/results/price"/>

		${go:XMLtoJSON(go:getEscapedXml(soapdata['soap-response/results']))}
	</c:when>
	<c:otherwise>
		<agg:outputValidationFailureJSON validationErrors="${validationErrors}" origin="travel_quote_results.jsp" />
	</c:otherwise>
		</c:choose>
	</c:when>
	<c:otherwise>
		${serviceResponse}
	</c:otherwise>
</c:choose>