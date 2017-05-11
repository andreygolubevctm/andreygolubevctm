<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Homeloan details group"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="field group's xpath" %>
<c:set var="currentLoan" value="${xpath}/currentLoan"/>
<c:set var="situation" value="${xpath}/situation"/>

<c:set var="displayCurrentLoan"><c:out value="${data[currentLoan]}" escapeXml="true"/></c:set>
<c:set var="displaySituation"><c:out value="${data[situation]}" escapeXml="true"/></c:set>

<%-- VARIABLES --%>
<c:set var="name" 			value="${go:nameFromXpath(xpath)}" />

<%-- POPULATE DATA WITH ANY PARAMS RECEIVED --%>


<%-- HTML --%>
<%-- NOTE: situation and goal values need to be kept in sync with com.ctm.web.core.model.homeloan.HomeLoanProductSearchRequest

TODO F=Looking to Re-enter the Market to be added post relaunch
--%>
<form_v2:fieldset legend="Your Situation" >

	<form_v2:row label="I am">
		<field_v2:array_radio xpath="${xpath}/situation"
			required="true"
			className="has-icons situation-radio"
			items="F=A First Home Buyer,E=An Existing Home Owner"
			style="radio-rounded"
			title="the situation you are in"
			additionalLabelAttributes="${analyticsAttr}" />
	</form_v2:row>

	<form_v2:row label="I am looking to">
		<field_v2:array_select items="=Please choose...,FH=Buy my first home,APL=Buy another property to live in,IP=Buy an investment property,REP=Renovate my existing property,CD=Consolidate my debt,CL=Compare better home loan options" xpath="${xpath}/goal" title="your situation" required="true" />
	</form_v2:row>

	<form_v2:row label="I live in">
		<field_v2:lookup_suburb_postcode xpath="${xpath}/location" required="true" placeholder="Suburb / Postcode" extraDataAttributes=" data-rule-validateSuburbPostcodeState='true' data-msg-validateSuburbPostcodeState='Please select a valid suburb / postcode'" />
		<field_v1:hidden xpath="${xpath}/suburb" defaultValue="" />
		<field_v1:hidden xpath="${xpath}/postcode" defaultValue="" />
		<field_v1:hidden xpath="${xpath}/state" defaultValue="" />
	</form_v2:row>

	<div id="${name}_existingToggleArea" class="${name}_existingToggleArea show_${displayCurrentLoan}">
		<form_v2:row label="Do you currently have a home loan?">
			<field_v2:array_radio id="${name}_currentLoan" xpath="${xpath}/currentLoan" required="true" items="Y=Yes,N=No" title="${title}whether you currently have a home loan" />
		</form_v2:row>
		<div id="${name}_currentLoanToggleArea" class="${name}_currentLoanToggleArea show_${displayCurrentLoan}">
			<form_v2:row label="How much do you have owing on your existing home loan(s)?">
				<field_v2:currency xpath="${xpath}/amountOwing" decimal="${false}" defaultValue="" title="Existing home loan" required="true" maxValue="1000000000" pattern="[0-9]*" />
			</form_v2:row>
		</div>

		<form_v2:row label="What is the current value of your existing property(ies)?">
			<field_v2:currency xpath="${xpath}/assetAmount" title="Current property value" decimal="${false}" defaultValue="" required="true" maxValue="1000000000" pattern="[0-9]*" />
		</form_v2:row>
	</div>



</form_v2:fieldset>