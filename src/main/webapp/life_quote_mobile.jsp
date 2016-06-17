<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<settings:setVertical verticalCode="LIFE" />
<c:set var="mobileVariant" value="${pageSettings.getSetting('mobileVariant') eq 'Y'}" />
<jsp:useBean id="userAgentSniffer" class="com.ctm.web.core.services.UserAgentSniffer" />
<c:set var="deviceType" value="${userAgentSniffer.getDeviceType(pageContext.getRequest().getHeader('user-agent'))}" />
<c:if test="${mobileVariant eq false or deviceType ne 'MOBILE'}">
	<c:set var="redirectURL" value="${pageSettings.getBaseUrl()}life_quote.jsp#/?stage=start" />
	<c:redirect url="${fn:substring(redirectURL,0,fn:length(redirectURL))}" />
</c:if>

<session:new verticalCode="LIFE" authenticated="true" />
<jsp:useBean id="serviceConfigurationService" class="com.ctm.web.core.services.ServiceConfigurationService" scope="session"/>

<core_v2:quote_check quoteType="life" />
<core_v2:load_preload />

<life_v1:widget_values />

<%-- Initialise Save Quote --%>
<c:set var="saveQuoteEnabled" scope="request">${pageSettings.getSetting('saveQuote')}</c:set>

<%-- Life Broker Number--%>
<c:set var="lifeBrokerNumber" scope="request"><content:get key="lifeBrokerNumber"/></c:set>

<%-- HTML --%>
<layout_v1:journey_engine_page title="Life Quote">

	<jsp:attribute name="head"></jsp:attribute>
	<jsp:attribute name="head_meta"></jsp:attribute>
	<jsp:attribute name="header_button_left">
		<button type="button" class="navbar-toggle contact collapsed pull-left" data-toggle="collapse" data-target=".header-collapse-contact">
			<span class="sr-only">Toggle Contact Us</span>
			<span class="icon icon-phone"></span>
			<span class="icon icon-cross"></span>
		</button>
	</jsp:attribute>

	<jsp:attribute name="header">
		<div class="navbar-collapse header-collapse-contact collapse">
			<ul class="nav navbar-nav navbar-right callCentreNumberSection">
				<c:if test="${not empty lifeBrokerNumber}">
					<li>
						<div class="navbar-text visible-xs">
							<h4>Do you need a hand?</h4>
							<h1>
								<a class="needsclick" href="tel:${lifeBrokerNumber}">
									Call <span class="noWrap callCentreNumber">${lifeBrokerNumber}</span>
								</a>
							</h1>
						</div>
					</li>
				</c:if>
			</ul>
		</div>
	</jsp:attribute>

	<jsp:attribute name="progress_bar">
	  <div class="progress-bar-row collapse navbar-collapse">
		  <div class="container">
			  <ul class="journeyProgressBar_v2"></ul>
		  </div>
	  </div>
	</jsp:attribute>

	<jsp:attribute name="navbar">
		<ul class="nav navbar-nav" role="menu">
			<core_v2:offcanvas_header />
			<li class="slide-feature-back">
				<a href="javascript:;" data-slide-control="previous" class="btn-back"><span class="icon icon-arrow-left"></span> <span>Back</span></a>
			</li>
			<c:if test="${saveQuoteEnabled == 'Y'}">
				<li class="slide-feature-emailquote hidden-lg hidden-md hidden-sm" data-openSaveQuote="true">
					<a href="javascript:;" class="save-quote-openAsModal"><span class="icon icon-envelope"></span> <span><c:choose>
						<c:when test="${not empty authenticatedData.login.user.uid}">Save Quote</c:when>
						<c:otherwise>Save Quote</c:otherwise>
					</c:choose></span> <b class="caret"></b></a>
				</li>

				<li class="dropdown dropdown-interactive slide-feature-emailquote hidden-xs" id="email-quote-dropdown">
					<a class="activator needsclick btn-email dropdown-toggle" data-toggle="dropdown" href="javascript:;"><span class="icon icon-envelope"></span> <span><c:choose>
						<c:when test="${not empty authenticatedData.login.user.uid}">Save Quote</c:when>
						<c:otherwise>Save Quote</c:otherwise>
					</c:choose></span> <b class="caret"></b></a>
					<div class="dropdown-menu dropdown-menu-large" role="menu" aria-labelledby="dLabel">
						<div class="dropdown-container">
							<agg_v2:save_quote includeCallMeback="false" />
						</div>
					</div>
				</li>
			</c:if>
			<li class="dropdown dropdown-interactive slide-edit-quote-dropdown" id="edit-details-dropdown">
				<a class="activator needsclick dropdown-toggle btn-back" href="#start"><span class="icon icon-cog"></span>
					<span>Edit Details</span></a>
			</li>
		</ul>

		<div class="coverLevelTabs hidden-xs">
			<div class="currentTabsContainer">
			</div>
		</div>
	</jsp:attribute>

	<jsp:attribute name="xs_results_pagination"></jsp:attribute>

	<jsp:attribute name="form_bottom"></jsp:attribute>

	<jsp:attribute name="footer">
		<content:get key="footerText" />
	</jsp:attribute>

	<jsp:attribute name="vertical_settings">
		<life_v2:settings />
	</jsp:attribute>

	<jsp:attribute name="body_end">

	</jsp:attribute>

	<jsp:body>
		<%-- Slides --%>
		<life_v2_layout:slide_insurance_details />
		<life_v2_layout:slide_about_you />
		<life_v2_layout:slide_about_your_partner />
		<life_v2_layout:slide_contact_details />
		<life_v2_layout:slide_results />
		<life_v2_layout:slide_xs_confirmation />

		<%-- generate the benefit fields (hidden) for form selection. --%>
		<div class="hiddenFields">
			<field_v1:hidden xpath="transcheck" constantValue="1" />
			<field_v1:hidden xpath="life/renderingMode" />
			<field_v1:hidden xpath="environmentOverride" />
			<core_v1:referral_tracking vertical="${pageSettings.getVerticalCode()}" />
		</div>
	</jsp:body>

</layout_v1:journey_engine_page>