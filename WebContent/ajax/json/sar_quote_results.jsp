<%@ page language="java" contentType="text/json; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>
<jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="session" />

<jsp:useBean id="now" class="java.util.Date" />
<fmt:formatDate var="current_year" value="${now}" pattern="yyyy" />

<c:set var="clientUserAgent"><%=request.getHeader("user-agent")%></c:set>

<security:populateDataFromParams rootPath="roadside" />


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

<c:import var="config" url="/WEB-INF/aggregator/roadside/config.xml" />
<go:schemaValidation
			config = "${config}"
			xsd="roadsidePriceResult.xsd"
			xml="${go:getEscapedXml(data['roadside'])}"
			validationErrorsVar="validationErrors"
			isValidVar="isValid" />

<c:choose>
	<c:when test="${not empty tranId and isValid}">
			<%-- Load the config and send quotes to the aggregator gadget --%>
			<go:soapAggregator config = "${config}"
					transactionId = "${tranId}"
					xml = "${go:getEscapedXml(data['roadside'])}"
					var = "resultXml"
					debugVar="debugXml" />


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
		{
			"errorType":"VALIDATION_FAILED",
			"validationErrors" : [
				<c:forEach var="validationError"  items="${validationErrors}">
					<error:non_fatal_error origin="sar_quote_results.jsp"
								errorMessage="${validationError.message} ${validationError.elementName}" errorCode="VALIDATION" />
					${prefix} {
						"message":"${validationError.message}" ,
						"elementName":"${validationError.elementName}"
					}
					<c:set var="prefix" value="," />
				</c:forEach>
			]
		}
	</c:otherwise>
</c:choose>