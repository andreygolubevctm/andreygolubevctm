<%@ tag description="Journey slide" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:set var="xpath" value="quote" />

<%-- Load in preselected factory options and accessories --%>
<car:options_preselections />

<layout:slide formId="optionsForm" nextLabel="Next Step">

	<layout:slide_columns sideHidden="false">

		<jsp:attribute name="rightColumn">
			<c:if test="${showRegoLookupContent eq false}">
				<car:snapshot />
			</c:if>
		</jsp:attribute>

		<jsp:body>
			<layout:slide_content>

				<ui:bubble variant="chatty">
					<h4>Options, Accessories & Modifications</h4>
					<p>By listing all of the options, accessories and modifications, the insurer will be able to get a more accurate idea of the car's true value.</p>
				</ui:bubble>

				<car:options_factory xpath="${xpath}/vehicle/factoryOptions" />

				<car:options_accessories xpath="${xpath}/vehicle/accessories" />

				<car:options_modifications xpath="${xpath}/vehicle/modifications" />

				<car:options_usage xpath="${xpath}/vehicle" />

				<car:options_dialog_inputs xpath="${xpath}/vehicle/options/inputs/container" />

			</layout:slide_content>
		</jsp:body>

	</layout:slide_columns>

</layout:slide>