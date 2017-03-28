<%@ tag description="Occupancy and Business Activity" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" required="true" rtexprvalue="true" description="field group's xpath"%>
<%@ attribute name="baseXpath" required="true" rtexprvalue="true" description="base xpath"%>

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

<form_v2:fieldset legend="Occupancy Details">
	<%-- Commencement Date --%>
	<c:if test="${journeySplitTestActive eq false}">
		<c:set var="fieldXpath" value="${baseXpath}/startDate" />
		<home:commencementDate xpath="${fieldXpath}" />
	</c:if>

	<%-- Address --%>
	<c:set var="fieldXpath" value="${baseXpath}/property/address" />
	<group_v2:elastic_address xpath="${fieldXpath}" type="R" />

	<%-- PPoR --%>
	<c:set var="fieldXpath" value="${xpath}/principalResidence" />
	<c:set var="analyticsAttr"><field_v1:analytics_attr analVal="Principal Residence - Tool Tip" quoteChar="\"" /></c:set>
	<form_v2:row fieldXpath="${fieldXpath}" label="Is it your principal place of residence?" helpId="503" tooltipAttributes="${analyticsAttr}">
		<c:set var="analyticsAttr"><field_v1:analytics_attr analVal="Principal Residence" quoteChar="\"" /></c:set>
		<field_v2:array_radio xpath="${fieldXpath}"
			className="principalResidence pretty_buttons"
			required="true"
			items="Y=Yes,N=No"
			title="if this is your principal place of residence"
			additionalLabelAttributes="${analyticsAttr}" />
	</form_v2:row>

	<%-- How Occupied --%>
	<c:set var="fieldXpath" value="${xpath}/howOccupied" />
	<form_v2:row fieldXpath="${fieldXpath}" label="How is the home occupied?" className="howOccupied">
		<field_v2:import_select xpath="${fieldXpath}"
			required="true"
			title="how the home is occupied"
			url="/WEB-INF/option_data/occupied_type.html"
			hideElement="${simplifiedJourneySplitTestActive ? 'true' : 'false'}" />

		<c:if test="${simplifiedJourneySplitTestActive}">
			<div id="hasOccupiedContainer" data-selector="${go:nameFromXpath(fieldXpath)}"></div>
		</c:if>
	</form_v2:row>

	<%-- When Moved in Year + Month --%>
	<c:set var="fieldXpath" value="${xpath}/whenMovedIn/year" />
	<form_v2:row fieldXpath="${fieldXpath}" label="When did you move into the home?" className="whenMovedInYear">
		<c:set var="analyticsAttr"><field_v1:analytics_attr analVal="Years Since Move" quoteChar="\"" /></c:set>
		<field_v2:array_select xpath="${fieldXpath}"
			items="${items}"
			title="when you moved into the home"
			required="true"
			extraDataAttributes="${analyticsAttr}" />
	</form_v2:row>

	<c:set var="fieldXpath" value="${xpath}/whenMovedIn/month" />
	<c:set var="analyticsAttr"><field_v1:analytics_attr analVal="Move in Month - Tool Tip" quoteChar="\"" /></c:set>
	<form_v2:row fieldXpath="${fieldXpath}" label="Month you move into the home?" helpId="504"
				 className="whenMovedInMonth" tooltipAttributes="${analyticsAttr}">
		<field_v2:import_select xpath="${fieldXpath}"
			required="true"
			omitPleaseChoose="Y"
			title="the month you moved into the home"
			url="/WEB-INF/option_data/month_full.html"/>
	</form_v2:row>

	<core_v1:js_template id="cover-type-warning-template">
		<content:get key="coverTypeWarningCopy"/>
	</core_v1:js_template>

	<field_v1:hidden xpath="${xpath}/coverTypeWarning/chosenOption"/>

	<c:if test="${journeySplitTestActive eq true}">
		<home:business_activity_v2 xpath="home/businessActivity" />
	</c:if>

</form_v2:fieldset>