<%@ tag description="The Health Journey's 'Contact Details' Slide" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<layout:slide formId="contactForm" nextLabel="Get Prices" className="contactSlide">

	<layout:slide_content>

		<health:contact_details_optin xpath="${pageSettings.getVerticalCode()}/contactDetails" />

	</layout:slide_content>

</layout:slide>