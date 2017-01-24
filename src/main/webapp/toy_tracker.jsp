<%@ page import="com.ctm.reward.model.TrackingStatusResponse" %>
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
    TrackingStatusResponse ts = rewardTrackingService.getTrackingStatus(token);
	request.setAttribute("trackingStatus", ts);
%>
<layout_v1:journey_engine_page title="Toy Tracker">
	<jsp:attribute name="head">
		<link rel="stylesheet" href="${assetUrl}assets/brand/${pageSettings.getBrandCode()}/css/zeus${pageSettings.getSetting('minifiedFileString')}.css?${revision}" media="all">
	</jsp:attribute>

	<jsp:attribute name="body_class_name">zeusPage</jsp:attribute>

	<jsp:attribute name="head_meta"></jsp:attribute>

	<jsp:attribute name="header">
		<script>window.twttr = (function(d, s, id) {
			var js, fjs = d.getElementsByTagName(s)[0],
			t = window.twttr || {};
			if (d.getElementById(id)) return t;
			js = d.createElement(s);
			js.id = id;
			js.src = "https://platform.twitter.com/widgets.js";
			fjs.parentNode.insertBefore(js, fjs);

			t._e = [];
			t.ready = function(f) {
			t._e.push(f);
			};

			return t;
		}(document, "script", "twitter-wjs"));</script>
	</jsp:attribute>

	<jsp:attribute name="vertical_settings"></jsp:attribute>

	<jsp:attribute name="footer"></jsp:attribute>

	<jsp:attribute name="form_bottom"></jsp:attribute>

	<jsp:attribute name="body_end"></jsp:attribute>

	<jsp:attribute name="additional_meerkat_scripts">
		<script src="${assetUrl}assets/js/bundles/zeus${pageSettings.getSetting('minifiedFileString')}.js?${revision}"></script>
	</jsp:attribute>

	<jsp:body>
		<zeus:header />
		<c:if test="${token eq '' or trackingStatus == null or trackingStatus.stage == null}">
			<zeus:error />
		</c:if>
		<c:if test="${trackingStatus != null}">
			<!-- Setup the values we need for the template. -->
			<c:choose>
				<c:when test="${trackingStatus.stage eq 1}">
					<c:set var="locationName" value="Meerkovo" />
					<c:set var="locationDistance" value="23,252" />
					<c:set var="toyType" value="_${trackingStatus.rewardType.rewardType}" />
					<c:set var="imageName" value="meerkovo" />
				</c:when>
				<c:when test="${trackingStatus.stage eq 2}">
					<c:set var="locationName" value="China" />
					<c:set var="locationDistance" value="14,701" />
					<c:set var="toyType" value="" />
					<c:set var="imageName" value="china" />
				</c:when>
				<c:when test="${trackingStatus.stage eq 3}">
					<c:set var="locationName" value="Madagascar" />
					<c:set var="locationDistance" value="15,177" />
					<c:set var="toyType" value="" />
					<c:set var="imageName" value="madagascar" />
				</c:when>
				<c:when test="${trackingStatus.stage eq 4}">
					<c:set var="locationName" value="New Zealand" />
					<c:set var="locationDistance" value="4,156" />
					<c:set var="toyType" value="" />
					<c:set var="imageName" value="new_zealand" />
				</c:when>
				<c:otherwise>
					<c:set var="locationName" value="Australia" />
					<c:set var="locationDistance" value="0" />
					<c:set var="toyType" value="" />
					<c:set var="imageName" value="australia" />
				</c:otherwise>
			</c:choose>
			<zeus:location firstName="${trackingStatus.firstName}" locationName="${locationName}" locationDistance="${locationDistance}" toyType="${toyType}" imageName="${imageName}" />
		</c:if>
		<zeus:footer />

		<div class="hiddenFields">
			<form_v1:operator_id xpath="${pageSettings.getVerticalCode()}/operatorid"/>
			<core_v1:referral_tracking vertical="${pageSettings.getVerticalCode()}"/>
		</div>

		<input type="hidden" name="transcheck" id="transcheck" value="1"/>
	</jsp:body>
</layout_v1:journey_engine_page>