<%@ tag language="java" pageEncoding="ISO-8859-1" %>
<%@ tag description="Displays a list of plans provided by a provider for a given state."%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%@ attribute name="postcode" required="true" description="The root postcode to search."%>
<%@ attribute name="providerid" required="true" description="The unique switchwise ID for the provider."%>
		
<c:set var="requestXml">
	<request>
		<Postcode>${postcode}</Postcode>
		<RetailerID>${providerid}</RetailerID>
	</request>
</c:set>

<%-- Load the config and send quotes to the aggregator gadget --%>
<c:import var="config" url="/WEB-INF/aggregator/utilities/config_getretailerplans.xml" />
<go:soapAggregator config = "${config}"
					transactionId = "${data.current.transactionId}" 
					xml = "${requestXml}" 
					var = "resultXml"
					debugVar="debugXml" />
					
<go:setData dataVar="data" xpath="soap-response" xml="${resultXml}" />
					
<go:log>GET PROVIDER PLANS: ${resultXml}</go:log>

<c:choose>
	<c:when test="${data['soap-response/results/status'] eq 'ERROR'}"></c:when>
	<c:otherwise>${resultXml}</c:otherwise>
</c:choose>