<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%@ attribute name="healthXML" required="true" rtexprvalue="true" type="org.apache.xerces.dom.NodeImpl"	 description="quote data" %>
<%@ attribute name="transactionId" required="true" rtexprvalue="true"	 description="transactionId" %>
<%@ attribute name="resultsList" type="java.util.LinkedHashMap" required="true" rtexprvalue="true"	 description="recordset" %>
<%@ attribute name="healthPriceService" type="com.ctm.services.health.HealthPriceService" required="true" rtexprvalue="true"	 description="health price logic" %>

<%-- #WHITELABEL styleCodeID --%>
<c:set var="transactionId"><x:out select="$healthXML/request/header/partnerReference" /></c:set>
<c:set var="styleCodeId"><core:get_stylecode_id transactionId="${transactionId}" /></c:set>

<sql:setDataSource dataSource="jdbc/ctm"/>

<c:set var="providerId"><x:out select="$healthXML/request/header/providerId" /></c:set>
<c:if test="${providerId==''}">
	<c:set var="providerId">0</c:set>
</c:if>

<%-- FILTER: LEVEL OF COVER --%>
<c:set var="filterLevelOfCover">${healthPriceService.getFilterLevelOfCover()}</c:set>

<c:set var="productTitle"><x:out select="$healthXML/request/header/productTitle" escapeXml="false" /></c:set>

<%-- Unencode apostrophes --%>
<c:set var="productTitle" value="${fn:replace(productTitle, '&#039;', '\\'')}" />
<c:set var="productTitle" value="${fn:replace(productTitle, '&#39;', '\\'')}" />

<c:set var="preferences"><x:out select="$healthXML/request/details/preferences" escapeXml="false" /></c:set>
<%-- Not used
<c:set var="situation"><x:out select="$healthXML/request/details/situation" /></c:set>
<c:set var="rankcount"><x:out select="string-length($preferences)-string-length(translate($preferences,',',''))+1"/></c:set>
--%>

<%-- Setting the algorithm search date based on either the PostPrice expected date, the application start date or today's date --%>
<c:set var="searchDate">
	<x:choose>
		<x:when select="$healthXML/request/details/searchDate != ''">
			<c:set var="sdate"><x:out select="$healthXML/request/details/searchDate" /></c:set>
			<%-- If date sent through as DD/MM/YYYY, need to reorder to YYYY-MM-DD --%>
			<c:if test="${fn:substring(sdate,2,3) == '/'}">
				<c:set var="sdatesplit" value="${fn:split(sdate, '/')}" />
				<c:set var="sdate" value="${sdatesplit[2]}-${sdatesplit[1]}-${sdatesplit[0]}" />
			</c:if>
			<c:out value="${sdate}" />
		</x:when>
		<x:otherwise>
			<fmt:setLocale value="en_GB" scope="session" />
			<jsp:useBean id="now" class="java.util.GregorianCalendar" scope="page" />
			<fmt:formatDate value="${now.time}" pattern="yyyy-MM-dd" var="displayDate" />
			${displayDate}
		</x:otherwise>
	</x:choose>
</c:set>
<c:set var="cover"><x:out select="$healthXML/request/details/cover" /></c:set>
<c:set var="productType"><x:out select="$healthXML/request/details/productType" /></c:set>
<c:set var="excessSel"><x:out select="$healthXML/request/details/excess"/></c:set>

<c:set var="rebate"><x:out select="$healthXML/request/details/rebate" escapeXml="false" /></c:set>
<c:set var="loading"><x:out select="$healthXML/request/details/loading" escapeXml="false" /></c:set>

<c:set var="loadingPerc">
	<c:choose>
		<c:when test="${loading != ''}">${loading * 0.01}</c:when>
		<c:otherwise>0</c:otherwise>
	</c:choose>
</c:set>

<c:set var="fullProductId"><x:out select="$healthXML/request/header/productId" /></c:set>
<c:set var="productId">${fn:substringAfter(fullProductId, 'PHIO-HEALTH-')}</c:set>
<%-- Not used
<c:set var="showAll"><x:out select="$healthXML/request/header/showAll = 'Y'" /></c:set>
--%>
<c:set var="brandFilter"><x:out select="$healthXML/request/header/brandFilter" /></c:set>
<c:set var="onResultsPage"><x:out select="$healthXML/request/header/onResultsPage = 'Y'" /></c:set>

${healthPriceService.setSearchDate(searchDate)}
${healthPriceService.setMembership(cover)}
${healthPriceService.setProductType(productType)}
${healthPriceService.setExcessSel(excessSel)}
${healthPriceService.setRebate(rebate)}
${healthPriceService.setLoading(loading)}
${healthPriceService.setBrandFilter(brandFilter)}
${healthPriceService.setOnResultsPage(onResultsPage)}

<c:set var="healthPriceRequest" value="${healthPriceService.getHealthPriceRequest()}" />

<go:log level="INFO" source="health:price_service_fetch_product">${transactionId}: Fetching ProductId: ${productId}</go:log>

<%--
	Get products that match the passed criteria

	When searching for a single product ignore the product ID and use
	the title of the product. The same product with 2 pricing periods
	won't share the product ID but should always share the same name.
--%>
<sql:query var="result">
	SELECT results.* FROM
	(
		SELECT
			search.ProductId,
			product.longTitle,
			product.shortTitle,
			product.providerId,
			product.productCat,
			product.ProductCode,
			search.excessAmount,
			<c:choose>
				<c:when test="${!empty preferences}">
					(SELECT SUM(value) FROM ctm.product_properties m
						WHERE m.productid = search.productid
						AND m.propertyid COLLATE latin1_bin IN (${preferences})
					GROUP BY ProductID) AS rank,
				</c:when>
				<c:otherwise>0 AS rank, </c:otherwise>
			</c:choose>
			search.monthlyPremium + (search.monthlyLhc * ?) as factoredPrice

		FROM ctm.product_properties_search search
		INNER JOIN ctm.stylecode_products product ON search.ProductId = product.ProductId
		${filterLevelOfCover}
		WHERE
		(
			product.EffectiveStart <= ? AND product.EffectiveEnd >= ?
			AND product.Status NOT IN(${healthPriceRequest.getExcludeStatus()})
		)
		AND (product.ShortTitle=? OR product.LongTitle=?)
		AND (product.styleCodeId=?)
		AND (? = 0 OR product.providerId=?)
		AND product.providerId NOT IN(${healthPriceRequest.getExcludedProviders()})
		AND product.productCat = 'HEALTH'
		AND search.monthlyPremium >= ?
		AND search.state = ?
		AND search.membership = ?
		AND search.productType = ?
		<%-- When searching for a single product also force comparison of excess
			amount as insurance against multiple products with the same name (eg NIB).
			This may need to be expanded if it turns out that there are other
			properties needed to differentiate between common products.
		--%>
		AND search.excessAmount = (SELECT Value FROM ctm.product_properties WHERE ProductId = ${productId} AND PropertyId = 'excessAmount')
		AND (? = 'Both'  OR search.hospitalType = ? )
		GROUP BY search.ProductId
		ORDER BY rank DESC, factoredPrice ASC
		LIMIT 1) results
	GROUP by ProviderID
	ORDER BY rank DESC, factoredPrice asc
	LIMIT 1

		<sql:param value="${loadingPerc}" />
		<sql:param value="${healthPriceRequest.getSearchDate()}" />
		<sql:param value="${healthPriceRequest.getSearchDate()}" />

		<sql:param value="${productTitle}" />
		<sql:param value="${productTitle}" />
		<sql:param value="${styleCodeId}" />
		<sql:param value="${providerId}" />
		<sql:param value="${providerId}" />
		<sql:param value="${healthPriceRequest.getPriceMinimum()}" />

		<sql:param value="${healthPriceRequest.getState()}" />
		<sql:param value="${healthPriceRequest.getMembership()}" />
		<sql:param value="${healthPriceRequest.getProductType()}" />

		<sql:param value="${healthPriceRequest.getHospitalSelection()}" />
		<sql:param value="${healthPriceRequest.getHospitalSelection()}" />
</sql:query>

<c:if test="${ not empty result}">
	<c:forEach var="row" items="${result.rows}" varStatus="status">
		<c:set var="ignore">${resultsList.put(row.ProductId, row)}</c:set>
	</c:forEach>
</c:if>