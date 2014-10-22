<%@ page language="java" contentType="text/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<session:get settings="true" authenticated="true" verticalCode="UTILITIES" />

<c:set var="clientUserAgent"><%=request.getHeader("user-agent")%></c:set>

<%-- Load the params into data --%>
<security:populateDataFromParams rootPath="utilities" />

<c:set var="continueOnValidationError" value="${true}" />

<%-- RECOVER: if things have gone pear shaped --%>
<c:if test="${empty data.current.transactionId}">
	<error:recover origin="ajax/json/utilities_quote_results.jsp" quoteType="utilities" />
</c:if>

<%-- Save client data --%>
<core:transaction touch="R" noResponse="true" />

<%-- add external testing ip address checking and loading correct config and send quotes --%>
<c:set var="clientIpAddress" value="${sessionScope.userIP}" />

<go:log>Utilities Tran Id = ${data['current/transactionId']}</go:log>

<c:set var="tranId" value="${data['current/transactionId']}" />

<%-- Load the config and send quotes to the aggregator gadget --%>
<c:import var="config" url="/WEB-INF/aggregator/utilities/config_results.xml" />
<go:soapAggregator config = "${config}"
					transactionId = "${tranId}"
					xml = "${data.xml['utilities']}"
					var = "resultXml"
					debugVar="debugXml"
					validationErrorsVar="validationErrors"
					continueOnValidationError="${continueOnValidationError}"
					isValidVar="isValid"
					configDbKey="quoteService"
					styleCodeId="${pageSettings.getBrandId()}"
					verticalCode="UTILITIES"  />
<c:if test="${isValid || continueOnValidationError}">
	<c:if test="${!isValid}">
		<c:forEach var="validationError"  items="${validationErrors}">
			<error:non_fatal_error origin="utilities_quote_results.jsp"
									errorMessage="${validationError.message} ${validationError.elementXpath}" errorCode="VALIDATION" />
		</c:forEach>
	</c:if>
	<%-- Write to the stats database --%>
	<agg:write_stats rootPath="utilities" tranId="${tranId}" debugXml="${debugXml}" />

	<%-- Add the results to the current session data --%>
	<go:setData dataVar="data" xpath="soap-response" value="*DELETE" />
	<go:setData dataVar="data" xpath="soap-response" xml="${resultXml}" />
	<go:setData dataVar="data" xpath="soap-response/results/transactionId" value="${tranId}" />

	<go:log>RESULTS XML: ${resultXml}</go:log>
	<go:log>DEBUG XML: ${debugXml}</go:log>
</c:if>
<c:choose>
	<c:when test="${isValid || continueOnValidationError}" >
		${go:XMLtoJSON(resultXml)}
	</c:when>
	<c:otherwise>
		<agg:outputValidationFailureJSON validationErrors="${validationErrors}"  origin="utilities_quote_results.jsp"/>
	</c:otherwise>
</c:choose>