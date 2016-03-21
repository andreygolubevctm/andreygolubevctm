<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<%-- <jsp:useBean id="userAgentSniffer" class="com.ctm.web.core.services.UserAgentSniffer" />
<c:set var="deviceType" value="${userAgentSniffer.getDeviceType(pageContext.getRequest().getHeader('user-agent'))}" />

<c:if test="${deviceType ne 'MOBILE'}">
	<c:set var="redirectURL" value="${pageSettings.getBaseUrl()}ip_quote.jsp#/?stage=start" />
	<c:redirect url="${fn:substring(redirectURL,0,fn:length(redirectURL))}" />
</c:if>--%>

<session:new verticalCode="IP" authenticated="true" />
<jsp:useBean id="serviceConfigurationService" class="com.ctm.web.core.services.ServiceConfigurationService" scope="session"/>

<core_v2:quote_check quoteType="ip" />
<core_v2:load_preload />

<%-- HTML --%>
<layout_v1:journey_engine_page title="Income Protection Quote">

	<jsp:attribute name="head"></jsp:attribute>
	<jsp:attribute name="head_meta"></jsp:attribute>
	<jsp:attribute name="header_button_left"></jsp:attribute>

	<jsp:attribute name="header">
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
			<li class="visible-xs">
				<span class="navbar-text-block navMenu-header">Menu</span>
			</li>
			<li class="slide-feature-back visible-xs">
				<a href="javascript:;" data-slide-control="previous" class="btn-back">
					<span class="icon icon-arrow-left"></span> <span>Revise Your Details</span></a>
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
		<travel:footer />
	</jsp:attribute>

	<jsp:attribute name="vertical_settings">
		<travel:settings />
	</jsp:attribute>

	<jsp:attribute name="body_end">

	</jsp:attribute>

	<jsp:body>
		<%-- Slides --%>
		<ip_v2_layout:slide_ip_details />
		<ip_v2_layout:slide_about_you />
		<ip_v2_layout:slide_contact_details />
		<ip_v2_layout:slide_results />
		<ip_v2_layout:slide_xs_confirmation />

		<%-- generate the benefit fields (hidden) for form selection. --%>
		<div class="hiddenFields">
			<field_v1:hidden xpath="transcheck" constantValue="1" />
			<field_v1:hidden xpath="ip/renderingMode" />
			<field_v1:hidden xpath="environmentOverride" />
			<core_v1:referral_tracking vertical="${pageSettings.getVerticalCode()}" />
		</div>
	</jsp:body>

</layout_v1:journey_engine_page>