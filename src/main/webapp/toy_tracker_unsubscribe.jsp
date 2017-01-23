<%@ page import="com.ctm.reward.model.UpdateTrackingStatusResponse" %>
<%@ page import="com.ctm.web.reward.services.RewardTrackingService" %>
<%@ page import="org.springframework.web.servlet.support.RequestContextUtils" %>
<%--
	Toy tracker Page
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- Set authenticatedData to scope of request --%>
<session:new verticalCode="GENERIC" authenticated="${true}"/>
<c:choose>
	<c:when test="${not empty param.token}" >
		<c:set var="token" value="${param.token}" />
	</c:when>
	<c:otherwise>
		<c:set var="token" value="" />
	</c:otherwise>
</c:choose>

<%
	String token = request.getParameter("token");
	RewardTrackingService rewardTrackingService = (RewardTrackingService) RequestContextUtils.findWebApplicationContext(request).getBean("rewardTrackingService");
	UpdateTrackingStatusResponse ts = rewardTrackingService.optOutOfTracking(token);
	request.setAttribute("trackingOptin", ts);
%>
<layout_v1:journey_engine_page title="Toy Tracker">
	<jsp:attribute name="head">
		<link rel="stylesheet" href="${assetUrl}assets/brand/${pageSettings.getBrandCode()}/css/zeus${pageSettings.getSetting('minifiedFileString')}.css?${revision}" media="all">
	</jsp:attribute>

	<jsp:attribute name="body_class_name">zeusPage</jsp:attribute>

	<jsp:attribute name="head_meta"></jsp:attribute>

	<jsp:attribute name="header"></jsp:attribute>

	<jsp:attribute name="vertical_settings"></jsp:attribute>

	<jsp:attribute name="footer">
		Some footer text
	</jsp:attribute>

	<jsp:attribute name="form_bottom"></jsp:attribute>

	<jsp:attribute name="body_end"></jsp:attribute>

	<jsp:attribute name="additional_meerkat_scripts">
		<script src="${assetUrl}assets/js/bundles/zeus${pageSettings.getSetting('minifiedFileString')}.js?${revision}"></script>
	</jsp:attribute>

	<jsp:body>
		<zeus:header />

		<c:choose>
			<c:when test="${trackingOptin == null or trackingOptin.status == false}">
				<zeus:unsubscribe_error />
			</c:when>
			<c:otherwise>
				<zeus:unsubscribe_success />
			</c:otherwise>
		</c:choose>

		<zeus:footer />

		<div class="hiddenFields">
			<form_v1:operator_id xpath="${pageSettings.getVerticalCode()}/operatorid"/>
			<core_v1:referral_tracking vertical="${pageSettings.getVerticalCode()}"/>
		</div>

		<input type="hidden" name="transcheck" id="transcheck" value="1"/>
	</jsp:body>
</layout_v1:journey_engine_page>