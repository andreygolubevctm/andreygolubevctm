<%--
	Reset Password Page
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- Set authenticatedData to scope of request --%>
<session:new verticalCode="GENERIC" authenticated="${true}"/>

<layout:journey_engine_page title="Reset Password" sessionPop="false">

	<jsp:attribute name="head">
		<link rel="stylesheet" href="${assetUrl}brand/${pageSettings.getBrandCode()}/css/components/resetpassword.${pageSettings.getBrandCode()}.css?${revision}" media="all">
	</jsp:attribute>

	<jsp:attribute name="head_meta"></jsp:attribute>

	<jsp:attribute name="header">
		<div class="navbar-collapse header-collapse-contact collapse">
			<ul class="nav navbar-nav navbar-right">
			</ul>
		</div>
	</jsp:attribute>

	<jsp:attribute name="navbar">

		<ul class="nav navbar-nav" role="menu">
			<li class="visible-xs">
				<span class="navbar-text-block navMenu-header">Menu</span>
			</li>
		</ul>

	</jsp:attribute>


	<jsp:attribute name="form_bottom"></jsp:attribute>

	<jsp:attribute name="footer">
		<core:whitelabeled_footer />
	</jsp:attribute>

	<jsp:attribute name="vertical_settings">
		<resetpassword:settings />
	</jsp:attribute>

	<jsp:attribute name="body_end"></jsp:attribute>

	<jsp:attribute name="additional_meerkat_scripts">
		<script src="${assetUrl}brand/${pageSettings.getBrandCode()}/js/components/resetpassword.modules.${pageSettings.getBrandCode()}${pageSettings.getSetting('minifiedFileString')}.js?${revision}"></script>
	</jsp:attribute>

	<jsp:body>

		<resetpassword_layout:slide_form />

		<div class="hiddenFields">
			<form:operator_id xpath="${pageSettings.getVerticalCode()}/operatorid"/>
			<core:referral_tracking vertical="${pageSettings.getVerticalCode()}"/>
		</div>

		<input type="hidden" name="transcheck" id="transcheck" value="1"/>

	</jsp:body>

</layout:journey_engine_page>