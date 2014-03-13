<%@ tag description="The Health Journey's 'All About You' Slide" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<layout:slide formId="startForm" firstSlide="true" nextLabel="Next Step">

	<layout:slide_content >

		<%-- PROVIDER TESTING --%>
		<health:provider_testing xpath="${pageSettings.vertical}" />

		<%-- COVER TYPE / SITUATION --%>
		<div id="${pageSettings.vertical}_situation">
			<health:situation xpath="${pageSettings.vertical}/situation" />
		</div>

	</layout:slide_content>

</layout:slide>