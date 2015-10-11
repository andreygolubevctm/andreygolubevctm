<%@ tag description="The Health Journey's 'All About You' Slide" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<layout:slide_new formId="startForm" firstSlide="true" nextLabel="Next Step">

	<layout:slide_content >

		<%-- PROVIDER TESTING --%>
		<health:provider_testing xpath="${pageSettings.getVerticalCode()}" />

		<%-- COVER TYPE / SITUATION --%>
		<div id="${pageSettings.getVerticalCode()}_situation">
			<health_new:situation xpath="${pageSettings.getVerticalCode()}/situation" />
		</div>

	</layout:slide_content>

</layout:slide_new>