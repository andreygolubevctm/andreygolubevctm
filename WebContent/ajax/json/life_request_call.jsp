<%@ page language="java" contentType="text/json; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%-- First check owner of the quote --%>
<c:set var="proceedinator"><core:access_check quoteType="${fn:toLowerCase(param.vertical)}" /></c:set>
<c:choose>
	<c:when test="${not empty proceedinator and proceedinator > 0}">
		<go:log>PROCEEDINATOR PASSED</go:log>

		<%-- Load the params into data --%>
		<security:populateDataFromParams rootPath="${vertical}" />

		<go:setData dataVar="data" xpath="${fn:toLowerCase(param.vertical)}/clientIpAddress" value="${pageContext.request.remoteAddr}" />
		<go:setData dataVar="data" xpath="${fn:toLowerCase(param.vertical)}/current/transactionId" value="${data.current.transactionId}" />

		<%-- Save client data --%>
		<%-- <agg:write_quote productType="${fn:toUpperCase(param.vertical)}" rootPath="${fn:toLowerCase(param.vertical)}"/> --%>
		<core:transaction touch="CB" noResponse="true" comment="Request call back" />

		<%-- add external testing ip address checking and loading correct config and send quotes --%>
		<c:set var="clientIpAddress" value="<%=request.getRemoteAddr()%>" />

		<c:set var="tranId" value="${data.current.transactionId}" />

		<%-- Load the config and send quotes to the aggregator gadget --%>
		<c:import var="config" url="/WEB-INF/aggregator/life/config_request_call.xml" />
		<go:soapAggregator config = "${config}"
							transactionId = "${tranId}" 
							xml = "${go:getEscapedXml(data[fn:toLowerCase(param.vertical)])}"
							var = "resultXml"
							debugVar="debugXml" />

		<%-- Add the results to the current session data --%>
		<go:setData dataVar="data" xpath="soap-response" value="*DELETE" />
		<go:setData dataVar="data" xpath="soap-response" xml="${resultXml}" />

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
${go:XMLtoJSON(go:getEscapedXml(data['soap-response/results']))}
