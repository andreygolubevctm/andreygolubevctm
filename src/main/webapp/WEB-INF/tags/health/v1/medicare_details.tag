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

		<form_v2:row label="Medicare card number and expiry" hideHelpIconCol="true" className="row" isNestedStyleGroup="${true}">
			<p id="health_medicareDetails_message"></p>
			<c:set var="fieldXpath" value="${xpath}/number" />
			<form_v2:row fieldXpath="${fieldXpath}" label="Your Medicare Card Number" smRowOverride="4" isNestedField="${true}" hideHelpIconCol="${true}">
				<field_v2:medicare_number xpath="${fieldXpath}" required="true" className="health-medicare_details-number sessioncamexclude" title="Medicare card number" disableErrorContainer="${true}" />
			</form_v2:row>

			<c:set var="fieldXpath" value="${xpath}/expiry" />
			<form_v2:row fieldXpath="${fieldXpath}" label="Medicare Expiry Date" isNestedField="${true}" smRowOverride="7" hideHelpIconCol="${true}">
				<field_v1:cards_expiry rule="mcExp" xpath="${fieldXpath}" title="Medicare card expiry date" required="true" className="health-medicare_details-expiry" maxYears="7" disableErrorContainer="${true}" />
			</form_v2:row>
		</form_v2:row>

		<field_v3:medicare_name_group xpath="${xpath}" showInitial="${true}" />


</div>