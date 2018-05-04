<%@ tag description="Journey slide" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:set var="xpath" value="quote" />

<layout_v1:slide formId="detailsForm" nextLabel="Next Step">

	<layout_v1:slide_content>

		<form_v2:fieldset_columns sideHidden="false" force4ColSide="true">

			<jsp:attribute name="rightColumn">
				<ad_containers:sidebar_top />
				<car:snapshot />
			</jsp:attribute>

			<jsp:body>

				<ui:bubble variant="chatty">
					<h4>The Regular Driver</h4>
					<p>In order to supply car insurance quotes, we'll need to know some more information about the regular driver of the car (this is the person who will be driving the car the most).</p>
				</ui:bubble>

                <car:drivers_regular xpath="${xpath}/drivers/regular" />

			</jsp:body>
		</form_v2:fieldset_columns>



		<car:drivers_regular_cont xpath="${xpath}/drivers/regular" />

		<car:drivers_young xpath="${xpath}/drivers/young" />

	</layout_v1:slide_content>

</layout_v1:slide>