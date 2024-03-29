<%@ page language="java" contentType="application/json; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<session:get settings="true" authenticated="true" verticalCode="ROADSIDE" />

<c:set var="clientUserAgent"><%=request.getHeader("user-agent")%></c:set>

<security:populateDataFromParams rootPath="roadside" />

<c:set var="continueOnValidationError" value="${false}" />

<c:set var="fetch_count"><c:out value="${param.fetchcount}" escapeXml="true" /></c:set>

<jsp:useBean id="soapdata" class="com.ctm.web.core.web.go.Data" scope="request" />

<jsp:useBean id="roadsideService" class="com.ctm.web.roadside.services.RoadsideService" scope="page" />
<c:set var="serviceRespone" value="${roadsideService.validate(pageContext.request, data)}" />
<c:choose>
<%-- RECOVER: if things have gone pear shaped --%>
	<c:when test="${empty data.current.transactionId}">
	<error:recover origin="ajax/json/sar_quote_results.jsp" quoteType="roadside" />
	</c:when>
	<%-- Increment tranId if fetching results again (not the first) --%>
	<c:when test="${fetch_count > 0}">
		<c:set var="ignoreme">
			<core_v1:get_transaction_id
				quoteType="roadside"
				id_handler="increment_tranId" />
			</c:set>
	</c:when>
	<%-- Otherwise ignore - no action required --%>
	<c:otherwise></c:otherwise>
</c:choose>

<%-- Save Client Data --%>
<core_v1:transaction touch="R" noResponse="true" />

<c:set var="tranId" value="${data['current/transactionId']}" />

<c:if test="${not empty tranId && roadsideService.isValid()}">
			<%-- Load the config and send quotes to the aggregator gadget --%>
	<jsp:useBean id="configResolver" class="com.ctm.web.core.utils.ConfigResolver" scope="application" />
	<c:set var="config" value="${configResolver.getConfig(pageContext.request.servletContext, '/WEB-INF/aggregator/roadside/config.xml')}" />
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
					verticalCode="ROADSIDE"
					sendCorrelationId="true" />
</c:if>

<c:choose>
	<c:when test="${not empty tranId and (isValid || continueOnValidationError) && roadsideService.isValid()}">
		<c:if test="${!isValid}">
			<c:forEach var="validationError"  items="${validationErrors}">
				<error:non_fatal_error origin="sar_quote_results.jsp"
									errorMessage="${validationError.message} ${validationError.elementXpath}" errorCode="VALIDATION" />
			</c:forEach>
		</c:if>
		<%-- Write to the stats database --%>
		<agg_v1:write_stats tranId="${tranId}" debugXml="${debugXml}" rootPath="roadside" />

		<%-- Build a response object and send it through! --%>
		<go:setData dataVar="soapdata" xpath="soap-response" value="*DELETE" />
		<go:setData dataVar="soapdata" xpath="soap-response" xml="${resultXml}" />
		<%-- !!IMPORTANT!! - ensure the trackingKey is passed back with results --%>
		<go:setData dataVar="soapdata" xpath="soap-response/results/info/trackingKey" value="${data.roadside.trackingKey}" />
		<go:setData dataVar="soapdata" xpath="soap-response/results/info/transactionId" value="${data.current.transactionId}" />

		<agg_v1:write_result_details transactionId="${tranId}" recordXPaths="quoteUrl" baseXmlNode="soap-response/results/price"/>

		${go:XMLtoJSON(go:getEscapedXml(soapdata["soap-response/results"]))}
	</c:when>
	<c:when test="${empty tranId}">
		{"errorType":"NO_TRAN_ID"}
		<error:non_fatal_error origin="sar_quote_results.jsp"
					errorMessage="transactionId is missing" errorCode="NO_TRAN_ID" />
	</c:when>
	<c:when test="${!roadsideService.isValid()}">
		${serviceRespone}
	</c:when>
	<c:otherwise>
		<agg_v1:outputValidationFailureJSON validationErrors="${validationErrors}" origin="sar_quote_results.jsp" />
	</c:otherwise>
</c:choose>