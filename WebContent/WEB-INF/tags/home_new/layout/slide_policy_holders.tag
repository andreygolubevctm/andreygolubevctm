<%@ tag description="Journey slide - Policy Holders" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:set var="xpath" value="${pageSettings.getVerticalCode()}" />
<layout:slide formId="policyHoldersForm" nextLabel="Next Step">

	<layout:slide_columns sideHidden="false">

		<jsp:attribute name="rightColumn">
			<home_new:snapshot />

		</jsp:attribute>

		<jsp:body>

			<layout:slide_content>

<%-- 				<ui:bubble variant="chatty"> --%>
<!-- 					<h4>Your Home, Your Contents</h4> -->
<!-- 					<p>Tell us about your home and/or contents to compare quotes from our participating providers.</p> -->
<%-- 				</ui:bubble> --%>

				<home_new:policy_holder xpath="${xpath}/policyHolder" />


			</layout:slide_content>

		</jsp:body>

	</layout:slide_columns>

	<home_new:other_occupants xpath="${xpath}/policyHolder" />

	<layout:slide_columns sideHidden="false">
		<jsp:attribute name="rightColumn">
		<%--	<home_new:snapshot />
		--%>
		</jsp:attribute>

		<jsp:body>

			<layout:slide_content>

				<home_new:contact_details xpath="${xpath}/policyHolder" />

			</layout:slide_content>

		</jsp:body>

	</layout:slide_columns>

</layout:slide>