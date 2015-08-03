<%@ tag description="Journey slide" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:set var="xpath" value="${pageSettings.getVerticalCode()}" />

<layout:slide formId="enquiryForm">
	<layout:slide_columns sideHidden="true">

		<jsp:attribute name="rightColumn">
			<ui:bubble variant="info">
				<h4>About the Broker</h4>
				<p>We have partnered with Australia's largest broker group, AFG, to provide you with a free, personalised service from their expert network of brokers.</p>
			</ui:bubble>
			<homeloan:snapshot />
		</jsp:attribute>

		<jsp:body>

			<layout:slide_content>
					<field:hidden xpath="${xpath}/product/id" defaultValue="" />
					<field:hidden xpath="${xpath}/product/lender" defaultValue="" />

					<ui:bubble variant="chatty">
						<h4>Ready to chat?</h4>
						<p>Fill in the details below and we'll pass these onto a broker who will contact you about your home loan options.</p>
					</ui:bubble>

					<homeloan:enquiry_contact xpath="${xpath}/enquiry/contact" />
					<homeloan:new_loan xpath="${xpath}/enquiry/newLoan" />

					<form_new:row id="confirm-step" hideHelpIconCol="true">
						<a href="javascript:void(0);" class="btn btn-cta col-xs-12 col-sm-8 col-md-5 journeyNavButton" id="submit_btn">Submit Enquiry <span class="icon icon-arrow-right"></span></a>
					</form_new:row>

			</layout:slide_content>

		</jsp:body>

	</layout:slide_columns>

</layout:slide>