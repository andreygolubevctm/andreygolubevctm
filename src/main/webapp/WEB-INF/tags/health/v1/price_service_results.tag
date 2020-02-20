<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:set var="logger" value="${log:getLogger('tag.health.price_service_result')}" />

<jsp:useBean id="data" class="com.ctm.web.core.web.go.Data" scope="request" />

<%@ attribute name="rows" type="java.util.ArrayList" required="true" rtexprvalue="true"	 description="recordset" %>
<%@ attribute name="healthXML" required="true" rtexprvalue="true" description="loading" type="org.apache.xerces.dom.NodeImpl" %>
<%@ attribute name="healthPriceService" type="com.ctm.web.health.services.HealthPriceService" required="true" rtexprvalue="true"	 description="recordset" %>

<jsp:useBean id="healthPriceDetailService" class="com.ctm.web.health.services.HealthPriceDetailService" scope="page" />

<c:set var="healthPriceRequest" value="${healthPriceService.getHealthPriceRequest()}" />
<c:set var="loading" value="${healthPriceRequest.getLoading()}" />
<c:set var="membership" value="${healthPriceRequest.getMembership()}" />

<c:set var="accountType"><x:out select="$healthXML/request/details/accountType" /></c:set>
<c:set var="transactionId"><x:out select="$healthXML/request/header/partnerReference" /></c:set>

<c:set var="rebateChangeover" value="${healthPriceService.getRebateChangeover()}" />
<c:set var="rebate" value="${healthPriceService.getRebate()}" />

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
		<c:set var="discountRates" value="${healthPriceService.hasDiscountRates(active_fund, accountType)}" />
		<c:set var="row" value="${healthPriceDetailService.setUpDiscountRates(row, discountRates)}" />

		<%-- set up premimum and lhc for normal prcing --%>
		<c:set var="row" value="${healthPriceDetailService.setUpPremiumAndLhc(row, false)}" />

			<%-- Only attempt to find future price if fund NOT disabled --%>
		<c:if test="${healthPriceDetailService.isAlternatePriceDisabledForResult(pageContext.getRequest(), healthPriceRequest.getStyleCodeId(), row) eq false}">

				<%-- ALTERNATE PRICING --%>
			<c:set var="row" value="${healthPriceService.setUpProductUpi(row)}" />

				<%-- Get the alternate product prices - if alt product exists then use that product
				Otherwise the premium will be 0 and says coming soon --%>
			<c:set var="row" value="${healthPriceDetailService.setUpPremiumAndLhc(row, true)}" />

				</c:if>
			<%-- Just made the brtag blank to assist with merging the trunk (Leto told me too!) --%>
			<c:set var="brtag" value=" " />

			<fmt:setLocale value="en_US" />
		<result productId="${row.getProductCat()}-${row.getProductId()}">
				<restrictedFund>
				<c:choose>
				<c:when test="${active_fund eq 'CBH' || active_fund eq 'THF' || active_fund eq 'NHB' }">Y</c:when>
					<c:otherwise>N</c:otherwise>
				</c:choose>
				</restrictedFund>
			<provider>${active_fund}</provider>
			<providerName>${row.getFundName()}</providerName>
			<providerId>${row.getProviderId()}</providerId>
			<productCode><c:out value="${row.getProductCode()}" escapeXml="true"/></productCode>
			<name><c:out value="${row.getLongTitle()}" escapeXml="true"/></name>
			<des><c:out value="${row.getLongTitle()}" escapeXml="true"/></des>
			<rank><c:out value="${row.getRank()+0}" escapeXml="true"/></rank>

			<premium>
				<annually>
					<health_v1:price_service_premium
								grossPrm="${row.getHealthPricePremium().getGrossAnnualPremium()}"
								prm="${row.getHealthPricePremium().getAnnualPremium()}"
								loading="${loading}"
								rebate="${rebate}"
								lhc="${row.getHealthPricePremium().getAnnualLhc()}"
								membership="${membership}" />
				</annually>
				<halfyearly>
					<health_v1:price_service_premium
								grossPrm="${row.getHealthPricePremium().getGrossHalfYearlyPremium()}"
								prm="${row.getHealthPricePremium().getHalfYearlyPremium()}"
								loading="${loading}"
								rebate="${rebate}"
								lhc="${row.getHealthPricePremium().getHalfYearlyLhc()}"
								membership="${membership}" />
				</halfyearly>
					<quarterly>
					<health_v1:price_service_premium
								grossPrm="${row.getHealthPricePremium().getGrossQuarterlyPremium()}"
								prm="${row.getHealthPricePremium().getQuarterlyPremium()}"
								loading="${loading}"
								rebate="${rebate}"
								lhc="${row.getHealthPricePremium().getQuarterlyLhc()}"
									membership="${membership}" />
					</quarterly>
					<monthly>
						<health_v1:price_service_premium
								grossPrm="${row.getHealthPricePremium().getGrossMonthlyPremium()}"
								prm="${row.getHealthPricePremium().getMonthlyPremium()}"
								loading="${loading}"
								rebate="${rebate}"
								lhc="${row.getHealthPricePremium().getMonthlyLhc()}"
									membership="${membership}" />
					</monthly>
					<fortnightly>
					<health_v1:price_service_premium
								grossPrm="${row.getHealthPricePremium().getGrossFortnightlyPremium()}"
								prm="${row.getHealthPricePremium().getFortnightlyPremium()}"
								loading="${loading}"
								rebate="${rebate}"
								lhc="${row.getHealthPricePremium().getFortnightlyLhc()}"
									membership="${membership}" />
					</fortnightly>
					<weekly>
					<health_v1:price_service_premium
								grossPrm="${row.getHealthPricePremium().getGrossWeeklyPremium()}"
								prm="${row.getHealthPricePremium().getWeeklyPremium()}"
								loading="${loading}"
								rebate="${rebate}"
								lhc="${row.getHealthPricePremium().getWeeklyLhc()}"
									membership="${membership}" />
					</weekly>
				</premium>

				<%-- Render the alternate Premium: NOTE see premium for full entry details --%>
				<altPremium>
					<annually>
						<health_v1:price_service_premium
								grossPrm="${row.getAltHealthPricePremium().getGrossAnnualPremium()}"
								prm="${row.getAltHealthPricePremium().getAnnualPremium()}"
								loading="${loading}"
								rebate="${rebateChangeover}"
								lhc="${row.getAltHealthPricePremium().getAnnualLhc()}"
									membership="${membership}" />

					</annually>
					<quarterly>
						<health_v1:price_service_premium
								grossPrm="${row.getAltHealthPricePremium().getGrossQuarterlyPremium()}"
								prm="${row.getAltHealthPricePremium().getQuarterlyPremium()}"
								loading="${loading}"
								rebate="${rebateChangeover}"
								lhc="${row.getAltHealthPricePremium().getQuarterlyLhc()}"
									membership="${membership}"/>
					</quarterly>
					<monthly>
						<health_v1:price_service_premium
								grossPrm="${row.getAltHealthPricePremium().getGrossMonthlyPremium()}"
								prm="${row.getAltHealthPricePremium().getMonthlyPremium()}"
								loading="${loading}"
								rebate="${rebateChangeover}"
								lhc="${row.getAltHealthPricePremium().getMonthlyLhc()}"
									membership="${membership}"/>
					</monthly>
					<fortnightly>
						<health_v1:price_service_premium
								grossPrm="${row.getAltHealthPricePremium().getGrossFortnightlyPremium()}"
								prm="${row.getAltHealthPricePremium().getFortnightlyPremium()}"
								loading="${loading}"
								rebate="${rebateChangeover}"
								lhc="${row.getAltHealthPricePremium().getFortnightlyLhc()}"
									membership="${membership}"/>
					</fortnightly>
					<weekly>
						<health_v1:price_service_premium
								grossPrm="${row.getAltHealthPricePremium().getGrossWeeklyPremium()}"
								prm="${row.getAltHealthPricePremium().getWeeklyPremium()}"
								loading="${loading}"
								rebate="${rebateChangeover}"
								lhc="${row.getAltHealthPricePremium().getWeeklyLhc()}"
									membership="${membership}" />
					</weekly>
					<halfyearly>
						<health_v1:price_service_premium
								grossPrm="${row.getAltHealthPricePremium().getGrossHalfYearlyPremium()}"
								prm="${row.getAltHealthPricePremium().getHalfYearlyPremium()}"
								loading="${loading}"
								rebate="${rebateChangeover}"
								lhc="${row.getAltHealthPricePremium().getHalfYearlyLhc()}"
									membership="${membership}"/>
					</halfyearly>
				</altPremium>

			<%-- set up extra and  hospital cover name --%>
			<c:set var="row" value="${healthPriceDetailService.setUpExtraName(row)}" />
			<c:set var="row" value="${healthPriceDetailService.setUpHospitalName(row)}" />

				<%-- Add the providers promo XML to the session so as to avoid retrieving it multiple times --%>
				<c:choose>
					<c:when test="${empty data.tempProvidersPromoXML or empty data.tempProvidersPromoXML[active_fund]}">
					<c:set var="promoXML"><health_v1:price_service_promo providerId="${row.getProviderId()}" healthPriceService="${healthPriceService}" /></c:set>
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
			${logger.trace('Got phio data. {}', log:kv('phioData',row.getPhioData()))}
			<c:out value="${row.getPhioData()}" escapeXml="false" />

			</result>
</c:forEach>

<%-- Remove temporary provider promo content from the session --%>
<go:setData dataVar="data" value="*DELETE" xpath="tempProvidersPromoXML" />