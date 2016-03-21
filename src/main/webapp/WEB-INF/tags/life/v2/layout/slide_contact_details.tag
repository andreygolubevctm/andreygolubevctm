<%@ tag description="The Health Journey's 'Contact Details' Slide" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:set var="xpath" value="life" />
<layout_v3:slide formId="contactForm" className="contactSlide" nextLabel="Next Step">

	<layout_v3:slide_content>

		<form_v2:fieldset legend="" postLegend="" />
		<life_v2:contact_details xpath="${xpath}" />

	</layout_v3:slide_content>

</layout_v3:slide>