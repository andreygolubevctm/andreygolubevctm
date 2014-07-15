<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="request" />

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

<%-- Include this tag to add required rebate multiplier variables to the request --%>
<health:changeover_rebates />

<c:if test="${rebate > 0}">
	<c:set var="rebate_changeover" value="${rebate * rebate_multiplier_future}" />
</c:if>
<c:set var="rebateCalc_changeover" value="${(100-rebate_changeover)*0.01}" />
<c:set var="rebateCalcReal_changeover" value="${rebate_changeover*0.01}" />

<%-- Test the date and apply the future rebate value --%>
<fmt:formatDate value="${changeover_date_1}" var="matchDate" pattern="YYYY-MM-dd" />
<c:choose>
	<c:when test="${searchDate >= matchDate}">
		<c:set var="rebate" value="${rebate_changeover}" />
	</c:when>
	<c:otherwise>
		<c:if test="${rebate > 0}">
			<c:set var="rebate" value="${rebate * rebate_multiplier_current}" />
		</c:if>
	</c:otherwise>
</c:choose>



<c:set var="rebateCalc" value="${(100-rebate)*0.01}" />
<c:set var="rebateCalcReal" value="${rebate*0.01}" />

<go:setData dataVar="data" xpath="tempProvidersPromoXML" value="" />

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

			<sql:query var="disabledFunds">
				SELECT Description FROM  aggregator.general
				WHERE type like 'healthSettings'
				AND code like 'dual-pricing-disabledfunds';
			</sql:query>

			<%-- Check if dual pricing has been turned off for the fund --%>
			<c:set var="alternatePriceDisabled" value="${false}" />
			<c:forTokens items="${disabledFunds.rows[0]['Description']}" var="disabledFund" delims=",">
				<c:if test="${disabledFund eq active_fund}">
					<c:set var="alternatePriceDisabled" value="${true}" />
					<go:log level="DEBUG" source="health:price_service_results" >duel pricing is disabled for ${active_fund}</go:log>
				</c:if>
			</c:forTokens>

			<%-- Only attempt to find future price if fund NOT disabled --%>
			<c:if test="${alternatePriceDisabled eq false}">



				<%-- ALTERNATE PRICING --%>

				<%-- Direct call to product_master as products are validated earlier for style code --%>
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
						AND search.excessAmount = ${row.excessAmount}
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

				<%-- Only create alt premium variable if future premium found --%>
				<c:if test="${alternateResult.rowCount != 0 && not empty alternateResult.rows[0]['ProductID']}">
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

			</c:if>
			<%-- Just made the brtag blank to assist with merging the trunk (Leto told me too!) --%>
			<c:set var="brtag" value=" " />

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
						<c:set var="starOthersAnnual">
							<c:choose>
								<c:when test="${discountAnnual=='Y'}">*</c:when>
								<c:otherwise></c:otherwise>
							</c:choose>
						</c:set>
						<health:price_service_premium
									discount="${discountAnnual}"
									prm="${aPrm}"
									rebateCalc="${rebateCalc}"
									loading="${loading}"
									healthRebate="${aRebate}"
									rebate="${rebate}"
									lhc="${aLhc}"
									star="${starOthersAnnual}"
									membership="${membership}" />
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

					<c:set var="qRebate" value="${qPrm * rebateCalcReal}" />
					<quarterly>
						<health:price_service_premium discount="${discountOthers}" prm="${qPrm}"
									rebateCalc="${rebateCalc}" loading="${loading}"
									healthRebate="${qRebate}"
									rebate="${rebate}" lhc="${qLhc}"
									star="${starOthers}"
									membership="${membership}" />
					</quarterly>
					<c:set var="mRebate" value="${mPrm * rebateCalcReal}" />
					<monthly>
						<health:price_service_premium
									discount="${discountOthers}" prm="${mPrm}"
									rebateCalc="${rebateCalc}" loading="${loading}"
									healthRebate="${mRebate}"
									rebate="${rebate}" lhc="${mLhc}"
									star="${starOthers}"
									membership="${membership}" />
					</monthly>
					<c:set var="fRebate" value="${fPrm * rebateCalcReal}" />
					<fortnightly>
						<health:price_service_premium discount="${discountOthers}" prm="${fPrm}"
									rebateCalc="${rebateCalc}" loading="${loading}"
									healthRebate="${fRebate}"
									rebate="${rebate}" lhc="${fLhc}"
									star="${starOthers}"
									membership="${membership}" />
					</fortnightly>
					<c:set var="wRebate" value="${wPrm * rebateCalcReal}" />
					<weekly>
						<health:price_service_premium discount="${discountOthers}" prm="${wPrm}"
									rebateCalc="${rebateCalc}" loading="${loading}"
									healthRebate="${wRebate}"
									rebate="${rebate}" lhc="${wLhc}"
									star="${starOthers}"
									membership="${membership}" />
					</weekly>
					<c:set var="hRebate" value="${hPrm * rebateCalcReal}" />
					<halfyearly>
						<health:price_service_premium discount="${discountOthers}" prm="${hPrm}"
									rebateCalc="${rebateCalc}" loading="${loading}"
									healthRebate="${hRebate}"
									rebate="${rebate}" lhc="${hLhc}"
									star="${starOthers}"
									membership="${membership}" />
					</halfyearly>
				</premium>

				<%-- Render the alternate Premium: NOTE see premium for full entry details --%>
				<altPremium>
					<c:set var="ALTaRebate" value="${ALTaPrm * rebateCalcReal_changeover}" />
					<annually>
						<health:price_service_premium
									discount="${discountAnnual}" prm="${ALTaPrm}"
									rebateCalc="${rebateCalc_changeover}" loading="${loading}"
									healthRebate="${ALTaRebate}"
									rebate="${rebate_changeover}" lhc="${ALTaLhc}"
									star="${starOthersAnnual}"
									active_fund="${active_fund}"
									membership="${membership}" />

					</annually>
					<c:set var="ALTqRebate" value="${ALTqPrm * rebateCalcReal_changeover}" />
					<quarterly>
						<health:price_service_premium
									discount="${discountOthers}" prm="${ALTqPrm}"
									rebateCalc="${rebateCalc_changeover}" loading="${loading}"
									healthRebate="${ALTqRebate}"
									rebate="${rebate_changeover}" lhc="${ALTqLhc}"
									star="${starOthers}"
									active_fund="${active_fund}"
									membership="${membership}"/>
					</quarterly>
					<c:set var="ALTmRebate" value="${ALTmPrm * rebateCalcReal_changeover}" />
					<monthly>
						<health:price_service_premium
									discount="${discountOthers}" prm="${ALTmPrm}"
									rebateCalc="${rebateCalc_changeover}" loading="${loading}"
									healthRebate="${ALTmRebate}"
									rebate="${rebate_changeover}" lhc="${ALTmLhc}"
									star="${starOthers}"
									active_fund="${active_fund}"
									membership="${membership}"/>
					</monthly>
					<c:set var="ALTfRebate" value="${ALTfPrm * rebateCalcReal_changeover}" />
					<fortnightly>
						<health:price_service_premium
									discount="${discountOthers}" prm="${ALTfPrm}"
									rebateCalc="${rebateCalc_changeover}" loading="${loading}"
									healthRebate="${ALTfRebate}"
									rebate="${rebate_changeover}" lhc="${ALTfLhc}"
									star="${starOthers}"
									active_fund="${active_fund}"
									membership="${membership}"/>
					</fortnightly>
					<c:set var="ALTwRebate" value="${ALTwPrm * rebateCalcReal_changeover}" />
					<weekly>
						<health:price_service_premium
									discount="${discountOthers}" prm="${ALTwPrm}"
									rebateCalc="${rebateCalc_changeover}" loading="${loading}"
									healthRebate="${ALTwRebate}"
									rebate="${rebate_changeover}" lhc="${ALTwLhc}"
									star="${starOthers}"
									active_fund="${active_fund}"
									membership="${membership}" />
					</weekly>
					<c:set var="ALThRebate" value="${ALThPrm * rebateCalcReal_changeover}" />
					<halfyearly>
						<health:price_service_premium
									discount="${discountOthers}"
									prm="${ALThPrm}"
									rebateCalc="${rebateCalc_changeover}" loading="${loading}"
									healthRebate="${ALThRebate}"
									rebate="${rebate_changeover}" lhc="${ALThLhc}"
									star="${starOthers}"
									active_fund="${active_fund}"
									membership="${membership}"/>
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

				<%-- Add the providers promo XML to the session so as to avoid retrieving it multiple times --%>
				<c:choose>
					<c:when test="${empty data.tempProvidersPromoXML or empty data.tempProvidersPromoXML[active_fund]}">
						<c:set var="promoXML"><health:price_service_promo providerId="${row.providerId}" /></c:set>
						<c:set var="xpath">tempProvidersPromoXML/${active_fund}</c:set>
						<go:setData dataVar="data" xpath="${xpath}" value="${promoXML}" />
					</c:when>
					<c:otherwise>
						<c:set var="promoXML">${data.tempProvidersPromoXML[active_fund]}</c:set>
					</c:otherwise>
				</c:choose>

				<c:import url="/WEB-INF/aggregator/health/extract-promo.xsl" var="promoXSL" />
				<c:set var="transformedPromoXML">
					<x:transform doc="${promoXML}" xslt="${promoXSL}">
						<x:param name="extras" value="${extrasName}" />
						<x:param name="hospital" value="${hospitalName}" />
					</x:transform>
				</c:set>

				<promo>${transformedPromoXML}</promo>

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

<%-- Remove temporary provider promo content from the session --%>
<go:setData dataVar="data" value="*DELETE" xpath="tempProvidersPromoXML" />