<%@ tag description="Journey slide" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:set var="xpath" value="quote" />

<layout:slide formId="addressForm" nextLabel="Get Quotes">

	<layout:slide_columns sideHidden="false">

		<jsp:attribute name="rightColumn">
			<car:snapshot />
		</jsp:attribute>

		<jsp:body>
			<layout:slide_content>

				<ui:bubble variant="chatty">
					<h4>Where is the car parked at night?</h4>
					<p>We're looking for the address where the car is parked at night which could be different to your postal address. This information will be used when determining your premium.</p>
				</ui:bubble>

				<car:risk_address xpath="${xpath}/riskAddress" />

				<car:contact_details xpath="${xpath}/contact" />

				<car:contact_optins xpath="${xpath}/termsAndConditions" />

			</layout:slide_content>
		</jsp:body>

	</layout:slide_columns>

</layout:slide>