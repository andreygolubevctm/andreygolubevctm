<%@ page language="java" contentType="text/json; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%-- First check owner of the quote --%>
<c:set var="proceedinator"><core:access_check quoteType="life" /></c:set>
<c:choose>
	<c:when test="${not empty proceedinator and proceedinator > 0}">
		<go:log>PROCEEDINATOR PASSED</go:log>

		<%-- Build XML required for Life Broker request --%>
		<c:set var="requestXML">
		<premium xmlns="urn:Lifebroker.EnterpriseAPI">
			<affiliate_id>${data.current.transactionId}</affiliate_id>
			<client_reference>${param.client_ref}</client_reference>
			<product_id>${param.product_id}</product_id>
			<action>${param.request_type}</action>
		</premium>
		</c:set>
		
		<c:set var="tranId" value="${data['life/transactionId']}" />
		
		<%-- Load the config and send quotes to the aggregator gadget --%>
		<c:import var="config" url="/WEB-INF/aggregator/life/config_product_apply.xml" />
		<go:soapAggregator config = "${config}"
							transactionId = "${tranId}" 
							xml = "${requestXML}" 
							var = "resultXml"
							debugVar="debugXml" />
		
		<%-- Add the results to the current session data --%>
		<go:setData dataVar="data" xpath="soap-response" value="*DELETE" />
		<go:setData dataVar="data" xpath="soap-response" xml="${resultXml}" />
		<go:setData dataVar="data" xpath="soap-response/results/transactionId" value="${tranId}" />
		<go:setData dataVar="data" xpath="soap-response/results/selection/pds" value="*DELETE" />
		
		<go:log>${resultXml}</go:log>
		<go:log>${debugXml}</go:log>
	</c:when>
	<c:otherwise>
		<c:set var="resultXml">
			<error><core:access_get_reserved_msg isSimplesUser="${not empty data.login.user.uid}" /></error>
		</c:set>		
		<go:setData dataVar="data" xpath="soap-response" xml="${resultXml}" />
	</c:otherwise>
</c:choose>
${go:XMLtoJSON(resultXml)}