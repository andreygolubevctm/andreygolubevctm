<%@ tag description="The price retrieval page" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%@ attribute name="providerId" 	required="true"	 rtexprvalue="true"	 description="The travel partner ID" %>
<%@ attribute name="age" 	required="true"	 rtexprvalue="true"	 description="The duration of the trip" %>
<%@ attribute name="region" 	required="true"	 rtexprvalue="true"	 description="The duration of the trip" %>
<%@ attribute name="type" 	required="true"	 rtexprvalue="true"	 description="The duration of the trip" %>
<%@ attribute name="multiTrip" 	required="true"	 rtexprvalue="true"	 description="The duration of the trip" %>
<%@ attribute name="duration" 	required="true"	 rtexprvalue="true"	 description="The duration of the trip" %>
<%@ attribute name="styleCodeId" 	required="true"	 rtexprvalue="true"	 description="The duration of the trip" %>
<%@ attribute name="productIds" 	required="false"	 rtexprvalue="true"	 description="The duration of the trip" %>

<c:set var="verticalId" value="2" />
<c:set var="productIdArray" value="" />

<sql:setDataSource dataSource="jdbc/ctm"/>

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

<%-- Check if the provider is valid. adding the ability to turn off provider through DB rather than using config file --%>
<sql:query var="validProvider">
	SELECT mast.ProviderId
	FROM ctm.stylecode_providers AS mast
	WHERE mast.styleCodeId = ?
	AND mast.verticalId = ?
	AND mast.ProviderId = ?
	AND mast.Status = _latin1' '
	AND curdate() between mast.EffectiveStart and mast.EffectiveEnd
	<sql:param>${styleCodeId}</sql:param>
	<sql:param>${verticalId}</sql:param>
	<sql:param>${providerId}</sql:param>
</sql:query>

<%-- Should only have one provider with the passed criteria --%>
<c:if test="${validProvider.rowCount == 1}">
	<c:if test="${not empty productIds}" >
		<c:set var="productIdArray" value="${fn:split(productIds,',')}" />
	</c:if>
	<%-- Get products that match the passed criteria --%>

	<%-- StyleCode is referenced once in the parent travel_rates to knockout disabled products --%>
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
		INNER JOIN ctm.stylecode_products b on a.ProductId = b.ProductId
		WHERE b.styleCodeId = ?
		AND b.providerId = ?
		<c:if test="${not empty productIds}" >
			<c:set var="delimeter" value="" />
		AND b.ProductId IN (
			<c:forEach items="${productIdArray}" varStatus="loop"> 
				${delimeter}?
				<c:set var="delimeter" value="," />
			</c:forEach>
		)
		</c:if>
		AND EXISTS (Select * from ctm.travel_rates b where b.productid = a.productid and b.sequenceNo = a.sequenceNo and b.propertyid = 'durMin' and b.value <= ?)
		AND	EXISTS (Select * from ctm.travel_rates b where b.productid = a.productid and b.sequenceNo = a.sequenceNo and b.propertyid = 'durMax' and b.value >= ?)
		AND	EXISTS (Select * from ctm.travel_rates b where b.productid = a.productid and b.sequenceNo = a.sequenceNo and b.propertyid = 'ageMin' and b.value <= ?)
		AND	EXISTS (Select * from ctm.travel_rates b where b.productid = a.productid and b.sequenceNo = a.sequenceNo and b.propertyid = 'ageMax' and b.value >= ?)
		AND	EXISTS (Select * from ctm.travel_details b where b.productid = a.productid and b.propertyid = 'multiTrip' and b.text = ? )
		GROUP BY b.ProductId, a.SequenceNo
		<sql:param>${styleCodeId}</sql:param>
		<sql:param>${providerId}</sql:param>
		<c:if test="${not empty productIds}" >
			<c:forEach items="${productIdArray}" varStatus="loop"> 
				<sql:param>${productIdArray[loop.index]}</sql:param>
			</c:forEach>
		</c:if>
		<sql:param>${duration}</sql:param>
		<sql:param>${duration}</sql:param>
		<sql:param>${age}</sql:param>
		<sql:param>${age}</sql:param>
		<sql:param>${multiTrip}</sql:param>
		
	</sql:query>

	<%-- Build the xml data for each row --%>
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


				<%-- StyleCode is referenced once in the parent travel_details to knockout disabled products --%>
				<sql:query var="detail">
					SELECT
						b.label,
						b.longlabel as description,
						a.Value,
						a.propertyid,
						a.Text
						FROM ctm.travel_details a
						JOIN ctm.property_master b on a.propertyid = b.propertyid
						WHERE a.productid = ?
					<sql:param>${row.productid}</sql:param>
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
</c:if>