<%@ tag description="The Health Journey's 'Contact Details' Slide" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<layout_v3:slide formId="contactForm" nextLabel="Get Prices" className="contactSlide">

	<layout_v3:slide_content>

		<health_new:contact_details_optin xpath="${pageSettings.getVerticalCode()}/contactDetails" />

	</layout_v3:slide_content>

</layout_v3:slide>