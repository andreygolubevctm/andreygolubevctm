<%@ tag description="Cover History" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" required="true" rtexprvalue="true" description="field group's xpath"%>

<%-- VARIABLES --%>
<c:set var="name"  value="${go:nameFromXpath(xpath)}" />

<jsp:useBean id="past" class="java.util.GregorianCalendar" />
<% past.add(java.util.GregorianCalendar.YEAR, -5); %>
<fmt:formatDate var="past_Date" pattern="yyyy-MM-dd" value="${past.time}" />

<jsp:useBean id="future" class="java.util.GregorianCalendar" />
<% future.add(java.util.GregorianCalendar.YEAR, 1); %>
<fmt:formatDate var="future_Date" pattern="yyyy-MM-dd" value="${future.time}" />

<form_new:fieldset legend="Previous Cover">

	<%-- Previous Insurance --%>
	<c:set var="fieldXpath" value="${xpath}/previousInsurance" />
	<form_new:row fieldXpath="${fieldXpath}" label="Have you had home and/or contents insurance in the last 5 years?">
		<field_new:array_radio xpath="${fieldXpath}"
			required="true"
			items="Y=Yes,N=No"
			title="if you have had insurance in the last 5 years"/>
	</form_new:row>

	<%-- At the current address --%>
	<c:set var="fieldXpath" value="${xpath}/atCurrentAddress" />
	<form_new:row fieldXpath="${fieldXpath}" label="Was the insurance policy for the same address as this quote?" className="atCurrentAddress">
		<field_new:array_radio xpath="${fieldXpath}"
			required="true"
			items="Y=Yes,N=No"
			title="if the insurance was for this address"/>
	</form_new:row>

	<%-- Insured with whom? --%>
	<c:set var="fieldXpath" value="${xpath}/insurer" />
	<form_new:row fieldXpath="${fieldXpath}" label="Who was the insurance with?" className="pastInsurer">
		<field_new:import_select xpath="${fieldXpath}"
			className="insurance_companies"
			url="/WEB-INF/option_data/home_contents_insurers.html"
			title = "who the insurance policy was with"
			required="true" />
	</form_new:row>

	<%-- Expiry date. Anytime within the last 5 years or up to 1 year in the future --%>
	<c:set var="fieldXpath" value="${xpath}/expiry" />
	<form_new:row fieldXpath="${fieldXpath}" label="Expiry date of the policy" className="insuranceExpiry">
			<field_new:calendar xpath="${fieldXpath}"
			mode="separated"
			validateMinMax="true"
			required="true"
			title="the expiry date of the previous insurance policy"
			minDate="${past_Date}"
			maxDate="${future_Date}"
			startView="0" />

	</form_new:row>

	<%-- Cover Length --%>
	<c:set var="fieldXpath" value="${xpath}/coverLength" />
	<form_new:row fieldXpath="${fieldXpath}" label="How long have you had the insurance?" className="insuranceCoverLength">
		<field_new:import_select xpath="${fieldXpath}"
			className="coverLength"
			url="/WEB-INF/option_data/home_contents_past_insurance_duration.html"
			title = "how long you have had the insurance"
			required="true" />
	</form_new:row>

	<%-- Claims --%>
	<c:set var="fieldXpath" value="${xpath}/claims" />
	<form_new:row fieldXpath="${fieldXpath}" label="In the last 5 years, have you or any other household member had any thefts, burglaries or made any insurance claims for home and/or contents?" id="claimsRow">
		<field_new:array_radio xpath="${fieldXpath}"
			required="true"
			items="Y=Yes,N=No"
			title="if the policy holder, or any other household member has had any thefts, burglaries or has made any home and/or contents insurance claims in the last 5 years." />
	</form_new:row>

</form_new:fieldset>