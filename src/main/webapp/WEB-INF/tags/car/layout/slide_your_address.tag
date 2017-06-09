<%@ tag description="Journey slide" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:set var="xpath" value="quote" />

<layout_v1:slide formId="addressForm" nextLabel="Get Quotes">

	<layout_v1:slide_columns sideHidden="false">

		<jsp:attribute name="rightColumn">
			<car:snapshot />
		</jsp:attribute>

		<jsp:body>
			<layout_v1:slide_content>

				<ui:bubble variant="chatty">
					<h4>Where is the car parked at night?</h4>
					<p>We're looking for the address where the car is parked at night which could be different to your postal address. This information will be used when determining your premium.</p>
				</ui:bubble>

                <car:risk_address xpath="${xpath}/riskAddress" />

                <car:commencement_date xpath="${xpath}/options/commencementDate" />

                <car:contact_details xpath="${xpath}/contact" />
                <c:if test="${leadCaptureActive eq true}">
				    			<agg_v1:lead_capture vertical="energy" label="Energy Comparison" baseXpath="${xpath}" heading="Interested in comparing enegry plans later?" info="After comparing Car insurance products" />
                </c:if>
                <car:contact_optins xpath="${xpath}/termsAndConditions" />

			</layout_v1:slide_content>
		</jsp:body>
	</layout_v1:slide_columns>

</layout_v1:slide>