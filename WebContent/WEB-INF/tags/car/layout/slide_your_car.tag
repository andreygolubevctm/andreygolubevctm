<%@ tag description="Journey slide" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:set var="xpath" value="quote" />

<layout:slide formId="startForm" firstSlide="true" nextLabel="Next Step">

	<layout:slide_content>

		<car:commencement_date xpath="${xpath}" />

		<car:vehicle_selection xpath="${xpath}/vehicle" />

	</layout:slide_content>

</layout:slide>