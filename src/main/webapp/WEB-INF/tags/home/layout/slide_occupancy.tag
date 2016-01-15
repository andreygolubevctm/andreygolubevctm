<%@ tag description="Journey slide - Occupancy" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:set var="xpath" value="${pageSettings.getVerticalCode()}" />
<layout_v1:slide formId="occupancyForm" firstSlide="false" nextLabel="Next Step">

	<layout_v1:slide_columns sideHidden="false">

		<jsp:attribute name="rightColumn">
			<home:snapshot />

			<ui:bubble variant="info">
				<h4>Do you own the home?</h4>
				<p>Even if you are still paying off the home, please select "yes" for the home ownership question.</p>
			</ui:bubble>
		</jsp:attribute>

		<jsp:body>

			<layout_v1:slide_content>

<%-- 				<ui:bubble variant="chatty"> --%>
<!-- 					<h4>Your Home, Your Contents</h4> -->
<!-- 					<p>Tell us about your home and/or contents to compare quotes from our participating providers.</p> -->
<%-- 				</ui:bubble> --%>

				<home:occupancy xpath="${xpath}/occupancy" />

				<home:business_activity xpath="${xpath}/businessActivity" />

			</layout_v1:slide_content>

		</jsp:body>

	</layout_v1:slide_columns>

</layout_v1:slide>
