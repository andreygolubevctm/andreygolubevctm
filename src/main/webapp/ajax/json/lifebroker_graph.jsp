<%@ page language="java" contentType="application/json; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>
<c:set var="logger" value="${log:getLogger('jsp.ajax.json.lifebroker_graph')}" />
<session:get  />

<%-- Build XML required for Life Broker request --%>
<c:set var="products_list">
	<c:forTokens items="${param.products}" delims="," var="product"><product>${product}</product></c:forTokens>
</c:set>

<c:set var="requestXML">
<request><client_reference><c:out value="${param.client_reference}" /></client_reference><c:choose>
	<c:when test="${param.premium_type eq 'S'}"><stepped_products><c:out value="${products_list}" /></stepped_products></c:when>
	<c:otherwise><level_products><c:out value="${products_list}" /></level_products></c:otherwise>
</c:choose></request>
</c:set>

<%-- Load the config and send quotes to the aggregator gadget --%>
<jsp:useBean id="configResolver" class="com.ctm.web.core.utils.ConfigResolver" scope="application" />
<c:set var="config" value="${configResolver.getConfig(pageContext.request.servletContext, '/WEB-INF/aggregator/life/config_lifebroker_graph.xml')}" />
<go:soapAggregator config = "${config}"
					transactionId = "${data.current.transactionId}"
					xml = "${requestXML}"
					var = "resultXml"
					debugVar="debugXml"
					verticalCode="${fn:toUpperCase(vertical)}"
					configDbKey="quoteService"
					styleCodeId="${pageSettings.getBrandId()}"  />

<%-- Add the results to the current session data --%>
<go:setData dataVar="data" xpath="soap-response" value="*DELETE" />
<go:setData dataVar="data" xpath="soap-response" xml="${resultXml}" />
<go:setData dataVar="data" xpath="soap-response/results/transactionId" value="${data.current.transactionId}" />
${go:XMLtoJSON(go:getEscapedXml(data['soap-response/results']))}