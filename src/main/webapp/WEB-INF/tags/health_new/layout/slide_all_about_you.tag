<%@ tag description="The Health Journey's 'All About You' Slide" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<layout_new_layout:slide_new formId="startForm" firstSlide="true" nextLabel="Next Step">

	<layout_new_layout:slide_content >

		<%-- PROVIDER TESTING --%>
		<health:provider_testing xpath="${pageSettings.getVerticalCode()}" />

		<%-- COVER TYPE / SITUATION --%>
		<div id="${pageSettings.getVerticalCode()}_situation">
			<health_new:situation xpath="${pageSettings.getVerticalCode()}/situation" />
		</div>

	</layout_new_layout:slide_content>

</layout_new_layout:slide_new>