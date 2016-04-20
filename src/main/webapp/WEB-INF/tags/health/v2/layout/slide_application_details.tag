<%@ tag description="The Health Journey's 'Applications Details' Slide" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<layout_v1:slide  nextLabel="Proceed to Payment">

	<layout_v1:slide_columns sideHidden="true">

		<jsp:attribute name="rightColumn">
			<health_v1:policySummary showProductDetails="true" />
			<health_v2_content:sidebar />
		</jsp:attribute>

		<jsp:body>

			<layout_v1:slide_content>

				<health_v1:competition_jeep />

				<div id="health_application-warning">
					<div class="fundWarning alert alert-danger">
						<%-- insert fund warning data --%>
					</div>
				</div>

				<form_v2:fieldset id="${name}_application_text" legend="" className="instructional">
					<h4>In a few more steps, you'll be done</h4>
					<p>Just fill in your details below and we'll pass them onto your chosen health fund, making the application process easier for you!</p>
				</form_v2:fieldset>
				<%-- The reason for the multiple forms here is because of an issue with iOS7 --%>

				<form  id="applicationForm_1" autocomplete="off" class="form-horizontal" role="form">
					<health_v3:your_details />
					<health_v3:partner_details />
				</form>

				<form  id="applicationForm_2" autocomplete="off" class="form-horizontal" role="form">
					<health_v1:dependants xpath="${pageSettings.getVerticalCode()}/application/dependants" />
				</form>

			</layout_v1:slide_content>

		</jsp:body>

	</layout_v1:slide_columns>

</layout_v1:slide>