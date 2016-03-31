<%@ tag description="The IP Journey's 'All About You' Slide" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:set var="xpath" value="ip" />
<layout_v3:slide formId="startForm" nextLabel="Next Step">

	<layout_v3:slide_content >

		<form_v2:fieldset legend="" postLegend="">
			<ip_v2:applicant xpath="${xpath}/primary" />
		</form_v2:fieldset>

	</layout_v3:slide_content>

</layout_v3:slide>