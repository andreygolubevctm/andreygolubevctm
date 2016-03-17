<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<session:new verticalCode="LIFE" authenticated="true" />
<jsp:useBean id="serviceConfigurationService" class="com.ctm.web.core.services.ServiceConfigurationService" scope="session"/>

<core_v2:quote_check quoteType="life" />
<core_v2:load_preload />

<%-- HTML --%>
<layout_v1:journey_engine_page title="Life Quote">

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