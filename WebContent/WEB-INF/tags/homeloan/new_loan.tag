<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Life Contact Details group"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>


<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="data xpath" %>

<%-- VARIABLES --%>
<c:set var="name"  value="${go:nameFromXpath(xpath)}" />
<c:set var="contactNumber"	value="${go:nameFromXpath(xpath)}_contactNumber" />
<c:set var="optIn"	value="${go:nameFromXpath(xpath)}_call" />
<c:set var="displayFoundAProperty"><c:out value="${data[foundAProperty]}" escapeXml="true"/></c:set>

<%-- HTML --%>
<div id="${name}-selection" class="${name}">

	<form_new:fieldset legend="Your New Home Loan">

		<form_new:row label="How much can you contribute to the purchase of the new property?">
			<field_new:currency xpath="${xpath}/contribution" title="your contribution amount" required="" />
		</form_new:row>

		<form_new:row label="Have you found a property?">
			<field_new:array_radio id="${name}_foundAProperty" xpath="${xpath}/foundAProperty" required="true" items="Y=Yes,N=No" title="${title} whether you have found a property" />
		</form_new:row>

		<div id="${name}_foundToggleArea" class="${name}_foundToggleArea show_${displayFoundAProperty}">
			<form_new:row label="When are you looking to make an offer?">
				<field_new:array_select items="=Please choose...,Within the next month=Within the next month,1-3 months=1-3 months,4-6 months=4-6 months,After 6 months=After 6 months" xpath="${xpath}/offerTime" title="your offer timing" required="true" />
			</form_new:row>

			<form_new:row label="The property is">
				<field_new:array_select items="=Please choose...,An existing property=An existing property,New Construction=New Construction,Off-the-Plan=Off-the-Plan" xpath="${xpath}/propertyType" title="your property type" required="true" />
			</form_new:row>
		</div>

		<form_new:row label="What is your employment status?">
			<field_new:array_select items="=Please choose...,Employed Full-time=Employed Full-time,Employed Part-time=Employed Part-time,Casual=Casual,Contract=Contract,Self-employed=Self-employed,Unemployed=Unemployed,Other=Other" xpath="${xpath}/employmentType" title="your employment status" required="true" />
		</form_new:row>

		<form_new:row label="Additional Information">
			<field:textarea xpath="${xpath}/additionalInformation" required="false" title="any additional information" />
		</form_new:row>
	</form_new:fieldset>
</div>
