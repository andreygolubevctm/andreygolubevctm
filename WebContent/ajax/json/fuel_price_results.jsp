<%@ page language="java" contentType="text/json; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<session:get settings="true" authenticated="true" verticalCode="FUEL" />

<c:set var="continueOnValidationError" value="${true}" />

<%-- Load the params into data --%>
<security:populateDataFromParams rootPath="fuel" delete="false" />


<c:set var="fetch_count"><c:out value="${param.fetchcount}" escapeXml="true" /></c:set>

<c:choose>
<%-- RECOVER: if things have gone pear shaped --%>
	<c:when test="${empty data.current.transactionId}">
	<error:recover origin="ajax/json/fuel_price_results.jsp" quoteType="fuel" />
	</c:when>
	<%-- Increment tranId if fetching results again (not the first) --%>
	<c:when test="${fetch_count > 0}">
		<c:set var="ignoreme">
			<core:get_transaction_id
				quoteType="fuel"
				id_handler="increment_tranId" />
			</c:set>
	</c:when>
	<%-- Otherwise ignore - no action required --%>
	<c:otherwise></c:otherwise>
</c:choose>

<%-- Save Client Data --%>
<core:transaction touch="R" noResponse="true" />

<c:set var="tranId" value="${data['current/transactionId']}" />


<%-- Load the config and send quotes to the aggregator gadget --%>
<c:import var="config" url="/WEB-INF/aggregator/fuel/config.xml" />
<go:soapAggregator config = "${config}"
					transactionId = "${tranId}"
					xml = "${go:getEscapedXml(data['fuel'])}"
					var = "resultXml"
					debugVar="debugXml"
					validationErrorsVar="validationErrors"
					continueOnValidationError="${continueOnValidationError}"
					isValidVar="isValid"
					verticalCode="FUEL"
					configDbKey="quoteService"
					styleCodeId="${pageSettings.getBrandId()}"
					 />

<c:choose>
	<c:when test="${isValid || continueOnValidationError}">
		<c:if test="${!isValid}">
			<c:forEach var="validationError"  items="${validationErrors}">
				<error:non_fatal_error origin="fuel_price_results.jsp"
									errorMessage="${validationError.message} ${validationError.elementXpath}" errorCode="VALIDATION" />
			</c:forEach>
		</c:if>
<%-- Write to the stats database  --%>
<agg:write_stats rootPath="fuel" tranId="${tranId}" debugXml="${debugXml}" />

		<%-- Add the results to the current session data --%>
		<go:setData dataVar="data" xpath="soap-response" value="*DELETE" />
		<go:setData dataVar="data" xpath="soap-response" xml="${resultXml}" />
		<go:log level="DEBUG">${resultXml}</go:log>
		<go:log level="DEBUG">${debugXml}</go:log>

		${go:XMLtoJSON(resultXml)}
	</c:when>
	<c:otherwise>
		<agg:outputValidationFailureJSON validationErrors="${validationErrors}" origin="fuel_price_results.jsp" />
	</c:otherwise>
</c:choose>