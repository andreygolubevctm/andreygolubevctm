<%@ tag description="The Health Journey's 'Payment Details' Slide" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<layout:slide formId="paymentForm">

	<layout:slide_columns sideHidden="true">

		<jsp:attribute name="rightColumn">
			<health_new:policySummary showProductDetails="true" showDualPricing="true" />
			<health_new:needHelpBubble />
		</jsp:attribute>

		<jsp:body>

			<layout:slide_content>

				<ui:bubble variant="chatty">
					<h4>Almost done!</h4>
					<p>Last step is to get your payment details and then we'll be finished</p>
				</ui:bubble>

				<health:payment xpath="${pageSettings.vertical}/payment" />
				<health:declaration xpath="${pageSettings.vertical}/declaration" />
				<health:whats-next />

				<form_new:row id="confirm-step" hideHelpIconCol="true">
					<a href="javascript:void(0);" class="btn btn-success col-xs-12 col-sm-8 col-md-5 journeyNavButton" id="submit_btn">Submit Application <span class="icon icon-arrow-right"></span></a>
				</form_new:row>

			</layout:slide_content>

		</jsp:body>

	</layout:slide_columns>

</layout:slide>