<%@ tag description="Journey slide - Your Property" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:set var="xpath" value="${pageSettings.getVerticalCode()}" />
<layout_v1:slide formId="propertyForm" firstSlide="false" nextLabel="Next Step">

	<layout_v1:slide_columns sideHidden="false">

		<jsp:attribute name="rightColumn">
			<home:snapshot />

			<ui:bubble variant="info">
				<h4>Construction Materials</h4>
				<p>Unsure where to find this information?</p>
				<p>If you own the home, you should be able to find this information in your building report.</p>
				<p>If you are a renter, your landlord or building manager will have this information.</p>
			</ui:bubble>
		</jsp:attribute>

		<jsp:body>

			<layout_v1:slide_content>

				<home:property_description xpath="${xpath}/property" />

				<home:property_features xpath="${xpath}/property" />

			</layout_v1:slide_content>

		</jsp:body>

	</layout_v1:slide_columns>

	<home:property_cover_amounts xpath="${xpath}/coverAmounts" />
</layout_v1:slide>
