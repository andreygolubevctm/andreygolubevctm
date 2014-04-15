<%@ page language="java" contentType="text/json; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<session:get settings="true" authenticated="true" verticalCode="TRAVEL" />

<c:set var="clientUserAgent"><%=request.getHeader("user-agent")%></c:set>

<%-- Load the params into data --%>
<security:populateDataFromParams rootPath="travel" />

<c:set var="continueOnValidationError" value="${true}" />

<%-- Calc the duration from the passed start/end dates for SOAP service call providers use only --%>
<c:set var="duration">
<c:choose>
	<c:when test="${data.travel.policyType == 'A'}">365</c:when>
	<c:otherwise>
		<fmt:parseDate type="DATE" value="${data.travel.dates.fromDate}" var="startdate" pattern="dd/MM/yyyy" parseLocale="en_AU"/>
		<fmt:parseDate type="DATE" value="${data.travel.dates.toDate}" var="enddate" pattern="dd/MM/yyyy" parseLocale="en_AU"/>
			<fmt:parseNumber value="${((enddate.time/86400000)-(startdate.time/86400000)) + 1}" type="number" integerOnly="true" parseLocale="en_AU" />
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

<%-- Load the config and send quotes to the aggregator gadget --%>
<go:soapAggregator config = "${config}"
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
<go:setData dataVar="data" xpath="soap-response" value="*DELETE" />
<go:setData dataVar="data" xpath="soap-response" xml="${resultXml}" />
		<go:log level="TRACE" source="travel_quote_results_jsp">${resultXml}</go:log>
		<go:log level="TRACE" source="travel_quote_results_jsp">${debugXml}</go:log>
		${go:XMLtoJSON(resultXml)}
	</c:when>
	<c:otherwise>
		<agg:outputValidationFailureJSON validationErrors="${validationErrors}" origin="travel_quote_results.jsp" />
	</c:otherwise>
</c:choose>