<%@ tag description="The Health Journey's 'Contact Details' Slide" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<layout_new_layout:slide formId="contactForm" nextLabel="Get Prices" className="contactSlide">

	<layout_new_layout:slide_content>

		<health_new:contact_details_optin xpath="${pageSettings.getVerticalCode()}/contactDetails" />

	</layout_new_layout:slide_content>

</layout_new_layout:slide>