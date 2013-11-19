<%@ page language="java" contentType="text/json; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<c:set var="tranId" value="${data.current.transactionId}" />

<%-- Build XML required for Life Broker request --%>
<c:set var="products_list">
	<c:forTokens items="${param.products}" delims="," var="product"><product>${product}</product></c:forTokens>
</c:set>

<%-- Build XML required for Life Broker request --%>
<c:set var="requestXML">
<benefitcomparisonrequest>
	<request xmlns="urn:Lifebroker.EnterpriseAPI">
		<products>${products_list}</products>
	</request>
</benefitcomparisonrequest>
</c:set>

<%-- Load the config and send quotes to the aggregator gadget --%>
<c:import var="config" url="/WEB-INF/aggregator/life/config_lifebroker_comparison.xml" />
<go:soapAggregator config = "${config}"
					transactionId = "${tranId}"
					xml = "${requestXML}"
					var = "resultXml"
					debugVar="debugXml" />

<%-- Add the results to the current session data --%>
<go:setData dataVar="data" xpath="soap-response" value="*DELETE" />
<go:setData dataVar="data" xpath="soap-response" xml="${resultXml}" />
<go:setData dataVar="data" xpath="soap-response/results/transactionId" value="${data.current.transactionId}" />

<go:log>${resultXml}</go:log>
<go:log>${debugXml}</go:log>

${go:XMLtoJSON(go:getEscapedXml(data['soap-response/results']))}