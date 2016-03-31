<%@ tag description="The Health Journey's 'Contact Details' Slide" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:set var="xpath" value="ip" />
<layout_v3:slide formId="contactForm" className="contactSlide" nextLabel="Next Step">

	<layout_v3:slide_content>

		<form_v2:fieldset legend="Contact Details" postLegend="">
			<life_v2:contact_details xpath="${xpath}" />
		</form_v2:fieldset>

	</layout_v3:slide_content>

</layout_v3:slide>