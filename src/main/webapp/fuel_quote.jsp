<%--
	FUEL quote page
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

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

		<%-- HTML --%>
		<layout_v1:journey_engine_page_fluid title="Fuel Quote">

			<jsp:attribute name="head"></jsp:attribute>

			<jsp:attribute name="head_meta">
				<meta name="apple-mobile-web-app-title" content="Fuel Prices">
			</jsp:attribute>

			<jsp:attribute name="header">
			</jsp:attribute>

			<jsp:attribute name="progress_bar">
			</jsp:attribute>

			<jsp:attribute name="navbar">
				<ul class="nav navbar-nav" role="menu">
					<core_v2:offcanvas_header />
					<li class="dropdown dropdown-interactive slide-feature-emailquote" id="email-quote-dropdown">
						<a class="activator needsclick btn-email dropdown-toggle" data-toggle="dropdown" href="javascript:;">
							<span class="icon icon-envelope"></span>
							<span>Sign Up for News and Offers!</span>
							<b class="caret"></b>
						</a>
						<div class="dropdown-menu dropdown-menu-large" role="menu" aria-labelledby="dLabel">
							<div class="dropdown-container">
								<fuel:sign_up />
							</div>
						</div>
					</li>
				</ul>
			</jsp:attribute>

			<jsp:attribute name="navbar_additional"></jsp:attribute>

			<jsp:attribute name="navbar_outer">
			</jsp:attribute>

			<jsp:attribute name="results_loading_message"></jsp:attribute>


			<jsp:attribute name="form_bottom"></jsp:attribute>

			<jsp:attribute name="footer">
                <%-- TODO: add signup box --%>
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
                    <div id="map-canvas" style="width: 100%; height: 100%"></div>
					<fuel:results_templates />
                </div>

				<div class="hiddenFields">
					<form_v1:operator_id xpath="${pageSettings.getVerticalCode()}/operatorid" />
					<core_v1:referral_tracking vertical="${pageSettings.getVerticalCode()}" />
				</div>

				<input type="hidden" name="transcheck" id="transcheck" value="1" />
                <fuel:fuel_map />
			</jsp:body>

		</layout_v1:journey_engine_page_fluid>
	</c:otherwise>
</c:choose>