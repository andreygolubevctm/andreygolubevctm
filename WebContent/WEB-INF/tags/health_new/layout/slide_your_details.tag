<%@ tag description="The Health Journey's 'Your Details' Slide" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<layout:slide formId="detailsForm" nextLabel="Choose Your Cover">

	<layout:slide_content>

		<health:contact_details_optin xpath="${pageSettings.vertical}/contactDetails" required="${callCentre}" />
		<health:health_cover_details xpath="${pageSettings.vertical}/healthCover" />		

	</layout:slide_content>

</layout:slide>