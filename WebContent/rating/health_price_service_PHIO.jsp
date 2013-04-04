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

<c:set var="accountType"><x:out select="$health/request/details/accountType" /></c:set>
<c:set var="paymentFreq"><x:out select="$health/request/details/paymentFreq" /></c:set>

<c:set var="prHospital"><x:out select="$health/request/details/prHospital" /></c:set>
<c:set var="puHospital"><x:out select="$health/request/details/puHospital" /></c:set>

<c:set var="hospitalSelection">
<c:choose>
<c:when test="${productType =='GeneralHealth'}">Both</c:when>
<c:when test="${prHospital == 'Y' and puHospital  != 'Y' }">PrivateHospital</c:when>
<c:when test="${prHospital != 'Y' and puHospital  != 'Y' }">PrivateHospital</c:when>
<c:when test="${prHospital == 'Y' and puHospital  == 'Y' }">PrivateHospital</c:when>
<c:when test="${prHospital != 'Y' and puHospital == 'Y' }">PublicHospital</c:when>
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
<sql:query var="result">
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
	AND product.productCat = 'HEALTH'
	AND search.state = ?
	AND search.membership = ?
	AND search.productType = ?
	AND search.excessAmount >= ? and search.excessAmount <=  ?
	AND ${searchExcessAlso}
	AND (? = 'Both'  OR search.hospitalType = ? )
	GROUP BY search.ProductId
	ORDER BY rank desc, factoredPrice asc
	LIMIT 12
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

<go:log>Result rowCount: ${result.rowCount}</go:log>

<%-- Build the xml data for each row --%>
<results>
	<c:forEach var="row" items="${result.rows}">

	<%--
		DISCOUNT HACK: NEEDS TO BE REVISED
		I feel dirty putting this here, but we need to ship
		and the funds all have weird discount rules.

		if no providerId (i.e. we're on results page)
			Show all .. and default to discount rates (but we'll only show the * for NIB)

		if NIB + not(Bank account) + single-product only being fetched
			= No Discount

		else if NIB or GMF
			= Discount
		else
			= No Discount

	--%>
		<c:set var="discountRates">
			<c:choose>
				<c:when test="${productId == 0}">Y</c:when>
				<c:when test="${row.providerId==3 and accountType=='ba'}">Y</c:when>
				<c:when test="${row.providerId==5 and accountType=='ba'}">Y</c:when>
				<c:when test="${row.providerId==6 and paymentFreq=='A'}">Y</c:when>
				<c:when test="${row.providerId==1}">Y</c:when>
				<c:otherwise></c:otherwise>
			</c:choose>
		</c:set>

		<c:set var="propName" value="gross" />
		<c:if test="${discountRates=='Y'}">
			<c:set var="propName" value="disc" />
		</c:if>
		<sql:query var="premium">
			SELECT props.value, props.text, props.PropertyId
			FROM ctm.product_properties props
			WHERE props.productid = ${row.ProductId}
			AND props.PropertyId in (
				'${propName}AnnualLhc',
				'${propName}FortnightlyLhc',
				'${propName}MonthlyLhc',
				'${propName}QuarterlyLhc',
				'${propName}WeeklyLhc',
				'${propName}HalfYearlyLhc',
				'${propName}AnnualPremium',
				'${propName}FortnightlyPremium',
				'${propName}MonthlyPremium',
				'${propName}QuarterlyPremium',
				'${propName}WeeklyPremium',
				'${propName}HalfYearlyPremium'
			)
			ORDER BY props.PropertyId
		</sql:query>

		<go:log>Premium rowCount: ${premium.rowCount}</go:log>

		<c:if test="${premium.rowCount != 0}">
			<c:set var="aLhc" value="0" />
			<c:set var="aPrm" value="0" />
			<c:set var="fLhc" value="0" />
			<c:set var="fPrm" value="0" />
			<c:set var="mLhc" value="0" />
			<c:set var="mPrm" value="0" />
			<c:set var="qLhc" value="0" />
			<c:set var="qPrm" value="0" />
			<c:set var="wLhc" value="0" />
			<c:set var="wPrm" value="0" />
			<c:set var="hLhc" value="0" />
			<c:set var="hPrm" value="0" />

			<c:forEach var="rr" items="${premium.rows}" varStatus="status">
				<c:choose>
					<c:when test="${rr.PropertyId == 'discAnnualLhc'			or rr.PropertyId == 'grossAnnualLhc'}">			<c:set var="aLhc" value="${rr.value}" /></c:when>
					<c:when test="${rr.PropertyId == 'discAnnualPremium'		or rr.PropertyId == 'grossAnnualPremium'}">		<c:set var="aPrm" value="${rr.value}" /></c:when>
					<c:when test="${rr.PropertyId == 'discFortnightlyLhc'		or rr.PropertyId == 'grossFortnightlyLhc'}">	<c:set var="fLhc" value="${rr.value}" /></c:when>
					<c:when test="${rr.PropertyId == 'discFortnightlyPremium'	or rr.PropertyId == 'grossFortnightlyPremium'}"><c:set var="fPrm" value="${rr.value}" /></c:when>
					<c:when test="${rr.PropertyId == 'discMonthlyLhc'			or rr.PropertyId == 'grossMonthlyLhc'}">		<c:set var="mLhc" value="${rr.value}" /></c:when>
					<c:when test="${rr.PropertyId == 'discMonthlyPremium'		or rr.PropertyId == 'grossMonthlyPremium'}">	<c:set var="mPrm" value="${rr.value}" /></c:when>
					<c:when test="${rr.PropertyId == 'discQuarterlyLhc'			or rr.PropertyId == 'grossQuarterlyLhc'}">		<c:set var="qLhc" value="${rr.value}" /></c:when>
					<c:when test="${rr.PropertyId == 'discQuarterlyPremium'		or rr.PropertyId == 'grossQuarterlyPremium'}">	<c:set var="qPrm" value="${rr.value}" /></c:when>
					<c:when test="${rr.PropertyId == 'discWeeklyLhc'			or rr.PropertyId == 'grossWeeklyLhc'}">			<c:set var="wLhc" value="${rr.value}" /></c:when>
					<c:when test="${rr.PropertyId == 'discWeeklyPremium'		or rr.PropertyId == 'grossWeeklyPremium'}">		<c:set var="wPrm" value="${rr.value}" /></c:when>
					<c:when test="${rr.PropertyId == 'discHalfYearlyLhc'		or rr.PropertyId == 'grossHalfYearlyLhc'}">		<c:set var="hLhc" value="${rr.value}" /></c:when>
					<c:when test="${rr.PropertyId == 'discHalfYearlyPremium'	or rr.PropertyId == 'grossHalfYearlyPremium'}">	<c:set var="hPrm" value="${rr.value}" /></c:when>
				</c:choose>
			</c:forEach>

			<go:log>
			MLHC CALC FOR: ${row.longtitle}. mLhc=${mLhc}.
			</go:log>

			<sql:query var="provider">
				SELECT m.Name, p.Text
				FROM provider_master m
				JOIN provider_properties p ON p.providerId=m.providerId
				WHERE m.providerId = ${row.providerId}
				AND p.propertyId = 'FundCode'
			</sql:query>



			<%-- ALTERNATE PRICING --%>
			<sql:query var="alternateResult">
				SELECT search.ProductId
				FROM ctm.product_properties_search search
				INNER JOIN ctm.product_master product ON search.ProductId = product.ProductId
				WHERE	( product.EffectiveStart <= DATE_ADD(?, INTERVAL 60 DAY)
						AND product.EffectiveEnd >= DATE_ADD(?, INTERVAL 60 DAY)
						AND (product.Status != 'N' AND product.Status != 'X') )
					AND product.productCat = 'HEALTH'
					AND search.state = ?
					AND search.membership = ?
					AND search.productType = ?
					AND (
						(product.effectiveStart <= curDate() AND product.effectiveEnd >= curDate() AND search.excessAmount = ${row.excessAmount})
						OR (product.effectiveStart > curDate() AND search.excessAmount >= ? AND search.excessAmount <= ?)
					)
					AND (? = 'Both' OR search.hospitalType = ? )
					AND product.longTitle = ?
					AND product.providerId = ${row.providerId}
					GROUP BY search.ProductId
					ORDER BY product.effectiveStart DESC
					LIMIT 1;
						<sql:param value="${searchDate}" />
						<sql:param value="${searchDate}" />
						<sql:param value="${state}" />
						<sql:param value="${membership}" />
						<sql:param value="${productType}" />
						<sql:param value="${excessMin}" />
						<sql:param value="${excessMax}" />

						<sql:param value="${hospitalSelection}" />
						<sql:param value="${hospitalSelection}" />

						<sql:param value="${row.longtitle}" />
			</sql:query>

			<%-- Re Above: When searching for alternate pricing I removed the check the effectiveStart
				was after the current date as we're now ordering by effectiveStart DESC and
				limiting to 1 record so no need to. This was to ensure we still retained
				premium details when the product was not scheduled to expire as soon as
				other products and consequently treated as not having a product after a date.

				Also modified so the excessAmount to match exactly with original search.
			--%>

				<%-- Alternate pricing defaults are required --%>
				<c:set var="ALTaLhc" value="0" />
				<c:set var="ALTaPrm" value="0" />
				<c:set var="ALTfLhc" value="0" />
				<c:set var="ALTfPrm" value="0" />
				<c:set var="ALTmLhc" value="0" />
				<c:set var="ALTmPrm" value="0" />
				<c:set var="ALTqLhc" value="0" />
				<c:set var="ALTqPrm" value="0" />
				<c:set var="ALTwLhc" value="0" />
				<c:set var="ALTwPrm" value="0" />
				<c:set var="ALThLhc" value="0" />
				<c:set var="ALThPrm" value="0" />

				<%-- Make sure there is an alternate product match --%>
				<c:if test="${alternateResult.rowCount != 0 && not empty alternateResult.rows[0]['ProductID']}">

					<sql:query var="alternatePremium">
						SELECT props.value, props.text, props.PropertyId
						FROM ctm.product_properties props
						WHERE props.productid = ${alternateResult.rows[0]['ProductID']}
						AND props.PropertyId in (
							'${propName}AnnualLhc',
							'${propName}FortnightlyLhc',
							'${propName}MonthlyLhc',
							'${propName}QuarterlyLhc',
							'${propName}WeeklyLhc',
							'${propName}HalfYearlyLhc',
							'${propName}AnnualPremium',
							'${propName}FortnightlyPremium',
							'${propName}MonthlyPremium',
							'${propName}QuarterlyPremium',
							'${propName}WeeklyPremium',
							'${propName}HalfYearlyPremium'
						)
						ORDER BY props.PropertyId
					</sql:query>

					<%-- Add the pricing data for Alternate premiums --%>
					<c:forEach var="rr" items="${alternatePremium.rows}" varStatus="status">
						<c:choose>
							<c:when test="${rr.PropertyId == 'discAnnualLhc'			or rr.PropertyId == 'grossAnnualLhc'}">			<c:set var="ALTaLhc" value="${rr.value}" /></c:when>
							<c:when test="${rr.PropertyId == 'discAnnualPremium'		or rr.PropertyId == 'grossAnnualPremium'}">		<c:set var="ALTaPrm" value="${rr.value}" /></c:when>
							<c:when test="${rr.PropertyId == 'discFortnightlyLhc'		or rr.PropertyId == 'grossFortnightlyLhc'}">	<c:set var="ALTfLhc" value="${rr.value}" /></c:when>
							<c:when test="${rr.PropertyId == 'discFortnightlyPremium'	or rr.PropertyId == 'grossFortnightlyPremium'}"><c:set var="ALTfPrm" value="${rr.value}" /></c:when>
							<c:when test="${rr.PropertyId == 'discMonthlyLhc'			or rr.PropertyId == 'grossMonthlyLhc'}">		<c:set var="ALTmLhc" value="${rr.value}" /></c:when>
							<c:when test="${rr.PropertyId == 'discMonthlyPremium'		or rr.PropertyId == 'grossMonthlyPremium'}">	<c:set var="ALTmPrm" value="${rr.value}" /></c:when>
							<c:when test="${rr.PropertyId == 'discQuarterlyLhc'			or rr.PropertyId == 'grossQuarterlyLhc'}">		<c:set var="ALTqLhc" value="${rr.value}" /></c:when>
							<c:when test="${rr.PropertyId == 'discQuarterlyPremium'		or rr.PropertyId == 'grossQuarterlyPremium'}">	<c:set var="ALTqPrm" value="${rr.value}" /></c:when>
							<c:when test="${rr.PropertyId == 'discWeeklyLhc'			or rr.PropertyId == 'grossWeeklyLhc'}">			<c:set var="ALTwLhc" value="${rr.value}" /></c:when>
							<c:when test="${rr.PropertyId == 'discWeeklyPremium'		or rr.PropertyId == 'grossWeeklyPremium'}">		<c:set var="ALTwPrm" value="${rr.value}" /></c:when>
							<c:when test="${rr.PropertyId == 'discHalfYearlyLhc'		or rr.PropertyId == 'grossHalfYearlyLhc'}">		<c:set var="ALThLhc" value="${rr.value}" /></c:when>
							<c:when test="${rr.PropertyId == 'discHalfYearlyPremium'	or rr.PropertyId == 'grossHalfYearlyPremium'}">	<c:set var="ALThPrm" value="${rr.value}" /></c:when>
						</c:choose>
					</c:forEach>

				</c:if>

			<fmt:setLocale value="en_US" />
			<result productId="${row.productCat}-${row.productid}">
				<provider>${provider.rows[0].text}</provider>
				<providerName>${provider.rows[0].Name}</providerName>
				<productCode><c:out value="${row.productCode}" escapeXml="true"/></productCode>
				<name><c:out value="${row.longtitle}" escapeXml="true"/></name>
				<des><c:out value="${row.longtitle}" escapeXml="true"/></des>
				<calcrank><c:out value="${row.rank/rankcount*100}" escapeXml="true"/></calcrank>
				<rank><c:out value="${row.rank+0}" escapeXml="true"/></rank>

				<premium>
					<c:set var="aLoading" value="${aLhc * (loading*0.01)}" />
					<c:set var="aRebate" value="${(100-rebate)*0.01}" />
					<annually>
						<c:set var="discountAnnual">
							<c:choose>
								<c:when test="${discountRates=='Y' && row.providerId==6}">Y</c:when>
								<c:when test="${discountRates=='Y' && row.providerId==3}">Y</c:when>
								<c:when test="${discountRates=='Y' && row.providerId==5}">Y</c:when>
								<c:otherwise>N</c:otherwise>
							</c:choose>
						</c:set>
						<discounted>${discountAnnual}</discounted>
						<text><c:if test="${discountAnnual=='Y'}">*</c:if><fmt:formatNumber type="currency" value="${(aPrm + aLoading) * aRebate}" maxFractionDigits="2" groupingUsed="true" currencySymbol="$"/></text>
						<value><fmt:formatNumber type="currency" value="${(aPrm + aLoading) * aRebate}" maxFractionDigits="2" groupingUsed="false" currencySymbol=""/></value>
						<pricing>Includes rebate of ${rebate}% &amp; LHC loading of <fmt:formatNumber type="currency" value="${aLoading}" maxFractionDigits="2" groupingUsed="true" currencySymbol="$"/></pricing>
					</annually>

					<%--
						All the other payment frequencies following the "normal" logic ..
						i.e. if the rates were discounted - show the * etc
						ONLY DO THIS FOR NIB AT PRESENT
					--%>
					<c:set var="discountOthers">
						<c:choose>
							<c:when test="${discountRates=='Y' && row.providerId==3}">Y</c:when>
							<c:when test="${discountRates=='Y' && row.providerId==5}">Y</c:when>
							<c:otherwise>N</c:otherwise>
						</c:choose>
					</c:set>
					<c:set var="starOthers">
						<c:if test="${discountOthers=='Y'}">*</c:if>
					</c:set>

					<c:set var="qLoading" value="${qLhc * (loading*0.01)}" />
					<c:set var="qRebate" value="${(100-rebate)*0.01}" />
					<quarterly>
						<discounted>${discountOthers}</discounted>
						<text>${starOthers}<fmt:formatNumber type="currency" value="${(qPrm + qLoading) * qRebate}" maxFractionDigits="2" groupingUsed="true" currencySymbol="$"/></text>
						<value><fmt:formatNumber type="currency" value="${(qPrm + qLoading) * qRebate}" maxFractionDigits="2" groupingUsed="false" currencySymbol=""/></value>
						<pricing>Includes rebate of ${rebate}% &amp; LHC loading of <fmt:formatNumber type="currency" value="${qLoading}" maxFractionDigits="2" groupingUsed="true" currencySymbol="$"/></pricing>
					</quarterly>

					<c:set var="mLoading" value="${mLhc * (loading*0.01)}" />
					<c:set var="mRebate" value="${(100-rebate)*0.01}" />
					<monthly>
						<discounted>${discountOthers}</discounted>
						<text>${starOthers}<fmt:formatNumber type="currency" value="${(mPrm + mLoading) * mRebate}" maxFractionDigits="2" groupingUsed="true" currencySymbol="$"/></text>
						<value><fmt:formatNumber type="currency" value="${(mPrm + mLoading) * mRebate}" maxFractionDigits="2" groupingUsed="false" currencySymbol=""/></value>
						<pricing>Includes rebate of ${rebate}% &amp; LHC loading of <fmt:formatNumber type="currency" value="${mLoading}" maxFractionDigits="2" groupingUsed="true" currencySymbol="$"/></pricing>
					</monthly>
					<go:log>
					LHC CALC FOR: ${row.longtitle}. Loading=${loading}. LoadingFactor=${(loading*0.01)}. mLoading=${mLoading}. mPrm=${mPrm}. mRebate=${mRebate}. mLhc=${mLhc}.
					</go:log>

					<c:set var="fLoading" value="${fLhc * (loading*0.01)}" />
					<c:set var="fRebate" value="${(100-rebate)*0.01}" />
					<fortnightly>
						<discounted>${discountOthers}</discounted>
						<text>${starOthers}<fmt:formatNumber type="currency" value="${(fPrm + fLoading) * fRebate}" maxFractionDigits="2" groupingUsed="true" currencySymbol="$"/></text>
						<value><fmt:formatNumber type="currency" value="${(fPrm + fLoading) * fRebate}" maxFractionDigits="2" groupingUsed="false" currencySymbol=""/></value>
						<pricing>Includes rebate of ${rebate}% &amp; LHC loading of <fmt:formatNumber type="currency" value="${fLoading}" maxFractionDigits="2" groupingUsed="true" currencySymbol="$"/></pricing>
					</fortnightly>

					<c:set var="wLoading" value="${wLhc * (loading*0.01)}" />
					<c:set var="wRebate" value="${(100-rebate)*0.01}" />
					<weekly>
						<discounted>${discountOthers}</discounted>
						<text>${starOthers}<fmt:formatNumber type="currency" value="${(wPrm + wLoading) * wRebate}" maxFractionDigits="2" groupingUsed="true" currencySymbol="$"/></text>
						<value><fmt:formatNumber type="currency" value="${(wPrm + wLoading) * wRebate}" maxFractionDigits="2" groupingUsed="false" currencySymbol=""/></value>
						<pricing>Includes rebate of ${rebate}% &amp; LHC loading of <fmt:formatNumber type="currency" value="${wLoading}" maxFractionDigits="2" groupingUsed="true" currencySymbol="$"/></pricing>
					</weekly>

					<c:set var="hLoading" value="${hLhc * (loading*0.01)}" />
					<c:set var="hRebate" value="${(100-rebate)*0.01}" />
					<halfyearly>
						<discounted>${discountOthers}</discounted>
						<text>${starOthers}<fmt:formatNumber type="currency" value="${(hPrm + hLoading) * hRebate}" maxFractionDigits="2" groupingUsed="true" currencySymbol="$"/></text>
						<value><fmt:formatNumber type="currency" value="${(hPrm + hLoading) * hRebate}" maxFractionDigits="2" groupingUsed="false" currencySymbol=""/></value>
						<pricing>Includes rebate of ${rebate}% &amp; LHC loading of <fmt:formatNumber type="currency" value="${hLoading}" maxFractionDigits="2" groupingUsed="true" currencySymbol="$"/></pricing>
					</halfyearly>
				</premium>

				<%-- Render the alternate Premium: NOTE see premium for full entry details --%>
				<altPremium>
					<c:set var="ALTaLoading" value="${ALTaLhc * (loading*0.01)}" />
					<c:set var="ALTaRebate" value="${(100-rebate)*0.01}" />
					<annually>
						<discounted>${discountAnnual}</discounted>
						<text><c:if test="${discountAnnual=='Y'}">*</c:if><fmt:formatNumber type="currency" value="${(ALTaPrm + ALTaLoading) * ALTaRebate}" maxFractionDigits="2" groupingUsed="true" currencySymbol="$"/></text>
						<value><fmt:formatNumber type="currency" value="${(ALTaPrm + ALTaLoading) * ALTaRebate}" maxFractionDigits="2" groupingUsed="false" currencySymbol=""/></value>
						<pricing>Includes rebate of ${rebate}% &amp; LHC loading of <fmt:formatNumber type="currency" value="${ALTaLoading}" maxFractionDigits="2" groupingUsed="true" currencySymbol="$"/></pricing>
					</annually>
					<c:set var="ALTqLoading" value="${ALTqLhc * (loading*0.01)}" />
					<c:set var="ALTqRebate" value="${(100-rebate)*0.01}" />
					<quarterly>
						<discounted>${discountOthers}</discounted>
						<text>${starOthers}<fmt:formatNumber type="currency" value="${(ALTqPrm + ALTqLoading) * ALTqRebate}" maxFractionDigits="2" groupingUsed="true" currencySymbol="$"/></text>
						<value><fmt:formatNumber type="currency" value="${(ALTqPrm + ALTqLoading) * ALTqRebate}" maxFractionDigits="2" groupingUsed="false" currencySymbol=""/></value>
						<pricing>Includes rebate of ${rebate}% &amp; LHC loading of <fmt:formatNumber type="currency" value="${ALTqLoading}" maxFractionDigits="2" groupingUsed="true" currencySymbol="$"/></pricing>
					</quarterly>
					<c:set var="ALTmLoading" value="${ALTmLhc * (loading*0.01)}" />
					<c:set var="ALTmRebate" value="${(100-rebate)*0.01}" />
					<monthly>
						<discounted>${discountOthers}</discounted>
						<text>${starOthers}<fmt:formatNumber type="currency" value="${(ALTmPrm + ALTmLoading) * ALTmRebate}" maxFractionDigits="2" groupingUsed="true" currencySymbol="$"/></text>
						<value><fmt:formatNumber type="currency" value="${(ALTmPrm + ALTmLoading) * ALTmRebate}" maxFractionDigits="2" groupingUsed="false" currencySymbol=""/></value>
						<pricing>Includes rebate of ${rebate}% &amp; LHC loading of <fmt:formatNumber type="currency" value="${ALTmLoading}" maxFractionDigits="2" groupingUsed="true" currencySymbol="$"/></pricing>
					</monthly>
					<c:set var="ALTfLoading" value="${ALTfLhc * (loading*0.01)}" />
					<c:set var="ALTfRebate" value="${(100-rebate)*0.01}" />
					<fortnightly>
						<discounted>${discountOthers}</discounted>
						<text>${starOthers}<fmt:formatNumber type="currency" value="${(ALTfPrm + ALTfLoading) * ALTfRebate}" maxFractionDigits="2" groupingUsed="true" currencySymbol="$"/></text>
						<value><fmt:formatNumber type="currency" value="${(ALTfPrm + ALTfLoading) * ALTfRebate}" maxFractionDigits="2" groupingUsed="false" currencySymbol=""/></value>
						<pricing>Includes rebate of ${rebate}% &amp; LHC loading of <fmt:formatNumber type="currency" value="${ALTfLoading}" maxFractionDigits="2" groupingUsed="true" currencySymbol="$"/></pricing>
					</fortnightly>
					<c:set var="ALTwLoading" value="${ALTwLhc * (loading*0.01)}" />
					<c:set var="ALTwRebate" value="${(100-rebate)*0.01}" />
					<weekly>
						<discounted>${discountOthers}</discounted>
						<text>${starOthers}<fmt:formatNumber type="currency" value="${(ALTwPrm + ALTwLoading) * ALTwRebate}" maxFractionDigits="2" groupingUsed="true" currencySymbol="$"/></text>
						<value><fmt:formatNumber type="currency" value="${(ALTwPrm + ALTwLoading) * ALTwRebate}" maxFractionDigits="2" groupingUsed="false" currencySymbol=""/></value>
						<pricing>Includes rebate of ${rebate}% &amp; LHC loading of <fmt:formatNumber type="currency" value="${ALTwLoading}" maxFractionDigits="2" groupingUsed="true" currencySymbol="$"/></pricing>
					</weekly>
					<c:set var="ALThLoading" value="${hLhc * (loading*0.01)}" />
					<c:set var="ALThRebate" value="${(100-rebate)*0.01}" />
					<halfyearly>
						<discounted>${discountOthers}</discounted>
						<text>${starOthers}<fmt:formatNumber type="currency" value="${(ALThPrm + ALThLoading) * ALThRebate}" maxFractionDigits="2" groupingUsed="true" currencySymbol="$"/></text>
						<value><fmt:formatNumber type="currency" value="${(ALThPrm + ALThLoading) * ALThRebate}" maxFractionDigits="2" groupingUsed="false" currencySymbol=""/></value>
						<pricing>Includes rebate of ${rebate}% &amp; LHC loading of <fmt:formatNumber type="currency" value="${ALThLoading}" maxFractionDigits="2" groupingUsed="true" currencySymbol="$"/></pricing>
					</halfyearly>
				</altPremium>

				<sql:query var="extrasRes">
					SELECT props.text, props.PropertyId
					FROM ctm.product_properties props
					WHERE props.productid = ${row.productid}
					AND props.PropertyId = 'extrasCoverName'
					LIMIT 1
				</sql:query>
				<c:set var="extrasName">
					<c:if test="${extrasRes.rowCount !=0}">${extrasRes.rows[0].text}</c:if>
				</c:set>
				<sql:query var="hospitalRes">
					SELECT props.text, props.PropertyId
					FROM ctm.product_properties props
					WHERE props.productid = ${row.productid}
					AND props.PropertyId = 'hospitalCoverName'
					LIMIT 1
				</sql:query>
				<c:set var="hospitalName">
					<c:if test="${hospitalRes.rowCount !=0}">${hospitalRes.rows[0].text}</c:if>
				</c:set>
				<go:log>Importing: /health_fund_info/${provider.rows[0].Text}/promo.xml</go:log>
				<c:import url="/health_fund_info/${provider.rows[0].Text}/promo.xml" var="promoXML" />
				<c:import url="/WEB-INF/aggregator/health/extract-promo.xsl" var="promoXSL" />
				<promo>
					<x:transform doc="${promoXML}" xslt="${promoXSL}">
						<x:param name="extras" value="${extrasName}" />
						<x:param name="hospital" value="${hospitalName}" />
					</x:transform>
				</promo>

				<sql:query var="phioData">
						SELECT text
						FROM ctm.product_properties_ext
						WHERE productid = ${row.productid}
						AND type = 'M'
				</sql:query>
				<go:log>${phioData.rows[0].text}</go:log>
				<c:out value="${phioData.rows[0].text}" escapeXml="false" />

			</result>
		</c:if>
	</c:forEach>

	<c:if test="${result.rowCount == 0}">
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
