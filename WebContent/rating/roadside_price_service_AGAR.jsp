<%@page import="java.util.Date"%>
<%@ page language="java" contentType="text/xml; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<x:parse var="roadside" xml="${param.QuoteData}" />
<go:log source="roadside_price_service_AGAR_jsp">QuoteData: ${param.QuoteData}</go:log>

<%-- #WHITELABEL styleCodeID --%>
<c:set var="transactionId"><x:out select="$roadside/request/header/partnerReference" /></c:set>
<c:set var="styleCodeId"><core:get_stylecode_id transactionId="${transactionId}" /></c:set>

<%--
	The data will arrive in a single parameter called QuoteData
	Containing the xml for the request in the structure:
	request
	|--state
--%>

<c:set var="providerId" >303</c:set>

<c:set var="state"><x:out select="$roadside/request/details/state" /></c:set>
<c:set var="commercial"><x:out select="$roadside/request/details/commercial" /></c:set>
<c:set var="odometer"><x:out select="$roadside/request/details/odometer" /></c:set>
<c:set var="year"><x:out select="$roadside/request/details/year" /></c:set>

<sql:setDataSource dataSource="jdbc/ctm"/>

<%-- Get products that match the passed criteria --%>
<%-- #WHITELABEL StyleCode is referenced once in the parent roadside_rates to knockout disabled products --%>
<sql:query var="result">
SELECT
		rr.ProductId AS productid,
		rr.SequenceNo,
		rr.propertyid,
		rr.value,
		prodm.productCat,
		prodm.longTitle AS des,
		prodm.shortTitle AS name,
		prodm.providerId AS provider,
		pm.Name AS provider,
		pr.value AS premium,
		pr.text AS premiumText
	FROM ctm.roadside_rates rr
		INNER JOIN ctm.stylecode_products prodm on rr.ProductId = prodm.ProductId
		INNER JOIN ctm.provider_master pm  on pm.providerId = prodm.providerId
		INNER JOIN ctm.roadside_rates pr on pr.ProductId = rr.ProductId
	WHERE prodm.styleCodeId = ?
		AND prodm.providerId = ?
		AND pr.propertyid = ?
		AND (
				(rr.propertyid = ?)
				OR
				(rr.propertyid = 'commercial' and rr.value = ? )
				OR
				(rr.propertyid = 'maxKm' and rr.value = ?  )
				OR
				(rr.propertyid = 'carAgeMax' and rr.value >= (year(CURRENT_TIMESTAMP ) - ?)  )
			)
	GROUP BY rr.ProductId, rr.SequenceNo;
	<sql:param>${styleCodeId}</sql:param>
	<sql:param>${providerId}</sql:param>
	<sql:param>${state}</sql:param>
	<sql:param>${state}</sql:param>
	<sql:param>${commercial}</sql:param>
	<sql:param>${odometer}</sql:param>
	<sql:param>${year}</sql:param>
</sql:query>


<%-- Build the xml data for each row --%>
<roadside:convert_to_results rows="${result.rows}"/>