<%@ page language="java" contentType="text/json; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%-- Build XML required for Life Broker request --%>
<c:set var="requestXML">
<combined>
	<premium xmlns="urn:Lifebroker.EnterpriseAPI">
		<client_reference>${param.client_ref}</client_reference>
		<product_id>${param.product_id}</product_id>
		<action>${param.request_type}</action>
	</premium>
	<request xmlns="urn:Lifebroker.EnterpriseAPI">
		<affiliate_id>${data.current.transactionId}</affiliate_id>
		<products>
			<product>${param.product_id}</product>
			<product>${param.product_id}</product>
		</products>
	</request>
</combined>
</c:set>

<c:set var="tranId" value="${data['ip/transactionId']}" />

<%-- Load the config and send quotes to the aggregator gadget --%>
<c:import var="config" url="/WEB-INF/aggregator/ip/config_product_selection.xml" />
<go:soapAggregator config = "${config}"
					transactionId = "${tranId}" 
					xml = "${requestXML}" 
					var = "resultXml"
					debugVar="debugXml" />

<%-- Add the results to the current session data --%>
<go:setData dataVar="data" xpath="soap-response" value="*DELETE" />
<go:setData dataVar="data" xpath="soap-response" xml="${resultXml}" />
<go:setData dataVar="data" xpath="soap-response/results/transactionId" value="${tranId}" />

<go:log>${resultXml}</go:log>
<go:log>${debugXml}</go:log>

${go:XMLtoJSON(data['soap-response/results'])}