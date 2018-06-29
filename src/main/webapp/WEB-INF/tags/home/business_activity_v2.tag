<%@ tag description="Business Activity" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" required="true" rtexprvalue="true" description="field group's xpath"%>

<%-- VARIABLES --%>
<c:set var="name"  value="${go:nameFromXpath(xpath)}" />

<%-- Business Conducted --%>
<c:set var="fieldXpath" value="${xpath}/conducted" />
<form_v2:row fieldXpath="${fieldXpath}" label="Is there any business activity conducted from the home?">
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
		additionalAttributes="${analyticsAttr}" />
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

<%-- Childcare Children--%>
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
