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
	  |--region		R1/R2/R3/R4/R5/R6/R7
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
<c:set var="regionLow"><x:out select="$travel/request/details/regionLow" /></c:set>

<%-- Calc the duration from the passed start/end dates --%>
<c:set var="duration">
	<c:choose>
	<c:when test="${multiTrip == 'Y'}">365.0</c:when>
	<c:otherwise>
		<fmt:parseDate type="DATE" value="${reqStartDate}" var="startdate" pattern="yyyy-MM-dd" parseLocale="en_GB"/>
		<fmt:parseDate type="DATE" value="${reqEndDate}" var="enddate" pattern="yyyy-MM-dd" parseLocale="en_GB"/>
		<c:out value="${1+ ((enddate.time/86400000)-(startdate.time/86400000)) }" />
	</c:otherwise>
	</c:choose>
</c:set>
<sql:setDataSource dataSource="jdbc/aggregator"/>
<c:set var="duration"><fmt:formatNumber value="${duration}" type="number" /></c:set>

<c:choose>
<c:when test="${duration > 60.0 && multiTrip != 'Y'}">
	<c:set var="multiTripType" value="N" />
</c:when>
<c:otherwise>
	<c:set var="multiTripType" value="Y" />
</c:otherwise>
</c:choose>


<%-- check if R6 & R7 region products exist if duration is over 215 days and if so Get products that match the passed criteria  --%>
<c:choose>
	
	<c:when test="${duration >= 215.0 && (regionLow == 'R6' || regionLow == 'R7')}">
		<%-- Get products that match the passed criteria --%> 
		<sql:query var="resultLowRegion">
			SELECT
			a.ProductId,
			a.SequenceNo,
			a.propertyid,
			a.Value,
			b.longTitle,
			b.shortTitle,
			b.providerId
		
			FROM aggregator.travel_rates a 
			INNER JOIN aggregator.product_master b on a.ProductId = b.ProductId
			WHERE b.providerId = 6
       		AND a.propertyId = '${regionLow}-${type}'
			AND EXISTS (Select * from aggregator.travel_rates b where b.productid = a.productid and b.sequenceNo = a.sequenceNo and b.propertyid = 'durMin' and b.value <= ${duration})
			AND	EXISTS (Select * from aggregator.travel_rates b where b.productid = a.productid and b.sequenceNo = a.sequenceNo and b.propertyid = 'durMax' and b.value >= ${duration})	
			GROUP BY a.ProductId, a.SequenceNo
		</sql:query>
		
		<c:if test="${resultLowRegion.rowCount > '0'}">	
			<sql:query var="result">
			   SELECT
				a.ProductId,
				a.SequenceNo,
				a.propertyid,
				a.Value,
				b.productCat,
				b.longTitle,
				b.shortTitle,
				b.providerId
			
				FROM aggregator.travel_rates a 
				INNER JOIN aggregator.product_master b on a.ProductId = b.ProductId
				WHERE b.providerId = 6
				AND a.productId <> 22
				AND EXISTS (Select * from aggregator.travel_rates b where b.productid = a.productid and b.sequenceNo = a.sequenceNo and b.propertyid = 'durMin' and b.value <= ${duration})
				AND	EXISTS (Select * from aggregator.travel_rates b where b.productid = a.productid and b.sequenceNo = a.sequenceNo and b.propertyid = 'durMax' and b.value >= ${duration})
				AND	EXISTS (Select * from aggregator.travel_rates b where b.productid = a.productid and b.sequenceNo = a.sequenceNo and b.propertyid = 'ageMin' and b.value <= ${age})
				AND	EXISTS (Select * from aggregator.travel_rates b where b.productid = a.productid and b.sequenceNo = a.sequenceNo and b.propertyid = 'ageMax' and b.value >= ${age})
				AND	EXISTS (Select * from aggregator.travel_details b where b.productid = a.productid and b.propertyid = 'multiTrip' and b.text = '${multiTrip}' )	
				GROUP BY a.ProductId, a.SequenceNo
			</sql:query>
		</c:if>

	</c:when>
	<c:otherwise>
	
		<%-- Get products that match the passed criteria --%> 
		<sql:query var="result">
		   SELECT
			a.ProductId,
			a.SequenceNo,
			a.propertyid,
			a.Value,
			b.productCat,
			b.longTitle,
			b.shortTitle,
			b.providerId
		
			FROM aggregator.travel_rates a 
			INNER JOIN aggregator.product_master b on a.ProductId = b.ProductId
			WHERE b.providerId = 6
			AND EXISTS (Select * from aggregator.travel_rates b where b.productid = a.productid and b.sequenceNo = a.sequenceNo and b.propertyid = 'durMin' and b.value <= ${duration})
			AND	EXISTS (Select * from aggregator.travel_rates b where b.productid = a.productid and b.sequenceNo = a.sequenceNo and b.propertyid = 'durMax' and b.value >= ${duration})
			AND	EXISTS (Select * from aggregator.travel_rates b where b.productid = a.productid and b.sequenceNo = a.sequenceNo and b.propertyid = 'ageMin' and b.value <= ${age})
			AND	EXISTS (Select * from aggregator.travel_rates b where b.productid = a.productid and b.sequenceNo = a.sequenceNo and b.propertyid = 'ageMax' and b.value >= ${age})
			AND	EXISTS (Select * from aggregator.travel_details b where b.productid = a.productid and b.propertyid = 'multiTrip' and b.text = '${multiTrip}' )	
			GROUP BY a.ProductId, a.SequenceNo
		</sql:query>
	</c:otherwise>
</c:choose>




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
			AND a.propertyid = '${region}-${type}'
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
						FROM aggregator.travel_details a 
						JOIN aggregator.property_master b on a.propertyid = b.propertyid
						where a.productid = ${row.productid}
				</sql:query>

				
				<c:forEach var="info" items="${detail.rows}">
					
					<productInfo propertyId="${info.propertyid}">
						<label>${info.label}</label>
						<desc>${info.longlabel}</desc>
						<value>${info.value}</value>
						<c:choose>
							<c:when test="${info.propertyid == 'infoDes' && row.productId == '37'}">
								<text>${info.text} &lt;br&gt; &lt;br&gt; Cover is for Worldwide excluding USA, South and Central America and Antarctica if more than 72 hours of any one trip is to these destinations.</text>
							</c:when>
							<c:otherwise>
								<text>${info.text}</text>
							</c:otherwise>
						</c:choose>
						
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
 