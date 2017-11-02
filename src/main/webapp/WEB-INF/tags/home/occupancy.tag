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

	<%-- Address --%>
	<c:set var="fieldXpath" value="${baseXpath}/property/address" />
	<field_v4:address_search_streetsearch xpath="${fieldXpath}" />


	<%-- MoP --%>
	<c:set var="fieldXpath" value="${baseXpath}/underFinance" />
	<c:set var="didExist" value="true" />
	<c:set var="isNewQuote" scope="session">
		<c:choose>
			<c:when test="${not empty param.action and not empty data.current.transactionId and param.action eq 'amend'}">${false}</c:when>
			<c:when test="${empty data['current/transactionId']}">${true}</c:when>
			<c:otherwise>${true}</c:otherwise>
		</c:choose>
	</c:set>


	<c:if test="${empty data[fieldXpath]}">
		<c:if test="${!isNewQuote}">
			<c:set var="didExist" value="false" />
		</c:if>
	</c:if>

	<form_v2:row fieldXpath="${fieldXpath}" label="Do you currently have a mortgage on the property?" className="underFinanceRow">
		<c:set var="analyticsAttr"><field_v1:analytics_attr analVal="Under Finance" quoteChar="\"" /></c:set>
		<field_v2:array_radio xpath="${fieldXpath}"
			className="pretty_buttons"
			required="${didExist}"
			items="Y=Yes,N=No"
			title="if you currently have a mortgage on the property"
			additionalLabelAttributes="${analyticsAttr}" />
	</form_v2:row>

	<%-- PPoR --%>
	<c:set var="fieldXpath" value="${xpath}/principalResidence" />

	<c:choose>
		<c:when test="${landlord eq true}">
		<div class="isLandlord">
			<field_v1:hidden
				xpath="${fieldXpath}"
				defaultValue="N" />
		</div>
		<div class="notLandlord">
			<%-- PPoR --%>
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
		</div>
		</c:when>

		<c:otherwise>
			<div class="isNormalJourney"></div>
			<%-- PPoR --%>
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
		</c:otherwise>
	</c:choose>



	<%-- How Occupied --%>
	<c:set var="fieldXpath" value="${xpath}/howOccupied" />
	<form_v2:row fieldXpath="${fieldXpath}" label="How is the property occupied?" className="howOccupied">
		<field_v2:import_select xpath="${fieldXpath}"
			required="true"
			title="how the home is occupied"
			url="/WEB-INF/option_data/occupied_type.html"
			hideElement="${simplifiedJourneySplitTestActive ? 'true' : 'false'}" />

		<c:if test="${simplifiedJourneySplitTestActive}">
			<div id="hasOccupiedContainer" data-selector="${go:nameFromXpath(fieldXpath)}"></div>
		</c:if>
	</form_v2:row>

	<%-- Toggle landlords question set --%>
	<c:set var="fieldXpath" value="${xpath}/isLandlord" />
	<form_v2:row fieldXpath="${fieldXpath}" label="Are you looking for landlord cover?" className="lookingForLandlord">
		<c:set var="analyticsAttr"><field_v1:analytics_attr analVal="Is Landlords" quoteChar="\"" /></c:set>
		<field_v2:array_radio xpath="${fieldXpath}"
			className="pretty_buttons"
			required="true"
			items="Y=Yes,N=No"
			title="are you looking for landlord"
			additionalLabelAttributes="${analyticsAttr}" />
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

	<c:set var="coverTypeWarningCopy" value="coverTypeWarningCopy" />
	<c:set var="coverTypeWarningCopyLandlord" value="coverTypeWarningCopyLandlord" />

	<core_v1:js_template id="cover-type-warning-template">
		<content:get key="${coverTypeWarningCopy}"/>
	</core_v1:js_template>

	<core_v1:js_template id="cover-type-warning-template-landlord">
		<content:get key="${coverTypeWarningCopyLandlord}"/>
	</core_v1:js_template>

	<field_v1:hidden xpath="${xpath}/coverTypeWarning/chosenOption"/>

</form_v2:fieldset>
