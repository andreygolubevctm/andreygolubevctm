<%@page import="java.util.Date"%>
<%@ page language="java" contentType="text/xml; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<sql:setDataSource dataSource="jdbc/aggregator"/>
<c:set var="providerId" >25</c:set>
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
<c:set var="children"><x:out select="$travel/request/details/children" /></c:set>

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

<c:set var="priceId" value="${region}-${type}" />

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

<go:log>SQL QUERY: ${resultRows}</go:log>


<%-- Build the xml data for each row --%>
<results>
	<c:forEach var="row" items="${resultRows.rows}">
		<result productId="${row.productCat}-${row.productid}">
				<provider>${row.providerName}</provider>
				<name>${row.shortTitle}</name>
				<des>${row.des}</des>

				<c:choose>
					<c:when test="${type == 'SIN' && children > '0' && row.productId == '162'}">
						<c:set var="newPrice" value="${row.premium * 2}" />
						<fmt:setLocale value="en_US"/>
						<premium>${newPrice}</premium>
						<premiumText><fmt:formatNumber value="${newPrice}" type="currency" /></premiumText>
					</c:when>
					<c:when test="${type == 'SIN' && children > '0' && row.productId == '163'}">
						<c:set var="newPrice" value="${row.premium * 2}" />
						<fmt:setLocale value="en_US"/>
						<premium>${newPrice}</premium>
						<premiumText><fmt:formatNumber value="${newPrice}" type="currency" /></premiumText>
					</c:when>
					<c:when test="${multiTrip != 'Y' && type == 'SIN' && children > '0'}">
						<c:set var="newPrice" value="${row.premium +(row.premium/2 * children)}" />
						<fmt:setLocale value="en_US"/>
						<premium>${newPrice}</premium>
						<premiumText><fmt:formatNumber value="${newPrice}" type="currency" /></premiumText>
					</c:when>
					<c:otherwise>
						<premium>${row.premium}</premium>
						<premiumText>${row.premiumText}</premiumText>
					</c:otherwise>
				</c:choose>

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
					<productInfo propertyId="${info.propertyid}">
						<label>${info.label}</label>
						<c:choose>
							<c:when test="${info.label == 'Overseas Medical' && row.productid == 164}"><desc>Medical Expenses Onboard a Ship</desc></c:when>
							<c:otherwise><desc>${info.description}</desc></c:otherwise>
						</c:choose>
						<value>${info.value}</value>
						<text>${info.text}</text>
					</productInfo>
				</c:forEach>

		</result>
	</c:forEach>
	<c:if test="${result.rowCount == 0}">
		<result>
				<provider></provider>
				<name></name>
				<des></des>
				<premium></premium>
		</result>
	</c:if>
</results>
