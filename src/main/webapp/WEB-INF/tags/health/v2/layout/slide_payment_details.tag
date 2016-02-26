<%@ tag description="The Health Journey's 'Payment Details' Slide" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<layout_v1:slide formId="paymentForm">

	<layout_v1:slide_columns sideHidden="true">

		<jsp:attribute name="rightColumn">
			<health_v1:policySummary showProductDetails="true" />
			<health_v2_content:sidebar />
		</jsp:attribute>

		<jsp:body>

			<layout_v1:slide_content>

				<health_v2:payment xpath="${pageSettings.getVerticalCode()}/payment" />

				<form_v2:fieldset legend="Declaration" className="${pageSettings.getVerticalCode()}_declaration-group">
					<health_v2:declaration xpath="${pageSettings.getVerticalCode()}/declaration" />
					<health_v1:contactAuthority xpath="${pageSettings.getVerticalCode()}/contactAuthority" />
					<health_v2:whats-next />
				</form_v2:fieldset>

				<simples:dialogue id="31" vertical="health" mandatory="true" />

				<form_v2:row id="confirm-step" hideHelpIconCol="true">
					<a href="javascript:void(0);" class="btn btn-next col-xs-12 col-sm-8 col-md-5 journeyNavButton" id="submit_btn">Submit Application <span class="icon icon-arrow-right"></span></a>
				</form_v2:row>

			</layout_v1:slide_content>

		</jsp:body>

	</layout_v1:slide_columns>

</layout_v1:slide>