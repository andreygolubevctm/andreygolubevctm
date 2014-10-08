<%@ tag description="Journey slide" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:set var="xpath" value="quote" />

<layout:slide formId="startForm" firstSlide="true" nextLabel="Next Step">

	<layout:slide_columns sideHidden="false">

		<jsp:attribute name="rightColumn">
			<car:snapshot />
		</jsp:attribute>

		<jsp:body>

			<layout:slide_content>

				<car:vehicle_selection xpath="${xpath}/vehicle" />

			</layout:slide_content>

		</jsp:body>

	</layout:slide_columns>

</layout:slide>