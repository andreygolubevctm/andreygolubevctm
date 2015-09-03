<%@ page language="java" contentType="text/json; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<session:get />

<c:set var="tranId" value="${data.current.transactionId}" />
<c:set var="continueOnValidationError" value="${false}" />

<%-- Build XML required for Life Broker request --%>
<c:set var="requestXML">
<productdetailsrequest>
	<request xmlns="urn:Lifebroker.EnterpriseAPI">
		<products>
			<product><c:out value="${param.product_id}" /></product>
			<product><c:out value="${param.product_id}" /></product>
		</products>
	</request>
</productdetailsrequest>
</c:set>

<%-- Load the config and send quotes to the aggregator gadget --%>
<jsp:useBean id="configResolver" class="com.ctm.utils.ConfigResolver" scope="application" />
<c:import var="config" url="${configResolver.getConfigUrl('/WEB-INF/aggregator/life/config_product_details.xml')}" />
<go:soapAggregator 	config = "${config}"
					transactionId = "${tranId}"
					xml = "${requestXML}"
					var = "resultXml"
					debugVar="debugXml"
					verticalCode="${fn:toUpperCase(vertical)}"
					configDbKey="quoteService"
					validationErrorsVar="validationErrors"
					isValidVar="isValid"
					continueOnValidationError="${continueOnValidationError}"
					styleCodeId="${pageSettings.getBrandId()}"  />

<c:choose>
	<c:when test="${isValid || continueOnValidationError}">
		<%-- Add the results to the current session data --%>
		<go:setData dataVar="data" xpath="soap-response" value="*DELETE" />
		<go:setData dataVar="data" xpath="soap-response" xml="${resultXml}" />
		<go:setData dataVar="data" xpath="soap-response/results/transactionId" value="${tranId}" />
		
		<go:log source="life_product_details_jsp" level="DEBUG">${resultXml}</go:log>
		<go:log source="life_product_details_jsp" level="DEBUG">${debugXml}</go:log>
		
		${go:XMLtoJSON(go:getEscapedXml(data['soap-response/results']))}
	</c:when>
	<c:otherwise>
		<agg:outputValidationFailureJSON validationErrors="${validationErrors}" origin="life_product_details.jsp"/>
	</c:otherwise>
</c:choose>