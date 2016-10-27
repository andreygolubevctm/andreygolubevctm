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

				<home:policy_holder xpath="${xpath}/policyHolder" />

				<c:if test="${journeySplitTestActive eq true}">
					<home:other_occupants_v2 xpath="${xpath}/policyHolder" />
				</c:if>

			</layout_v1:slide_content>

		</jsp:body>

	</layout_v1:slide_columns>

	<c:if test="${journeySplitTestActive eq false}">
		<home:other_occupants xpath="${xpath}/policyHolder" />
	</c:if>

	<layout_v1:slide_columns sideHidden="false">
		<jsp:attribute name="rightColumn"></jsp:attribute>

		<jsp:body>

			<layout_v1:slide_content>

				<%-- Commencement Date --%>
				<c:if test="${journeySplitTestActive eq true}">
					<form_v2:fieldset legend="Your preferred date to start the insurance">
						<c:set var="fieldXpath" value="${baseXpath}/startDate" />
						<home:commencementDate xpath="${fieldXpath}" />
					</form_v2:fieldset>
				</c:if>

				<c:if test="${journeySplitTestActive eq false}">
					<home:contact_details xpath="${xpath}/policyHolder" />
				</c:if>

				<c:if test="${journeySplitTestActive eq true}">
					<home:contact_optins xpath="${xpath}" />
				</c:if>

			</layout_v1:slide_content>

		</jsp:body>

	</layout_v1:slide_columns>

</layout_v1:slide>