<%@ tag description="Journey slide" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:set var="xpath" value="quote" />
<c:set var="nextStepLabel" value="Next Step" />
<c:set var="nextStepLabel" value="Continue" />

<layout_v1:slide formId="startForm" firstSlide="true" nextLabel="${nextStepLabel}">

	<layout_v1:slide_columns sideHidden="false">

		<jsp:attribute name="rightColumn">
			<car:snapshot />
		</jsp:attribute>

		<jsp:body>
			<layout_v1:slide_content>
				<%-- PROVIDER TESTING --%>
				<agg_v1:provider_testing xpath="${xpath}" displayFullWidth="true" keyLabel="authToken" filterProperty="providerList" hideSelector="${false}" />

				<car:vehicle_selection xpath="${xpath}/vehicle" />
				<c:if test="${isFromExoticPage eq true}">
					<car:exotic_vehicle_selection xpath="${xpath}/vehicle/exotic" />
				</c:if>
				<car:rego_lookup xpath="${xpath}/regoLookup" />
			</layout_v1:slide_content>
		</jsp:body>

	</layout_v1:slide_columns>

</layout_v1:slide>