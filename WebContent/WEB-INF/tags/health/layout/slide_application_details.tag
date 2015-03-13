<%@ tag description="The Health Journey's 'Applications Details' Slide" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<layout:slide  nextLabel="Proceed to Payment">

	<layout:slide_columns sideHidden="true">

		<jsp:attribute name="rightColumn">
			<health:policySummary showProductDetails="true" />
			<health:needHelpBubble />
		</jsp:attribute>

		<jsp:body>

			<layout:slide_content>

				<health:competition_jeep />

				<div id="health_application-warning">
					<div class="fundWarning alert alert-danger">
						<%-- insert fund warning data --%>
					</div>
				</div>

				<ui:bubble variant="chatty">
					<h4>Your Application</h4>
					<p>In a few more steps, you'll be done. Just fill in your details below and we'll pass them onto your chosen health fund, making the application process easier for you!</p>
				</ui:bubble>

				<%-- The reason for the multiple forms here is because of an issue with iOS7 --%>

				<form  id="applicationForm_1" autocomplete="off" class="form-horizontal" role="form">
					<health:persons xpath="${pageSettings.getVerticalCode()}/application" />
				</form>

				<form  id="applicationForm_2" autocomplete="off" class="form-horizontal" role="form">
					<health:dependants xpath="${pageSettings.getVerticalCode()}/application/dependants" />
				</form>

				<form  id="applicationForm_3" autocomplete="off" class="form-horizontal" role="form">
					<health:application_details xpath="${pageSettings.getVerticalCode()}/application" />
				</form>

				<form  id="applicationForm_4" autocomplete="off" class="form-horizontal" role="form">
					<health:previous_fund xpath="${pageSettings.getVerticalCode()}/previousfund" id="previousfund" />
				</form>

			</layout:slide_content>

		</jsp:body>

	</layout:slide_columns>

</layout:slide>