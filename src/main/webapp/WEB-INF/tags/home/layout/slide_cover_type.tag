<%@ tag description="Journey slide - Cover Type" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:set var="xpath" value="${pageSettings.getVerticalCode()}" />

<layout_v1:slide formId="startForm" firstSlide="true" nextLabel="Next Step">

	<layout_v1:slide_columns sideHidden="false">

		<jsp:attribute name="rightColumn">
			<home:snapshot />
			<ui:bubble variant="info">
				<h4>Looking for Landlords Insurance?</h4>
				<p>You'll be given a chance to add this during the application stage, so for now please select "Home Cover Only".</p>
			</ui:bubble>
		</jsp:attribute>

		<jsp:body>

			<layout_v1:slide_content>
				<%-- PROVIDER TESTING --%>
				<agg_v1:provider_testing xpath="${xpath}" displayFullWidth="true" keyLabel="authToken" filterProperty="providerList" hideSelector="${false}" />

			<c:choose>
			<c:when test="${brochurewarePassedParams}">
				<form_v2:fieldset legend="Cover for your home">

					<%-- Own the home --%>
					<c:set var="fieldXpath" value="${xpath}/occupancy/ownProperty" />
					<form_v2:row fieldXpath="${fieldXpath}" label="Are you the home owner or are you renting?">
						<field_v2:array_radio xpath="${fieldXpath}"
							className="ownProperty pretty_buttons"
							required="true"
							items="Y=Yes,N=No"
							title="if you own the home" />
					</form_v2:row>

					<%-- Cover type --%>
					<c:set var="fieldXpath" value="${xpath}/coverType" />
					<form_v2:row fieldXpath="${fieldXpath}" label="Type of cover">
						<field_v2:import_select xpath="${fieldXpath}"
							required="true"
							title="the type of cover"
							url="/WEB-INF/option_data/home_contents_cover_type.html" />
					</form_v2:row>

				</form_v2:fieldset>
			</c:when>
			<c:otherwise>

				<ui:bubble variant="chatty">
					<h4>Your Home, Your Contents</h4>
					<p>Tell us about your home and/or contents to compare quotes from our participating providers.</p>
				</ui:bubble>

				<home:cover_type />

			</c:otherwise>
			</c:choose>

			</layout_v1:slide_content>

		</jsp:body>

	</layout_v1:slide_columns>

</layout_v1:slide>
