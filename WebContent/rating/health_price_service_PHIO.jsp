<%@page import="java.util.Date"%>
<%@ page language="java" contentType="text/xml; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<x:parse var="health" xml="${param.QuoteData}" />
<go:log>QuoteData: ${param.QuoteData}</go:log>
<c:set var="providerId"><x:out select="$health/request/header/providerId" /></c:set>
<c:if test="${providerId==''}">
	<c:set var="providerId">0</c:set>
</c:if>
<c:set var="brandFilter"><x:out select="$health/request/header/brandFilter" /></c:set>

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

<c:set var="fullProductId">
	<x:choose>
		<x:when select="$health/request/header/showAll = 'Y'">0</x:when>
		<x:otherwise>
			<x:out select="$health/request/header/productId" />
		</x:otherwise>
	</x:choose>
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

<%-- When searching for a single product ignore the product ID and use
	the title of the product. The same product with 2 pricing periods
	won't share the product ID but should always share the same name.
--%>
<c:set var="searchProductIdOrProductTitle">
	<x:choose>
		<x:when select="$health/request/header/showAll = 'Y'">
			${productId} = 0 OR product.productId=${productId}
		</x:when>
		<x:otherwise>
			product.ShortTitle='${fn:replace(productTitle, "'", "''")}' OR product.LongTitle='${fn:replace(productTitle, "'", "''")}'
		</x:otherwise>
	</x:choose>
</c:set>

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
<c:when test="${prHospital != 'Y' and puHospital  != 'Y' }">PrivateHospital</c:when>
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

<%-- Get products that match the passed criteria --%>
<sql:setDataSource dataSource="jdbc/ctm"/>

<c:set var="algorithm" value="2"/>
<c:set var="resultCount" value="0"/> 
<c:set var="exclude" value=""/> 
<c:set var="exclude2" value=""/> 

<go:log>ALGORITHM: ${algorithm}</go:log>
<c:if test="${algorithm == '2'}">

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
(SELECT SUM(value) FROM ctm.product_properties m
				WHERE m.productid = search.productid
				<c:if test="${!empty preferences}">
					AND m.propertyid COLLATE latin1_bin IN (${preferences})
				</c:if>
		GROUP BY ProductID) AS rank,
search.monthlyPremium + (search.monthlyLhc * ?) as factoredPrice

	FROM ctm.product_properties_search search
	INNER JOIN ctm.product_master product ON search.ProductId = product.ProductId
	WHERE
	(product.EffectiveStart <= ? AND product.EffectiveEnd >= ? AND (product.Status != 'N' AND product.Status != 'X'))
	AND (${searchProductIdOrProductTitle})
	AND (? = 0 OR product.providerId=?)
			AND product.providerId NOT IN(${brandFilter})
	AND product.productCat = 'HEALTH'
	AND search.state = ?
	AND search.membership = ?
	AND search.productType = ?
	AND search.excessAmount >= ? and search.excessAmount <=  ?
	AND ${searchExcessAlso}
	AND (? = 'Both'  OR search.hospitalType = ? )
	GROUP BY search.ProductId
	ORDER BY rank desc, factoredPrice asc
			LIMIT 120) results
	GROUP by ProviderID
	ORDER BY rank desc, factoredPrice asc
	LIMIT 4
	
	<sql:param value="${loadingPerc}" />
	<sql:param value="${searchDate}" />
	<sql:param value="${searchDate}" />

	<sql:param value="${providerId}" />
	<sql:param value="${providerId}" />

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
			(SELECT SUM(value) FROM ctm.product_properties m
						WHERE m.productid = search.productid
						<c:if test="${!empty preferences}">
							AND m.propertyid COLLATE latin1_bin IN (${preferences})
		</c:if>
				GROUP BY ProductID) AS rank,
		search.monthlyPremium + (search.monthlyLhc * ?) as factoredPrice
		
			FROM ctm.product_properties_search search
			INNER JOIN ctm.product_master product ON search.ProductId = product.ProductId
			WHERE
			(product.EffectiveStart <= ? AND product.EffectiveEnd >= ? AND (product.Status != 'N' AND product.Status != 'X'))
			AND (${searchProductIdOrProductTitle})
			AND (? = 0 OR product.providerId=?)
			AND product.providerId NOT IN(${brandFilter})
			AND product.productCat = 'HEALTH'
			AND search.state = ?
			AND search.membership = ?
			AND search.productType = ?
			AND search.excessAmount >= ? and search.excessAmount <=  ?
			AND ${searchExcessAlso}
			AND (? = 'Both'  OR search.hospitalType = ? )
			AND search.ProductId NOT IN (${exclude}0)
			GROUP BY search.ProductId
			ORDER BY rank desc, factoredPrice asc
			LIMIT 120) results
	GROUP by ProviderID
	ORDER BY rank desc, factoredPrice asc
	LIMIT ${searchResults - 4}
	
		<sql:param value="${loadingPerc}" />
		<sql:param value="${searchDate}" />
		<sql:param value="${searchDate}" />
	
		<sql:param value="${providerId}" />
		<sql:param value="${providerId}" />
	
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
			(SELECT SUM(value) FROM ctm.product_properties m
						WHERE m.productid = search.productid
						<c:if test="${!empty preferences}">
							AND m.propertyid COLLATE latin1_bin IN (${preferences})
						</c:if>
				GROUP BY ProductID) AS rank,
		search.monthlyPremium + (search.monthlyLhc * ?) as factoredPrice

			FROM ctm.product_properties_search search
			INNER JOIN ctm.product_master product ON search.ProductId = product.ProductId
			WHERE
			(product.EffectiveStart <= ? AND product.EffectiveEnd >= ? AND (product.Status != 'N' AND product.Status != 'X'))
			AND (${searchProductIdOrProductTitle})
			AND (? = 0 OR product.providerId=?)
			AND product.providerId NOT IN(${brandFilter})
			AND product.productCat = 'HEALTH'
			AND search.state = ?
			AND search.membership = ?
			AND search.productType = ?
			AND search.excessAmount >= ? and search.excessAmount <=  ?
			AND ${searchExcessAlso}
			AND (? = 'Both'  OR search.hospitalType = ? )
			AND search.ProductId NOT IN (${exclude}0)
			GROUP BY search.ProductId
			ORDER BY rank desc, factoredPrice asc
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
		(SELECT SUM(value) FROM ctm.product_properties m
						WHERE m.productid = search.productid
						<c:if test="${!empty preferences}">
							AND m.propertyid COLLATE latin1_bin IN (${preferences})
						</c:if>
				GROUP BY ProductID) AS rank,
		search.monthlyPremium + (search.monthlyLhc * ?) as factoredPrice

				FROM ctm.product_properties_search search
				INNER JOIN ctm.product_master product ON search.ProductId = product.ProductId
			WHERE
			(product.EffectiveStart <= ? AND product.EffectiveEnd >= ? AND (product.Status != 'N' AND product.Status != 'X'))
			AND (${searchProductIdOrProductTitle})
			AND (? = 0 OR product.providerId=?)
			AND product.providerId NOT IN(${brandFilter})
					AND product.productCat = 'HEALTH'
					AND search.state = ?
					AND search.membership = ?
					AND search.productType = ?
			AND search.excessAmount >= ? and search.excessAmount <=  ?
			AND ${searchExcessAlso}
					AND (? = 'Both' OR search.hospitalType = ? )
			AND search.ProductId NOT IN (${exclude2}0)
					GROUP BY search.ProductId
			ORDER BY rank desc, factoredPrice asc
			LIMIT 120) results
	GROUP by ProviderID
	
	ORDER BY rank desc, factoredPrice asc
	LIMIT <c:out value="${searchResults - resultCount}"/>
	
		<sql:param value="${loadingPerc}" />
						<sql:param value="${searchDate}" />
						<sql:param value="${searchDate}" />
	
		<sql:param value="${providerId}" />
		<sql:param value="${providerId}" />
	
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
	
		<sql:param value="${providerId}" />
		<sql:param value="${providerId}" />
	
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

	<go:log>RESULTCOUNT V2: ${resultCount}</go:log>
				</c:if>

<c:if test="${resultCount < searchResults}">
	<go:log>RESULTCOUNT PRE V1: ${resultCount}</go:log>

	<sql:query var="result3">
	SELECT
		search.ProductId,
		product.longTitle,
		product.shortTitle,
		product.providerId,
		product.productCat,
		product.ProductCode,
		search.excessAmount,
		(SELECT SUM(value) FROM ctm.product_properties m
					WHERE m.productid = search.productid
					<c:if test="${!empty preferences}">
						AND m.propertyid COLLATE latin1_bin IN (${preferences})
					</c:if>
			GROUP BY ProductID) AS rank,
	search.monthlyPremium + (search.monthlyLhc * ?) as factoredPrice
	
		FROM ctm.product_properties_search search
		INNER JOIN ctm.product_master product ON search.ProductId = product.ProductId
		WHERE
		(product.EffectiveStart <= ? AND product.EffectiveEnd >= ? AND (product.Status != 'N' AND product.Status != 'X'))
		AND (${searchProductIdOrProductTitle})
		AND (? = 0 OR product.providerId=?)
		AND product.providerId NOT IN(${brandFilter})
		AND product.productCat = 'HEALTH'
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
		ORDER BY rank desc, factoredPrice asc
		LIMIT <c:out value="${searchResults - resultCount}"/>
	
		<sql:param value="${loadingPerc}" />
		<sql:param value="${searchDate}" />
		<sql:param value="${searchDate}" />
	
		<sql:param value="${providerId}" />
		<sql:param value="${providerId}" />
	
		<sql:param value="${state}" />
		<sql:param value="${membership}" />
		<sql:param value="${productType}" />
	
		<sql:param value="${excessMin}" />
		<sql:param value="${excessMax}" />
	
		<sql:param value="${hospitalSelection}" />
		<sql:param value="${hospitalSelection}" />
				</sql:query>

		</c:if>

<go:log>RESULTCOUNT FINAL: ${resultCount}</go:log>

<%-- Build the xml data for each row --%>
<results>

	<c:if test="${algorithm == '2'}">
		<health:price_service_results rows="${result.rows}" searchDate="${searchDate}" state="${state}" membership="${membership}" productType="${productType}" excessMin="${excessMin}" excessMax="${excessMax}" hospitalSelection="${hospitalSelection}" rebate="${rebate}" 
				loading="${loading}" healthXML="${health}" />
	
		<health:price_service_results rows="${result2.rows}" searchDate="${searchDate}" state="${state}" membership="${membership}" 
		productType="${productType}" excessMin="${excessMin}" excessMax="${excessMax}"
		hospitalSelection="${hospitalSelection}" rebate="${rebate}" loading="${loading}"
		healthXML="${health}" />
	</c:if>

	<c:if test="${resultCount < searchResults}">
		<c:set var="resultCount" value="${resultCount + result3.rowCount}"/> 
		<health:price_service_results rows="${result3.rows}" searchDate="${searchDate}" state="${state}" membership="${membership}" 
		productType="${productType}" excessMin="${excessMin}" excessMax="${excessMax}" hospitalSelection="${hospitalSelection}"
		rebate="${rebate}" loading="${loading}" healthXML="${health}" />
	</c:if>

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
</results>
<go:log>${results}</go:log>
