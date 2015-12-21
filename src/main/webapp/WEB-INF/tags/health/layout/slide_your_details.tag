<%@ tag description="The Health Journey's 'Your Details' Slide" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<layout_v1:slide formId="detailsForm" nextLabel="Choose Your Cover">

	<layout_v1:slide_content>
		<health:health_cover_details xpath="${pageSettings.getVerticalCode()}/healthCover" />
	</layout_v1:slide_content>

</layout_v1:slide>