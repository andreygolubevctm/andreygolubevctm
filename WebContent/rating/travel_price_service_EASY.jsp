<%@page import="java.util.Date"%>
<%@ page language="java" contentType="text/xml; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<sql:setDataSource dataSource="jdbc/aggregator"/>

<c:set var="providerId">6</c:set>

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

<c:set var="age">
	<x:out select="$travel/request/details/age" />
</c:set>
<c:set var="region">
	<x:out select="$travel/request/details/region" />
</c:set>
<c:set var="type">
	<x:out select="$travel/request/details/type" />
</c:set>
<c:set var="multiTrip">
	<x:out select="$travel/request/details/multiTrip" />
</c:set>
<c:set var="reqStartDate">
	<x:out select="$travel/request/details/startDate" />
</c:set>
<c:set var="reqEndDate">
	<x:out select="$travel/request/details/endDate" />
</c:set>
<c:set var="regionLow">
	<x:out select="$travel/request/details/regionLow" />
</c:set>

<%-- Calc the duration from the passed start/end dates --%>
<c:set var="duration">
	<c:choose>
		<c:when test="${multiTrip == 'Y'}">365</c:when>
	<c:otherwise>
			<fmt:parseDate type="DATE" value="${reqStartDate}" var="startdate"
				pattern="yyyy-MM-dd" parseLocale="en_GB" />
			<fmt:parseDate type="DATE" value="${reqEndDate}" var="enddate"
				pattern="yyyy-MM-dd" parseLocale="en_GB" />
			<fmt:parseNumber value="${((enddate.time/86400000)-(startdate.time/86400000)) + 1}" type="number" integerOnly="true" parseLocale="en_GB" />
	</c:otherwise>
	</c:choose>
</c:set>

<c:choose>
	<c:when test="${duration > 60.0 && multiTrip != 'Y'}">
	<c:set var="multiTripType" value="N" />
</c:when>
<c:otherwise>
	<c:set var="multiTripType" value="Y" />
</c:otherwise>
</c:choose>

<c:choose>
	<c:when test="${multiTrip == 'Y'}">
		<c:set var="priceId" value="R1-${type}" />
	</c:when>
	<c:otherwise>
<c:set var="priceId">${region}-${type}</c:set>
	</c:otherwise>
</c:choose>

<%-- check if R6 & R7 region products exist if duration is over 215 days and if so Get products that match the passed criteria  --%>
<c:choose>
	<c:when test="${duration >= 215.0 && (regionLow == 'R6' || regionLow == 'R7')}">
		<go:log>
			EASY duration >= 215.0 && (regionLow == 'R6' || regionLow == 'R7')
		</go:log>
		<%-- Get products that match the passed criteria --%> 
		<sql:query var="resultLowRegion">
			SELECT
			tr.ProductId,
			tr.SequenceNo
		
			FROM aggregator.travel_rates tr
			INNER JOIN aggregator.product_master pm on tr.ProductId = pm.ProductId
			WHERE pm.providerId = 6
			AND (
				tr.propertyid = ?
				OR
				(tr.propertyid = 'durMin' and tr.value <= ?)
				OR
				(tr.propertyid = 'durMax' and tr.value >= ?)
			)
			GROUP BY tr.ProductId, tr.sequenceNo
			HAVING count(*) = 3
			<sql:param>${region}-${type}</sql:param>
			<sql:param>${duration}</sql:param>
			<sql:param>${duration}</sql:param>
		</sql:query>
		
		<c:if test="${resultLowRegion.rowCount > '0'}">	
		<go:log>
			EASY resultLowRegion.rowCount > '0'
		</go:log>
	<sql:query var="resultRows">
			   SELECT
		tr.ProductId,
		tr.SequenceNo,
		tr.propertyid,
		tr.value,
		pm.productCat,
		pm.longTitle as des,
		pm.shortTitle,
		pm.providerId,
		provm.name as providerName,
		pr.value as premium,
		pr.text as premiumText
			
		FROM aggregator.travel_rates tr
			INNER JOIN aggregator.product_master pm on pm.ProductId = tr.ProductId
			INNER JOIN aggregator.travel_details td  on td.ProductId = tr.ProductId
			INNER JOIN aggregator.travel_rates pr on pr.ProductId = tr.ProductId
			INNER JOIN aggregator.provider_master provm on provm.providerId = pm.providerId
		WHERE pm.providerId = 6
			AND tr.productId <> 22
			AND td.propertyid = 'multiTrip' AND td.text = ?
			AND pr.propertyid = ? AND pr.sequenceNo = tr.sequenceNo
			AND((tr.propertyid = 'durMin' and tr.value <= ?)
			OR
				(tr.propertyid = 'durMax' and tr.value >= ?)
			OR
				(tr.propertyid = 'ageMin' and tr.value <= ?)
			OR
				(tr.propertyid = 'ageMax' and tr.value >= ?)
			)
			GROUP BY tr.ProductId, tr.SequenceNo
			having count(*) = 4
				<sql:param>${providerId}</sql:param>
				<sql:param>${multiTrip}</sql:param>
				<sql:param>${priceId}</sql:param>
				<sql:param>${duration}</sql:param>
				<sql:param>${duration}</sql:param>
				<sql:param>${age}</sql:param>
				<sql:param>${age}</sql:param>
			</sql:query>
		</c:if>
	</c:when>
	<c:otherwise>
		<%-- Get products that match the passed criteria --%> 
		<sql:query var="resultRows">
			SELECT
				pm.productCat as productCat,
				tr.ProductId,
				provm.name as providerName,
				tr.SequenceNo,
				tr.propertyid,
				tr.value,
				pm.longTitle as des,
				pm.shortTitle,
				pm.providerId,
				pr.value as premium,
				pr.text as premiumText
				FROM aggregator.travel_rates tr
				INNER JOIN aggregator.product_master pm on pm.ProductId = tr.ProductId
				INNER JOIN aggregator.travel_details td  on td.ProductId = tr.ProductId
				INNER JOIN aggregator.travel_rates pr on pr.ProductId = tr.ProductId
				INNER JOIN aggregator.provider_master provm on provm.providerId = pm.providerId
				WHERE pm.providerId = ? AND pr.sequenceNo = tr.sequenceNo
				AND td.propertyid = 'multiTrip' AND td.text = ?
				AND pr.propertyid = ?
				AND(
					(tr.propertyid = 'durMin' and tr.value <= ?)
						OR
					(tr.propertyid = 'durMax' and tr.value >= ?)
						OR
					(tr.propertyid = 'ageMin' and tr.value <= ?)
						OR
					(tr.propertyid = 'ageMax' and tr.value >= ?)
				)
				GROUP BY tr.ProductId, tr.SequenceNo, pr.value
				having count(*) = 4
			<sql:param>${providerId}</sql:param>
			<sql:param>${multiTrip}</sql:param>
			<sql:param>${priceId}</sql:param>
			<sql:param>${duration}</sql:param>
			<sql:param>${duration}</sql:param>
			<sql:param>${age}</sql:param>
			<sql:param>${age}</sql:param>
		</sql:query>
	</c:otherwise>
</c:choose>

<%-- Build the xml data for each row --%>
<results>
	<c:if test="${resultRows != null}">
		<c:forEach var="row" items="${resultRows.rows}">
			<result productId="${row.productCat}-${row.productid}">
				<provider>${row.provider}</provider>
				<name>${row.shortTitle}</name>
				<des>${row.des}</des>
				<premium>${row.premium}</premium>
				<premiumText>${row.premiumText}</premiumText>
			<sql:query var="details">
				SELECT
					b.label,
					b.longlabel as description,
					a.Value,
					a.benefitOrder,
					a.propertyid,
					a.Text
				FROM aggregator.travel_details a
				JOIN aggregator.property_master b on a.propertyid = b.propertyid
				WHERE a.productid = ?
				ORDER BY benefitOrder DESC
				<sql:param>${row.productid}</sql:param>
			</sql:query>
			<c:forEach var="info" items="${details.rows}">
					<c:set var="text" value="${info.text}" />
					<c:if test="${info.propertyid == 'infoDes' && row.productId == '37'}">
					<c:set var="text" value="${text} &lt;br&gt; &lt;br&gt; Cover is for
								Worldwide excluding USA, South and Central America and Antarctica
								if more than 72 hours of any one trip is to these destinations." />
					</c:if>
					<productInfo propertyId="${info.propertyid}">
						<label>${info.label}</label>
						<desc>${info.description}</desc>
						<value>${info.value}</value>
						<text>${text}</text>
						<order>${info.order}</order>
					</productInfo>
				</c:forEach>
	   		</result>
		</c:forEach>
	   	</c:if>
	<c:if test="result.rowCount == 0">
		<result> <provider></provider> <name></name> <des></des> <premium></premium>
		</result>		
	</c:if>
</results>
