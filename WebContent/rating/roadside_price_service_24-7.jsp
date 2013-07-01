<%@page import="java.util.Date"%>
<%@ page language="java" contentType="text/xml; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>


<%-- 
	The data will arrive in a single parameter called QuoteData 
	Containing the xml for the request in the structure:
	request
	  |--state
--%>
<x:parse var="roadside" xml="${param.QuoteData}" />

<c:set var="state"><x:out select="$roadside/request/details/state" /></c:set>
<c:set var="commercial"><x:out select="$roadside/request/details/commercial" /></c:set>
<c:set var="odometer"><x:out select="$roadside/request/details/odometer" /></c:set>
<c:set var="year"><x:out select="$roadside/request/details/year" /></c:set>


<%-- Get products that match the passed criteria --%> 
<sql:setDataSource dataSource="jdbc/aggregator"/>
<sql:query var="result">
   SELECT
	a.ProductId,
	a.SequenceNo,
	a.propertyid,
	a.value,
	b.productCat,
	b.longTitle,
	b.shortTitle,
	b.providerId

	FROM aggregator.roadside_rates a 
	INNER JOIN aggregator.product_master b on a.ProductId = b.ProductId
	WHERE b.providerId = 10
	AND EXISTS (Select * from aggregator.roadside_rates b where b.productid = a.productid and b.sequenceNo = a.sequenceNo and b.propertyid = ?)
	AND	EXISTS (Select * from aggregator.roadside_rates b where b.productid = a.productid and b.sequenceNo = a.sequenceNo and b.propertyid = 'commercial' and b.text LIKE '%${commercial}%' )	
	GROUP BY a.ProductId, a.SequenceNo
	<sql:param>${state}</sql:param>
</sql:query>
    

<%-- Build the xml data for each row --%>
<results>
	<c:forEach var="row" items="${result.rows}">
		<sql:query var="premium">
			SELECT
				a.propertyid,
				a.Value,
				a.Text
			FROM aggregator.roadside_rates a
			WHERE a.productid = ${row.productid} 
			AND a.sequenceNo = ${row.sequenceno} 
			AND a.propertyid = '${state}'
		</sql:query>
		
		<c:if test="${premium.rowCount != 0}">
			<c:set var="price" value="${premium.rows[0]}" />
			
			<sql:query var="provider">
				SELECT Name
				FROM aggregator.provider_master
				WHERE providerId = ${row.providerId} 
			</sql:query>

			<result productId="${row.productCat}-${row.productid}">
				<provider>${provider.rows[0].name}</provider>
				<name>${row.shorttitle}</name>
				<des>${row.longtitle}</des>
				<premium>${price.value}</premium>
				<premiumText>${price.text}</premiumText>				
				<sql:query var="detail">
					SELECT
						b.label,
						b.longlabel,
						a.Value,
						a.propertyid,
						a.Text
						FROM aggregator.roadside_details a 
						JOIN aggregator.property_master b on a.propertyid = b.propertyid
						where a.productid = ${row.productid}
						ORDER BY label						
				</sql:query>
				<c:forEach var="info" items="${detail.rows}">
					<productInfo propertyId="${info.propertyid}">
						<label>${info.label}</label>
						<desc>${info.longlabel}</desc>
						<value>${info.value}</value>
						<text>${info.text}</text>
					</productInfo>
				</c:forEach>
				
	   		</result>
	   		
	   	</c:if>
	</c:forEach>	
	<c:if test="result.rowCount == 0">
		<result>
				<provider></provider>
				<name></name>
				<des></des>
				<premium></premium>
		</result>		
	</c:if>
</results>