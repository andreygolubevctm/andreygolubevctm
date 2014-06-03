<%@page import="java.util.Date"%>
<%@ page language="java" contentType="text/xml; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<x:parse var="health" xml="${param.QuoteData}" />
<go:log source="health_price_service_PHIO_jsp" level="DEBUG">QuoteData: ${param.QuoteData}</go:log>

<c:set var="transactionId"><x:out select="$health/request/header/partnerReference" /></c:set>
<c:set var="styleCodeId"><core:get_stylecode_id transactionId="${transactionId}" /></c:set>

<c:set var="isSimples"><x:out select="$health/request/header/isSimples = 'Y'" escapeXml="false"/></c:set>

<sql:setDataSource dataSource="jdbc/ctm"/>

<c:set var="providerId"><x:out select="$health/request/header/providerId" /></c:set>
<c:set var="pricesHaveChanged" value="false" />
<c:if test="${providerId==''}">
	<c:set var="providerId">0</c:set>
</c:if>

<%-- FILTERS --%>
<c:set var="brandFilter"><x:out select="$health/request/header/brandFilter" /></c:set>
<c:set var="excludeStatus"><x:out select="$health/request/header/excludeStatus" escapeXml="false"/></c:set>
<c:set var="onResultsPage"><x:out select="$health/request/header/onResultsPage = 'Y'" /></c:set>
<c:set var="priceMinimum">
	<x:choose>
		<x:when select="$health/request/header/onResultsPage = 'Y'"><x:out select="$health/request/header/priceMinimum" /></x:when>
		<x:otherwise>0</x:otherwise>
	</x:choose>
</c:set>

<%-- FILTER: LEVEL OF COVER --%>
<c:set var="tierHospital"><x:out select="$health/request/header/filter/tierHospital" /></c:set>
<c:set var="tierExtras"><x:out select="$health/request/header/filter/tierExtras" /></c:set>
	<%-- Validate values to prevent SQL injection --%>
	<c:if test="${tierHospital != '0' and tierHospital != '1' and tierHospital != '2' and tierHospital != '3' and tierHospital != '4'}"><c:set var="tierHospital" value="" /></c:if>
	<c:if test="${tierExtras != '0' and tierExtras != '1' and tierExtras != '2' and tierExtras != '3'}"><c:set var="tierExtras" value="" /></c:if>
	<c:set var="filterLevelOfCover">
		<c:if test="${not empty tierHospital and tierHospital != '0'}">
			INNER JOIN ctm.product_properties locPP ON search.ProductId = locPP.ProductId AND locPP.PropertyId = 'TierHospital' AND locPP.SequenceNo = 0
			AND locPP.Value >= ${tierHospital}
		</c:if>
		<c:if test="${not empty tierExtras and tierExtras != '0'}">
			INNER JOIN ctm.product_properties locPPe ON search.ProductId = locPPe.ProductId AND locPPe.PropertyId = 'TierExtras' AND locPPe.SequenceNo = 0
			AND locPPe.Value >= ${tierExtras}
		</c:if>
	</c:set>

<%-- Setting the algorithm search date based on either the PostPrice expected date, the application start date or today's date --%>
<c:set var="searchDate">
	<x:choose>
		<x:when select="$health/request/details/searchDate != ''">
			<c:set var="sdate"><x:out select="$health/request/details/searchDate" /></c:set>
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

<c:set var="searchResults">
	<x:choose>
		<x:when select="$health/request/details/searchResults != ''">
			<x:out select="$health/request/details/searchResults" />
		</x:when>
		<x:otherwise>12</x:otherwise>
	</x:choose>
</c:set>

<c:set var="showAll"><x:out select="$health/request/header/showAll = 'Y'" /></c:set>

<go:log source="health_price_service_PHIO_jsp">SearchResults = ${searchResults}</go:log>

<c:set var="selectedProductId">
	<x:out select="$health/request/header/productId" />
</c:set>
<c:if test="${fn:startsWith(selectedProductId, 'PHIO-HEALTH-') and fn:length(selectedProductId) > 12}">
	<c:set var="selectedProductId" value="${fn:substringAfter(selectedProductId, 'PHIO-HEALTH-')}" />
</c:if>

<c:set var="fullProductId">
	<c:choose>
		<c:when test="${showAll}">0</c:when>
		<c:otherwise>
			<x:out select="$health/request/header/productId" />
		</c:otherwise>
	</c:choose>
</c:set>

<c:set var="productId">
	<c:choose>
		<c:when test="${fn:startsWith(fullProductId, 'PHIO-HEALTH-') and fn:length(fullProductId) > 12}">
			${fn:substringAfter(fullProductId, 'PHIO-HEALTH-')}
		</c:when>
		<c:otherwise>0</c:otherwise>
	</c:choose>
</c:set>

<c:set var="productTitle">
	<x:choose>
		<x:when select="$health/request/header/showAll = 'Y'">0</x:when>
		<x:otherwise>
			<x:out select="$health/request/header/productTitle" escapeXml="false" />
		</x:otherwise>
	</x:choose>
</c:set>
<%-- Unencode apostrophes --%>
<c:set var="productTitle" value="${fn:replace(productTitle, '&#039;', '\\'')}" />
<c:set var="productTitle" value="${fn:replace(productTitle, '&#39;', '\\'')}" />

<%-- When searching for a single product also force comparison of excess
	amount as insurance against multiple products with the same name (eg NIB).
	This may need to be expanded if it turns out that there are other
	properties needed to differentiate between common products.
--%>
<c:set var="searchExcessAlso">
	<x:choose>
		<x:when select="$health/request/header/showAll = 'N'">
			search.excessAmount = (SELECT Value FROM ctm.product_properties WHERE ProductId = ${productId} AND PropertyId = 'excessAmount')
		</x:when>
		<x:otherwise>
			0 = 0
		</x:otherwise>
	</x:choose>
</c:set>

<c:set var="situation"><x:out select="$health/request/details/situation" /></c:set>
<c:set var="cover"><x:out select="$health/request/details/cover" /></c:set>
<c:set var="preferences"><x:out select="$health/request/details/preferences" escapeXml="false" /></c:set>
<c:set var="rankcount"><x:out select="string-length($preferences)-string-length(translate($preferences,',',''))+1"/></c:set>

<c:set var="loading"><x:out select="$health/request/details/loading" escapeXml="false" /></c:set>
<c:set var="rebate"><x:out select="$health/request/details/rebate" escapeXml="false" /></c:set>
<c:set var="state"><x:out select="$health/request/details/state" /></c:set>
<c:set var="productType"><x:out select="$health/request/details/productType" /></c:set>

<c:set var="excessSel"><x:out select="$health/request/details/excess"/></c:set>

<c:set var="prHospital"><x:out select="$health/request/details/prHospital" /></c:set>
<c:set var="puHospital"><x:out select="$health/request/details/puHospital" /></c:set>

<c:set var="hospitalSelection">
<c:choose>
<c:when test="${productType =='GeneralHealth'}">Both</c:when>
		<c:when test="${prHospital != 'Y' and puHospital  != 'Y'}">
			<c:choose>
				<%-- Show both Public/Private because user selected 'Public' tier --%>
				<c:when test="${tierHospital == '1'}">Both</c:when>
				<%-- If user chooses neither Public nor Private, business decision is to show Private (i.e. hide Public products) --%>
				<c:otherwise>PrivateHospital</c:otherwise>
			</c:choose>
		</c:when>
<c:when test="${prHospital == 'Y'}">PrivateHospital</c:when>
<c:when test="${puHospital == 'Y' }">Both</c:when>
<c:otherwise>Both</c:otherwise>
</c:choose>
</c:set>

<c:choose>
<c:when test="${productType =='GeneralHealth'}">
	<c:set var="excessMin">0</c:set>
	<c:set var="excessMax">99999</c:set>
</c:when>
<c:when test="${excessSel=='1'}">
	<c:set var="excessMin">0</c:set>
	<c:set var="excessMax">0</c:set>
</c:when>
<c:when test="${excessSel=='2'}">
	<c:set var="excessMin">1</c:set>
	<c:set var="excessMax">250</c:set>
</c:when>
<c:when test="${excessSel=='3'}">
	<c:set var="excessMin">251</c:set>
	<c:set var="excessMax">500</c:set>
</c:when>
<c:otherwise>
	<c:set var="excessMin">0</c:set>
	<c:set var="excessMax">99999</c:set>
</c:otherwise>
</c:choose>

<c:set var="membership">
	<c:choose>
		<c:when test="${cover == 'C'}">C</c:when>
		<c:when test="${cover == 'SPF'}">SP</c:when>
		<c:when test="${cover == 'F'}">F</c:when>
		<c:when test="${cover == 'S'}">S</c:when>
	</c:choose>
</c:set>
<c:set var="loadingPerc">
	<c:choose>
		<c:when test="${loading != ''}">${loading * 0.01}</c:when>
		<c:otherwise>0</c:otherwise>
	</c:choose>
</c:set>

<go:log source="health_price_service_PHIO_jsp">ProviderId: ${providerId}</go:log>
<go:log source="health_price_service_PHIO_jsp">ProductId: ${productId}</go:log>
<go:log source="health_price_service_PHIO_jsp">ProductTitle: ${productTitle}</go:log>
<go:log source="health_price_service_PHIO_jsp">ProductType: ${productType}</go:log>
<go:log source="health_price_service_PHIO_jsp">LoadingPerc: ${loadingPerc}</go:log>

<%-- Get products that match the passed criteria --%>

<c:set var="resultCount" value="0"/>

<%-- When searching for a single product ignore the product ID and use
	the title of the product. The same product with 2 pricing periods
	won't share the product ID but should always share the same name.
--%>
<c:set var="searchProductIdOrProductTitle">
	<c:choose>
		<c:when test="${showAll}">
			${productId} = 0 OR product.productId=${productId}
		</c:when>
		<c:otherwise>
			product.ShortTitle='${fn:replace(productTitle, "'", "''")}' OR product.LongTitle='${fn:replace(productTitle, "'", "''")}'
		</c:otherwise>
	</c:choose>
</c:set>

<c:set var="algorithm" value="2"/>
<c:set var="exclude" value=""/> 
<c:set var="exclude2" value=""/> 



<jsp:useBean id="healthPriceService" class="com.ctm.services.health.HealthPriceService" scope="page" />
${healthPriceService.setState(state)}
${healthPriceService.setTransactionId(transactionId)}
${healthPriceService.setBrandFilter(brandFilter)}
${healthPriceService.setOnResultsPage(onResultsPage)}

<c:set var="healthPriceRequest" value="${healthPriceService.getHealthPriceRequest()}" />

<go:log source="health_price_service_PHIO_jsp">ALGORITHM: ${algorithm}</go:log>
<go:log source="health_price_service_PHIO_jsp" level="DEBUG">Excluded providers: ${healthPriceRequest.getExcludedProviders()}</go:log>

<c:if test="${algorithm == '2' && resultCount < searchResults}">

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
		(product.EffectiveStart <= ? AND product.EffectiveEnd >= ? AND product.Status NOT IN(${excludeStatus}))
	AND (${searchProductIdOrProductTitle})
		AND (product.styleCodeId=?)
	AND (? = 0 OR product.providerId=?)
		AND product.providerId NOT IN(${healthPriceRequest.getExcludedProviders()})
	AND product.productCat = 'HEALTH'
			AND search.monthlyPremium >= ?
	AND search.state = ?
	AND search.membership = ?
	AND search.productType = ?
	AND search.excessAmount >= ? and search.excessAmount <=  ?
	AND ${searchExcessAlso}
	AND (? = 'Both'  OR search.hospitalType = ? )
	GROUP BY search.ProductId
		ORDER BY rank DESC, factoredPrice ASC
			LIMIT 120) results
	GROUP by ProviderID
	ORDER BY rank DESC, factoredPrice asc
	LIMIT 4
	
	<sql:param value="${loadingPerc}" />
	<sql:param value="${searchDate}" />
	<sql:param value="${searchDate}" />

		<sql:param value="${styleCodeId}" />
	<sql:param value="${providerId}" />
	<sql:param value="${providerId}" />
		<sql:param value="${priceMinimum}" />

	<sql:param value="${state}" />
	<sql:param value="${membership}" />
	<sql:param value="${productType}" />

	<sql:param value="${excessMin}" />
	<sql:param value="${excessMax}" />

	<sql:param value="${hospitalSelection}" />
	<sql:param value="${hospitalSelection}" />
</sql:query>

	<c:forEach var="row" items="${result.rows}">
		<c:set var="exclude" value="${row.ProductId},${exclude}"/> 
	</c:forEach>

	<c:set var="resultCount" value="${resultCount + result.rowCount}"/> 

	<sql:query var="result1">
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
		(product.EffectiveStart <= ? AND product.EffectiveEnd >= ? AND product.Status NOT IN(${excludeStatus}))
			AND (${searchProductIdOrProductTitle})
		AND (product.styleCodeId=?)
			AND (? = 0 OR product.providerId=?)
		AND product.providerId NOT IN(${healthPriceRequest.getExcludedProviders()})
			AND product.productCat = 'HEALTH'
			AND search.monthlyPremium >= ?
			AND search.state = ?
			AND search.membership = ?
			AND search.productType = ?
			AND search.excessAmount >= ? and search.excessAmount <=  ?
			AND ${searchExcessAlso}
			AND (? = 'Both'  OR search.hospitalType = ? )
			AND search.ProductId NOT IN (${exclude}0)
			GROUP BY search.ProductId
		ORDER BY rank DESC, factoredPrice ASC
			LIMIT 120) results
	GROUP by ProviderID
	ORDER BY rank DESC, factoredPrice ASC
	LIMIT ${searchResults - 4}
	
		<sql:param value="${loadingPerc}" />
		<sql:param value="${searchDate}" />
		<sql:param value="${searchDate}" />
	
		<sql:param value="${styleCodeId}" />
		<sql:param value="${providerId}" />
		<sql:param value="${providerId}" />
		<sql:param value="${priceMinimum}" />
	
		<sql:param value="${state}" />
		<sql:param value="${membership}" />
		<sql:param value="${productType}" />
	
		<sql:param value="${excessMin}" />
		<sql:param value="${excessMax}" />
	
		<sql:param value="${hospitalSelection}" />
		<sql:param value="${hospitalSelection}" />
		</sql:query>

	<c:set var="exclude2" value="${exclude}"/> 
	<c:forEach var="row" items="${result1.rows}">
		<c:set var="exclude2" value="${row.ProductId},${exclude2}"/> 
	</c:forEach>


	<sql:query var="result2">
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
		(product.EffectiveStart <= ? AND product.EffectiveEnd >= ? AND product.Status NOT IN(${excludeStatus}))
			AND (${searchProductIdOrProductTitle})
		AND (product.styleCodeId=?)
			AND (? = 0 OR product.providerId=?)
		AND product.providerId NOT IN(${healthPriceRequest.getExcludedProviders()})
			AND product.productCat = 'HEALTH'
			AND search.monthlyPremium >= ?
			AND search.state = ?
			AND search.membership = ?
			AND search.productType = ?
			AND search.excessAmount >= ? and search.excessAmount <=  ?
			AND ${searchExcessAlso}
			AND (? = 'Both'  OR search.hospitalType = ? )
			AND search.ProductId NOT IN (${exclude}0)
			GROUP BY search.ProductId
		ORDER BY rank DESC, factoredPrice ASC
			LIMIT 120) results
	GROUP by ProviderID

	UNION

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
		(product.EffectiveStart <= ? AND product.EffectiveEnd >= ? AND product.Status NOT IN(${excludeStatus}))
			AND (${searchProductIdOrProductTitle})
		AND (product.styleCodeId=?)
			AND (? = 0 OR product.providerId=?)
		AND product.providerId NOT IN(${healthPriceRequest.getExcludedProviders()})
					AND product.productCat = 'HEALTH'
			AND search.monthlyPremium >= ?
					AND search.state = ?
					AND search.membership = ?
					AND search.productType = ?
			AND search.excessAmount >= ? and search.excessAmount <=  ?
			AND ${searchExcessAlso}
					AND (? = 'Both' OR search.hospitalType = ? )
			AND search.ProductId NOT IN (${exclude2}0)
					GROUP BY search.ProductId
		ORDER BY rank DESC, factoredPrice ASC
			LIMIT 120) results
	GROUP by ProviderID
	
	ORDER BY rank DESC, factoredPrice ASC
	LIMIT <c:out value="${searchResults - resultCount}"/>
	
		<sql:param value="${loadingPerc}" />
						<sql:param value="${searchDate}" />
						<sql:param value="${searchDate}" />
	
		<sql:param value="${styleCodeId}" />
		<sql:param value="${providerId}" />
		<sql:param value="${providerId}" />
		<sql:param value="${priceMinimum}" />
	
						<sql:param value="${state}" />
						<sql:param value="${membership}" />
						<sql:param value="${productType}" />
	
						<sql:param value="${excessMin}" />
						<sql:param value="${excessMax}" />

						<sql:param value="${hospitalSelection}" />
						<sql:param value="${hospitalSelection}" />

		<sql:param value="${loadingPerc}" />
		<sql:param value="${searchDate}" />
		<sql:param value="${searchDate}" />
	
		<sql:param value="${styleCodeId}" />
		<sql:param value="${providerId}" />
		<sql:param value="${providerId}" />
		<sql:param value="${priceMinimum}" />
	
		<sql:param value="${state}" />
		<sql:param value="${membership}" />
		<sql:param value="${productType}" />
	
		<sql:param value="${excessMin}" />
		<sql:param value="${excessMax}" />

		<sql:param value="${hospitalSelection}" />
		<sql:param value="${hospitalSelection}" />
					</sql:query>

	<c:set var="exclude2" value="${exclude}"/> 
	<c:forEach var="row" items="${result2.rows}">
		<c:set var="exclude2" value="${row.ProductId},${exclude2}"/> 
					</c:forEach>

	<c:set var="resultCount" value="${resultCount + result2.rowCount}"/> 

	<go:log source="health_price_service_PHIO_jsp">RESULTCOUNT V2: ${resultCount}</go:log>
				</c:if>

<c:if test="${resultCount < searchResults}">
	<go:log source="health_price_service_PHIO_jsp">RESULTCOUNT PRE V1: ${resultCount}</go:log>

	<sql:query var="result3">
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
		(product.EffectiveStart <= ? AND product.EffectiveEnd >= ? AND product.Status NOT IN(${excludeStatus}))
		AND (${searchProductIdOrProductTitle})
		AND (product.styleCodeId=?)
		AND (? = 0 OR product.providerId=?)
		AND product.providerId NOT IN(${healthPriceRequest.getExcludedProviders()})
		AND product.productCat = 'HEALTH'
		AND search.monthlyPremium >= ?
		AND search.state = ?
		AND search.membership = ?
		AND search.productType = ?
		AND search.excessAmount >= ? and search.excessAmount <=  ?
		AND ${searchExcessAlso}
		AND (? = 'Both'  OR search.hospitalType = ? )
		<c:if test="${!empty exclude2}">
		AND search.ProductId NOT IN (${exclude2}0)
		</c:if>
		GROUP BY search.ProductId
		ORDER BY rank DESC, factoredPrice ASC
		LIMIT <c:out value="${searchResults - resultCount}"/>
	
		<sql:param value="${loadingPerc}" />
		<sql:param value="${searchDate}" />
		<sql:param value="${searchDate}" />
	
		<sql:param value="${styleCodeId}" />
		<sql:param value="${providerId}" />
		<sql:param value="${providerId}" />
		<sql:param value="${priceMinimum}" />
	
		<sql:param value="${state}" />
		<sql:param value="${membership}" />
		<sql:param value="${productType}" />
	
		<sql:param value="${excessMin}" />
		<sql:param value="${excessMax}" />
	
		<sql:param value="${hospitalSelection}" />
		<sql:param value="${hospitalSelection}" />
				</sql:query>

		</c:if>

<jsp:useBean id="resultsList" class="java.util.LinkedHashMap" scope="request" />

<c:if test="${algorithm == '2' && not empty result}">
	<c:forEach var="result" items="${result.rows}" varStatus="status">
		<c:set var="ignore">${resultsList.put(result.ProductId, result)}</c:set>
	</c:forEach>

		<c:if test="${not empty result2}">
			<c:forEach var="result" items="${result2.rows}" varStatus="status">
				<c:set var="ignore">${resultsList.put(result.ProductId, result)}</c:set>
			</c:forEach>
		</c:if>
</c:if>
<c:if test="${resultCount < searchResults}">
	<c:set var="resultCount" value="${resultCount + result3.rowCount}"/>
	<c:forEach var="result" items="${result3.rows}" varStatus="status">
		<c:set var="ignore">${resultsList.put(result.ProductId, result)}</c:set>
	</c:forEach>
</c:if>
	

<c:set var="retrieveSavedResults"><x:out select="$health/request/header/retrieve/SavedResults = 'Y'" /></c:set>
<c:if test="${retrieveSavedResults && showAll}">
	<jsp:useBean id="savedResultsMap" class="java.util.LinkedHashMap" scope="request" />
	<jsp:useBean id="savedResultsToAddMap" class="java.util.LinkedHashMap" scope="request" />
	<c:set var="savedTransactionId"><x:out select="$health/request/header/retrieve/transactionId" /></c:set>
	<sql:query var="savedResults" dataSource="jdbc/ctm">
		SELECT
			product.ProductId,
			product.longTitle,
			product.shortTitle,
			product.providerId,
			product.productCat,
			product.ProductCode,
			search.excessAmount,
			(SELECT SUM(value) FROM ctm.product_properties m
								WHERE m.productid = search.productid
						GROUP BY ProductID) AS newRank,
			rd.RankPosition,
			search.monthlyPremium + (search.monthlyLhc * 10) as factoredPrice,

			(product.EffectiveStart <= ? AND product.EffectiveEnd >= ?
					AND product.Status NOT IN(${excludeStatus})) as isValid
			FROM ctm.product_properties_search search
			INNER JOIN ctm.stylecode_products product
				ON search.ProductId = product.ProductId
			INNER JOIN aggregator.ranking_details rd
				ON (rd.Property = 'productid' AND product.ProductId = rd.Value)
			WHERE rd.TransactionId = ?
		ORDER BY rd.RankPosition asc
		<sql:param value="${searchDate}" />
		<sql:param value="${searchDate}" />
		<sql:param value="${styleCodeId}" />
		<sql:param value="${savedTransactionId}" />
	</sql:query>
	<c:forEach var="result" items="${savedResults.rows}" varStatus="status">
		<c:set var="ignoreMe">${savedResultsMap.put(result.ProductId, result)}</c:set>
		<c:if test="${result.isValid == 0}" >
			<c:set var="pricesHaveChanged" value="true" />
	</c:if>
		<c:if test="${result.isValid == 1 && !resultsList.containsKey(result.ProductId) && status.count <= searchResults}" >
			<c:set var="pricesHaveChanged" value="true" />
			<c:set var="ignoreMe">${savedResultsToAddMap.put(result.ProductId, result)}</c:set>
		</c:if>
	</c:forEach>

	<%--Add any saved results that have not been loaded in search replacing the lowest rankings--%>
	<c:forEach var="savedResultsToAddRow" items="${savedResultsToAddMap}">
		<c:set var="lastRanking" value="" />
		<c:forEach var="returnedResultsRow" items="${resultsList}">
			<c:if test="${!savedResultsMap.containsKey(returnedResultsRow.key)}">
				<c:set var="lastRanking" value="${returnedResultsRow.key}" />
			</c:if>
		</c:forEach>
		<c:if test="${not empty lastRanking}">
			<c:set var="ignoreMe">
				${resultsList.remove(lastRanking)}
				${resultsList.put(savedResultsToAddRow.key, savedResultsToAddRow.value)}
			</c:set>
		</c:if>
	</c:forEach>
</c:if>

<go:log source="health_price_service_PHIO_jsp">RESULTCOUNT FINAL: ${resultCount}</go:log>

<%--
If loading a quote and unable to find the quote in simple check if online only
--%>
<c:if test="${isSimples && not empty selectedProductId && selectedProductId != '0' && empty resultsList.get(selectedProductId)}">
	<go:log source="health_price_service_PHIO_jsp" level="DEBUG">selectedProductId '${selectedProductId}' not found in results, need to fetch.</go:log>
			<c:set var="excludeStatus">'N','X'</c:set>
			${healthPriceService.setExcludeStatus(excludeStatus)}
	<health:price_service_fetch_product healthXML="${health}"
										transactionId="${transactionId}"
										resultsList="${resultsList}"
			healthPriceService="${healthPriceService}" />
</c:if>

<%-- Build the xml data for each row --%>
<results>
	<health:price_service_results rows="${resultsList}" searchDate="${searchDate}" state="${state}" membership="${membership}"
		productType="${productType}" excessMin="${excessMin}" excessMax="${excessMax}" hospitalSelection="${hospitalSelection}"
		rebate="${rebate}" loading="${loading}" healthXML="${health}" />

	<c:if test="${resultCount == 0}">
	<%--
		<result>
				<provider></provider>
				<name></name>
				<des></des>
				<premium></premium>
		</result>
	--%>
	</c:if>
	<pricesHaveChanged>${pricesHaveChanged}</pricesHaveChanged>
	<transactionId><x:out select="$health/request/header/partnerReference" /></transactionId>
</results>

