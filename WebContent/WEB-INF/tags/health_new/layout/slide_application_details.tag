<%@ tag description="The Health Journey's 'Applications Details' Slide" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<layout:slide  nextLabel="Proceed to Payment">

	<layout:slide_columns sideHidden="true">

		<jsp:attribute name="rightColumn">
			<health_new:policySummary showProductDetails="true" showDualPricing="true" />
			<health_new:needHelpBubble />
		</jsp:attribute>

		<jsp:body>

			<layout:slide_content >

				<ui:bubble variant="chatty">
					<h4>Now let's get you that deal!</h4>
					<p>All you need to proceed are you banking and Medicare details</p>
				</ui:bubble>

				<%-- The reason for the multiple forms here is because of an issue with iOS7 --%>
				
				<form  id="applicationForm_1" autocomplete="off" class="form-horizontal" role="form">
					<health:persons xpath="${pageSettings.vertical}/application" />
				</form>
				
				<form  id="applicationForm_2" autocomplete="off" class="form-horizontal" role="form">
					<health:dependants xpath="${pageSettings.vertical}/application/dependants" />
				</form>
				
				<form  id="applicationForm_3" autocomplete="off" class="form-horizontal" role="form">
					<health:application_details xpath="${pageSettings.vertical}/application" />
				</form>
				
				<form  id="applicationForm_4" autocomplete="off" class="form-horizontal" role="form">
					<health:previous_fund xpath="${pageSettings.vertical}/previousfund" id="previousfund" />
				</form>

			</layout:slide_content>

		</jsp:body>

	</layout:slide_columns>

</layout:slide>