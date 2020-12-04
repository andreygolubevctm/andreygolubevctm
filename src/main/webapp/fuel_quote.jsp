<%--
	FUEL quote page
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<link rel="manifest" href="manifest.json" />
<%@ include file="/WEB-INF/tags/taglib.tagf"%>
<script type="application/javascript">
	if ('serviceWorker' in navigator) {
		navigator.serviceWorker.register('./service-worker.js', { scope: '/ctm/fuel_quote.jsp' }).catch(function(err) {
			console.warn('Error whilst registering service worker', err);
		});
	}
</script>

<session:new verticalCode="FUEL" authenticated="true" />

<core_v2:quote_check quoteType="fuel" />

<c:if test="${empty param.action}">
	<go:setData dataVar="data" value="*DELETE" xpath="fuel" />
</c:if>

<%-- Check requests from IP and throw 429 if limit exceeded. --%>
<jsp:useBean id="sessionDataService" class="com.ctm.web.core.services.SessionDataService" />
<jsp:useBean id="ipCheckService" class="com.ctm.web.core.services.IPCheckService" />
<c:choose>
	<%-- Remove session and throw 429 error if request limit exceeded --%>
	<c:when test="${!ipCheckService.isWithinLimitAsBoolean(pageContext.request, pageSettings)}">
		<c:set var="removeSession" value="${sessionDataService.removeSessionForTransactionId(pageContext.request, data.current.transactionId)}" />
	<%	response.sendError(429, "Number of requests exceeded!" ); %>
	</c:when>
	<%-- Only proceed if number of requests not exceeded --%>
	<c:otherwise>
		<%-- PRELOAD DATA --%>
		<core_v2:load_preload />

		<%-- Set global variable to flags for active split tests --%>
		<fuel:splittest_helper />

		<%-- HTML --%>
		<layout_v1:journey_engine_page_fluid title="Fuel Quote">

			<jsp:attribute name="head"></jsp:attribute>

			<jsp:attribute name="head_meta">
				<meta name="apple-mobile-web-app-title" content="Fuel Prices">
			</jsp:attribute>

			<jsp:attribute name="header">
			</jsp:attribute>

    <jsp:attribute name="header_nav_section">
        <c:if test="${not empty customerAccountsAuthHeaderSplitTest and customerAccountsAuthHeaderSplitTest eq true}">
            <c:if test="${pageSettings.getBrandCode() eq 'ctm'}">
                <div class="authHeaderContainer smallAuth">
                    <div data-microui-component="AuthHeader" class="authHeaderSmall authHeaderElement"></div>
                    <script type="application/javascript">
                        // @param n = UMD library name ie soarExampleMicroUI
                        // @param c = component name ie Foo
                        // @param p = props to be passed to mounted component
                        (function(n, c, p) {
                            var w = window, m = function(e){
                              if (e.detail.name === n) {
                                var env = w['__MicroUIcustomerAccountsMicroUIEnvironment__'];
                                w[n].Render(document.querySelector('div.authHeaderSmall[data-microui-component="' +c +'"]'),c, { env: env });
                              }
                            };
                            if (w[n]) {
                                m();
                            } else {
                                w.addEventListener('microUILoaded', m);
                            }
                        })('customerAccountsMicroUI', 'AuthHeader', {});
                    </script>
                </div>
            </c:if>
        </c:if>
	</jsp:attribute>

			<jsp:attribute name="progress_bar">
			</jsp:attribute>

			<jsp:attribute name="navbar_additional"></jsp:attribute>

			<jsp:attribute name="navbar_outer">
			</jsp:attribute>

			<jsp:attribute name="results_loading_message"></jsp:attribute>


			<jsp:attribute name="form_bottom"></jsp:attribute>

			<jsp:attribute name="footer">
                <core_v1:whitelabeled_footer />
			</jsp:attribute>

			<jsp:attribute name="vertical_settings">
				<fuel:settings />
			</jsp:attribute>

			<jsp:attribute name="body_end">
				<script type="text/javascript" src="https://www.google.com/jsapi"></script>
			</jsp:attribute>

			<jsp:body>
				<%-- Slides --%>
                <div id="google-map-container">
					<fuel:overlay_sidebar />
                    <div id="map-canvas" style="width: 100%;"></div>
					<fuel:results_templates />
                </div>

				<div class="hiddenFields">
					<form_v1:operator_id xpath="${pageSettings.getVerticalCode()}/operatorid" />
					<core_v1:referral_tracking vertical="${pageSettings.getVerticalCode()}" />
				</div>

				<input type="hidden" name="transcheck" id="transcheck" value="1" />
                <div id="info-window-container-xs" class="visible-xs">
                    <fuel:fuel_infoWindow />
                </div>

                <div id="price-band-container-xs" class="price-bands visible-xs">
                    <fuel:price_bands_template />
                </div>

				<fuel:sign_up />
			</jsp:body>

		</layout_v1:journey_engine_page_fluid>
	</c:otherwise>
</c:choose>
