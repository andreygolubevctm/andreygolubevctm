<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Medicare details group"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="field group's xpath" %>

<%-- VARIABLES --%>
<c:set var="name" 			value="${go:nameFromXpath(xpath)}" />


<%-- HTML --%>
<div id="${name}-selection" class="health-medicare_details">

	<simples:dialogue id="30" vertical="health" mandatory="true" />

	<form_new:fieldset legend="Medicare Details" id="medicare_details" className="medicare_details">

		<c:set var="fieldXpath" value="${xpath}/cover" />
		<form_new:row fieldXpath="${fieldXpath}" label="Are all people to be included on this policy covered by a green or blue Medicare card?" id="medicareCoveredRow" helpId="291">
			<p id="health_medicareDetails_coverMessage"></p>
			<field_new:array_radio items="Y=Yes,N=No" xpath="${fieldXpath}" title="your Medicare card cover" required="true" className="health-medicare_details-card" id="${name}_cover"/>
		</form_new:row>

		<c:set var="fieldXpath" value="${xpath}/number" />
		<form_new:row fieldXpath="${fieldXpath}" label="Your Medicare Card Number">
			<p id="health_medicareDetails_message"></p>
			<field_new:medicare_number xpath="${fieldXpath}" required="true" className="health-medicare_details-number sessioncamexclude" title="Medicare card number" />
		</form_new:row>

		<c:set var="fieldXpath" value="${xpath}/expiry" />
		<form_new:row fieldXpath="${fieldXpath}" label="Medicare Expiry Date">
			<field:cards_expiry rule="mcExp" xpath="${fieldXpath}" title="Medicare card expiry date" required="true" className="health-medicare_details-expiry" maxYears="7"/>
		</form_new:row>

		<c:set var="fieldXpath" value="${xpath}/firstName" />
		<form_new:row fieldXpath="${fieldXpath}" label="First Name on Medicare card">
			<field_new:input xpath="${fieldXpath}" title="first name on the Medicare card" required="true" className="health-medicare_details-first_name sessioncamexclude" />
		</form_new:row>

		<c:set var="fieldXpath" value="${xpath}/middleInitial" />
		<form_new:row fieldXpath="${fieldXpath}" label="Middle Initial on Medicare card">
			<field_new:input xpath="${fieldXpath}" title="middle initial on the Medicare card" maxlength="1" required="false" className="health-medicare_details-initial sessioncamexclude" />
		</form_new:row>

		<c:set var="fieldXpath" value="${xpath}/surname" />
		<form_new:row fieldXpath="${fieldXpath}" label="Last Name on Medicare card">
			<field_new:input xpath="${fieldXpath}" title="last name on the Medicare card" required="true" className="health-medicare_details-surname sessioncamexclude" />
		</form_new:row>

	</form_new:fieldset>

</div>

<go:validate selector="${name}_cover" rule="agree" parm="true" message="To proceed with this policy, you must have a blue or green medicare card" />
