<%@ tag description="The Health Journey's 'All About You' Slide" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<layout_v3:slide formId="startForm" firstSlide="true" nextLabel="Next Step">

	<layout_v3:slide_content >

		<%-- PROVIDER TESTING --%>
		<health_v1:provider_testing xpath="${pageSettings.getVerticalCode()}" />

		<form_v2:fieldset legend="About you" postLegend="Tell us about yourself, so we can find the right cover for you" />

		<%-- COVER TYPE / SITUATION --%>
		<div id="${pageSettings.getVerticalCode()}_situation">
			<health_v2:situation xpath="${pageSettings.getVerticalCode()}/situation" />
			<health_v2:health_cover_details xpath="${pageSettings.getVerticalCode()}/healthCover" />
		</div>

	</layout_v3:slide_content>

</layout_v3:slide>