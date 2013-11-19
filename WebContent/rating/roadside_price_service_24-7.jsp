<%@page import="java.util.Date"%>
<%@ page language="java" contentType="text/xml; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- 
	The data will arrive in a single parameter called QuoteData 
	Containing the xml for the request in the structure:
	request
	  |--state
--%>
<x:parse var="roadside" xml="${param.QuoteData}" />

<c:set var="providerId" >10</c:set>

<c:set var="state"><x:out select="$roadside/request/details/state" /></c:set>
<c:set var="commercial"><x:out select="$roadside/request/details/commercial" /></c:set>
<c:set var="year"><x:out select="$roadside/request/details/year" /></c:set>

<%-- Get products that match the passed criteria --%>
<sql:setDataSource dataSource="jdbc/aggregator"/>

<%-- Get products that match the passed criteria --%> 
<sql:query var="result">
   SELECT
		rr.ProductId as productid,
		rr.SequenceNo,
		rr.propertyid,
		rr.value,
	b.productCat,
		b.longTitle AS des,
		b.shortTitle AS name,
		b.providerId AS provider,
		pm.Name AS provider,
		pr.value AS premium,
		pr.text AS premiumText
	FROM aggregator.roadside_rates rr
		INNER JOIN aggregator.product_master b on rr.ProductId = b.ProductId
		INNER JOIN aggregator.provider_master pm  on pm.providerId = b.providerId
		INNER JOIN aggregator.roadside_rates pr on pr.ProductId = rr.ProductId
	WHERE b.providerId = ?
		AND pr.propertyid = ?
		AND (
				(rr.propertyid = ?)
				OR
				(rr.propertyid = 'commercial' and rr.text LIKE ? )
				OR
				(rr.propertyid = 'carAgeMax' and rr.value >= (year(CURRENT_TIMESTAMP ) - ?) )
			)
	GROUP BY rr.ProductId, rr.SequenceNo
	Having count(*) = 3;
	<sql:param>${providerId}</sql:param>
	<sql:param>${state}</sql:param>
	<sql:param>${state}</sql:param>
	<sql:param>%${commercial}%</sql:param>
	<sql:param>${year}</sql:param>
</sql:query>
    

<%-- Build the xml data for each row --%>
<roadside:convert_to_results rows="${result.rows}"/>