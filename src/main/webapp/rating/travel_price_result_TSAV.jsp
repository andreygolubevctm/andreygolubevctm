<%@page import="java.util.Date"%>
<%@ page language="java" contentType="text/xml; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<x:parse var="travel" xml="${param.QuoteData}" />

<c:set var="transactionId"><x:out select="$travel/request/header/partnerReference" /></c:set>
<c:set var="styleCodeId"><core:get_stylecode_id transactionId="${transactionId}" /></c:set>

<sql:setDataSource dataSource="${datasource:getDataSource()}"/>

<%--
	The data will arrive in a single parameter called QuoteData
	Containing the xml for the request in the structure:
	request
	|--startDate
	|--endDate
	|--age
	|--region		WW/EU/AS/PA
	|--multiTrip 	Y/N
	`--type		SIN/FAM/DUO


--%>

<results>
	<x:forEach select="$travel/request/product" var="product">
		<c:set var="age"><x:out select="$product/details/age" /></c:set>
		<c:set var="region"><x:out select="$product/details/region" /></c:set>
		<c:set var="type"><x:out select="$product/details/type" /></c:set>
		<c:set var="multiTrip"><x:out select="$product/details/multiTrip" /></c:set>
		<c:set var="reqStartDate"><x:out select="$product/details/startDate" /></c:set>
		<c:set var="reqEndDate"><x:out select="$product/details/endDate" /></c:set>
		<c:set var="productIds"><x:out select="$product/ids" /></c:set>

		<%-- Calc the duration from the passed start/end dates for SOAP service call providers use only --%>
		<c:set var="duration">
			<c:choose>
				<c:when test="${multiTrip == 'Y'}">365</c:when>
				<c:otherwise>
					<jsp:useBean id="utilCalc" class="com.ctm.utils.travel.DurationCalculation" scope="request" />
					${utilCalc.calculateDayDuration(reqStartDate, reqEndDate)}
				</c:otherwise>
			</c:choose>
		</c:set>

		<%-- Save the results into this variable --%>
		<c:set var="price_results">
			<travel:price_results providerId="${param.providerId}" styleCodeId="${styleCodeId}" duration="${duration}" age="${age}" region="${region}" type="${type}" multiTrip="${multiTrip}" productIds="${productIds}"  />
		</c:set>

		<%-- Output the results and don't escape the XML. If there's no results it will print out nothing. If all loops return nothing, then this result will fall into the 'Chose not to quote' section of the price presentation page --%>
		<x:out select="$price_results" escapeXml="false" />
	</x:forEach>
</results>