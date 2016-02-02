<%@ tag description="The Health Journey's 'All About You' Slide" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<layout_v1:slide_new formId="startForm" firstSlide="true" nextLabel="Next Step">

	<layout_v1:slide_content >

		<%-- PROVIDER TESTING --%>
		<health_v1:provider_testing xpath="${pageSettings.getVerticalCode()}" />

		<%-- COVER TYPE / SITUATION --%>
		<div id="${pageSettings.getVerticalCode()}_situation">
			<health_v1:situation xpath="${pageSettings.getVerticalCode()}/situation" />
		</div>

	</layout_v1:slide_content>

</layout_v1:slide_new>