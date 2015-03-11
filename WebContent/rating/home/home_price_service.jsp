<%@page import="java.util.Date"%>
<%@ page language="java" contentType="text/xml; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<fmt:setLocale value="en_US" />

<jsp:useBean id="now" class="java.util.Date" scope="request" />
<jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="request" />

<sql:setDataSource dataSource="jdbc/aggregator"/>


<%-- Import request data from quote page --%>
<c:set var="param_QuoteData" value="${param.QuoteData}" />
<x:parse var="request" xml="${param_QuoteData}" />

<c:set var="tranId">
	<x:out select="$request/home/transactionId" escapeXml="false" />
</c:set>

<c:set var="service" value="${param.service}" />
<c:set var="styleCodeId"><core:get_stylecode_id transactionId="${tranId}" /></c:set>
<c:set var="pageSettings" value="${settingsService.getPageSettings(styleCodeId, 'HOME')}" />

<c:choose>
	<c:when test="${service == 'WOOL'}">
		<c:set var="providerId" value="80" />
	</c:when>
	<c:otherwise>
		<c:set var="providerId" value="71" />
	</c:otherwise>
</c:choose>


<go:soapAggregator
			config=""
			configDbKey="homeQuoteService_hollard_init"
		 	manuallySetProviderIds="${providerId}"
			verticalCode="HOME"
			styleCodeId="${pageSettings.getBrandId()}"
			transactionId="${tranId}"
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

		<c:import var="inbound_xsl" url="/WEB-INF/aggregator/home/Hollard/inbound.xsl?service=${service}" />
		<c:set var="tokenResultXml">
			<x:transform doc="${tokenResultXml}" xslt="${inbound_xsl}" xsltSystemId="/WEB-INF/aggregator/home/Hollard/inbound.xsl?service=${service}" />
		</c:set>

		<c:out value="${tokenResultXml}" escapeXml="false" />

	</c:when>

	<c:otherwise>

		<%-- Got token... continue... --%>

		<go:setData dataVar="data" xpath="temp" value="*DELETE" />
		<go:setData dataVar="data" xpath="soap-response" value="*DELETE" />

		<go:setData dataVar="data" xpath="temp" xml="${param_QuoteData}" />
		<go:setData dataVar="data" xpath="temp/home/token" value="${token}" />

		<fmt:formatDate pattern="yyyy-MM-dd" value="${now}" var="currentDate" type="DATE"/>
		<go:setData dataVar="data" xpath="temp/home/currentDate" value="${currentDate}" />

		<c:set var="xmlData" value="${go:getEscapedXml(data['temp/home'])}" />

				<go:soapAggregator config = ""
				 	configDbKey="homeQuoteService_hollard_quote"
				 	manuallySetProviderIds="${providerId}"
					verticalCode="HOME"
					styleCodeId="${pageSettings.getBrandId()}"
					transactionId="${tranId}"
					xml="${xmlData}"
					var="resultXml"
					debugVar="debugXml" />

		<%-- Get the content for Bridging Pages --%>
				<go:soapAggregator config = ""
				 	configDbKey="homeQuoteService_hollard_content"
				 	manuallySetProviderIds="${providerId}"
					verticalCode="HOME"
					styleCodeId="${pageSettings.getBrandId()}"
					transactionId="${tranId}"
					xml="${xmlData}"
					var="resultContentXml"
					debugVar="debugXml" />

		<%-- Combine these two --%>
		<c:import var="transferXml" url="/WEB-INF/aggregator/home/Hollard/merge-quote-and-content.xsl"/>
		<c:set var="combinedXml">${resultXml}${resultContentXml}</c:set>

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