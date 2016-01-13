<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<settings:setVertical verticalCode="GENERIC" />
<c:set var="transactionId">
	<c:out value="${param.transactionId}" escapeXml="true" />
</c:set>
<c:set var="productId">
	<c:out value="${param.productId}" escapeXml="true" />
</c:set>
<c:set var="revision" value="${webUtils.buildRevisionAsQuerystringParam()}" />

<jsp:useBean id="resultsService" class="com.ctm.web.core.services.ResultsService" scope="request" />

<c:set var="quoteUrl" value="${fn:replace(resultsService.getSingleResultPropertyValue(transactionId, productId, 'quoteUrl'),'%26','&') }" />
<c:set var="brandCode" value="${fn:replace(resultsService.getSingleResultPropertyValue(transactionId, productId, 'brandCode'),'%26','&') }" />

<c:set var="isTrackingEnabled">
	<content:get key="trackingEnabled" />
</c:set>

<c:if test="${isTrackingEnabled eq true}">
	<c:set var="providerCode">providerCode</c:set>
	<c:if test="${param.vertical}"
	<c:set var="quoteUrl">
		 <content:get key="PHGHandoverTracking" /><content:get key="PHGHandoverTracking" suppKey="" />
	</c:set>
</c:if>

<%-- HTML --%>
<layout:generic_page title="Transferring you...">

	<jsp:attribute name="head">
		<link rel="stylesheet" href="${assetUrl}assets/brand/${pageSettings.getBrandCode()}/css/transferring${pageSettings.getSetting('minifiedFileString')}.css?${revision}" media="all">
		<script>
			alert("brandcode [${brandCode} ] (${pageSettings.getBrandCode()})");
			<%-- In case we want to turn off looped URI Decoding --%>
			window.useLoopedTransferringURIDecoding = ${pageSettings.getSetting("useLoopedTransferringURIDecoding")};

			<%-- Mock underscore.js (_) because we don't need it but our framework insists that it is required :( --%>
			window._ = {};
			var properties = ['debounce', 'isNull', 'isUndefined', 'template', 'bind', 'isEmpty'];
			for(var i = 0; i < properties.length; i++){
				window._[properties[i]] = function() {};
			}

			<%-- Mock results objects because same reason as above --%>
			window.ResultsModel = { moduleEvents: { WEBAPP_LOCK: 'WEBAPP_LOCK' } };
			window.ResultsView = { moduleEvents: { RESULTS_TOGGLE_MODE: 'RESULTS_TOGGLE_MODE' } };
		</script>
		<script src="${assetUrl}assets/js/bundles/transferring${pageSettings.getSetting('minifiedFileString')}.js?${revision}"></script>
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
	</jsp:attribute>

	<jsp:body>
		<div id="pageContent">

			<article class="container">

				<div id="journeyEngineContainer">
					<div id="journeyEngineLoading" class="journeyEngineLoader opacityTransitionQuick">
						<span id="logo" class="navbar-brand text-hide">Compare The Market Australia</span>
						<div class="spinner">
							<div class="bounce1"></div>
							<div class="bounce2"></div>
							<div class="bounce3"></div>
						</div>
						<p class="message">Please wait while we transfer you</p>
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

</layout:generic_page>