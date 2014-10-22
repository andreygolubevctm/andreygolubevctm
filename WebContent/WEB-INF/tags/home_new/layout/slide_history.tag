<%@ tag description="Journey slide - Cover History" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:set var="xpath" value="${pageSettings.getVerticalCode()}" />

<layout:slide formId="coverHistoryForm" nextLabel="Get Quotes">

	<layout:slide_columns sideHidden="false">

		<jsp:attribute name="rightColumn">
			<home_new:snapshot />
		</jsp:attribute>

		<jsp:body>

			<layout:slide_content>

				<home_new:cover_history xpath="${xpath}/disclosures"  />

				<home_new:contact_optins xpath="${xpath}" />

			</layout:slide_content>

		</jsp:body>

	</layout:slide_columns>

</layout:slide>
