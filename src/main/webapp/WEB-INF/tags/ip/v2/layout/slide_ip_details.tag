<%@ tag description="The IP Journey's 'IP Details' Slide" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:set var="xpath" value="ip" />
<layout_v3:slide formId="startForm" firstSlide="true" nextLabel="Next Step">

	<layout_v3:slide_content >

		<form_v2:fieldset legend="Income Protection Details" postLegend="">
			<ip_v2:ip_details xpath="${xpath}" />
		</form_v2:fieldset>

	</layout_v3:slide_content>

</layout_v3:slide>