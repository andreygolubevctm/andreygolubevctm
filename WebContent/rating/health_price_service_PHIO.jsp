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
<c:set var="SearchDate">
	<x:choose>
		<x:when select="$health/request/payment/details/start != ''">
			<x:out select="$health/request/payment/details/start" />
		</x:when>
		<x:when select="$health/request/searchDate != ''">
			<x:out select="$health/request/searchDate" />
		</x:when>		
		<x:otherwise>
			<fmt:setLocale value="en_GB" scope="session" />
			<jsp:useBean id="now" class="java.util.GregorianCalendar" scope="page" />
			<fmt:formatDate value="${now.time}" pattern="yyyy-MM-dd" var="displayDate" />
			${displayDate}
		</x:otherwise>
	</x:choose>	
</c:set>

<go:log>Display Date = ${displayDate}</go:log>

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

<go:log>ProviderId: ${providerId}</go:log>
<go:log>ProductType: ${productType}</go:log>
<go:log>LoadingPerc: ${loadingPerc}</go:log>

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
  (SELECT SUM(value) FROM ctm.product_properties m
				WHERE m.productid = search.productid
				AND m.propertyid COLLATE latin1_bin IN (${preferences})
        GROUP BY ProductID) AS rank,
 search.monthlyPremium + (search.monthlyLhc * ${loadingPerc}) as factoredPrice   
 
	FROM ctm.product_properties_search search
	INNER JOIN ctm.product_master product ON search.ProductId = product.ProductId        
	WHERE
	(product.EffectiveStart <= ? AND product.EffectiveEnd >= ? AND product.Status != 'N')
	AND (${productId} = 0 OR product.productId=${productId}) 
	AND (${providerId} = 0 OR product.providerId=${providerId}) 
	AND product.productCat = 'HEALTH'
	AND search.state = '${state}'
  AND search.membership = '${membership}'
  AND search.productType = '${productType}' 
	AND search.excessAmount >= ${excessMin} and search.excessAmount <=  ${excessMax}
	AND ('${hospitalSelection}' = 'Both'  OR search.hospitalType = '${hospitalSelection}' )				
	GROUP BY search.ProductId
	ORDER BY rank desc, factoredPrice asc
	LIMIT 12
	<sql:param value="${displayDate}" />
	<sql:param value="${displayDate}" />
</sql:query>


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
	<c:choose>
		<c:when test="${discountRates=='Y'}">
			<sql:query var="premium">
				SELECT props.value, props.text, props.PropertyId
				FROM ctm.product_properties props
				WHERE props.productid = ${row.productid}
				AND props.PropertyId in (
					'discAnnualLhc', 
					'discFortnightlyLhc',
					'discMonthlyLhc',
					'discQuarterlyLhc',  
					'discAnnualPremium', 
					'discFortnightlyPremium', 
					'discMonthlyPremium',
					'discQuarterlyPremium'				 
				)
				ORDER BY props.propertyid
			</sql:query>		
		</c:when>
		<c:otherwise>				
			<sql:query var="premium">
				SELECT props.value, props.text, props.PropertyId
				FROM ctm.product_properties props
				WHERE props.productid = ${row.productid}
				AND props.PropertyId in (
					'grossAnnualLhc', 
					'grossFortnightlyLhc',
					'grossMonthlyLhc',
					'grossQuarterlyLhc',  
					'grossAnnualPremium', 
					'grossFortnightlyPremium', 
					'grossMonthlyPremium',
					'grossQuarterlyPremium'				 
				)
				ORDER BY props.propertyid
			</sql:query>
		</c:otherwise>
	</c:choose>
		<c:if test="${premium.rowCount != 0}">
			<c:set var="aLhc" value="${premium.rows[0].Value}" />
			<c:set var="aPrm" value="${premium.rows[1].Value}" />
			<c:set var="fLhc" value="${premium.rows[2].Value}" />
			<c:set var="fPrm" value="${premium.rows[3].Value}" />			
			<c:set var="mLhc" value="${premium.rows[4].Value}" />
			<c:set var="mPrm" value="${premium.rows[5].Value}" />
			<c:choose>
			<c:when test="${premium.rowCount == 8}">
				<c:set var="qLhc" value="${premium.rows[6].Value}" />
				<c:set var="qPrm" value="${premium.rows[7].Value}" />
			</c:when>
			<c:otherwise>
				<c:set var="qLhc" value="999999" />
				<c:set var="qPrm" value="999999" />
			</c:otherwise>	
			</c:choose>
			
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
				</premium>
					
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
	
	<c:if test="result.rowCount == 0">
		<result>
				<provider></provider>
				<name></name>
				<des></des>
				<premium></premium>
		</result>		
	</c:if>
</results>
<go:log>${results}</go:log>
