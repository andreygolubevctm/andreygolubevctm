<%@page import="java.util.Date"%>
<%@ page language="java" contentType="text/xml; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:set var="providerId" >${param.providerId}</c:set>

<sql:setDataSource dataSource="jdbc/aggregator"/>

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
			<fmt:parseNumber value="${((enddate.time/86400000)-(startdate.time/86400000)) + 1}" type="number" integerOnly="true" parseLocale="en_GB" />
	</c:otherwise>
	</c:choose>
</c:set>

<%-- Check if the provider is valid. adding the ability to turn off provider through DB rather than using config file --%>
<sql:query var="validProvider">
	SELECT mast.ProviderId
	FROM ctm.provider_master AS mast
	WHERE mast.ProviderId = ?
	AND mast.Status = _latin1' '
	AND curdate() between mast.EffectiveStart and mast.EffectiveEnd
	<sql:param>${providerId}</sql:param>
</sql:query>

<%-- Should only have one provider with the passed criteria --%>
<c:if test="${validProvider.rowCount == 1}">
<%-- Get products that match the passed criteria --%> 
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

	FROM ctm.travel_rates a
	INNER JOIN ctm.product_master b on a.ProductId = b.ProductId
	WHERE b.providerId = ?
	AND EXISTS (Select * from ctm.travel_rates b where b.productid = a.productid and b.sequenceNo = a.sequenceNo and b.propertyid = 'durMin' and b.value <= ?)
	AND	EXISTS (Select * from ctm.travel_rates b where b.productid = a.productid and b.sequenceNo = a.sequenceNo and b.propertyid = 'durMax' and b.value >= ?)
	AND	EXISTS (Select * from ctm.travel_rates b where b.productid = a.productid and b.sequenceNo = a.sequenceNo and b.propertyid = 'ageMin' and b.value <= ?)
	AND	EXISTS (Select * from ctm.travel_rates b where b.productid = a.productid and b.sequenceNo = a.sequenceNo and b.propertyid = 'ageMax' and b.value >= ?)
	AND	EXISTS (Select * from ctm.travel_details b where b.productid = a.productid and b.propertyid = 'multiTrip' and b.text = ? )
	GROUP BY a.ProductId, a.SequenceNo
	<sql:param>${providerId}</sql:param>
	<sql:param>${duration}</sql:param>
	<sql:param>${duration}</sql:param>
	<sql:param>${age}</sql:param>
	<sql:param>${age}</sql:param>
	<sql:param>${multiTrip}</sql:param>
</sql:query>
    

<%-- Build the xml data for each row --%>
<results>
	<c:forEach var="row" items="${result.rows}">
		<sql:query var="premium">
			SELECT
				a.propertyid,
				a.value,
				a.text
			FROM ctm.travel_rates a
			WHERE a.productid = ?
			AND a.sequenceNo = ?
			AND a.propertyid = ?
			<sql:param>${row.productid}</sql:param>
			<sql:param>${row.sequenceno}</sql:param>
			<sql:param>${region}-${type}</sql:param>
		</sql:query>

		<c:if test="${premium.rowCount != 0}">
			<c:set var="price" value="${premium.rows[0]}" />

			<sql:query var="provider">
				SELECT Name
				FROM ctm.provider_master
				WHERE providerId = ${row.providerId}
			</sql:query>

			<result productId="${row.productCat}-${row.productid}">
				<provider>${provider.rows[0].name}</provider>
				<name>${row.shorttitle}</name>
				<des>${row.longtitle}</des>
				<premium>${price.value}</premium>
				<premiumText>${price.text}</premiumText>
				<duration>${duration}</duration>

				<sql:query var="detail">
				SELECT
					b.label,
					b.longlabel as description,
					a.Value,
					a.propertyid,
					a.Text
					FROM ctm.travel_details a
					JOIN ctm.property_master b on a.propertyid = b.propertyid
						where a.productid = ${row.productid}
			</sql:query>
				<c:forEach var="info" items="${detail.rows}">
					<productInfo propertyId="${info.propertyid}">
						<label>${info.label}</label>
						<desc>${info.description}</desc>
						<value>${info.value}</value>
						<text>${info.text}</text>
						<order/> <%-- Benefits are now displaying in Alphabetical order --%>
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

</c:if>