<%@ page language="java" contentType="text/json; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<session:get settings="true" authenticated="true" verticalCode="ROADSIDE" />

<c:set var="clientUserAgent"><%=request.getHeader("user-agent")%></c:set>

<security:populateDataFromParams rootPath="roadside" />

<c:set var="continueOnValidationError" value="${true}" />

<c:set var="fetch_count"><c:out value="${param.fetchcount}" escapeXml="true" /></c:set>

<c:choose>
<%-- RECOVER: if things have gone pear shaped --%>
	<c:when test="${empty data.current.transactionId}">
	<error:recover origin="ajax/json/sar_quote_results.jsp" quoteType="roadside" />
	</c:when>
	<%-- Increment tranId if fetching results again (not the first) --%>
	<c:when test="${fetch_count > 0}">
		<c:set var="ignoreme">
			<core:get_transaction_id
				quoteType="roadside"
				id_handler="increment_tranId" />
			</c:set>
	</c:when>
	<%-- Otherwise ignore - no action required --%>
	<c:otherwise></c:otherwise>
</c:choose>

<%-- Save Client Data --%>
<core:transaction touch="R" noResponse="true" />

<c:set var="tranId" value="${data['current/transactionId']}" />

<c:if test="${not empty tranId}">
			<%-- Load the config and send quotes to the aggregator gadget --%>
	<c:import var="config" url="/WEB-INF/aggregator/roadside/config.xml" />
			<go:soapAggregator config = "${config}"
					transactionId = "${tranId}"
					xml = "${go:getEscapedXml(data['roadside'])}"
					var = "resultXml"
					debugVar="debugXml"
					validationErrorsVar="validationErrors"
					continueOnValidationError="${continueOnValidationError}"
					isValidVar="isValid"
					configDbKey="quoteService"
					styleCodeId="${pageSettings.getBrandId()}"
					verticalCode="ROADSIDE" />
</c:if>

<c:choose>
	<c:when test="${not empty tranId and (isValid || continueOnValidationError)}">
		<c:if test="${!isValid}">
			<c:forEach var="validationError"  items="${validationErrors}">
				<error:non_fatal_error origin="sar_quote_results.jsp"
									errorMessage="${validationError.message} ${validationError.elementXpath}" errorCode="VALIDATION" />
			</c:forEach>
		</c:if>
		<%-- Write to the stats database --%>
		<agg:write_stats tranId="${tranId}" debugXml="${debugXml}" rootPath="roadside" />

		<%-- Add the results to the current session data --%>
		<go:setData dataVar="data" xpath="soap-response" value="*DELETE" />
		<go:setData dataVar="data" xpath="soap-response" xml="${resultXml}" />

		${go:XMLtoJSON(resultXml)}
	</c:when>
	<c:when test="${empty tranId}">
		{"errorType":"NO_TRAN_ID"}
		<error:non_fatal_error origin="sar_quote_results.jsp"
					errorMessage="transactionId is missing" errorCode="NO_TRAN_ID" />
	</c:when>
	<c:otherwise>
		<agg:outputValidationFailureJSON validationErrors="${validationErrors}" origin="sar_quote_results.jsp" />
	</c:otherwise>
</c:choose>