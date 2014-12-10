<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="request" />

<%@ attribute name="rows" type="java.util.ArrayList" required="true" rtexprvalue="true"	 description="recordset" %>
<%@ attribute name="healthXML" required="true" rtexprvalue="true" description="loading" type="org.apache.xerces.dom.NodeImpl" %>
<%@ attribute name="healthPriceService" type="com.ctm.services.health.HealthPriceService" required="true" rtexprvalue="true"	 description="recordset" %>

<jsp:useBean id="healthPriceDetailService" class="com.ctm.services.health.HealthPriceDetailService" scope="page" />

<c:set var="healthPriceRequest" value="${healthPriceService.getHealthPriceRequest()}" />
<c:set var="loading" value="${healthPriceRequest.getLoading()}" />
<c:set var="rebate" value="${healthPriceRequest.getRebate()}" />
<c:set var="membership" value="${healthPriceRequest.getMembership()}" />

<c:set var="accountType"><x:out select="$healthXML/request/details/accountType" /></c:set>
<c:set var="currentCustomer"><x:out select="$healthXML/request/details/currentCustomer" /></c:set>
<c:set var="transactionId"><x:out select="$healthXML/request/header/partnerReference" /></c:set>

<c:if test="${rebate > 0}">
	<c:set var="rebate_changeover" value="${rebate * rebate_multiplier_future}" />
</c:if>
<c:set var="rebateCalc_changeover" value="${(100-rebate_changeover)*0.01}" />
<c:set var="rebateCalcReal_changeover" value="${rebate_changeover*0.01}" />

<%-- Test the date and apply the future rebate value --%>
<fmt:formatDate value="${changeover_date_1}" var="matchDate" pattern="YYYY-MM-dd" />
<c:choose>
	<c:when test="${healthPriceRequest.getSearchDate() >= matchDate}">
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

	<c:forEach var="row" items="${rows}">

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
			Budget Direct			BUD
			--%>

			<%-- ALL fund except Teachers will be providing either a genuine price alternative
				or an industry percentage increase as a minimum --%>
		<c:set var="row" value="${healthPriceDetailService.setUpFundCodeAndName(row)}" />
		<c:set var="active_fund" value="${row.getFundCode()}" />

		<%-- set up if provider has discount --%>
		<c:set var="discountRates" value="${healthPriceService.hasDiscountRates(active_fund, currentCustomer, accountType)}" />
		<c:set var="row" value="${healthPriceDetailService.setUpDiscountRates(row, discountRates)}" />

		<%-- set up premimum and lhc for normal prcing --%>
		<c:set var="row" value="${healthPriceDetailService.setUpPremiumAndLhc(row, false)}" />

			<%-- Only attempt to find future price if fund NOT disabled --%>
		<c:if test="${healthPriceDetailService.isAlternatePriceDisabled(row) eq false}">

				<%-- ALTERNATE PRICING --%>
			<c:set var="row" value="${healthPriceService.setUpAltProductId(row)}" />

				<%-- Get the alternate product prices - if alt product exists then use that product
					Otherwise get the existing product and we'll apply percentage increase--%>
			<c:set var="row" value="${healthPriceDetailService.setUpPremiumAndLhc(row, true)}" />

				</c:if>
			<%-- Just made the brtag blank to assist with merging the trunk (Leto told me too!) --%>
			<c:set var="brtag" value=" " />

			<fmt:setLocale value="en_US" />
		<result productId="${row.getProductCat()}-${row.getProductId()}">
				<restrictedFund>
				<c:choose>
				<c:when test="${active_fund eq 'CBH' || active_fund eq 'THF' }">Y</c:when>
					<c:otherwise>N</c:otherwise>
				</c:choose>
				</restrictedFund>
			<provider>${active_fund}</provider>
			<providerName>${row.getFundName()}</providerName>
			<productCode><c:out value="${row.getProductCode()}" escapeXml="true"/></productCode>
			<name><c:out value="${row.getLongTitle()}" escapeXml="true"/></name>
			<des><c:out value="${row.getLongTitle()}" escapeXml="true"/></des>
			<rank><c:out value="${row.getRank()+0}" escapeXml="true"/></rank>

				<premium>
				<c:set var="aRebate" value="${row.getHealthPricePremium().getAnnualPremium() * rebateCalcReal}" />
					<annually>
						<c:set var="discountAnnual">
							<c:choose>
							<c:when test="${discountRates}">Y</c:when>
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
								prm="${row.getHealthPricePremium().getAnnualPremium()}"
									rebateCalc="${rebateCalc}"
									loading="${loading}"
									healthRebate="${aRebate}"
									rebate="${rebate}"
								lhc="${row.getHealthPricePremium().getAnnualLhc()}"
									star="${starOthersAnnual}"
									membership="${membership}" />
					</annually>

					<%--
						All the other payment frequencies following the "normal" logic ..
						i.e. if the rates were discounted - show the * etc
					GMF only has discount for Annual payment, so do not display * for all other frequenies
					--%>
					<c:set var="discountOthers">
						<c:choose>
						<c:when test="${discountRates && row.getProviderId()==6}">N</c:when>
						<c:when test="${discountRates}">Y</c:when>
							<c:otherwise>N</c:otherwise>
						</c:choose>
					</c:set>
					<c:set var="starOthers">
						<c:if test="${discountOthers=='Y'}">*</c:if>
					</c:set>

				<c:set var="qRebate" value="${row.getHealthPricePremium().getQuarterlyPremium() * rebateCalcReal}" />
					<quarterly>
					<health:price_service_premium discount="${discountOthers}" prm="${row.getHealthPricePremium().getQuarterlyPremium()}"
									rebateCalc="${rebateCalc}" loading="${loading}"
									healthRebate="${qRebate}"
								rebate="${rebate}" lhc="${row.getHealthPricePremium().getQuarterlyLhc()}"
									star="${starOthers}"
									membership="${membership}" />
					</quarterly>
				<c:set var="mRebate" value="${row.getHealthPricePremium().getMonthlyPremium() * rebateCalcReal}" />
					<monthly>
						<health:price_service_premium
								discount="${discountOthers}" prm="${row.getHealthPricePremium().getMonthlyPremium()}"
									rebateCalc="${rebateCalc}" loading="${loading}"
									healthRebate="${mRebate}"
								rebate="${rebate}" lhc="${row.getHealthPricePremium().getMonthlyLhc()}"
									star="${starOthers}"
									membership="${membership}" />
					</monthly>
				<c:set var="fRebate" value="${row.getHealthPricePremium().getFortnightlyPremium() * rebateCalcReal}" />
					<fortnightly>
					<health:price_service_premium discount="${discountOthers}" prm="${row.getHealthPricePremium().getFortnightlyPremium()}"
									rebateCalc="${rebateCalc}" loading="${loading}"
									healthRebate="${fRebate}"
								rebate="${rebate}" lhc="${row.getHealthPricePremium().getFortnightlyLhc()}"
									star="${starOthers}"
									membership="${membership}" />
					</fortnightly>
				<c:set var="wRebate" value="${row.getHealthPricePremium().getWeeklyPremium() * rebateCalcReal}" />
					<weekly>
					<health:price_service_premium discount="${discountOthers}" prm="${row.getHealthPricePremium().getWeeklyPremium()}"
									rebateCalc="${rebateCalc}" loading="${loading}"
									healthRebate="${wRebate}"
								rebate="${rebate}" lhc="${row.getHealthPricePremium().getWeeklyLhc()}"
									star="${starOthers}"
									membership="${membership}" />
					</weekly>
				<c:set var="hRebate" value="${row.getHealthPricePremium().getHalfYearlyPremium() * rebateCalcReal}" />
					<halfyearly>
					<health:price_service_premium discount="${discountOthers}" prm="${row.getHealthPricePremium().getHalfYearlyPremium()}"
									rebateCalc="${rebateCalc}" loading="${loading}"
									healthRebate="${hRebate}"
								rebate="${rebate}" lhc="${row.getHealthPricePremium().getHalfYearlyLhc()}"
									star="${starOthers}"
									membership="${membership}" />
					</halfyearly>
				</premium>

				<%-- Render the alternate Premium: NOTE see premium for full entry details --%>
				<altPremium>
				<c:set var="ALTaRebate" value="${row.getAltHealthPricePremium().getAnnualPremium() * rebateCalcReal_changeover}" />
					<annually>
						<health:price_service_premium
								discount="${discountAnnual}" prm="${row.getAltHealthPricePremium().getAnnualPremium()}"
									rebateCalc="${rebateCalc_changeover}" loading="${loading}"
									healthRebate="${ALTaRebate}"
								rebate="${rebate_changeover}" lhc="${row.getAltHealthPricePremium().getAnnualLhc()}"
									star="${starOthersAnnual}"
									active_fund="${active_fund}"
									membership="${membership}" />

					</annually>
				<c:set var="ALTqRebate" value="${row.getAltHealthPricePremium().getQuarterlyPremium() * rebateCalcReal_changeover}" />
					<quarterly>
						<health:price_service_premium
								discount="${discountOthers}" prm="${row.getAltHealthPricePremium().getQuarterlyPremium()}"
									rebateCalc="${rebateCalc_changeover}" loading="${loading}"
									healthRebate="${ALTqRebate}"
								rebate="${rebate_changeover}" lhc="${row.getAltHealthPricePremium().getQuarterlyLhc()}"
									star="${starOthers}"
									active_fund="${active_fund}"
									membership="${membership}"/>
					</quarterly>
				<c:set var="ALTmRebate" value="${row.getAltHealthPricePremium().getMonthlyPremium() * rebateCalcReal_changeover}" />
					<monthly>
						<health:price_service_premium
								discount="${discountOthers}" prm="${row.getAltHealthPricePremium().getMonthlyPremium()}"
									rebateCalc="${rebateCalc_changeover}" loading="${loading}"
									healthRebate="${ALTmRebate}"
								rebate="${rebate_changeover}" lhc="${row.getAltHealthPricePremium().getMonthlyLhc()}"
									star="${starOthers}"
									active_fund="${active_fund}"
									membership="${membership}"/>
					</monthly>
				<c:set var="ALTfRebate" value="${row.getAltHealthPricePremium().getFortnightlyPremium() * rebateCalcReal_changeover}" />
					<fortnightly>
						<health:price_service_premium
								discount="${discountOthers}" prm="${row.getAltHealthPricePremium().getFortnightlyPremium()}"
									rebateCalc="${rebateCalc_changeover}" loading="${loading}"
									healthRebate="${ALTfRebate}"
								rebate="${rebate_changeover}" lhc="${row.getAltHealthPricePremium().getFortnightlyLhc()}"
									star="${starOthers}"
									active_fund="${active_fund}"
									membership="${membership}"/>
					</fortnightly>
				<c:set var="ALTwRebate" value="${row.getAltHealthPricePremium().getWeeklyPremium() * rebateCalcReal_changeover}" />
					<weekly>
						<health:price_service_premium
								discount="${discountOthers}" prm="${row.getAltHealthPricePremium().getWeeklyPremium()}"
									rebateCalc="${rebateCalc_changeover}" loading="${loading}"
									healthRebate="${ALTwRebate}"
								rebate="${rebate_changeover}" lhc="${row.getAltHealthPricePremium().getWeeklyLhc()}"
									star="${starOthers}"
									active_fund="${active_fund}"
									membership="${membership}" />
					</weekly>
				<c:set var="ALThRebate" value="${row.getAltHealthPricePremium().getHalfYearlyPremium() * rebateCalcReal_changeover}" />
					<halfyearly>
						<health:price_service_premium
									discount="${discountOthers}"
								prm="${row.getAltHealthPricePremium().getHalfYearlyPremium()}"
									rebateCalc="${rebateCalc_changeover}" loading="${loading}"
									healthRebate="${ALThRebate}"
								rebate="${rebate_changeover}" lhc="${row.getAltHealthPricePremium().getHalfYearlyLhc()}"
									star="${starOthers}"
									active_fund="${active_fund}"
									membership="${membership}"/>
					</halfyearly>
				</altPremium>

			<%-- set up extra and  hospital cover name --%>
			<c:set var="row" value="${healthPriceDetailService.setUpExtraName(row)}" />
			<c:set var="row" value="${healthPriceDetailService.setUpHospitalName(row)}" />

				<%-- Add the providers promo XML to the session so as to avoid retrieving it multiple times --%>
				<c:choose>
					<c:when test="${empty data.tempProvidersPromoXML or empty data.tempProvidersPromoXML[active_fund]}">
					<c:set var="promoXML"><health:price_service_promo providerId="${row.getProviderId()}" healthPriceService="${healthPriceService}" /></c:set>
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
					<x:param name="extras" value="${row.getExtrasName()}" />
					<x:param name="hospital" value="${row.getHospitalName()}" />
					</x:transform>
				</c:set>

				<promo>${transformedPromoXML}</promo>

			<%-- set up phio data --%>
			<c:set var="row" value="${healthPriceDetailService.setUpPhioData(row)}" />
			<go:log source="health:price_service_results" level="TRACE" >${row.getPhioData()}</go:log>
			<c:out value="${row.getPhioData()}" escapeXml="false" />

			</result>
</c:forEach>

<%-- Remove temporary provider promo content from the session --%>
<go:setData dataVar="data" value="*DELETE" xpath="tempProvidersPromoXML" />