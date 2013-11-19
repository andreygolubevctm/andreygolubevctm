<%@ page language="java" contentType="text/json; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>
<jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="session" />
<c:set var="clientUserAgent"><%=request.getHeader("user-agent")%></c:set>

<%-- Load the params into data --%>
<go:setData dataVar="data" xpath="fuel" value="*DELETE" />
<go:setData dataVar="data" value="*PARAMS" />

<go:setData dataVar="data" xpath="fuel/clientIpAddress" value="${pageContext.request.remoteAddr}" />
<go:setData dataVar="data" xpath="fuel/clientUserAgent" value="${clientUserAgent}" />

<%-- Add the postcode to the databucket --%>
<c:forTokens items="${data.fuel.location}" delims=" " var="locationToken">
		<c:catch var="error">
			<c:set var="temp"><fmt:formatNumber value="${locationToken}" type="number" /></c:set>
		</c:catch>

		<c:if test="${empty error && locationToken != ''}">
			<go:setData dataVar="data" xpath="fuel/postcode" value="${locationToken}" />
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
					debugVar="debugXml" />

<%-- Add the results to the current session data --%>
<go:setData dataVar="data" xpath="soap-response" value="*DELETE" />
<go:setData dataVar="data" xpath="soap-response" xml="${resultXml}" />
<go:log>${resultXml}</go:log>
<go:log>${debugXml}</go:log>

${go:XMLtoJSON(go:getEscapedXml(data['soap-response/results']))}