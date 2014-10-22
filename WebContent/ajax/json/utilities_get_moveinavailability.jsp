<%@ page language="java" contentType="text/json; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<session:get settings="true" authenticated="true"/>

<%-- First check owner of the quote --%>
<c:set var="proceedinator"><core:access_check quoteType="utilities" /></c:set>
<c:choose>
	<c:when test="${not empty proceedinator and proceedinator > 0}">
		<go:log>PROCEEDINATOR PASSED</go:log>
		
		<c:set var="requestXml">
<RetailerSearch xmlns="http://switchwise.com.au/" xmlns:i="http://www.w3.org/2001/XMLSchema-instance">
	<RetailerCode>${param.providerCode}</RetailerCode>
	<State>${param.state}</State>
</RetailerSearch>
		</c:set>
		
		<%-- Load the config and send quotes to the aggregator gadget --%>
		<c:import var="config" url="/WEB-INF/aggregator/utilities/config_getmoveinavailability.xml" />
		<go:soapAggregator config = "${config}"
							transactionId = "${data.current.transactionId}" 
							xml = "${requestXml}" 
							var = "resultXml"
							debugVar="debugXml"
							configDbKey="quoteService"
							styleCodeId="${pageSettings.getBrandId()}"
							verticalCode="UTILITIES" />
							
		<go:setData dataVar="data" xpath="soap-response" xml="${resultXml}" />
							
		<go:log>${resultXml}</go:log>
		<go:log>${debugXml}</go:log>
	</c:when>
	<c:otherwise>
		<c:set var="resultXml">
			<error><core:access_get_reserved_msg isSimplesUser="${not empty authenticatedData.login.user.uid}" /></error>
		</c:set>		
		<go:setData dataVar="data" xpath="soap-response" xml="${resultXml}" />
	</c:otherwise>
</c:choose>
${go:XMLtoJSON(resultXml)}
