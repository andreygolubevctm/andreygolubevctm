<%@ tag description="Journey slide - Policy Holders" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<jsp:useBean id="splitTestService" class="com.ctm.services.tracking.SplitTestService" />

<c:set var="xpath" value="${pageSettings.getVerticalCode()}" />

<c:set var="buttonLabel" value="Next Step" />
<c:if test="${splitTestService.isActive(pageContext.getRequest(), data.current.transactionId, 34) or splitTestService.isActive(pageContext.getRequest(), data.current.transactionId, 35)}">
	<c:set var="buttonLabel" value="Get Quotes" />
</c:if>

<layout:slide formId="policyHoldersForm" nextLabel="${buttonLabel}">

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

				<%-- Commencement date --%>
				<c:if test="${splitTestService.isActive(pageContext.getRequest(), data.current.transactionId, 2)}">
					<form_new:fieldset legend="Your preferred date to start the insurance">
						<home_new:commencementDate xpath="${xpath}/startDate" />
					</form_new:fieldset>
				</c:if>

				<home_new:contact_details xpath="${xpath}/policyHolder" />

			</layout:slide_content>

		</jsp:body>

	</layout:slide_columns>

</layout:slide>