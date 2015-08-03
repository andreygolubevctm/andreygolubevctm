<%@page import="java.util.Date"%>
<%@ page language="java" contentType="text/xml; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="request" />

<sql:setDataSource dataSource="jdbc/ctm"/>

<%-- Import request data from quote page --%>
<c:set var="param_QuoteData" value="${param.QuoteData}" />
<x:parse var="request" xml="${param_QuoteData}" />

<c:set var="tranId">
	<x:out select="$request/quote/transactionId" escapeXml="false" />
</c:set>

<c:set var="service" value="${param.service}" />
<c:set var="authToken" value="${param.authToken}" />
<c:set var="styleCodeId"><core:get_stylecode_id transactionId="${tranId}" /></c:set>
<c:set var="pageSettings" value="${settingsService.getPageSettings(styleCodeId, 'CAR')}" />

<c:set var="useDB" value="true"/>

<c:choose>
	<c:when test="${service == 'WOOL'}">
		<c:set var="providerId" value="80" />
	</c:when>
	<c:otherwise>
		<c:set var="providerId" value="71" />
	</c:otherwise>
</c:choose>

<go:soapAggregator
	config = ""
 	configDbKey="carQuoteService_hollard_init"
 	manuallySetProviderIds="${providerId}"
	verticalCode="CAR"
	styleCodeId="${pageSettings.getBrandId()}"
	transactionId="${tranId}"
	authToken="${authToken}"
	xml="<xml />"
	var="tokenResultXml"
	debugVar="tokenDebugXml" />

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

		<c:import var="inbound_xsl" url="/WEB-INF/aggregator/car/Hollard/v2/inbound.xsl" />
		<c:set var="tokenResultXml">
			<x:transform doc="${tokenResultXml}" xslt="${inbound_xsl}" xsltSystemId="/WEB-INF/aggregator/car/Hollard/v2/inbound.xsl" />
		</c:set>

		<c:out value="${tokenResultXml}" escapeXml="false" />

	</c:when>

	<c:otherwise>

		<%-- Got token... continue... --%>

		<go:setData dataVar="data" xpath="temp" value="*DELETE" />
		<go:setData dataVar="data" xpath="soap-response" value="*DELETE" />

		<go:setData dataVar="data" xpath="temp" xml="${param_QuoteData}" />
		<go:setData dataVar="data" xpath="temp/quote/token" value="${token}" />

		<jsp:useBean id="carService" class="com.ctm.services.car.CarVehicleSelectionService"/>
		<c:set var="glassesCode" value="${carService.getGlassesCode(data['temp/quote/vehicle/redbookCode'], data['temp/quote/vehicle/registrationYear'])}"/>
		<go:setData dataVar="data" xpath="temp/quote/glasses" value="${glassesCode}"/>

		<c:set var="xmlData" value="${go:getEscapedXml(data['temp/quote'])}" />

		<go:soapAggregator
			config = ""
		 	configDbKey="carQuoteService_hollard_quote"
		 	manuallySetProviderIds="${providerId}"
			verticalCode="CAR"
			styleCodeId="${pageSettings.getBrandId()}"
			transactionId="${tranId}"
			authToken="${authToken}"
			xml="${xmlData}"
			var="quoteResultXml"
			debugVar="debugXml" />

		<go:soapAggregator
			config = ""
		 	configDbKey="carQuoteService_hollard_content"
		 	manuallySetProviderIds="${providerId}"
			verticalCode="CAR"
			styleCodeId="${pageSettings.getBrandId()}"
			transactionId="${tranId}"
			authToken="${authToken}"
			xml="${xmlData}"
			var="contentResultXml"
			debugVar="debugXml" />

		<%-- Combine these two --%>
		<c:import var="transferXml" url="/WEB-INF/aggregator/car/Hollard/v2/merge-quote-and-content.xsl"/>
		<c:set var="combinedXml">${quoteResultXml}${contentResultXml}</c:set>

		<%-- 	This is ugly... and needs to be fixed... --%>
		<c:set var="combinedXml">
			<%
			String xml = (String) pageContext.getAttribute("combinedXml");
			xml = xml.replaceAll("(</results></soap-response><soap-response><results responseTime=\"[0-9]{1,}\">)", "");
			xml = xml.replaceAll("(</soap-response><soap-response><results responseTime=\"[0-9]{1,}\"/>)", "");

			pageContext.setAttribute("combinedXml2", xml);
			%>
		</c:set>
		
		<c:set var="finalXml">
			<x:transform xml="${combinedXml2}" xslt="${transferXml}"/>
		</c:set>
		
		<c:out value="${finalXml}" escapeXml="false" />

	</c:otherwise>

</c:choose>