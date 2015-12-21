<%@ tag description="The Health Journey's 'Payment Details' Slide" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<layout_v1:slide formId="paymentForm">

	<layout_v1:slide_columns sideHidden="true">

		<jsp:attribute name="rightColumn">
			<health:policySummary showProductDetails="true" />
			<health_content:needHelpBubble />
			<health:competition_jeep />
		</jsp:attribute>

		<jsp:body>

			<layout_v1:slide_content>

				<ui:bubble variant="chatty">
					<h4>Almost done!</h4>
					<p>Just fill in your payment details below using our secure form. These details will be provided to your new health fund.</p>
				</ui:bubble>

				<health:payment xpath="${pageSettings.getVerticalCode()}/payment" />
				<health:declaration xpath="${pageSettings.getVerticalCode()}/declaration" />
				<health:contactAuthority xpath="${pageSettings.getVerticalCode()}/contactAuthority" />
				<health:whats-next />
				<simples:dialogue id="31" vertical="health" mandatory="true" />

				<form_v2:row id="confirm-step" hideHelpIconCol="true">
					<a href="javascript:void(0);" class="btn btn-next col-xs-12 col-sm-8 col-md-5 journeyNavButton" id="submit_btn">Submit Application <span class="icon icon-arrow-right"></span></a>
				</form_v2:row>

			</layout_v1:slide_content>

		</jsp:body>

	</layout_v1:slide_columns>

</layout_v1:slide>