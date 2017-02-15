<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description=""%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>


<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"		 rtexprvalue="true"	 description="data xpath" %>
<%@ attribute name="label" 		required="false"	 rtexprvalue="true"	 description="The row heading label." %>

<c:set var="primaryXPath" value="${xpath}/primary/insurance" />
<c:set var="partnerXPath" value="${xpath}/partner/insurance" />

<c:set var="fieldLabel" value="Who is the cover for?" />
<c:set var="fieldXPath" value="${primaryXPath}/partner" />
<form_v3:row label="${fieldLabel}">
	<field_v2:array_radio xpath="${fieldXPath}" required="true" title="${fieldLabel}" items="N=Just for You,Y=You & your partner" defaultValue="N" />
</form_v3:row>

<c:set var="fieldLabel" value="Would you like to be covered for the same amount?" />
<c:set var="fieldXPath" value="${primaryXPath}/samecover" />
<form_v3:row label="${fieldLabel}" id="partnerSameCoverRadio">
	<field_v2:array_radio xpath="${fieldXPath}" required="true" title="if you would like to be covered for the same amount" items="Y=Same cover,N=Different cover" />
</form_v3:row>

<div id="primaryInsuranceAmountFields" class="insuranceAmountContainer">
	<c:set var="fieldLabel" value="Your Term Life Cover" />
	<c:set var="fieldXPath" value="${primaryXPath}/term" />
	<form_v3:row label="${fieldLabel}" helpId="409">
		<div class="input-group">
			<div class="input-group-addon">$</div>
			<field_v2:input type="text" xpath="${fieldXPath}" required="false" title="${fieldLabel}" placeHolder="0" className="currency" additionalAttributes=" data-rule-validateInsuranceAmount='true'" />
		</div>
	</form_v3:row>

	<c:set var="fieldLabel" value="Total and Permanent Disability (TPD)" />
	<c:set var="fieldXPath" value="${primaryXPath}/tpd" />
	<form_v3:row label="${fieldLabel}" helpId="410">
		<div class="input-group">
			<div class="input-group-addon">$</div>
			<field_v2:input type="text" xpath="${fieldXPath}" required="false" title="${fieldLabel}" placeHolder="0" className="currency" additionalAttributes=" data-rule-validateInsuranceAmount='true'" />
		</div>
	</form_v3:row>

	<c:set var="fieldLabel" value="Trauma Cover" />
	<c:set var="fieldXPath" value="${primaryXPath}/trauma" />
	<form_v3:row label="${fieldLabel}" helpId="408">
		<div class="input-group">
			<div class="input-group-addon">$</div>
			<field_v2:input type="text" xpath="${fieldXPath}" required="false" title="${fieldLabel}" placeHolder="0" className="currency" additionalAttributes=" data-rule-validateInsuranceAmount='true'" />
		</div>
	</form_v3:row>
</div>

<div id="partnerInsuranceAmountFields" class="insuranceAmountContainer">
	<c:set var="fieldLabel" value="Your Partner's Term Life Cover" />
	<c:set var="fieldXPath" value="${partnerXPath}/term" />
	<form_v3:row label="${fieldLabel}" helpId="409">
		<div class="input-group">
			<div class="input-group-addon">$</div>
			<field_v2:input type="text" xpath="${fieldXPath}" required="false" title="${fieldLabel}" placeHolder="0" className="currency" additionalAttributes=" data-rule-validateInsuranceAmount='true'" />
		</div>
	</form_v3:row>

	<c:set var="fieldLabel" value="Total and Permanent Disability (TPD)" />
	<c:set var="fieldXPath" value="${partnerXPath}/tpd" />
	<form_v3:row label="${fieldLabel}" helpId="410">
		<div class="input-group">
			<div class="input-group-addon">$</div>
			<field_v2:input type="text" xpath="${fieldXPath}" required="false" title="${fieldLabel}" placeHolder="0" className="currency" additionalAttributes=" data-rule-validateInsuranceAmount='true'" />
		</div>
	</form_v3:row>

	<c:set var="fieldLabel" value="Trauma Cover" />
	<c:set var="fieldXPath" value="${partnerXPath}/trauma" />
	<form_v3:row label="${fieldLabel}" helpId="408">
		<div class="input-group">
			<div class="input-group-addon">$</div>
			<field_v2:input type="text" xpath="${fieldXPath}" required="false" title="${fieldLabel}" placeHolder="0" className="currency" additionalAttributes=" data-rule-validateInsuranceAmount='true'" />
		</div>
	</form_v3:row>
</div>