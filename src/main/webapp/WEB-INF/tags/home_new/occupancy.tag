<%@ tag description="Occupancy and Business Activity" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" required="true" rtexprvalue="true" description="field group's xpath"%>

<%-- VARIABLES --%>
<c:set var="name"  value="${go:nameFromXpath(xpath)}" />

<%-- Use the server date to discourage the user from doing naughty things --%>
<jsp:useBean id="now" class="java.util.Date" />
<fmt:formatDate var="currentYear" pattern="yyyy" value="${now}" />

<%-- Setup the items list --%>
	<c:set var="items" value="=Please Select...,${currentYear}=This Year (${currentYear})" />
	<c:set var="items" value="${items},${currentYear - 1}=Last Year (${currentYear - 1})" />
	<c:forEach var="num" begin="2" end="5" step="1">
		<c:set var="items"
			value="${items},${currentYear - num}=${num} Years Ago (${currentYear - num})" />
	</c:forEach>
	<c:set var="items" value="${items},${currentYear - 6}=More than 5 years,NotAtThisAddress=Not yet living at this address" />

<form_new:fieldset legend="Occupancy Details">

	<%-- Own the home --%>
	<c:set var="fieldXpath" value="${xpath}/ownProperty" />
	<form_new:row fieldXpath="${fieldXpath}" label="Do you own the home?">
		<field_new:array_radio xpath="${fieldXpath}"
			className="ownProperty pretty_buttons"
			required="true"
			items="Y=Yes,N=No"
			title="if you own the home" />
	</form_new:row>

	<%-- PPoR --%>
	<c:set var="fieldXpath" value="${xpath}/principalResidence" />
	<form_new:row fieldXpath="${fieldXpath}" label="Is it your principal place of residence?" helpId="503">
		<field_new:array_radio xpath="${fieldXpath}"
			className="principalResidence pretty_buttons"
			required="true"
			items="Y=Yes,N=No"
			title="if this is your principal place of residence" />
	</form_new:row>

	<%-- How Occupied --%>
	<c:set var="fieldXpath" value="${xpath}/howOccupied" />
	<form_new:row fieldXpath="${fieldXpath}" label="How is the home occupied?" className="howOccupied">
		<field_new:import_select xpath="${fieldXpath}"
			required="true"
			title="how the home is occupied"
			url="/WEB-INF/option_data/occupied_type.html"/>
	</form_new:row>

	<%-- When Moved in Year + Month --%>
	<c:set var="fieldXpath" value="${xpath}/whenMovedIn/year" />
	<form_new:row fieldXpath="${fieldXpath}" label="When did you move into the home?" className="whenMovedInYear">
		<field_new:array_select xpath="${fieldXpath}"
			items="${items}"
			title="when you moved into the home"
			required="true" />
	</form_new:row>

	<c:set var="fieldXpath" value="${xpath}/whenMovedIn/month" />
	<form_new:row fieldXpath="${fieldXpath}" label="Month you move into the home?" helpId="504" className="whenMovedInMonth">
		<field_new:import_select xpath="${fieldXpath}"
			required="true"
			omitPleaseChoose="Y"
			title="the month you moved into the home"
			url="/WEB-INF/option_data/month_full.html"/>
	</form_new:row>

	<core:js_template id="cover-type-warning-template">
		<content:get key="coverTypeWarningCopy"/>
	</core:js_template>

	<field:hidden xpath="${xpath}/coverTypeWarning/chosenOption"/>

</form_new:fieldset>