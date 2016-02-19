<%@ tag description="Journey slide - Policy Holders" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<jsp:useBean id="splitTestService" class="com.ctm.web.core.services.tracking.SplitTestService" />

<c:set var="xpath" value="${pageSettings.getVerticalCode()}" />

<c:set var="buttonLabel" value="Next Step" />

<layout_v1:slide formId="policyHolderForm" nextLabel="${buttonLabel}">

	<layout_v1:slide_columns sideHidden="false">

		<jsp:attribute name="rightColumn">
			<home:snapshot />

		</jsp:attribute>

		<jsp:body>

			<layout_v1:slide_content>

<%-- 				<ui:bubble variant="chatty"> --%>
<!-- 					<h4>Your Home, Your Contents</h4> -->
<!-- 					<p>Tell us about your home and/or contents to compare quotes from our participating providers.</p> -->
<%-- 				</ui:bubble> --%>

				<home:policy_holder xpath="${xpath}/policyHolder" />


			</layout_v1:slide_content>

		</jsp:body>

	</layout_v1:slide_columns>

	<home:other_occupants xpath="${xpath}/policyHolder" />

	<layout_v1:slide_columns sideHidden="false">
		<jsp:attribute name="rightColumn">
		<%--	<home_new:snapshot />
		--%>
		</jsp:attribute>

		<jsp:body>

			<layout_v1:slide_content>

				<home:contact_details xpath="${xpath}/policyHolder" />

			</layout_v1:slide_content>

		</jsp:body>

	</layout_v1:slide_columns>

</layout_v1:slide>