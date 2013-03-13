<%@page import="java.util.Date"%>
<%@ page language="java" contentType="text/xml; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

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
<x:parse var="travel" xml="${param.QuoteData}" />

<c:set var="age"><x:out select="$travel/request/details/age" /></c:set>
<c:set var="region"><x:out select="$travel/request/details/region" /></c:set>
<c:set var="type"><x:out select="$travel/request/details/type" /></c:set>
<c:set var="multiTrip"><x:out select="$travel/request/details/multiTrip" /></c:set>
<c:set var="reqStartDate"><x:out select="$travel/request/details/startDate" /></c:set>
<c:set var="reqEndDate"><x:out select="$travel/request/details/endDate" /></c:set>

<%-- Calc the duration from the passed start/end dates --%>
<c:set var="duration">
	<c:choose>
	<c:when test="${multiTrip == 'Y'}">365</c:when>
	<c:otherwise>
		<fmt:parseDate type="DATE" value="${reqStartDate}" var="startdate" pattern="yyyy-MM-dd" parseLocale="en_GB"/>
		<fmt:parseDate type="DATE" value="${reqEndDate}" var="enddate" pattern="yyyy-MM-dd" parseLocale="en_GB"/>
		<c:out value="${1+ ((enddate.time/86400000)-(startdate.time/86400000)) }" />
	</c:otherwise>
	</c:choose>
</c:set>

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

	FROM aggregator.travel_rates a 
	INNER JOIN aggregator.product_master b on a.ProductId = b.ProductId
	WHERE b.providerId = 21
	AND EXISTS (Select * from aggregator.travel_rates b where b.productid = a.productid and b.sequenceNo = a.sequenceNo and b.propertyid = 'durMin' and b.value <= ${duration})
	AND	EXISTS (Select * from aggregator.travel_rates b where b.productid = a.productid and b.sequenceNo = a.sequenceNo and b.propertyid = 'durMax' and b.value >= ${duration})
	AND	EXISTS (Select * from aggregator.travel_rates b where b.productid = a.productid and b.sequenceNo = a.sequenceNo and b.propertyid = 'ageMin' and b.value <= ${age})
	AND	EXISTS (Select * from aggregator.travel_rates b where b.productid = a.productid and b.sequenceNo = a.sequenceNo and b.propertyid = 'ageMax' and b.value >= ${age})
	AND	EXISTS (Select * from aggregator.travel_details b where b.productid = a.productid and b.propertyid = 'multiTrip' and b.text = '${multiTrip}' )	
	GROUP BY a.ProductId, a.SequenceNo
</sql:query>
    
<go:log>${result}</go:log>

<%-- Build the xml data for each row --%>
<results>
	<c:forEach var="row" items="${result.rows}">
		<sql:query var="premium">
			SELECT
				a.propertyid,
				a.value,
				a.text
			FROM aggregator.travel_rates a
			WHERE a.productid = ${row.productid} 
			AND a.sequenceNo = ${row.sequenceno}
		<c:choose>
			<c:when test="${multiTrip == 'Y'}">
			AND a.propertyid = 'R1-${type}'
			</c:when>
			<c:otherwise>
			AND a.propertyid = '${region}-${type}'
			</c:otherwise>
		</c:choose>
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
						a.benefitOrder,
						a.propertyid,
						a.Text
						FROM aggregator.travel_details a 
						JOIN aggregator.property_master b on a.propertyid = b.propertyid
						where a.productid = ${row.productid}
						ORDER BY benefitOrder DESC
				</sql:query>
				<c:forEach var="info" items="${detail.rows}">
					<productInfo propertyId="${info.propertyid}">
						<label>${info.label}</label>
						<c:choose>
							<c:when test="${info.label == 'Overseas Medical'}"><desc>Overseas Emergency Medical &amp; Hospital Expenses</desc></c:when>
							<c:otherwise><desc>${info.longlabel}</desc></c:otherwise>
						</c:choose>
						<value>${info.value}</value>
						<text>${info.text}</text>
						<order>${info.benefitOrder}</order>
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
 