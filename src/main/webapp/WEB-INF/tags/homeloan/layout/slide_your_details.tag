<%@ tag description="The Home Loans Journey's 'Details' Slide" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:set var="xpath" value="${pageSettings.getVerticalCode()}" />

<layout_v1:slide formId="startForm" firstSlide="true" nextLabel="Get Quotes">

	<layout_v1:slide_columns sideHidden="true" hideAdSidebarBottom="true">
		<jsp:attribute name="rightColumn">
			<homeloan:brand_sidebar />
		</jsp:attribute>

		<jsp:body>
			<layout_v1:slide_content>

				<ui:bubble variant="chatty">
					<h4>Let's get you started.</h4>
					<p>Answering the following questions will help us supply you with home loan options from participating lenders.</p>
				</ui:bubble>

				<homeloan:details xpath="${xpath}/details" />

			</layout_v1:slide_content>
		</jsp:body>
	</layout_v1:slide_columns>

	<layout_v1:slide_columns sideHidden="true" hideAdSidebarTop="true" hideAdSidebarBottom="true">
		<jsp:attribute name="rightColumn">
			<ui:bubble variant="info" className="yourLoanDetails-bubble">
				<h4>Your Loan Details</h4>
				<p>If you're unsure about the purchase price or the amount you would like to borrow, please enter an estimate. You'll then be able to chat to your broker who will help you confirm these details.</p>
			</ui:bubble>
		</jsp:attribute>
		<jsp:body>
			<layout:slide_content>
				<homeloan:loan_details xpath="${xpath}/loanDetails" />
			</layout:slide_content>
		</jsp:body>
	</layout_v1:slide_columns>

	<layout_v1:slide_columns sideHidden="true" hideAdSidebarTop="true">
		<jsp:attribute name="rightColumn">
		</jsp:attribute>

		<jsp:body>
			<layout_v1:slide_content>
				<homeloan:contact xpath="${xpath}/contact" />
			</layout_v1:slide_content>
		</jsp:body>
	</layout_v1:slide_columns>


</layout_v1:slide>