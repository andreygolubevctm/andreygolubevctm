<%@ tag description="The IP Journey's 'All About You' Slide" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:set var="xpath" value="life" />

<layout_v3:slide formId="startForm" firstSlide="true" nextLabel="Next Step">

	<layout_v3:slide_content >

		<form_v2:fieldset legend="Life Insurance Details" postLegend="">

			<ui:bubble variant="chatty">
				<h4>Hi there,</h4>
				<p>We see that you're using a mobile device. This means that you won't see a table of comparison results, however you will receive a call back from one of our trusted partners to discuss your life insurance and/or income protection needs. Click <em><a href="life_quote.jsp?source=mobile">here</a></em> to see the desktop view with full comparison results.</p>
			</ui:bubble>

			<life_v2:insurance_details xpath="${xpath}" />

		</form_v2:fieldset>

	</layout_v3:slide_content>

</layout_v3:slide>