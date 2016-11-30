<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Medicare details group"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="field group's xpath" %>

<%-- VARIABLES --%>
<c:set var="name" 			value="${go:nameFromXpath(xpath)}" />

<%-- HTML --%>
<div id="${name}-selection" class="health-situation">

	<form_v4:fieldset_columns sideHidden="true">

		<jsp:attribute name="rightColumn">
			<health_v2_content:sidebar />
		</jsp:attribute>

		<jsp:body>

			<health_v4_aboutyou:simples />

            <form_v3:fieldset id="healthAboutYou" legend="Tell us about yourself, so we can find the right cover for you" className="health-about-you">

				<health_v4_aboutyou:livingin xpath="${xpath}" />
				<health_v4_aboutyou:youarea xpath="${xpath}" />
				<health_v4_aboutyou:youarea xpath="${xpath}" />

				<c:set var="xpath" value="${pageSettings.getVerticalCode()}/healthCover" />
				<health_v4_aboutyou:dob xpath="${xpath}" />
				<health_v4_aboutyou:currentlyowninsurance xpath="${xpath}" />
				<health_v4_aboutyou:applyrebate xpath="${xpath}" />
				<health_v4_aboutyou:optin xpath="${xpath}" />
			</form_v3:fieldset>

		</jsp:body>
	</form_v4:fieldset_columns>
</div>