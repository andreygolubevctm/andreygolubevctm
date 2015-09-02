<%@ page language="java" contentType="text/json; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<c:set var="logger" value="${log:getLogger('life_product_select_jsp')}" />

<c:set var="continueOnValidationError" value="${false}" />
<c:set var="vertical" value="${fn:toUpperCase(param.vertical)}" />
<session:get settings="true" authenticated="true" verticalCode="${vertical}" />

<c:set var="tranId" value="${data.current.transactionId}" />

<%-- Build XML required for Life Broker request --%>
<c:set var="requestXML">
<productselectrequest>
	<request xmlns="urn:Lifebroker.EnterpriseAPI">
		<api_reference><c:out value="${param.api_ref}" /></api_reference>
		<action><c:out value="${param.request_type}" /></action>
	<c:choose>
		<c:when test="${param.partner_quote eq 'Y'}">
		<client_product_id><c:if test="${not empty param.client_product_id}"><c:out value="${param.client_product_id}" /></c:if></client_product_id>
		<partner_product_id><c:if test="${not empty param.partner_product_id}"><c:out value="${param.partner_product_id}" /></c:if></partner_product_id>
		</c:when>
		<c:otherwise>
		<product_id><c:out value="${param.client_product_id}" /></product_id>
		</c:otherwise>
	</c:choose>
	</request>
</productselectrequest>
</c:set>

<%-- Load the config and send quotes to the aggregator gadget --%>
<c:import var="config" url="/WEB-INF/aggregator/life/config_product_select.xml" />
<go:soapAggregator config = "${config}"
					transactionId = "${tranId}"
					xml = "${requestXML}"
					var = "resultXml"
					debugVar="debugXml"
					validationErrorsVar="validationErrors"
					isValidVar="isValid"
					continueOnValidationError="${continueOnValidationError}"
					verticalCode="${vertical}"
					configDbKey="quoteService"
					styleCodeId="${pageSettings.getBrandId()}"  />


<c:choose>
	<c:when test="${isValid || continueOnValidationError}">
		<%-- Add the results to the current session data --%>
		<go:setData dataVar="data" xpath="soap-response" value="*DELETE" />
		<go:setData dataVar="data" xpath="soap-response" xml="${resultXml}" />
		<go:setData dataVar="data" xpath="soap-response/results/transactionId" value="${tranId}" />
		${logger.debug('resultXml={} debugXml={}',resultXml, debugXml)}
		${go:XMLtoJSON(go:getEscapedXml(data['soap-response/results']))}
	</c:when>
	<c:otherwise>
		<agg:outputValidationFailureJSON validationErrors="${validationErrors}"  origin="life_product_select.jsp"/>
	</c:otherwise>
</c:choose>