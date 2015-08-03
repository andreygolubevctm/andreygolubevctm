<%@ tag description="Journey slide" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:set var="xpath" value="quote" />

<layout:slide formId="detailsForm" nextLabel="Next Step">

	<layout:slide_content>

		<form_new:fieldset_columns sideHidden="false">

			<jsp:attribute name="rightColumn">
				<car:snapshot />
			</jsp:attribute>

			<jsp:body>

				<ui:bubble variant="chatty">
					<h4>The Regular Driver</h4>
					<p>In order to supply car insurance quotes, we'll need to know some more information about the regular driver of the car (this is the person who will be driving the car the most).</p>
				</ui:bubble>

			</jsp:body>
		</form_new:fieldset_columns>

		<car:drivers_regular xpath="${xpath}/drivers/regular" />

		<car:drivers_regular_cont xpath="${xpath}/drivers/regular" />

		<car:drivers_young xpath="${xpath}/drivers/young" />

	</layout:slide_content>

</layout:slide>