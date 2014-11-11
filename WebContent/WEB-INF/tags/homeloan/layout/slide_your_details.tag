<%@ tag description="The Home Loans Journey's 'Details' Slide" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:set var="xpath" value="${pageSettings.getVerticalCode()}" />

<layout:slide formId="startForm" firstSlide="true" nextLabel="Get Quotes">

	<layout:slide_columns sideHidden="true">
		<jsp:attribute name="rightColumn">
			<homeloan:brand_sidebar />
		</jsp:attribute>

		<jsp:body>
			<layout:slide_content>

					<ui:bubble variant="chatty">
						<h4>Let's get you started.</h4>
						<p>Answering the following questions will help us supply you with home loan options from participating lenders.</p>
					</ui:bubble>

					<homeloan:details xpath="${xpath}/details" />

			</layout:slide_content>
		</jsp:body>
	</layout:slide_columns>



	<layout:slide_content>
		<homeloan:loan_details xpath="${xpath}/loanDetails" />
	</layout:slide_content>



	<layout:slide_columns sideHidden="true">
		<jsp:attribute name="rightColumn">
		</jsp:attribute>

		<jsp:body>
			<layout:slide_content>
				<homeloan:contact xpath="${xpath}/contact" />
			</layout:slide_content>
		</jsp:body>
	</layout:slide_columns>


</layout:slide>