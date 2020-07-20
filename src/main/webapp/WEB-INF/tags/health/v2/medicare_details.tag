<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Medicare details group"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="field group's xpath" %>

<%-- VARIABLES --%>
<c:set var="name" 			value="${go:nameFromXpath(xpath)}" />


<%-- HTML --%>
<div id="${name}-selection" class="health-medicare_details">

	<simples:dialogue id="30" vertical="health" className="red" />

	<form_v3:fieldset legend="Medicare Details" id="medicare_details" className="medicare_details">

		<c:set var="fieldXpath" value="${xpath}/cover" />
		<field_v1:hidden xpath="${fieldXpath}" defaultValue="Y" />

		<c:set var="fieldXpath" value="${xpath}/colour" />
		<form_v3:row fieldXpath="${fieldXpath}" label="What colour is your Medicare card?" id="medicareCoveredRow" helpId="291" smRowOverride="5">
			<p id="health_medicareDetails_coverMessage"></p>
			<field_v2:medicare_colour xpath="${fieldXpath}" />
		</form_v3:row>

		<c:set var="fieldXpath" value="${xpath}/number" />
		<form_v3:row fieldXpath="${fieldXpath}" label="Your Medicare Card Number">
			<p id="health_medicareDetails_message"></p>
			<field_v2:medicare_number xpath="${fieldXpath}" required="true" className="health-medicare_details-number sessioncamexclude" title="Medicare card number" />
		</form_v3:row>

		<c:set var="fieldXpath" value="${xpath}/expiry" />
		<form_v3:row fieldXpath="${fieldXpath}" label="Medicare Expiry Date">
			<field_v1:cards_expiry rule="mcExp" xpath="${fieldXpath}" title="Medicare card expiry date" required="true" className="health-medicare_details-expiry" maxYears="10" medicareCardValidationField="${xpath}/colour"/>
		</form_v3:row>

		<c:set var="fieldXpath" value="${xpath}/firstName" />
		<form_v3:row fieldXpath="${fieldXpath}" label="First Name on Medicare card">
			<field_v2:input xpath="${fieldXpath}" title="first name on the Medicare card" required="true" className="health-medicare_details-first_name sessioncamexclude" maxlength="24" additionalAttributes=" data-rule-personName='true' " />
		</form_v3:row>

		<c:set var="fieldXpath" value="${xpath}/middleInitial" />
		<form_v3:row fieldXpath="${fieldXpath}" label="Middle Initial on Medicare card">
			<field_v2:input xpath="${fieldXpath}" title="middle initial on the Medicare card" maxlength="1" required="false" className="health-medicare_details-initial sessioncamexclude" additionalAttributes=" data-rule-personName='true' " />
		</form_v3:row>

		<c:set var="fieldXpath" value="${xpath}/surname" />
		<form_v3:row fieldXpath="${fieldXpath}" label="Last Name on Medicare card">
			<field_v2:input xpath="${fieldXpath}" title="last name on the Medicare card" required="true" className="health-medicare_details-surname sessioncamexclude" additionalAttributes=" data-rule-personName='true' data-rule-medicareLastName='true' " />
		</form_v3:row>

		<c:set var="fieldXpath" value="${xpath}/cardPosition" />
		<form_v3:row fieldXpath="${fieldXpath}" label="Position you appear on your medicare card"  className="health_payment_medicare_cardPosition-group">
			<field_v2:count_select xpath="${fieldXpath}" min="1" max="9" step="1" title="your medicare card position" required="true" className="health_payment_medicare_cardPosition"/>
		</form_v3:row>

	</form_v3:fieldset>

</div>