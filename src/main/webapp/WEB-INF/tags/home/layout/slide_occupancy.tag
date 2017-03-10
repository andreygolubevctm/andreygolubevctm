<%@ tag description="Journey slide - Occupancy" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:set var="xpath" value="${pageSettings.getVerticalCode()}" />
<layout_v1:slide formId="occupancyForm" firstSlide="false" nextLabel="Next Step">

	<layout_v1:slide_columns sideHidden="false">

		<jsp:attribute name="rightColumn">
			<home:snapshot />
		</jsp:attribute>

		<jsp:body>

			<layout_v1:slide_content>

				<home:occupancy xpath="${xpath}/occupancy" baseXpath="${xpath}" />

				<c:if test="${journeySplitTestActive eq false}">
					<home:business_activity xpath="${xpath}/businessActivity" />
				</c:if>

				<c:if test="${journeySplitTestActive eq true}">
					<home:cover_history xpath="${xpath}/disclosures" baseXpath="${xpath}" />
				</c:if>

			</layout_v1:slide_content>

		</jsp:body>

	</layout_v1:slide_columns>

</layout_v1:slide>
