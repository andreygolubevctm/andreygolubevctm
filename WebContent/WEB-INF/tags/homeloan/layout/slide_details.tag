<%@ tag description="The Home Loans Journey's 'Details' Slide" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<layout:slide>

	<layout:slide_columns sideHidden="true">

		<jsp:attribute name="rightColumn">
		</jsp:attribute>

		<jsp:body>

			<layout:slide_content>

				<form id="situationForm" autocomplete="off" class="form-horizontal" role="form">
					<homeloan:questionset xpath="${pageSettings.getVerticalCode()}" />
				</form>

			</layout:slide_content>

		</jsp:body>

	</layout:slide_columns>

</layout:slide>