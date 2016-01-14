<%@ page language="java" contentType="text/json; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<session:get settings="true" authenticated="true" verticalCode="FUEL" />

<c:set var="clientUserAgent"><%=request.getHeader("user-agent")%></c:set>

<security:populateDataFromParams rootPath="fuel" />

<%-- Add the postcode to the databucket --%>
<c:forTokens items="${data.fuel.location}" delims=" " var="locationToken">
	<c:if test="${locationToken != '' && locationToken.matches('[0-9]+')}">
		<go:setData dataVar="data" xpath="fuel/postcode" value="${locationToken}" />
	</c:if>
</c:forTokens>

<%-- Log a warning if the postcode couldn't be set --%>
<c:if test="${empty data.fuel.postcode}">
	<c:set var="error"><fmt:formatNumber value="${data.fuel.location}" type="number" /></c:set>
	${logger.warn('Exception formatting locationToken to number. {}', log:kv('locationToken',data.fuel.location), error)}
</c:if>

<%-- RECOVER: if things have gone pear shaped --%>
<c:if test="${empty data.current.transactionId}">
	<error:recover origin="ajax/json/fuel_price_monthly_averages.jsp" quoteType="fuel" />
</c:if>

<%-- Save Client Data --%>
<core_v1:transaction touch="R" noResponse="true" />

<c:set var="tranId" value="${data['current/transactionId']}" />

<%-- Load the config and send quotes to the aggregator gadget --%>
<jsp:useBean id="configResolver" class="com.ctm.web.core.utils.ConfigResolver" scope="application" />
<c:set var="config" value="${configResolver.getConfig(pageContext.request.servletContext, '/WEB-INF/aggregator/fuel/config_averages.xml')}" />
<go:soapAggregator config = "${config}"
					transactionId = "${tranId}"
					xml = "${go:getEscapedXml(data['fuel'])}"
					var = "resultXml"
					debugVar="debugXml"
					verticalCode="FUEL"
					configDbKey="quoteService"
				   	sendCorrelationId="true"
					styleCodeId="${pageSettings.getBrandId()}" />

${go:XMLtoJSON(resultXml)}