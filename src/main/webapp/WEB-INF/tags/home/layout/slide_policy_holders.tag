<%@ tag description="Journey slide - Policy Holders" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<jsp:useBean id="splitTestService" class="com.ctm.web.core.services.tracking.SplitTestService" />

<c:set var="xpath" value="${pageSettings.getVerticalCode()}" />

<c:set var="buttonLabel" value="Next Step" />
<c:if test="${splitTestService.isActive(pageContext.getRequest(), data.current.transactionId, 34) or splitTestService.isActive(pageContext.getRequest(), data.current.transactionId, 35)}">
	<c:set var="buttonLabel" value="Get Quotes" />
</c:if>

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

				<%-- Commencement date --%>
				<c:if test="${splitTestService.isActive(pageContext.getRequest(), data.current.transactionId, 2)}">
					<form_v2:fieldset legend="Your preferred date to start the insurance">
						<home:commencementDate xpath="${xpath}/startDate" />
					</form_v2:fieldset>
				</c:if>

				<home:contact_details xpath="${xpath}/policyHolder" />

			</layout_v1:slide_content>

		</jsp:body>

	</layout_v1:slide_columns>

</layout_v1:slide>