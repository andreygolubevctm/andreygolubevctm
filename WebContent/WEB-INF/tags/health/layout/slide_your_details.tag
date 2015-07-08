<%@ tag description="The Health Journey's 'Your Details' Slide" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<layout:slide formId="detailsForm" nextLabel="Choose Your Cover">

	<layout:slide_content>
		<c:if test="${contactSplitTest == false}">
			<health:contact_details_optin xpath="${pageSettings.getVerticalCode()}/contactDetails" required="false"/>
		</c:if>
		<health:health_cover_details xpath="${pageSettings.getVerticalCode()}/healthCover" />

	</layout:slide_content>

</layout:slide>