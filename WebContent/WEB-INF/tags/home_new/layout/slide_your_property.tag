<%@ tag description="Journey slide - Your Property" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:set var="xpath" value="${pageSettings.getVerticalCode()}" />
<layout:slide formId="propertyForm" firstSlide="false" nextLabel="Next Step">

	<layout:slide_columns sideHidden="false">

		<jsp:attribute name="rightColumn">
			<home_new:snapshot />

			<ui:bubble variant="info">
				<h4>Construction Materials</h4>
				<p>Unsure where to find this information?</p>
				<p>If you own the home, you should be able to find this information in your building report.</p>
				<p>If you are a renter, your landlord or building manager will have this information.</p>
			</ui:bubble>
		</jsp:attribute>

		<jsp:body>

			<layout:slide_content>

				<home_new:property_description xpath="${xpath}/property" />

				<home_new:property_features xpath="${xpath}/property" />

			</layout:slide_content>

		</jsp:body>

	</layout:slide_columns>

	<home_new:property_cover_amounts xpath="${xpath}/coverAmounts" />
</layout:slide>
