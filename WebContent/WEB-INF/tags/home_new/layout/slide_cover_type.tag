<%@ tag description="Journey slide - Cover Type" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:set var="xpath" value="${pageSettings.getVerticalCode()}" />

<%-- Load in quicklaunch form values from brochure site --%>
<home_new:quicklaunch_preload />

<layout:slide formId="startForm" firstSlide="true" nextLabel="Next Step">

	<layout:slide_columns sideHidden="false">

		<jsp:attribute name="rightColumn">
			<home_new:snapshot />
			<ui:bubble variant="info">
				<h4>Looking for Landlords Insurance?</h4>
				<p>You'll be given a chance to add this during the application stage, so for now please select "Home Cover Only".</p>
			</ui:bubble>
		</jsp:attribute>

		<jsp:body>

			<layout:slide_content>

				<ui:bubble variant="chatty">
					<h4>Your Home, Your Contents</h4>
					<p>Tell us about your home and/or contents to compare quotes from our participating providers.</p>
				</ui:bubble>

				<home_new:cover_type />

			</layout:slide_content>

		</jsp:body>

	</layout:slide_columns>

</layout:slide>
