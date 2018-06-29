<%@ tag description="Business Activity" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" required="true" rtexprvalue="true" description="field group's xpath"%>
<%@ attribute name="baseXpath" required="true" rtexprvalue="true" description="base xpath"%>

<%-- VARIABLES --%>
<c:set var="name"  value="${go:nameFromXpath(xpath)}" />

<c:set var="legend" value="Business Activity" />

<form_v2:fieldset legend="">

	<div class="notLandlord">
		<h2>Business Activity</h2>
	</div>
	<div class="isLandlord">
		<h2>Rental Details</h2>
	</div>

	<c:set var="fieldXpath" value="${xpath}/conducted" />
	<form_v2:row fieldXpath="${fieldXpath}" label="Is there any business activity conducted from the property?">
		<c:set var="analyticsAttr"><field_v1:analytics_attr analVal="Business Activity" quoteChar="\"" /></c:set>
		<field_v2:array_radio xpath="${fieldXpath}"
			required="true"
			className="pretty_buttons"
			title="if there is any business activity"
			items="Y=Yes,N=No"
			id=""
			additionalLabelAttributes="${analyticsAttr}" />
	</form_v2:row>

	<%-- Business Type --%>
	<c:set var="fieldXpath" value="${xpath}/businessType" />
	<form_v2:row fieldXpath="${fieldXpath}" label="What type of business is it?" className="businessType">
		<c:set var="analyticsAttr"><field_v1:analytics_attr analVal="Business Type" quoteChar="\"" /></c:set>
		<field_v2:import_select xpath="${fieldXpath}"
			required="true"
			title="the type of business activity"
			url="/WEB-INF/option_data/business_type.html"
			additionalAttributes="${analyticsAttr}"
			hideElement="${simplifiedJourneySplitTestActive ? 'true' : 'false'}" />

			<c:if test="${simplifiedJourneySplitTestActive}">
				<div id="businessTypeContainer" data-selector="${go:nameFromXpath(fieldXpath)}"></div>
			</c:if>
	</form_v2:row>

	<%-- Business Rooms --%>
	<c:set var="fieldXpath" value="${xpath}/rooms" />
	<form_v2:row fieldXpath="${fieldXpath}" label="How many rooms are used for business?" className="businessRooms">
		<c:set var="analyticsAttr"><field_v1:analytics_attr analVal="Rooms Used" quoteChar="\"" /></c:set>
		<field_v2:array_select xpath="${fieldXpath}"
			required="true"
			title="how many rooms are used for business"
			items="=Please select...,1=1,2=2,3=3,4=4,5=5,6=6,7=7+"
			extraDataAttributes="${analyticsAttr}" />
	</form_v2:row>

	<%-- Business Employees --%>
	<c:set var="fieldXpath" value="${xpath}/employees" />
	<form_v2:row fieldXpath="${fieldXpath}" label="Are there any employees (other than household members) who work at the home?" className="hasEmployees">
		<c:set var="analyticsAttr"><field_v1:analytics_attr analVal="Any Employees" quoteChar="\"" /></c:set>
		<field_v2:array_radio xpath="${fieldXpath}"
			required="true"
			className="pretty_buttons"
			title="if there any other employees (other than household members) who work at the home"
			items="Y=Yes,N=No"
			additionalLabelAttributes="${analyticsAttr}" />
	</form_v2:row>

	<%-- Childcare Children --%>
	<c:set var="fieldXpath" value="${xpath}/childcareChildren" />
	<form_v2:row fieldXpath="${fieldXpath}" label="What is the maximum number of children cared for at the property at any one time?" className="childcareChildren">
		<c:set var="analyticsAttr"><field_v1:analytics_attr analVal="How many childcare children" quoteChar="\"" /></c:set>
		<field_v2:array_select xpath="${fieldXpath}"
			required="true"
			title="maximum number of children cared for at the property at any one time"
			items="=Please select...,1=1,2=2,3=3,4=4,5=5,6=6,7=7+"
			extraDataAttributes="${analyticsAttr}" />
	</form_v2:row>

	<%-- Registered Childcare --%>
	<c:set var="fieldXpath" value="${xpath}/registeredChildcare" />
	<form_v2:row fieldXpath="${fieldXpath}" label="Is the Childcare service registered?" className="registeredChildcare">
		<c:set var="analyticsAttr"><field_v1:analytics_attr analVal="Registered childcare" quoteChar="\"" /></c:set>
		<field_v2:array_radio xpath="${fieldXpath}"
			required="true"
			className="pretty_buttons"
			title="childcare service registered"
			items="Y=Yes,N=No"
			additionalLabelAttributes="${analyticsAttr}" />
	</form_v2:row>

	<%-- Amount of Employees --%>
	<c:set var="fieldXpath" value="${xpath}/employeeAmount" />
	<form_v2:row fieldXpath="${fieldXpath}" label="How many employees?" className="employeeAmount">
		<c:set var="analyticsAttr"><field_v1:analytics_attr analVal="How many employees" quoteChar="\"" /></c:set>
		<field_v2:array_select xpath="${fieldXpath}"
			required="true"
			title="how many employees work at the home"
			items="=Please select...,1=1,2=2,3=3,4=4,5=5,6=6,7=7+"
			extraDataAttributes="${analyticsAttr}" />
	</form_v2:row>

	<div class="isLandlord">

		<%-- Property Managed by --%>
		<c:set var="fieldXpath" value="${baseXpath}/landlordDetails/propertyManagedBy" />
		<form_v2:row fieldXpath="${fieldXpath}" label="Who manages the property?" className="managesProperty">
			<c:set var="analyticsAttr"><field_v1:analytics_attr analVal="Manages Property" quoteChar="\"" /></c:set>
			<field_v2:array_select xpath="${fieldXpath}"
				required="true"
				title="who manages the property"
				items="=Please select...,REAL_ESTATE=Real Estate Agent or Property Manager,SELF_MANAGED=Self-managed for more than 3 years,OTHER=Other"
				extraDataAttributes="${analyticsAttr}" />
		</form_v2:row>

		<%-- Valid lease agreement  --%>
		<c:set var="fieldXpath" value="${baseXpath}/landlordDetails/validRentalLease" />
		<form_v2:row fieldXpath="${fieldXpath}" label="Do you have a written rental agreement in place?" className="validRentalLease">
			<c:set var="analyticsAttr"><field_v1:analytics_attr analVal="Valid Rental Lease" quoteChar="\"" /></c:set>
			<field_v2:array_radio xpath="${fieldXpath}"
				required="true"
				className="pretty_buttons"
				title="Do you have a written rental agreement in place"
				items="Y=Yes,N=No"
				additionalLabelAttributes="${analyticsAttr}" />
		</form_v2:row>

		<%-- Do you intend to have a wrritten rental agreement --%>
		<c:set var="fieldXpath" value="${baseXpath}/landlordDetails/pendingRentalLease" />
		<form_v2:row fieldXpath="${fieldXpath}" label="Do you intend to have a written rental agreement in place in the next 60 days?" className="pendingRentalLease">
			<c:set var="analyticsAttr"><field_v1:analytics_attr analVal="Pending Rental Lease" quoteChar="\"" /></c:set>
			<field_v2:array_radio xpath="${fieldXpath}"
				required="true"
				className="pretty_buttons"
				title="Do you intend to have a written rental agreement in place in the next 60 days"
				items="Y=Yes,N=No"
				additionalLabelAttributes="${analyticsAttr}" />
		</form_v2:row>


		<%-- Weekly Rent Value --%>
		<c:set var="fieldXpath" value="${baseXpath}/landlordDetails/weeklyRentValue" />
		<form_v2:row fieldXpath="${fieldXpath}" label="What is the weekly rental income?">
			<c:set var="analyticsAttr"><field_v1:analytics_attr analVal="Weekly Rental Income" quoteChar="\"" /></c:set>
			<field_v2:currency xpath="${fieldXpath}"
				required="true"
				title="Rental Income"
				className="specifiedValues"
				minValue="100"
				maxValue="3000"
				decimal="${false}"
				defaultValue=""
				additionalAttributes="${analyticsAttr}" />
		</form_v2:row>


		<%-- Number of tenants --%>
		<c:set var="fieldXpath" value="${baseXpath}/landlordDetails/numberOfTenants" />
		<form_v2:row fieldXpath="${fieldXpath}" label="How many tenants have you had in the past 12 months?" className="howManyTenants">
			<c:set var="analyticsAttr"><field_v1:analytics_attr analVal="Number of Tenants" quoteChar="\"" /></c:set>
			<field_v2:array_select xpath="${fieldXpath}"
				required="true"
				title="How many tenants have you had in the past 12 months"
				items="=Please select...,0=None,1=1,2=2,3=3,4=4+"
				extraDataAttributes="${analyticsAttr}" />
		</form_v2:row>
	</div>

</form_v2:fieldset>
