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

<jsp:useBean id="resultsService" class="com.ctm.web.core.results.services.ResultsService" scope="request" />

<c:set var="quoteUrl" value="${fn:replace(resultsService.getSingleResultPropertyValue(transactionId, productId, 'quoteUrl'),'%26','&') }" />

<%-- HTML --%>
<layout:generic_page title="Transferring you...">

	<jsp:attribute name="head">
		<link rel="stylesheet" href="${assetUrl}assets/brand/${pageSettings.getBrandCode()}/css/transferring${pageSettings.getSetting('minifiedFileString')}.css?${revision}" media="all">
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
	</jsp:body>

</layout:generic_page>