<%@ tag description="Journey slide - Cover History" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:set var="xpath" value="${pageSettings.getVerticalCode()}" />

<c:set var="buttonLabel" value="Get Quotes" />

<layout_v1:slide formId="coverHistoryForm" nextLabel="${buttonLabel}">

	<layout_v1:slide_columns sideHidden="false">

		<jsp:attribute name="rightColumn">
			<home:snapshot />
		</jsp:attribute>

		<jsp:body>

			<layout_v1:slide_content>
				<c:if test="${journeySplitTestActive eq false}">
					<home:cover_history xpath="${xpath}/disclosures"  />
					<home:contact_optins xpath="${xpath}" />
				</c:if>
			</layout_v1:slide_content>

		</jsp:body>

	</layout_v1:slide_columns>

</layout_v1:slide>
