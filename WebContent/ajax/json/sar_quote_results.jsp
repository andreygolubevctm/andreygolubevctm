<%@ page language="java" contentType="text/json; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>
<jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="session" />

<jsp:useBean id="now" class="java.util.Date" />
<fmt:formatDate var="current_year" value="${now}" pattern="yyyy" />

<c:set var="clientUserAgent"><%=request.getHeader("user-agent")%></c:set>

<%-- Load the params into data --%>
<go:setData dataVar="data" xpath="roadside" value="*DELETE" />
<go:setData dataVar="data" value="*PARAMS" />

<go:setData dataVar="data" xpath="roadside/clientIpAddress" value="${pageContext.request.remoteAddr}" />
<go:setData dataVar="data" xpath="roadside/clientUserAgent" value="${clientUserAgent}" />

<%-- RECOVER: if things have gone pear shaped --%>
<c:if test="${empty data.current.transactionId}">
	<error:recover origin="ajax/json/sar_quote_results.jsp" quoteType="roadside" />
</c:if>

<%-- Save Client Data --%>
<core:transaction touch="R" noResponse="true" />

<c:set var="tranId" value="${data['current/transactionId']}" />

<c:set var="valid" value="${
								not empty data['roadside/riskAddress/state'] &&
								not empty data['roadside/vehicle/vehicle/commercial'] &&
								not empty data['roadside/vehicle/year'] &&
								not empty data['roadside/vehicle/vehicle/odometer']
							}" />
<c:choose>
	<c:when test="${not empty tranId and valid}">
			<%-- Load the config and send quotes to the aggregator gadget --%>
			<c:import var="config" url="/WEB-INF/aggregator/roadside/config.xml" />
			<go:soapAggregator config = "${config}"
					transactionId = "${tranId}"
					xml = "${go:getEscapedXml(data['roadside'])}"
					var = "resultXml"
					debugVar="debugXml" />


		<%-- Write to the stats database --%>
		<agg:write_stats tranId="${tranId}" debugXml="${debugXml}" rootPath="" />

		<%-- Add the results to the current session data --%>
		<go:setData dataVar="data" xpath="soap-response" value="*DELETE" />
		<go:setData dataVar="data" xpath="soap-response" xml="${resultXml}" />
		<go:log>${resultXml}</go:log>
		<go:log>${debugXml}</go:log>

		${go:XMLtoJSON(resultXml)}
	</c:when>
	<c:when test="${empty tranId}">
		<go:log>
			sar_quote_results.jsp
			transactionId is missing
			${data.xml['roadside']}
		</go:log>
		{"error":"NO_TRAN_ID"}
	</c:when>
	<c:otherwise>
		<go:log>
			sar_quote_results.jsp
			data is missing
			${data.xml['roadside']}
		</go:log>
		{"error":"VALIDATION_FAILED"}
	</c:otherwise>
</c:choose>