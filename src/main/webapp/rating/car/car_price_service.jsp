<%@page import="java.util.Date"%>
<%@ page language="java" contentType="text/xml; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<c:set var="logger" value="${log:getLogger('jsp.rating.car.car_price_service')}" />

<jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="request" />

<sql:setDataSource dataSource="${datasource:getDataSource()}"/>

<%-- Import request data from quote page --%>
<c:set var="param_QuoteData" value="${param.QuoteData}" />
<x:parse var="request" xml="${param_QuoteData}" />

<c:set var="service">${param.service}</c:set>

<c:set var="tranId">
	<x:out select="$request/quote/transactionId" escapeXml="false" />
</c:set>

<c:set var="styleCodeId"><core:get_stylecode_id transactionId="${tranId}" /></c:set>
<c:set var="pageSettings" value="${settingsService.getPageSettings(styleCodeId, 'CAR')}" />

<%--
<go:soapAggregator
	config = ""
 	configDbKey="carQuoteService_hollard_init"
 	manuallySetProviderIds="71"
	verticalCode="CAR"
	styleCodeId="${pageSettings.getBrandId()}"
	transactionId="${tranId}"
	xml="<xml />"
	var="tokenResultXml"
	debugVar="tokenDebugXml" />
--%>

<%-- init_config.xml will contain details of the init_inbound.xsl and init_outbound.xsl for init --%>
<c:import var="init_config" url="/WEB-INF/aggregator/car/Hollard/config_${service}_init.xml" />
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

		<c:import var="inbound_xsl" url="/WEB-INF/aggregator/car/Hollard/v2/inbound.xsl" />
		<c:set var="tokenResultXml">
			<x:transform doc="${tokenResultXml}" xslt="${inbound_xsl}" xsltSystemId="/WEB-INF/aggregator/car/Hollard/v2/inbound.xsl" >
				<x:param name="service" value="${service}" />
			</x:transform>
		</c:set>

		<c:out value="${tokenResultXml}" escapeXml="false" />

	</c:when>

	<c:otherwise>

		<%-- Got token... continue... --%>

		<go:setData dataVar="data" xpath="temp" value="*DELETE" />
		<go:setData dataVar="data" xpath="soap-response" value="*DELETE" />

		<go:setData dataVar="data" xpath="temp" xml="${param_QuoteData}" />
		<go:setData dataVar="data" xpath="temp/quote/token" value="${token}" />
		${logger.debug('About to call car service', log:kv("params",param))}
		<jsp:useBean id="carService" class="com.ctm.services.car.CarVehicleSelectionService"/>
		<c:set var="glassesCode" value="${carService.getGlassesCode(data['temp/quote/vehicle/redbookCode'], data['temp/quote/vehicle/registrationYear'])}"/>
		<go:setData dataVar="data" xpath="temp/quote/glasses" value="${glassesCode}"/>

		<c:set var="xmlData" value="${go:getEscapedXml(data['temp/quote'])}" />

		<jsp:useBean id="configResolver" class="com.ctm.utils.ConfigResolver" scope="application" />
		<c:set var="config" value="${configResolver.getConfig(pageContext.request.servletContext, '/WEB-INF/aggregator/car/Hollard/config_${service}_quote.xml')}" />
		<go:soapAggregator config="${config}" transactionId="${tranId}" xml="${xmlData}" var="resultXml" debugVar="debugXml" />
		<c:out value="${resultXml}" escapeXml="false" />

	</c:otherwise>

</c:choose>