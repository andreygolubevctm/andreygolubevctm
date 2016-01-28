<%@ tag description="The Health Journey's 'Contact Details' Slide" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<layout_v1:slide formId="contactForm" nextLabel="Get Prices" className="contactSlide">

	<layout_v1:slide_content>

		<health_v1:contact_details_optin xpath="${pageSettings.getVerticalCode()}/contactDetails" />

	</layout_v1:slide_content>

</layout_v1:slide>