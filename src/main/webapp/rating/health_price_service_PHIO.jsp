<%@ page language="java" contentType="text/xml; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:set var="logger" value="${log:getLogger('jsp.rating.health_price_service_PHIO')}" />

<jsp:useBean id="resultsList" class="java.util.ArrayList" scope="request" />
<jsp:useBean id="healthPriceService" class="com.ctm.web.health.services.HealthPriceService" scope="page" />
<jsp:useBean id="healthPriceResultsService" class="com.ctm.web.health.services.HealthPriceResultsService" scope="page" />
<jsp:useBean id="healthPriceRequest" class="com.ctm.web.health.model.HealthPriceRequest" scope="page" />

<x:parse var="healthXML" xml="${param.QuoteData}" />

<c:set var="applicationDate"><x:out select="$healthXML/request/header/applicationDate" /></c:set>
<c:set var="transactionId"><x:out select="$healthXML/request/header/partnerReference" /></c:set>
<c:set var="isSimples"><x:out select="$healthXML/request/header/isSimples = 'Y'" escapeXml="false"/></c:set>
<c:set var="showAll"><x:out select="$healthXML/request/header/showAll = 'Y'" /></c:set>
<c:set var="directApplication"><x:out select="$healthXML/request/header/directApplication = 'Y'" /></c:set>
<c:set var="onResultsPage"><x:out select="$healthXML/request/header/onResultsPage = 'Y'" /></c:set>
<c:set var="rebate"><x:out select="$healthXML/request/details/rebate" escapeXml="false" /></c:set>
<c:set var="rebateChangeover"><x:out select="$healthXML/request/details/rebateChangeover" escapeXml="false" /></c:set>
<c:set var="paymentFrequency"><x:out select="$healthXML/request/header/paymentFrequency" /></c:set>
<c:set var="preferences"><x:out select="$healthXML/request/details/preferences" escapeXml="false" /></c:set>
<c:set var="state"><x:out select="$healthXML/request/details/state" /></c:set>
<c:set var="cover"><x:out select="$healthXML/request/details/cover" /></c:set>
<c:set var="productType"><x:out select="$healthXML/request/details/productType" /></c:set>
<c:set var="excessSel"><x:out select="$healthXML/request/details/excess"/></c:set>
<c:set var="tierHospital"><x:out select="$healthXML/request/header/filter/tierHospital" /></c:set>
<c:set var="tierExtras"><x:out select="$healthXML/request/header/filter/tierExtras" /></c:set>
<c:set var="privateHospital"><x:out select="$healthXML/request/details/prHospital='Y'" /></c:set>
<c:set var="publicHospital"><x:out select="$healthXML/request/details/puHospital='Y'" /></c:set>
<c:set var="loading"><x:out select="$healthXML/request/details/loading" escapeXml="false" /></c:set>
<c:set var="providerId"><x:out select="$healthXML/request/header/providerId" /></c:set>
<c:set var="brandFilter"><x:out select="$healthXML/request/header/brandFilter" /></c:set>
<c:set var="searchDate"><x:out select="$healthXML/request/details/searchDate" /></c:set>
<c:set var="priceMinimum"><x:out select="$healthXML/request/header/priceMinimum" /></c:set>
<c:set var="searchResults"><x:out select="$healthXML/request/details/searchResults" /></c:set>
<c:set var="retrieveSavedResults"><x:out select="$healthXML/request/header/retrieve/savedResults = 'Y'" /></c:set>
<c:set var="savedTransactionId"><x:out select="$healthXML/request/header/retrieve/transactionId" /></c:set>
<c:set var="productTitleSearch"><x:out select="$healthXML/request/header/productTitleSearch" escapeXml="false" /></c:set>
<c:set var="productTitle"><x:out select="$healthXML/request/header/productTitle" escapeXml="false" /></c:set>
<%-- Unencode apostrophes --%>
<c:set var="productTitle" value="${fn:replace(productTitle, '&#039;', '\\'')}" />
<c:set var="productTitle" value="${fn:replace(productTitle, '&#39;', '\\'')}" />

<c:set var="selectedProductId"><x:out select="$healthXML/request/header/productId" /></c:set>
<c:if test="${fn:startsWith(selectedProductId, 'PHIO-HEALTH-') and fn:length(selectedProductId) > 12}">
	<c:set var="selectedProductId" value="${fn:substringAfter(selectedProductId, 'PHIO-HEALTH-')}" />
</c:if>

<jsp:useBean id="changeOverRebatesService" class="com.ctm.web.simples.services.ChangeOverRebatesService" />
<c:set var="changeOverRebates" value="${changeOverRebatesService.getChangeOverRebate(null)}"/>
<c:set var="rebate_multiplier_current" value="${changeOverRebates.getCurrentMultiplier()}"/>
<c:set var="rebate_multiplier_future" value="${changeOverRebates.getFutureMultiplier()}"/>

<c:if test="${not empty providerId}">${healthPriceRequest.setProviderId(providerId)}</c:if>
<c:if test="${not empty tierHospital}">${healthPriceRequest.setTierHospital(tierHospital)}</c:if>
<c:if test="${not empty tierExtras}">${healthPriceRequest.setTierExtras(tierExtras)}</c:if>
<c:if test="${not empty searchResults}">${healthPriceRequest.setSearchResults(searchResults)}</c:if>
${healthPriceRequest.setPriceMinimum(priceMinimum)}
${healthPriceRequest.setProductTitle(productTitle)}
${healthPriceRequest.setDirectApplication(directApplication)}
${healthPriceRequest.setProductTitleSearch(productTitleSearch)}
${healthPriceRequest.setPaymentFrequency(paymentFrequency)}
${healthPriceRequest.setState(state)}
${healthPriceRequest.setProductType(productType)}
${healthPriceRequest.setPrivateHospital(privateHospital)}
${healthPriceRequest.setPublicHospital(publicHospital)}
${healthPriceRequest.setLoading(loading)}
${healthPriceRequest.setExcessSel(excessSel)}
${healthPriceRequest.setSelectedProductId(selectedProductId)}
${healthPriceRequest.setRetrieveSavedResults(retrieveSavedResults)}
${healthPriceRequest.setSavedTransactionId(savedTransactionId)}
${healthPriceRequest.setOnResultsPage(onResultsPage)}
${healthPriceRequest.setPreferences(preferences)}
${healthPriceRequest.setBrandFilter(brandFilter)}

${healthPriceService.setHealthPriceRequest(healthPriceRequest)}

${healthPriceService.setMembership(cover)}
${healthPriceService.setSearchDate(searchDate)}
${healthPriceService.setChangeoverDate(changeOverRebates.getEffectiveStart())}
${healthPriceService.setRebateCurrent(rebate)}
${healthPriceService.setRebateChangeover(rebateChangeover)}
${healthPriceService.setTransactionId(transactionId)}
${healthPriceService.getHealthPriceRequest().setIsSimples(isSimples)}
${healthPriceService.setShowAll(showAll)}
${healthPriceService.setApplicationDate(applicationDate)}
${healthPriceService.setup()}
${logger.trace('Starting results jsp. {}', log:kv('quoteData ', param.QuoteData ))}

			<c:choose>
	<c:when test="${showAll}">
		<c:set var="resultsList" value="${healthPriceResultsService.fetchHealthResults(healthPriceService.getHealthPriceRequest())}" scope="request"/>
				</c:when>
				<c:otherwise>
		<c:set var="resultsList" value="${healthPriceResultsService.fetchSingleHealthResult(healthPriceService.getHealthPriceRequest())}" scope="request"/>
				</c:otherwise>
			</c:choose>

			<c:choose>
	<%--fail because we don't know which product is valid --%>
	<c:when test="${resultsList.size() > 1 && !onResultsPage}">
		<c:import var="fatal_error" url="/ajax/write/register_fatal_error.jsp">
			<c:param name="page" value="${pageContext.request.servletPath}" />
			<c:param name="message" value="duplicate products returned" />
			<c:param name="description" value="${resultsList}" />
		</c:import>
	</c:when>
	<c:otherwise>
<%-- Build the xml data for each row --%>
<results>
			<health:price_service_results rows="${resultsList}" healthXML="${healthXML}" healthPriceService="${healthPriceService}" />
			<pricesHaveChanged>${healthPriceService.getHealthPriceRequest().getPricesHaveChanged()}</pricesHaveChanged>
			<transactionId>${transactionId}</transactionId>
	<c:if test="${onResultsPage && showAll}">
		${healthPriceService.getHealthPricePremiumRange().toXML()}
	</c:if>
</results>
	</c:otherwise>
</c:choose>