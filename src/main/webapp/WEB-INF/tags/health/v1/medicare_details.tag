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

		<c:set var="fieldXpath" value="${xpath}/cover" />
		<form_v2:row fieldXpath="${fieldXpath}" label="Are all people to be included on this policy covered by a green or blue Medicare card?" id="medicareCoveredRow" helpId="291" smRowOverride="5">
			<p id="health_medicareDetails_coverMessage"></p>
			<field_v2:array_radio items="Y=Yes,N=No" xpath="${fieldXpath}" title="your Medicare card cover" required="true" className="health-medicare_details-card" id="${name}_cover" additionalAttributes=" data-rule-isCheckedYes='true' data-msg-isCheckedYes='To proceed with this policy, you must have a blue or green medicare card' "/>
		</form_v2:row>

		<form_v2:row label="Medicare card number and expiry" hideHelpIconCol="true" className="row" addRowClass="${true}">
			<p id="health_medicareDetails_message"></p>
			<c:set var="fieldXpath" value="${xpath}/number" />
			<form_v2:row fieldXpath="${fieldXpath}" label="Your Medicare Card Number" smRowOverride="5" labelClassName="hidden-sm hidden-md hidden-lg" hideHelpIconCol="${true}" disableFormGroup="${true}">
				<field_v2:medicare_number xpath="${fieldXpath}" required="true" className="health-medicare_details-number sessioncamexclude" title="Medicare card number" />
			</form_v2:row>

			<c:set var="fieldXpath" value="${xpath}/expiry" />
			<form_v2:row fieldXpath="${fieldXpath}" label="Medicare Expiry Date" labelClassName="hidden-sm hidden-md hidden-lg" smRowOverride="6" hideHelpIconCol="${true}" disableFormGroup="${true}">
				<field_v1:cards_expiry rule="mcExp" xpath="${fieldXpath}" title="Medicare card expiry date" required="true" className="health-medicare_details-expiry" maxYears="7"/>
			</form_v2:row>
		</form_v2:row>

		<field_v3:name_group xpath="${xpath}" showInitial="${true}" />

		<c:set var="fieldXpath" value="${xpath}/cardPosition" />
		<form_v2:row fieldXpath="${fieldXpath}" label="Position you appear on your medicare card"  className="health_payment_medicare_cardPosition-group">
			<field_v2:count_select xpath="${fieldXpath}" min="1" max="5" step="1" title="your medicare card position" required="true" className="health_payment_medicare_cardPosition"/>
		</form_v2:row>


</div>