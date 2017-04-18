<%@ tag description="Journey slide - Policy Holders" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:set var="xpath" value="${pageSettings.getVerticalCode()}" />

<c:set var="buttonLabel" value="Next Step" />

<layout_v1:slide formId="policyHolderForm" nextLabel="${buttonLabel}">

	<layout_v1:slide_columns sideHidden="false">

		<jsp:attribute name="rightColumn">
			<home:snapshot />

		</jsp:attribute>

		<jsp:body>

			<layout_v1:slide_content>

				<home:policy_holder xpath="${xpath}/policyHolder" />

			</layout_v1:slide_content>

		</jsp:body>

	</layout_v1:slide_columns>

	<home:other_occupants xpath="${xpath}/policyHolder" />

	<layout_v1:slide_columns sideHidden="false">
		<jsp:attribute name="rightColumn"></jsp:attribute>

		<jsp:body>

			<layout_v1:slide_content>

				<home:contact_details xpath="${xpath}/policyHolder" />

			</layout_v1:slide_content>

		</jsp:body>

	</layout_v1:slide_columns>

</layout_v1:slide>