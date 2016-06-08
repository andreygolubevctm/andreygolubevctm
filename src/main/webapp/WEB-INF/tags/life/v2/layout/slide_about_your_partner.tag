<%@ tag description="The Health Journey's 'All About You' Slide" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:set var="xpath" value="life" />

<layout_v1:slide_new formId="aboutYourPartner" firstSlide="false" nextLabel="Next Step">

	<layout_v1:slide_content >

		<form_v2:fieldset legend="" postLegend="">
			<life_v2:applicant xpath="${xpath}/partner" label="About your partner" />
		</form_v2:fieldset>

	</layout_v1:slide_content>

</layout_v1:slide_new>