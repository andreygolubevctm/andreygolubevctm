<%@ tag description="The Health Journey's 'Contact Details' Slide" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<layout:slide formId="contactForm" nextLabel="Get Prices" className="contactSlide">

	<layout:slide_content>

		<form_new:fieldset legend="Your Details" postLegend="Enter your details below and we'll show you products that match your needs on the next page" ></form_new:fieldset>
		<div id="${name}-selection" class="health-your_details">
			<health_new:contact_details_optin xpath="${pageSettings.getVerticalCode()}/contactDetails" />
		</div>

	</layout:slide_content>

</layout:slide>