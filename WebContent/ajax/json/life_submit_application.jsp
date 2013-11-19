<%@ page language="java" contentType="text/json; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%-- First check owner of the quote --%>
<c:set var="proceedinator"><core:access_check quoteType="life" /></c:set>
<c:choose>
	<c:when test="${not empty proceedinator and proceedinator > 0}">
		<go:log>PROCEEDINATOR PASSED</go:log>

		<%-- Processing --%>
		<core:transaction touch="P" noResponse="true" />

		<c:set var="tranId" value="${data.current.transactionId}" />

		<%-- Build XML required for Life Broker request --%>
		<c:set var="requestXML">
<applyrequest>
	<request xmlns="urn:Lifebroker.EnterpriseAPI">
		<affiliate_id><c:out value="${data.current.transactionId}" /></affiliate_id>
		<client_reference><c:out value="${param.client_ref}" /></client_reference>
		<action><c:out value="${param.request_type}" /></action>
	<c:choose>
		<c:when test="${param.partner_quote eq 'Y'}">
			<c:if test="${not empty param.client_product_id}">
		<client_product_id><c:out value="${param.client_product_id}" /></client_product_id>
			</c:if>
			<c:if test="${not empty param.partner_product_id}">
		<partner_product_id><c:out value="${param.partner_product_id}" /></partner_product_id>
			</c:if>
		</c:when>
		<c:otherwise>
		<product_id><c:out value="${param.client_product_id}" /></product_id>
		</c:otherwise>
	</c:choose>
	</request>
</applyrequest>
		</c:set>

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

		<%-- Confirmation --%>
		<core:transaction touch="C" noResponse="true" />
	</c:when>
	<c:otherwise>
		<c:set var="resultXml">
			<error><core:access_get_reserved_msg isSimplesUser="${not empty data.login.user.uid}" /></error>
		</c:set>
		<go:setData dataVar="data" xpath="soap-response" xml="${resultXml}" />
	</c:otherwise>
</c:choose>
${go:XMLtoJSON(go:getEscapedXml(data['soap-response/results']))}