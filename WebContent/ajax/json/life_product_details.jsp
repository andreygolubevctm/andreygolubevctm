<%@ page language="java" contentType="text/json; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<session:get />

<c:set var="tranId" value="${data.current.transactionId}" />

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
<c:import var="config" url="/WEB-INF/aggregator/life/config_product_details.xml" />
<go:soapAggregator 	config = "${config}"
					transactionId = "${tranId}"
					xml = "${requestXML}"
					var = "resultXml"
					debugVar="debugXml"
					verticalCode="${fn:toUpperCase(vertical)}"
					configDbKey="quoteService"
					styleCodeId="${pageSettings.getBrandId()}"  />

<%-- Add the results to the current session data --%>
<go:setData dataVar="data" xpath="soap-response" value="*DELETE" />
<go:setData dataVar="data" xpath="soap-response" xml="${resultXml}" />
<go:setData dataVar="data" xpath="soap-response/results/transactionId" value="${tranId}" />

<go:log source="life_product_details_jsp" level="DEBUG">${resultXml}</go:log>
<go:log source="life_product_details_jsp" level="DEBUG">${debugXml}</go:log>

${go:XMLtoJSON(go:getEscapedXml(data['soap-response/results']))}