<%@ tag description="Journey slide - Occupancy" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:set var="xpath" value="${pageSettings.getVerticalCode()}" />
<layout:slide formId="occupancyForm" firstSlide="false" nextLabel="Next Step">

	<layout:slide_columns sideHidden="false">

		<jsp:attribute name="rightColumn">
			<home_new:snapshot />

			<ui:bubble variant="info">
				<h4>Do you own the home?</h4>
				<p>Even if you are still paying off the home, please select "yes" for the home ownership question.</p>
			</ui:bubble>
		</jsp:attribute>

		<jsp:body>

			<layout:slide_content>

<%-- 				<ui:bubble variant="chatty"> --%>
<!-- 					<h4>Your Home, Your Contents</h4> -->
<!-- 					<p>Tell us about your home and/or contents to compare quotes from our participating providers.</p> -->
<%-- 				</ui:bubble> --%>

				<home_new:occupancy xpath="${xpath}/occupancy" />

				<home_new:business_activity xpath="${xpath}/businessActivity" />

			</layout:slide_content>

		</jsp:body>

	</layout:slide_columns>

</layout:slide>
