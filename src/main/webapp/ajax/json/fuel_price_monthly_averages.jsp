<%@ page language="java" contentType="text/json; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<session:get settings="true" authenticated="true" verticalCode="FUEL" />

<c:set var="clientUserAgent"><%=request.getHeader("user-agent")%></c:set>

<security:populateDataFromParams rootPath="fuel" />


<%-- Add the postcode to the databucket --%>
<c:forTokens items="${data.fuel.location}" delims=" " var="locationToken">
		<c:catch var="error">
			<c:set var="temp"><fmt:formatNumber value="${locationToken}" type="number" /></c:set>
		</c:catch>
		<c:if test="${empty error && locationToken != ''}">
			<go:setData dataVar="data" xpath="fuel/postcode" value="${locationToken}" />
		</c:if>
			<c:if test="${error}">
				${logger.warn('Exception formatting locationToken to number. {}', log:kv('locationToken',locationToken), error)}
			</c:if>
</c:forTokens>

<%-- RECOVER: if things have gone pear shaped --%>
<c:if test="${empty data.current.transactionId}">
	<error:recover origin="ajax/json/fuel_price_monthly_averages.jsp" quoteType="fuel" />
</c:if>

<%-- Save Client Data --%>
<core:transaction touch="R" noResponse="true" />

<c:set var="tranId" value="${data['current/transactionId']}" />

<%-- Load the config and send quotes to the aggregator gadget --%>
<c:import var="config" url="/WEB-INF/aggregator/fuel/config_averages.xml" />
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