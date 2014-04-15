<%@page import="java.util.Date"%>
<%@ page language="java" contentType="text/xml; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="request" />
<sql:setDataSource dataSource="jdbc/test" />

<%-- Import request data from quote page --%>
<c:set var="param_QuoteData" value="${param.QuoteData}" />
<x:parse var="request" xml="${param_QuoteData}" />

<c:set var="tranId">
	<x:out select="$request/quote/transactionId" escapeXml="false" />
</c:set>

<%-- init_config.xml will contain details of the init_inbound.xsl and init_outbound.xsl for init --%>
<c:import var="init_config" url="/WEB-INF/aggregator/get_prices/config_WOOL_init.xml" />
<go:soapAggregator config="${init_config}" transactionId="${tranId}" xml="<xml />" var="tokenResultXml" debugVar="tokenDebugXml" />

<go:setData dataVar="data" xpath="soap-response/result" value="*DELETE" />
<go:setData dataVar="data" xml="${tokenResultXml}" />

<c:set var="token" value=""/>
<c:catch var="error">
	<c:set var="token">
		<c:out value="${data['soap-response/result/token']}" />
	</c:set>
</c:catch>

<c:choose>

	<c:when test="${empty token}">

		<%-- Has failed to get a token, print through failed response. --%>

		<c:import var="inbound_xsl" url="/WEB-INF/aggregator/get_prices/WOOL_inbound.xsl" />
		<c:set var="tokenResultXml">
			<x:transform doc="${tokenResultXml}" xslt="${inbound_xsl}" />
		</c:set>

		<c:out value="${tokenResultXml}" escapeXml="false" />

	</c:when>

	<c:otherwise>

		<%-- Got token... continue... --%>

		<go:setData dataVar="data" xpath="temp" value="*DELETE" />
		<go:setData dataVar="data" xpath="soap-response" value="*DELETE" />

		<go:setData dataVar="data" xpath="temp" xml="${param_QuoteData}" />
		<go:setData dataVar="data" xpath="temp/quote/token" value="${token}" />
		<c:set var="glassesCode">
			<quote:getGlassesCode redbookCode="${data['temp/quote/vehicle/redbookCode']}" year="${data['temp/quote/vehicle/registrationYear']}"/>
		</c:set>



		<go:setData dataVar="data" xpath="temp/quote/glasses" value="${glassesCode}"/>

		<c:set var="xmlData" value="${go:getEscapedXml(data['temp/quote'])}" />

		<c:import var="config" url="/WEB-INF/aggregator/get_prices/config_WOOL_quote.xml" />
		<go:soapAggregator config="${config}" transactionId="${tranId}" xml="${xmlData}" var="resultXml" debugVar="debugXml" />

		<c:out value="${resultXml}" escapeXml="false" />

	</c:otherwise>

</c:choose>