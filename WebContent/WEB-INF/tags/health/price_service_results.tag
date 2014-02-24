<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%@ attribute name="rows" type="java.util.LinkedHashMap" required="true" rtexprvalue="true"	 description="recordset" %>

<%@ attribute name="searchDate" required="true" rtexprvalue="true"	 description="search date" %>
<%@ attribute name="state" required="true" rtexprvalue="true"	 description="state" %>
<%@ attribute name="membership" required="true" rtexprvalue="true"	 description="membership" %>
<%@ attribute name="productType" required="true" rtexprvalue="true"	 description="product type" %>
<%@ attribute name="excessMin" required="true" rtexprvalue="true"	 description="excess min" %>
<%@ attribute name="excessMax" required="true" rtexprvalue="true"	 description="excess max" %>
<%@ attribute name="hospitalSelection" required="true" rtexprvalue="true"	 description="hospital selection" %>


<%@ attribute name="rebate" required="true" rtexprvalue="true"	 description="rebate" %>
<%@ attribute name="loading" required="true" rtexprvalue="true"	 description="loading" %>

<%@ attribute name="healthXML" required="true" rtexprvalue="true" description="loading" type="org.apache.xerces.dom.NodeImpl" %>

<c:set var="onResultsPage"><x:out select="$healthXML/request/header/onResultsPage = 'Y'" /></c:set>
<c:set var="accountType"><x:out select="$healthXML/request/details/accountType" /></c:set>
<c:set var="paymentFreq"><x:out select="$healthXML/request/details/paymentFrequency" /></c:set>

<c:set var="rebateCalc" value="${(100-rebate)*0.01}" />
<c:set var="rebateCalcReal" value="${rebate*0.01}" />

    <sql:setDataSource dataSource="jdbc/ctm"/>

	<c:forEach var="row" items="${rows}">
	<c:set var="row" value="${row.value}" />

	<%--
		DISCOUNT HACK: NEEDS TO BE REVISED
		I feel dirty putting this here, but we need to ship
		and the funds all have weird discount rules.

		if onResultsPage = true
			= Discount
			Show all .. and default to discount rates (but we'll only show the * for NIB)

		if NIB + not(Bank account) + single-product only being fetched
			= No Discount

		else if NIB or GMF
			= Discount
		else
			= No Discount

		1=AUF, 3=NIB, 5=GMH, 6=GMF
	--%>
		<c:set var="discountRates">
			<c:choose>
				<c:when test="${onResultsPage}">Y</c:when>
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

		<go:log source="health:price_service_results" level="DEBUG">Premium rowCount: ${premium.rowCount}</go:log>

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

			<go:log source="health:price_service_results" level="DEBUG">
			MLHC CALC FOR: ${row.longtitle}. mLhc=${mLhc}.
			</go:log>

			<sql:query var="provider">
				SELECT m.Name, p.Text
				FROM provider_master m
				JOIN provider_properties p ON p.providerId=m.providerId
				WHERE m.providerId = ${row.providerId}
				AND p.propertyId = 'FundCode'
			</sql:query>

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

			<%-- PROVIDER LIST
				Australian Unity		AUF
				BUPA					BUP
				HCF						HCF
				nib						NIB
				GMHBA					GMH
				GMF						GMF
				Westfund				WFD
				Frank					FRA
				AHM						AHM
				CBHS					CBH
				HIF						HIF
				CUA						CUA
				Teachers Health Fund	THF
				Compare the Market		CTM
			--%>
			<c:set var="active_fund" value="${provider.rows[0].text}" />

			<%-- ALL fund except Teachers will be providing either a genuine price alternative
				or an industry percentage increase as a minimum --%>

			<sql:query var="enabledFunds">
				SELECT Description FROM  test.general
				WHERE type like 'healthSettings'
				AND code like 'dual-pricing-enabledfunds';
			</sql:query>

			<c:set var="alternatePriceEnabled" value="${false}" />
			<c:forTokens items="${enabledFunds.rows[0]['Description']}" var="enabledFund" delims=",">
				<c:if test="${enabledFund eq active_fund}">
					<c:set var="alternatePriceEnabled" value="${true}" />
					<go:log level="DEBUG" source="health:price_service_results" >duel pricing in disabled for ${active_fund}</go:log>
				</c:if>
			</c:forTokens>

			<c:if test="${alternatePriceEnabled}">

			<go:log source="health:price_service_results" level="TRACE">
				<sql___query var="alternateResult">
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
						<sql__param value="${searchDate}" />
						<sql__param value="${searchDate}" />
						<sql__param value="${state}" />
						<sql__param value="${membership}" />
						<sql__param value="${productType}" />
						<sql__param value="${excessMin}" />
						<sql__param value="${excessMax}" />
						<sql__param value="${hospitalSelection}" />
						<sql__param value="${hospitalSelection}" />
						<sql__param value="${row.longtitle}" />
				</sql___query>

			</go:log>
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

				<%-- Get the alternate product prices - if alt product exists then use that product
					Otherwise get the existing product and we'll apply percentage increase--%>

				<c:set var="productid_to_use">
					<c:choose>
						<c:when test="${alternateResult.rowCount != 0 && not empty alternateResult.rows[0]['ProductID']}">${alternateResult.rows[0]['ProductID']}</c:when>
						<c:otherwise>${row.ProductId}</c:otherwise>
					</c:choose>
				</c:set>

					<sql:query var="alternatePremium">
						SELECT props.value, props.text, props.PropertyId
						FROM ctm.product_properties props
					WHERE props.productid = ${productid_to_use}
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

				<%-- Set the percentage to be applied, if any --%>
				<c:set var="fund_percentage">
					<c:choose>
						<%-- Zero percent increase if alt premium found --%>
						<c:when test="${alternateResult.rowCount != 0 && not empty alternateResult.rows[0]['ProductID']}">0</c:when>
						<%-- Otherwise apply industry standard rate increase --%>
						<c:otherwise>
							<c:choose>
								<c:when test="${active_fund eq 'AUF'}">6.62</c:when>
								<c:when test="${active_fund eq 'BUP'}">6.35</c:when>
								<c:when test="${active_fund eq 'HCF'}">6.89</c:when>
								<c:when test="${active_fund eq 'NIB'}">7.99</c:when>
								<c:when test="${active_fund eq 'GMH'}">5.94</c:when>
								<c:when test="${active_fund eq 'GMF'}">4.95</c:when>
								<c:when test="${active_fund eq 'WFD'}">3.25</c:when>
								<c:when test="${active_fund eq 'FRA'}">5.94</c:when>
								<c:when test="${active_fund eq 'AHM'}">6.49</c:when>
								<c:when test="${active_fund eq 'CBH'}">5.61</c:when>
								<c:when test="${active_fund eq 'HIF'}">2.98</c:when>
								<c:when test="${active_fund eq 'CUA'}">5.47</c:when>
								<c:when test="${active_fund eq 'CTM'}">5.0</c:when>
								<c:otherwise>1</c:otherwise>
							</c:choose>
						</c:otherwise>
					</c:choose>
				</c:set>

				<%-- Apply percentage to existing premium, is zero when alt premium found - just return as is --%>
					<c:forEach var="rr" items="${alternatePremium.rows}" varStatus="status">
						<c:choose>
						<c:when test="${rr.PropertyId == 'discAnnualLhc'			or rr.PropertyId == 'grossAnnualLhc'}">			<c:set var="ALTaLhc" value="${rr.value + (rr.value * fund_percentage / 100)}" /></c:when>
						<c:when test="${rr.PropertyId == 'discAnnualPremium'		or rr.PropertyId == 'grossAnnualPremium'}">		<c:set var="ALTaPrm" value="${rr.value + (rr.value * fund_percentage / 100)}" /></c:when>
						<c:when test="${rr.PropertyId == 'discFortnightlyLhc'		or rr.PropertyId == 'grossFortnightlyLhc'}">	<c:set var="ALTfLhc" value="${rr.value + (rr.value * fund_percentage / 100)}" /></c:when>
						<c:when test="${rr.PropertyId == 'discFortnightlyPremium'	or rr.PropertyId == 'grossFortnightlyPremium'}"><c:set var="ALTfPrm" value="${rr.value + (rr.value * fund_percentage / 100)}" /></c:when>
						<c:when test="${rr.PropertyId == 'discMonthlyLhc'			or rr.PropertyId == 'grossMonthlyLhc'}">		<c:set var="ALTmLhc" value="${rr.value + (rr.value * fund_percentage / 100)}" /></c:when>
						<c:when test="${rr.PropertyId == 'discMonthlyPremium'		or rr.PropertyId == 'grossMonthlyPremium'}">	<c:set var="ALTmPrm" value="${rr.value + (rr.value * fund_percentage / 100)}" /></c:when>
						<c:when test="${rr.PropertyId == 'discQuarterlyLhc'			or rr.PropertyId == 'grossQuarterlyLhc'}">		<c:set var="ALTqLhc" value="${rr.value + (rr.value * fund_percentage / 100)}" /></c:when>
						<c:when test="${rr.PropertyId == 'discQuarterlyPremium'		or rr.PropertyId == 'grossQuarterlyPremium'}">	<c:set var="ALTqPrm" value="${rr.value + (rr.value * fund_percentage / 100)}" /></c:when>
						<c:when test="${rr.PropertyId == 'discWeeklyLhc'			or rr.PropertyId == 'grossWeeklyLhc'}">			<c:set var="ALTwLhc" value="${rr.value + (rr.value * fund_percentage / 100)}" /></c:when>
						<c:when test="${rr.PropertyId == 'discWeeklyPremium'		or rr.PropertyId == 'grossWeeklyPremium'}">		<c:set var="ALTwPrm" value="${rr.value + (rr.value * fund_percentage / 100)}" /></c:when>
						<c:when test="${rr.PropertyId == 'discHalfYearlyLhc'		or rr.PropertyId == 'grossHalfYearlyLhc'}">		<c:set var="ALThLhc" value="${rr.value + (rr.value * fund_percentage / 100)}" /></c:when>
						<c:when test="${rr.PropertyId == 'discHalfYearlyPremium'	or rr.PropertyId == 'grossHalfYearlyPremium'}">	<c:set var="ALThPrm" value="${rr.value + (rr.value * fund_percentage / 100)}" /></c:when>
						</c:choose>
					</c:forEach>

				</c:if>

			<c:set var="brtag"><br></c:set>

			<fmt:setLocale value="en_US" />
			<result productId="${row.productCat}-${row.productid}">
				<restrictedFund>
				<c:choose>
					<c:when test="${provider.rows[0].text eq 'CBH' || provider.rows[0].text eq 'THF' }">Y</c:when>
					<c:otherwise>N</c:otherwise>
				</c:choose>
				</restrictedFund>
				<provider>${provider.rows[0].text}</provider>
				<providerName>${provider.rows[0].Name}</providerName>
				<productCode><c:out value="${row.productCode}" escapeXml="true"/></productCode>
				<name><c:out value="${row.longtitle}" escapeXml="true"/></name>
				<des><c:out value="${row.longtitle}" escapeXml="true"/></des>
				<calcrank><c:out value="${row.rank/rankcount*100}" escapeXml="true"/></calcrank>
				<rank><c:out value="${row.rank+0}" escapeXml="true"/></rank>

				<premium>
					<c:set var="aLoading" value="${aLhc * (loading*0.01)}" />
					<c:set var="aRebate" value="${aPrm * rebateCalcReal}" />
					<annually>
						<c:set var="discountAnnual">
							<c:choose>
								<c:when test="${discountRates=='Y' && row.providerId==6}">Y</c:when>
								<c:when test="${discountRates=='Y' && row.providerId==3}">Y</c:when>
								<c:when test="${discountRates=='Y' && row.providerId==5}">Y</c:when>
								<c:when test="${discountRates=='Y' && row.providerId==1}">Y</c:when>
								<c:otherwise>N</c:otherwise>
							</c:choose>
						</c:set>
						<discounted>${discountAnnual}</discounted>
						<text><c:if test="${discountAnnual=='Y'}">*</c:if><fmt:formatNumber type="currency" value="${(aPrm * rebateCalc) + aLoading}" maxFractionDigits="2" groupingUsed="true" currencySymbol="$"/></text>
						<value><fmt:formatNumber type="currency" value="${(aPrm * rebateCalc) + aLoading}" maxFractionDigits="2" groupingUsed="false" currencySymbol=""/></value>
						<pricing>Includes rebate of <fmt:formatNumber type="currency" value="${aRebate}" maxFractionDigits="2" groupingUsed="true" currencySymbol="$"/><c:out value="${brtag}" escapeXml="true" />&amp; LHC loading of <fmt:formatNumber type="currency" value="${aLoading}" maxFractionDigits="2" groupingUsed="true" currencySymbol="$"/></pricing>
						<lhcfreetext><c:if test="${discountAnnual=='Y'}">*</c:if><fmt:formatNumber type="currency" value="${aPrm * rebateCalc}" maxFractionDigits="2" groupingUsed="true" currencySymbol="$"/></lhcfreetext>
						<lhcfreevalue><fmt:formatNumber type="currency" value="${aPrm * rebateCalc}" maxFractionDigits="2" groupingUsed="false" currencySymbol=""/></lhcfreevalue>
						<lhcfreepricing>plus LHC of <fmt:formatNumber type="currency" value="${aLoading}" maxFractionDigits="2" groupingUsed="true" currencySymbol="$"/> and including<c:out value="${brtag}" escapeXml="true" /><fmt:formatNumber type="currency" value="${aRebate}" maxFractionDigits="2" groupingUsed="true" currencySymbol="$"/> Government Rebate.</lhcfreepricing>
						<hospitalValue><fmt:formatNumber type="currency" value="${(aLhc * rebateCalc) + aLoading}" maxFractionDigits="2" groupingUsed="false" currencySymbol=""/></hospitalValue>
						<rebate>${rebate}</rebate>
						<rebateValue><fmt:formatNumber type="currency" value="${aRebate}" maxFractionDigits="2" groupingUsed="true" currencySymbol="$"/></rebateValue>
						<lhc><fmt:formatNumber type="currency" value="${aLoading}" maxFractionDigits="2" groupingUsed="false" currencySymbol=""/></lhc>
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
							<c:when test="${discountRates=='Y' && row.providerId==1}">Y</c:when>
							<c:otherwise>N</c:otherwise>
						</c:choose>
					</c:set>
					<c:set var="starOthers">
						<c:if test="${discountOthers=='Y'}">*</c:if>
					</c:set>

					<c:set var="qLoading" value="${qLhc * (loading*0.01)}" />
					<c:set var="qRebate" value="${qPrm * rebateCalcReal}" />
					<quarterly>
						<discounted>${discountOthers}</discounted>
						<text>${starOthers}<fmt:formatNumber type="currency" value="${(qPrm * rebateCalc) + qLoading}" maxFractionDigits="2" groupingUsed="true" currencySymbol="$"/></text>
						<value><fmt:formatNumber type="currency" value="${(qPrm * rebateCalc) + qLoading}" maxFractionDigits="2" groupingUsed="false" currencySymbol=""/></value>
						<pricing>Includes rebate of <fmt:formatNumber type="currency" value="${qRebate}" maxFractionDigits="2" groupingUsed="true" currencySymbol="$"/><c:out value="${brtag}" escapeXml="true" />&amp; LHC loading of <fmt:formatNumber type="currency" value="${qLoading}" maxFractionDigits="2" groupingUsed="true" currencySymbol="$"/></pricing>
						<lhcfreetext>${starOthers}<fmt:formatNumber type="currency" value="${qPrm * rebateCalc}" maxFractionDigits="2" groupingUsed="true" currencySymbol="$"/></lhcfreetext>
						<lhcfreevalue><fmt:formatNumber type="currency" value="${qPrm * rebateCalc}" maxFractionDigits="2" groupingUsed="false" currencySymbol=""/></lhcfreevalue>
						<lhcfreepricing>plus LHC of <fmt:formatNumber type="currency" value="${qLoading}" maxFractionDigits="2" groupingUsed="true" currencySymbol="$"/> and including<c:out value="${brtag}" escapeXml="true" /><fmt:formatNumber type="currency" value="${qRebate}" maxFractionDigits="2" groupingUsed="true" currencySymbol="$"/> Government Rebate.</lhcfreepricing>
						<hospitalValue><fmt:formatNumber type="currency" value="${(qLhc * rebateCalc) + qLoading}" maxFractionDigits="2" groupingUsed="false" currencySymbol=""/></hospitalValue>
						<rebate>${rebate}</rebate>
						<rebateValue><fmt:formatNumber type="currency" value="${qRebate}" maxFractionDigits="2" groupingUsed="true" currencySymbol="$"/></rebateValue>
						<lhc><fmt:formatNumber type="currency" value="${qLoading}" maxFractionDigits="2" groupingUsed="false" currencySymbol=""/></lhc>
					</quarterly>

					<c:set var="mLoading" value="${mLhc * (loading*0.01)}" />
					<c:set var="mRebate" value="${mPrm * rebateCalcReal}" />
					<monthly>
						<discounted>${discountOthers}</discounted>
						<text>${starOthers}<fmt:formatNumber type="currency" value="${(mPrm * rebateCalc) + mLoading}" maxFractionDigits="2" groupingUsed="true" currencySymbol="$"/></text>
						<value><fmt:formatNumber type="currency" value="${(mPrm * rebateCalc) + mLoading}" maxFractionDigits="2" groupingUsed="false" currencySymbol=""/></value>
						<pricing>Includes rebate of <fmt:formatNumber type="currency" value="${mRebate}" maxFractionDigits="2" groupingUsed="true" currencySymbol="$"/><c:out value="${brtag}" escapeXml="true" />&amp; LHC loading of <fmt:formatNumber type="currency" value="${mLoading}" maxFractionDigits="2" groupingUsed="true" currencySymbol="$"/></pricing>
						<lhcfreetext>${starOthers}<fmt:formatNumber type="currency" value="${mPrm * rebateCalc}" maxFractionDigits="2" groupingUsed="true" currencySymbol="$"/></lhcfreetext>
						<lhcfreevalue><fmt:formatNumber type="currency" value="${mPrm * rebateCalc}" maxFractionDigits="2" groupingUsed="false" currencySymbol=""/></lhcfreevalue>
						<lhcfreepricing>plus LHC of <fmt:formatNumber type="currency" value="${mLoading}" maxFractionDigits="2" groupingUsed="true" currencySymbol="$"/> and including<c:out value="${brtag}" escapeXml="true" /><fmt:formatNumber type="currency" value="${mRebate}" maxFractionDigits="2" groupingUsed="true" currencySymbol="$"/> Government Rebate.</lhcfreepricing>
						<hospitalValue><fmt:formatNumber type="currency" value="${(mLhc * rebateCalc) + mLoading}" maxFractionDigits="2" groupingUsed="false" currencySymbol=""/></hospitalValue>
						<rebate>${rebate}</rebate>
						<rebateValue><fmt:formatNumber type="currency" value="${mRebate}" maxFractionDigits="2" groupingUsed="true" currencySymbol="$"/></rebateValue>
						<lhc><fmt:formatNumber type="currency" value="${mLoading}" maxFractionDigits="2" groupingUsed="false" currencySymbol=""/></lhc>
					</monthly>

					<c:set var="fLoading" value="${fLhc * (loading*0.01)}" />
					<c:set var="fRebate" value="${fPrm * rebateCalcReal}" />
					<fortnightly>
						<discounted>${discountOthers}</discounted>
						<text>${starOthers}<fmt:formatNumber type="currency" value="${(fPrm * rebateCalc) + fLoading}" maxFractionDigits="2" groupingUsed="true" currencySymbol="$"/></text>
						<value><fmt:formatNumber type="currency" value="${(fPrm * rebateCalc) + fLoading}" maxFractionDigits="2" groupingUsed="false" currencySymbol=""/></value>
						<pricing>Includes rebate of <fmt:formatNumber type="currency" value="${fRebate}" maxFractionDigits="2" groupingUsed="true" currencySymbol="$"/><c:out value="${brtag}" escapeXml="true" />&amp; LHC loading of <fmt:formatNumber type="currency" value="${fLoading}" maxFractionDigits="2" groupingUsed="true" currencySymbol="$"/></pricing>
						<lhcfreetext>${starOthers}<fmt:formatNumber type="currency" value="${fPrm * rebateCalc}" maxFractionDigits="2" groupingUsed="true" currencySymbol="$"/></lhcfreetext>
						<lhcfreevalue><fmt:formatNumber type="currency" value="${fPrm * rebateCalc}" maxFractionDigits="2" groupingUsed="false" currencySymbol=""/></lhcfreevalue>
						<lhcfreepricing>plus LHC of <fmt:formatNumber type="currency" value="${fLoading}" maxFractionDigits="2" groupingUsed="true" currencySymbol="$"/> and including<c:out value="${brtag}" escapeXml="true" /><fmt:formatNumber type="currency" value="${fRebate}" maxFractionDigits="2" groupingUsed="true" currencySymbol="$"/> Government Rebate.</lhcfreepricing>
						<hospitalValue><fmt:formatNumber type="currency" value="${(fLhc * rebateCalc) + fLoading}" maxFractionDigits="2" groupingUsed="false" currencySymbol=""/></hospitalValue>
						<rebate>${rebate}</rebate>
						<rebateValue><fmt:formatNumber type="currency" value="${fRebate}" maxFractionDigits="2" groupingUsed="true" currencySymbol="$"/></rebateValue>
						<lhc><fmt:formatNumber type="currency" value="${fLoading}" maxFractionDigits="2" groupingUsed="false" currencySymbol=""/></lhc>
					</fortnightly>

					<c:set var="wLoading" value="${wLhc * (loading*0.01)}" />
					<c:set var="wRebate" value="${wPrm * rebateCalcReal}" />
					<weekly>
						<discounted>${discountOthers}</discounted>
						<text>${starOthers}<fmt:formatNumber type="currency" value="${(wPrm * rebateCalc) + wLoading}" maxFractionDigits="2" groupingUsed="true" currencySymbol="$"/></text>
						<value><fmt:formatNumber type="currency" value="${(wPrm * rebateCalc) + wLoading}" maxFractionDigits="2" groupingUsed="false" currencySymbol=""/></value>
						<pricing>Includes rebate of <fmt:formatNumber type="currency" value="${wRebate}" maxFractionDigits="2" groupingUsed="true" currencySymbol="$"/><c:out value="${brtag}" escapeXml="true" />&amp; LHC loading of <fmt:formatNumber type="currency" value="${wLoading}" maxFractionDigits="2" groupingUsed="true" currencySymbol="$"/></pricing>
						<lhcfreetext>${starOthers}<fmt:formatNumber type="currency" value="${wPrm * rebateCalc}" maxFractionDigits="2" groupingUsed="true" currencySymbol="$"/></lhcfreetext>
						<lhcfreevalue><fmt:formatNumber type="currency" value="${wPrm * rebateCalc}" maxFractionDigits="2" groupingUsed="false" currencySymbol=""/></lhcfreevalue>
						<lhcfreepricing>plus LHC of <fmt:formatNumber type="currency" value="${wLoading}" maxFractionDigits="2" groupingUsed="true" currencySymbol="$"/> and including<c:out value="${brtag}" escapeXml="true" /><fmt:formatNumber type="currency" value="${wRebate}" maxFractionDigits="2" groupingUsed="true" currencySymbol="$"/> Government Rebate.</lhcfreepricing>
						<hospitalValue><fmt:formatNumber type="currency" value="${(wLhc * rebateCalc) + wLoading}" maxFractionDigits="2" groupingUsed="false" currencySymbol=""/></hospitalValue>
						<rebate>${rebate}</rebate>
						<rebateValue><fmt:formatNumber type="currency" value="${wRebate}" maxFractionDigits="2" groupingUsed="true" currencySymbol="$"/></rebateValue>
						<lhc><fmt:formatNumber type="currency" value="${wLoading}" maxFractionDigits="2" groupingUsed="false" currencySymbol=""/></lhc>
					</weekly>

					<c:set var="hLoading" value="${hLhc * (loading*0.01)}" />
					<c:set var="hRebate" value="${hPrm * rebateCalcReal}" />
					<halfyearly>
						<discounted>${discountOthers}</discounted>
						<text>${starOthers}<fmt:formatNumber type="currency" value="${(hPrm * rebateCalc) + hLoading}" maxFractionDigits="2" groupingUsed="true" currencySymbol="$"/></text>
						<value><fmt:formatNumber type="currency" value="${(hPrm * rebateCalc) + hLoading}" maxFractionDigits="2" groupingUsed="false" currencySymbol=""/></value>
						<pricing>Includes rebate of <fmt:formatNumber type="currency" value="${hRebate}" maxFractionDigits="2" groupingUsed="true" currencySymbol="$"/><c:out value="${brtag}" escapeXml="true" />&amp; LHC loading of <fmt:formatNumber type="currency" value="${hLoading}" maxFractionDigits="2" groupingUsed="true" currencySymbol="$"/></pricing>
						<lhcfreetext>${starOthers}<fmt:formatNumber type="currency" value="${hPrm * rebateCalc}" maxFractionDigits="2" groupingUsed="true" currencySymbol="$"/></lhcfreetext>
						<lhcfreevalue><fmt:formatNumber type="currency" value="${hPrm * rebateCalc}" maxFractionDigits="2" groupingUsed="false" currencySymbol=""/></lhcfreevalue>
						<lhcfreepricing>plus LHC of <fmt:formatNumber type="currency" value="${hLoading}" maxFractionDigits="2" groupingUsed="true" currencySymbol="$"/> and including<c:out value="${brtag}" escapeXml="true" /><fmt:formatNumber type="currency" value="${hRebate}" maxFractionDigits="2" groupingUsed="true" currencySymbol="$"/> Government Rebate.</lhcfreepricing>
						<hospitalValue><fmt:formatNumber type="currency" value="${(hLhc * rebateCalc) + hLoading}" maxFractionDigits="2" groupingUsed="false" currencySymbol=""/></hospitalValue>
						<rebate>${rebate}</rebate>
						<rebateValue><fmt:formatNumber type="currency" value="${hRebate}" maxFractionDigits="2" groupingUsed="true" currencySymbol="$"/></rebateValue>
						<lhc><fmt:formatNumber type="currency" value="${hLoading}" maxFractionDigits="2" groupingUsed="false" currencySymbol=""/></lhc>
					</halfyearly>
				</premium>

				<%-- Render the alternate Premium: NOTE see premium for full entry details --%>
				<altPremium>
					<c:set var="ALTaLoading" value="${ALTaLhc * (loading*0.01)}" />
					<c:set var="ALTaRebate" value="${ALTaPrm * rebateCalcReal}" />
					<annually>
						<discounted>${discountAnnual}</discounted>
						<text><c:if test="${discountAnnual=='Y'}">*</c:if><fmt:formatNumber type="currency" value="${(ALTaPrm * rebateCalc) + ALTaLoading}" maxFractionDigits="2" groupingUsed="true" currencySymbol="$"/></text>
						<value><fmt:formatNumber type="currency" value="${(ALTaPrm * rebateCalc) + ALTaLoading}" maxFractionDigits="2" groupingUsed="false" currencySymbol=""/></value>
						<pricing>Includes rebate of <fmt:formatNumber type="currency" value="${ALTaRebate}" maxFractionDigits="2" groupingUsed="true" currencySymbol="$"/><c:out value="${brtag}" escapeXml="true" />&amp; LHC loading of <fmt:formatNumber type="currency" value="${ALTaLoading}" maxFractionDigits="2" groupingUsed="true" currencySymbol="$"/></pricing>
						<lhcfreetext><c:if test="${discountAnnual=='Y'}">*</c:if><fmt:formatNumber type="currency" value="${ALTaPrm * rebateCalc}" maxFractionDigits="2" groupingUsed="true" currencySymbol="$"/></lhcfreetext>
						<lhcfreevalue><fmt:formatNumber type="currency" value="${ALTaPrm * rebateCalc}" maxFractionDigits="2" groupingUsed="false" currencySymbol=""/></lhcfreevalue>
						<lhcfreepricing>plus LHC of <fmt:formatNumber type="currency" value="${ALTaLoading}" maxFractionDigits="2" groupingUsed="true" currencySymbol="$"/> and including<c:out value="${brtag}" escapeXml="true" /><fmt:formatNumber type="currency" value="${ALTaRebate}" maxFractionDigits="2" groupingUsed="true" currencySymbol="$"/> Government Rebate.</lhcfreepricing>
						<hospitalValue><fmt:formatNumber type="currency" value="${(ALTaLhc * rebateCalc) + ALTaLoading}" maxFractionDigits="2" groupingUsed="false" currencySymbol=""/></hospitalValue>
						<rebate>${rebate}</rebate>
						<rebateValue><fmt:formatNumber type="currency" value="${ALTaRebate}" maxFractionDigits="2" groupingUsed="true" currencySymbol="$"/></rebateValue>
						<lhc><fmt:formatNumber type="currency" value="${ALTaLoading}" maxFractionDigits="2" groupingUsed="false" currencySymbol=""/></lhc>
						<specialcase><c:choose><c:when test="${active_fund eq 'THF'}">true</c:when><c:otherwise>false</c:otherwise></c:choose></specialcase>
					</annually>
					<c:set var="ALTqLoading" value="${ALTqLhc * (loading*0.01)}" />
					<c:set var="ALTqRebate" value="${ALTqPrm * rebateCalcReal}" />
					<quarterly>
						<discounted>${discountOthers}</discounted>
						<text>${starOthers}<fmt:formatNumber type="currency" value="${(ALTqPrm * rebateCalc) + ALTqLoading}" maxFractionDigits="2" groupingUsed="true" currencySymbol="$"/></text>
						<value><fmt:formatNumber type="currency" value="${(ALTqPrm * rebateCalc) + ALTqLoading}" maxFractionDigits="2" groupingUsed="false" currencySymbol=""/></value>
						<pricing>Includes rebate of <fmt:formatNumber type="currency" value="${ALTqRebate}" maxFractionDigits="2" groupingUsed="true" currencySymbol="$"/><c:out value="${brtag}" escapeXml="true" />&amp; LHC loading of <fmt:formatNumber type="currency" value="${ALTqLoading}" maxFractionDigits="2" groupingUsed="true" currencySymbol="$"/></pricing>
						<lhcfreetext>${starOthers}<fmt:formatNumber type="currency" value="${ALTqPrm * rebateCalc}" maxFractionDigits="2" groupingUsed="true" currencySymbol="$"/></lhcfreetext>
						<lhcfreevalue><fmt:formatNumber type="currency" value="${ALTqPrm * rebateCalc}" maxFractionDigits="2" groupingUsed="false" currencySymbol=""/></lhcfreevalue>
						<lhcfreepricing>plus LHC of <fmt:formatNumber type="currency" value="${ALTqLoading}" maxFractionDigits="2" groupingUsed="true" currencySymbol="$"/> and including<c:out value="${brtag}" escapeXml="true" /><fmt:formatNumber type="currency" value="${ALTqRebate}" maxFractionDigits="2" groupingUsed="true" currencySymbol="$"/> Government Rebate.</lhcfreepricing>
						<hospitalValue><fmt:formatNumber type="currency" value="${(ALTqLhc * rebateCalc) + ALTqLoading}" maxFractionDigits="2" groupingUsed="false" currencySymbol=""/></hospitalValue>
						<rebate>${rebate}</rebate>
						<rebateValue><fmt:formatNumber type="currency" value="${ALTqRebate}" maxFractionDigits="2" groupingUsed="true" currencySymbol="$"/></rebateValue>
						<lhc><fmt:formatNumber type="currency" value="${ALTqLoading}" maxFractionDigits="2" groupingUsed="false" currencySymbol=""/></lhc>
						<specialcase><c:choose><c:when test="${active_fund eq 'THF'}">true</c:when><c:otherwise>false</c:otherwise></c:choose></specialcase>
					</quarterly>
					<c:set var="ALTmLoading" value="${ALTmLhc * (loading*0.01)}" />
					<c:set var="ALTmRebate" value="${ALTmPrm * rebateCalcReal}" />
					<monthly>
						<discounted>${discountOthers}</discounted>
						<text>${starOthers}<fmt:formatNumber type="currency" value="${(ALTmPrm * rebateCalc) + ALTmLoading}" maxFractionDigits="2" groupingUsed="true" currencySymbol="$"/></text>
						<value><fmt:formatNumber type="currency" value="${(ALTmPrm * rebateCalc) + ALTmLoading}" maxFractionDigits="2" groupingUsed="false" currencySymbol=""/></value>
						<pricing>Includes rebate of <fmt:formatNumber type="currency" value="${ALTmRebate}" maxFractionDigits="2" groupingUsed="true" currencySymbol="$"/><c:out value="${brtag}" escapeXml="true" />&amp; LHC loading of <fmt:formatNumber type="currency" value="${ALTmLoading}" maxFractionDigits="2" groupingUsed="true" currencySymbol="$"/></pricing>
						<lhcfreetext>${starOthers}<fmt:formatNumber type="currency" value="${ALTmPrm * rebateCalc}" maxFractionDigits="2" groupingUsed="true" currencySymbol="$"/></lhcfreetext>
						<lhcfreevalue><fmt:formatNumber type="currency" value="${ALTmPrm * rebateCalc}" maxFractionDigits="2" groupingUsed="false" currencySymbol=""/></lhcfreevalue>
						<lhcfreepricing>plus LHC of <fmt:formatNumber type="currency" value="${ALTmLoading}" maxFractionDigits="2" groupingUsed="true" currencySymbol="$"/> and including<c:out value="${brtag}" escapeXml="true" /><fmt:formatNumber type="currency" value="${ALTmRebate}" maxFractionDigits="2" groupingUsed="true" currencySymbol="$"/> Government Rebate.</lhcfreepricing>
						<hospitalValue><fmt:formatNumber type="currency" value="${(ALTmLhc * rebateCalc) + ALTmLoading}" maxFractionDigits="2" groupingUsed="false" currencySymbol=""/></hospitalValue>
						<rebate>${rebate}</rebate>
						<rebateValue><fmt:formatNumber type="currency" value="${ALTmRebate}" maxFractionDigits="2" groupingUsed="true" currencySymbol="$"/></rebateValue>
						<lhc><fmt:formatNumber type="currency" value="${ALTmLoading}" maxFractionDigits="2" groupingUsed="false" currencySymbol=""/></lhc>
						<specialcase><c:choose><c:when test="${active_fund eq 'THF'}">true</c:when><c:otherwise>false</c:otherwise></c:choose></specialcase>
					</monthly>
					<c:set var="ALTfLoading" value="${ALTfLhc * (loading*0.01)}" />
					<c:set var="ALTfRebate" value="${ALTfPrm * rebateCalcReal}" />
					<fortnightly>
						<discounted>${discountOthers}</discounted>
						<text>${starOthers}<fmt:formatNumber type="currency" value="${(ALTfPrm * rebateCalc) + ALTfLoading}" maxFractionDigits="2" groupingUsed="true" currencySymbol="$"/></text>
						<value><fmt:formatNumber type="currency" value="${(ALTfPrm * rebateCalc) + ALTfLoading}" maxFractionDigits="2" groupingUsed="false" currencySymbol=""/></value>
						<pricing>Includes rebate of <fmt:formatNumber type="currency" value="${ALTfRebate}" maxFractionDigits="2" groupingUsed="true" currencySymbol="$"/><c:out value="${brtag}" escapeXml="true" />&amp; LHC loading of <fmt:formatNumber type="currency" value="${ALTfLoading}" maxFractionDigits="2" groupingUsed="true" currencySymbol="$"/></pricing>
						<lhcfreetext>${starOthers}<fmt:formatNumber type="currency" value="${ALTfPrm * rebateCalc}" maxFractionDigits="2" groupingUsed="true" currencySymbol="$"/></lhcfreetext>
						<lhcfreevalue><fmt:formatNumber type="currency" value="${ALTfPrm * rebateCalc}" maxFractionDigits="2" groupingUsed="false" currencySymbol=""/></lhcfreevalue>
						<lhcfreepricing>plus LHC of <fmt:formatNumber type="currency" value="${ALTfLoading}" maxFractionDigits="2" groupingUsed="true" currencySymbol="$"/> and including<c:out value="${brtag}" escapeXml="true" /><fmt:formatNumber type="currency" value="${ALTfRebate}" maxFractionDigits="2" groupingUsed="true" currencySymbol="$"/> Government Rebate.</lhcfreepricing>
						<hospitalValue><fmt:formatNumber type="currency" value="${(ALTfLhc * rebateCalc) + ALTfLoading}" maxFractionDigits="2" groupingUsed="false" currencySymbol=""/></hospitalValue>
						<rebate>${rebate}</rebate>
						<rebateValue><fmt:formatNumber type="currency" value="${ALTfRebate}" maxFractionDigits="2" groupingUsed="true" currencySymbol="$"/></rebateValue>
						<lhc><fmt:formatNumber type="currency" value="${ALTfLoading}" maxFractionDigits="2" groupingUsed="false" currencySymbol=""/></lhc>
						<specialcase><c:choose><c:when test="${active_fund eq 'THF'}">true</c:when><c:otherwise>false</c:otherwise></c:choose></specialcase>
					</fortnightly>
					<c:set var="ALTwLoading" value="${ALTwLhc * (loading*0.01)}" />
					<c:set var="ALTwRebate" value="${ALTwPrm * rebateCalcReal}" />
					<weekly>
						<discounted>${discountOthers}</discounted>
						<text>${starOthers}<fmt:formatNumber type="currency" value="${(ALTwPrm * rebateCalc) + ALTwLoading}" maxFractionDigits="2" groupingUsed="true" currencySymbol="$"/></text>
						<value><fmt:formatNumber type="currency" value="${(ALTwPrm * rebateCalc) + ALTwLoading}" maxFractionDigits="2" groupingUsed="false" currencySymbol=""/></value>
						<pricing>Includes rebate of <fmt:formatNumber type="currency" value="${ALTwRebate}" maxFractionDigits="2" groupingUsed="true" currencySymbol="$"/><c:out value="${brtag}" escapeXml="true" />&amp; LHC loading of <fmt:formatNumber type="currency" value="${ALTwLoading}" maxFractionDigits="2" groupingUsed="true" currencySymbol="$"/></pricing>
						<lhcfreetext>${starOthers}<fmt:formatNumber type="currency" value="${ALTwPrm * rebateCalc}" maxFractionDigits="2" groupingUsed="true" currencySymbol="$"/></lhcfreetext>
						<lhcfreevalue><fmt:formatNumber type="currency" value="${ALTwPrm * rebateCalc}" maxFractionDigits="2" groupingUsed="false" currencySymbol=""/></lhcfreevalue>
						<lhcfreepricing>plus LHC of <fmt:formatNumber type="currency" value="${ALTwLoading}" maxFractionDigits="2" groupingUsed="true" currencySymbol="$"/> and including<c:out value="${brtag}" escapeXml="true" /><fmt:formatNumber type="currency" value="${ALTwRebate}" maxFractionDigits="2" groupingUsed="true" currencySymbol="$"/> Government Rebate.</lhcfreepricing>
						<hospitalValue><fmt:formatNumber type="currency" value="${(ALTwLhc * rebateCalc) + ALTwLoading}" maxFractionDigits="2" groupingUsed="false" currencySymbol=""/></hospitalValue>
						<rebate>${rebate}</rebate>
						<rebateValue><fmt:formatNumber type="currency" value="${ALTwRebate}" maxFractionDigits="2" groupingUsed="true" currencySymbol="$"/></rebateValue>
						<lhc><fmt:formatNumber type="currency" value="${ALTwLoading}" maxFractionDigits="2" groupingUsed="false" currencySymbol=""/></lhc>
						<specialcase><c:choose><c:when test="${active_fund eq 'THF'}">true</c:when><c:otherwise>false</c:otherwise></c:choose></specialcase>
					</weekly>
					<c:set var="ALThLoading" value="${hLhc * (loading*0.01)}" />
					<c:set var="ALThRebate" value="${ALThPrm * rebateCalcReal}" />
					<halfyearly>
						<discounted>${discountOthers}</discounted>
						<text>${starOthers}<fmt:formatNumber type="currency" value="${(ALThPrm * rebateCalc) + ALThLoading}" maxFractionDigits="2" groupingUsed="true" currencySymbol="$"/></text>
						<value><fmt:formatNumber type="currency" value="${(ALThPrm * rebateCalc) + ALThLoading}" maxFractionDigits="2" groupingUsed="false" currencySymbol=""/></value>
						<pricing>Includes rebate of <fmt:formatNumber type="currency" value="${ALThRebate}" maxFractionDigits="2" groupingUsed="true" currencySymbol="$"/><c:out value="${brtag}" escapeXml="true" />&amp; LHC loading of <fmt:formatNumber type="currency" value="${ALThLoading}" maxFractionDigits="2" groupingUsed="true" currencySymbol="$"/></pricing>
						<lhcfreetext>${starOthers}<fmt:formatNumber type="currency" value="${ALThPrm * rebateCalc}" maxFractionDigits="2" groupingUsed="true" currencySymbol="$"/></lhcfreetext>
						<lhcfreevalue><fmt:formatNumber type="currency" value="${ALThPrm * rebateCalc}" maxFractionDigits="2" groupingUsed="false" currencySymbol=""/></lhcfreevalue>
						<lhcfreepricing>plus LHC of <fmt:formatNumber type="currency" value="${ALThLoading}" maxFractionDigits="2" groupingUsed="true" currencySymbol="$"/> and including<c:out value="${brtag}" escapeXml="true" /><fmt:formatNumber type="currency" value="${ALThRebate}" maxFractionDigits="2" groupingUsed="true" currencySymbol="$"/> Government Rebate.</lhcfreepricing>
						<hospitalValue><fmt:formatNumber type="currency" value="${(ALThLhc * rebateCalc) + ALThLoading}" maxFractionDigits="2" groupingUsed="false" currencySymbol=""/></hospitalValue>
						<rebate>${rebate}</rebate>
						<rebateValue><fmt:formatNumber type="currency" value="${ALThRebate}" maxFractionDigits="2" groupingUsed="true" currencySymbol="$"/></rebateValue>
						<lhc><fmt:formatNumber type="currency" value="${ALThLoading}" maxFractionDigits="2" groupingUsed="false" currencySymbol=""/></lhc>
						<specialcase><c:choose><c:when test="${active_fund eq 'THF'}">true</c:when><c:otherwise>false</c:otherwise></c:choose></specialcase>
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
				<go:log  source="health:price_service_results" level="DEBUG" >Importing: /health_fund_info/${provider.rows[0].Text}/promo.xml</go:log>
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
				<go:log source="health:price_service_results" level="TRACE" >${phioData.rows[0].text}</go:log>
				<c:out value="${phioData.rows[0].text}" escapeXml="false" />

			</result>
		</c:if>
	</c:forEach>