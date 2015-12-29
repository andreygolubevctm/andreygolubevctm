<%@ tag description="The Health Journey's 'Payment Details' Slide" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<layout:slide formId="paymentForm">

	<layout:slide_columns sideHidden="true">

		<jsp:attribute name="rightColumn">
			<health:policySummary showProductDetails="true" />
			<health_new_content:needHelpBubble />
			<health:competition_jeep />
		</jsp:attribute>

		<jsp:body>

			<layout:slide_content>

				<form_new:fieldset id="${name}_payment_text" legend="" className="instructional">
					<h4>Almost done!</h4>
					<p>Just fill in your payment details below using our secure form. These details will be provided to your new health fund.</p>
				</form_new:fieldset>

				<health:payment xpath="${pageSettings.getVerticalCode()}/payment" />

				<form_new:fieldset legend="Declaration" className="${pageSettings.getVerticalCode()}_declaration-group">
					<health_new:declaration xpath="${pageSettings.getVerticalCode()}/declaration" />
					<health:contactAuthority xpath="${pageSettings.getVerticalCode()}/contactAuthority" />
					<health_new:whats-next />
				</form_new:fieldset>

				<simples:dialogue id="31" vertical="health" mandatory="true" />

				<form_new:row id="confirm-step" hideHelpIconCol="true">
					<a href="javascript:void(0);" class="btn btn-next col-xs-12 col-sm-8 col-md-5 journeyNavButton" id="submit_btn">Submit Application <span class="icon icon-arrow-right"></span></a>
				</form_new:row>

			</layout:slide_content>

		</jsp:body>

	</layout:slide_columns>

</layout:slide>