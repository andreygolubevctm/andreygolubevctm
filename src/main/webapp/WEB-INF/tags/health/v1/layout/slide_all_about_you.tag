<%@ tag description="The Health Journey's 'All About You' Slide" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<layout_v1:slide_new formId="startForm" firstSlide="true" nextLabel="Next Step">

	<layout_v1:slide_content >

		<%-- PROVIDER TESTING --%>
		<health_v1:provider_testing xpath="${pageSettings.getVerticalCode()}" />

		<%--This is empty since we want to align the right hand box below this	--%>
		<form_v2:fieldset legend="About you" postLegend="Tell us about yourself, so we can find the right cover for you"></form_v2:fieldset>
		<%-- COVER TYPE / SITUATION --%>
		<div id="${pageSettings.getVerticalCode()}_situation">
			<health_v2:situation xpath="${pageSettings.getVerticalCode()}/situation" />
		</div>

	</layout_v1:slide_content>

</layout_v1:slide_new>