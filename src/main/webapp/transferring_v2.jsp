<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<settings:setVertical verticalCode="GENERIC" />
<c:set var="isDev" value="${environmentService.getEnvironmentAsString() eq 'localhost' || environmentService.getEnvironmentAsString() eq 'NXI'}"/>
<c:set var="transactionId">
	<c:out value="${param.transactionId}" escapeXml="true" />
</c:set>
<c:set var="productId">
	<c:out value="${param.productId}" escapeXml="true" />
</c:set>
<c:set var="revision" value="${webUtils.buildRevisionAsQuerystringParam()}" />

<jsp:useBean id="resultsService" class="com.ctm.web.core.services.ResultsService" scope="request" />
<jsp:useBean id="configurationService" class="com.ctm.web.core.services.ServiceConfigurationService" scope="request" />
<c:set var="providerCode" value="brandCode" /> <%-- prefer to use providerCode which makes more sense than brandCode --%>
<c:if test="${param.vertical eq 'travel'}"><c:set var="providerCode" value="providerCode" /></c:if>
<c:set var="providerCode" value="${fn:replace(resultsService.getSingleResultPropertyValue(transactionId, productId, providerCode),'%26','&') }" />
<c:set var="quoteUrl" value="${fn:replace(resultsService.getQuoteUrl(transactionId, productId, 'quoteUrl', providerCode, param.vertical),'%26','&') }" />

<c:set var="verticalBrandCode" value="${pageSettings.getBrandCode()}" />
<c:set var="trackingEnabled" value="${contentService.getContentValue(pageContext.getRequest(), 'trackingEnabled', verticalBrandCode, param.vertical)}" />

<c:set var="gaClientId" value="${fn:replace(resultsService.getSingleResultPropertyValue(transactionId, productId, 'gaClientId'),'%26','&') }" />

<c:if test="${trackingEnabled eq true and not empty quoteUrl and quoteUrl != 'DUPLICATE'}">
	<c:set var="trackingURL" value="${contentService.getContentValue(pageContext.getRequest(), 'handoverTrackingURL', verticalBrandCode, param.vertical)}" />
	<c:set var="trackingCode" value="${contentService.getContentWithSupplementary(pageContext.getRequest(), 'handoverTrackingURL', verticalBrandCode, param.vertical).getSupplementaryValueByKey(providerCode)}" />

	<c:set var="quoteUrl">
			<c:out value="${trackingURL}" />${trackingCode}/pubref:${gaClientId}/adref:${transactionId}/destination:${quoteUrl}
	</c:set>
</c:if>


<%-- HTML --%>
<layout_v1:generic_page title="Transferring you...">

	<jsp:attribute name="head">
		<link rel="stylesheet" href="${assetUrl}assets/brand/${pageSettings.getBrandCode()}/css/transferring_v2${pageSettings.getSetting('minifiedFileString')}.css?${revision}" media="all">
		<script>
			<%-- In case we want to turn off looped URI Decoding --%>
			window.useLoopedTransferringURIDecoding = ${pageSettings.getSetting("useLoopedTransferringURIDecoding")};

			<%-- Mock results objects because same reason as above --%>
			window.ResultsModel = { moduleEvents: { WEBAPP_LOCK: 'WEBAPP_LOCK' } };
			window.ResultsView = { moduleEvents: { RESULTS_TOGGLE_MODE: 'RESULTS_TOGGLE_MODE' } };
		</script>

		<%--  Underscore --%>
		<c:if test="${isDev eq false}">
			<script src="//cdnjs.cloudflare.com/ajax/libs/underscore.js/1.8.3/underscore-min.js"></script>
		</c:if>
		<script>window._ || document.write('<script src="${assetUrl}assets/libraries/underscore-1.8.3.min.js">\x3C/script>')</script>
	</jsp:attribute>

	<jsp:attribute name="head_meta">
	</jsp:attribute>

	<jsp:attribute name="header">
	</jsp:attribute>


	<jsp:attribute name="form_bottom">
	<%-- If a provider wants to POST instead of GET from handover page --%>
	<input type="hidden" name="transcheck" id="transcheck" value="1" />
	</jsp:attribute>

	<jsp:attribute name="footer">
	</jsp:attribute>

	<jsp:attribute name="body_end">
        <script src="${assetUrl}assets/js/bundles/transferring_v2${pageSettings.getSetting('minifiedFileString')}.js?${revision}"></script>
	</jsp:attribute>

	<jsp:body>
		<div id="pageContent">

			<article class="container">

				<div id="journeyEngineContainer">
					<div id="journeyEngineLoading" class="journeyEngineLoader opacityTransitionQuick">
						<span id="logo" class="navbar-brand text-hide">Compare The Market Australia</span>
                        <p class="custom-message text-tertiary">${contentService.getContentValue(pageContext.getRequest(), "customTransferringContent", verticalBrandCode, param.vertical)}</p>
						<p class="message">
							<c:choose>
								<c:when test="${param.vertical eq 'car' || param.vertical eq 'home'}">
									${contentService.getContentValue(pageContext.getRequest(), "transferringText", verticalBrandCode, param.vertical)}
								</c:when>
								<c:otherwise>
									<content:get key="transferringText" />
								</c:otherwise>
							</c:choose>
						</p>
                        <p class="no-redirect">If you are not redirected in 3 seconds <a href="${quoteUrl}">click here</a></p>
                        <div class="spinner">
                            <div class="bounce1"></div>
                            <div class="bounce2"></div>
                            <div class="bounce3"></div>
                        </div>
                        <c:if test='${contentService.getContentValue(pageContext.getRequest(), "transferringLogoEnabled", verticalBrandCode, param.vertical) eq "Y"}'>
                            <img src="assets/graphics/logos/${param.vertical}/src/${providerCode}.png" />
                        </c:if>
						<div class="quoteUrl" quoteUrl="${quoteUrl}"></div>
					</div>
				</div>
			</article>

		</div>

		<%-- Test the tracking codes --%>
		<c:if test="${ (not empty param.trackCode) && (param.trackCode != 'undefined')}">
			<fmt:parseNumber var="trackCode" type="number" value="${param.trackCode}" integerOnly="true" />
			<c:if test="${not empty trackCode}">
				<img src="https://partners.comparethemarket.com.au/z/${trackCode}/CD1/${transactionId}" />
			</c:if>
		</c:if>

		<input type="hidden" id="generic_currentJourney" />
	</jsp:body>

</layout_v1:generic_page>
