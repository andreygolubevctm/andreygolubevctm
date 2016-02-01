<%@ tag description="The Health Journey's 'Contact Details' Slide" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<layout_v3:slide formId="contactForm" nextLabel="Get Prices" className="contactSlide">

	<layout_v3:slide_content>

		<form_v2:fieldset legend="Your details" postLegend="Enter your details below and we'll show you products that match your needs on the next page" />

		<health_v2:contact_details_optin xpath="${pageSettings.getVerticalCode()}/contactDetails" />

	</layout_v3:slide_content>

</layout_v3:slide>