<%@ tag description="The Health Journey's 'Applications Details' Slide" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<layout_new_layout:slide  nextLabel="Proceed to Payment">

	<layout_new_layout:slide_columns sideHidden="true">

		<jsp:attribute name="rightColumn">
			<health:policySummary showProductDetails="true" />
			<health_content:needHelpBubble />
		</jsp:attribute>

		<jsp:body>

			<layout_new_layout:slide_content>

				<health:competition_jeep />

				<div id="health_application-warning">
					<div class="fundWarning alert alert-danger">
						<%-- insert fund warning data --%>
					</div>
				</div>

				<form_new:fieldset id="${name}_application_text" legend="" className="instructional">
					<h4>In a few more steps, you'll be done</h4>
					<p>Just fill in your details below and we'll pass them onto your chosen health fund, making the application process easier for you!</p>
				</form_new:fieldset>
				<%-- The reason for the multiple forms here is because of an issue with iOS7 --%>

				<form  id="applicationForm_1" autocomplete="off" class="form-horizontal" role="form">
					<health_new:persons xpath="${pageSettings.getVerticalCode()}/application" />
				</form>

				<form  id="applicationForm_2" autocomplete="off" class="form-horizontal" role="form">
					<health_new:dependants xpath="${pageSettings.getVerticalCode()}/application/dependants" />
				</form>

				<form  id="applicationForm_3" autocomplete="off" class="form-horizontal" role="form">
					<health_new:application_details xpath="${pageSettings.getVerticalCode()}/application" />
				</form>

				<form  id="applicationForm_4" autocomplete="off" class="form-horizontal" role="form">
					<health_new:previous_fund xpath="${pageSettings.getVerticalCode()}/previousfund" id="previousfund" />
				</form>

			</layout_new_layout:slide_content>

		</jsp:body>

	</layout_new_layout:slide_columns>

</layout_new_layout:slide>