<%@ tag description="The Health Journey's 'Payment Details' Slide" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<layout:slide formId="paymentForm">

	<layout:slide_columns sideHidden="true">

		<jsp:attribute name="rightColumn">
			<health:policySummary showProductDetails="true" showDualPricing="true" />
			<health:needHelpBubble />
		</jsp:attribute>

		<jsp:body>

			<layout:slide_content>

				<ui:bubble variant="chatty">
					<h4>Almost done!</h4>
					<p>Just fill in your payment details below using our secure form. These details will be provided to your new health fund.</p>
				</ui:bubble>

				<health:payment xpath="${pageSettings.getVerticalCode()}/payment" />
				<health:declaration xpath="${pageSettings.getVerticalCode()}/declaration" />
				<health:whats-next />

				<form_new:row id="confirm-step" hideHelpIconCol="true">
					<a href="javascript:void(0);" class="btn btn-next col-xs-12 col-sm-8 col-md-5 journeyNavButton" id="submit_btn">Submit Application <span class="icon icon-arrow-right"></span></a>
				</form_new:row>

			</layout:slide_content>

		</jsp:body>

	</layout:slide_columns>

</layout:slide>