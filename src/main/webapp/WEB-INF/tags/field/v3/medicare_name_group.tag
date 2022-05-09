<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" required="true" rtexprvalue="true" description="Set xpath base"%>
<%@ attribute name="showInitial" required="false" rtexprvalue="true" description="Toggle to display initial field"%>

<%-- HTML --%>
<form_v2:row label="# and name on Medicare card" hideHelpIconCol="true" className="row" isNestedStyleGroup="${true}" id="medicare_group" helpId="655">

	<c:set var="fieldXpath" value="${xpath}/cardPosition" />
	<form_v2:row fieldXpath="${fieldXpath}" label="Position you appear on your medicare card"  className="health_payment_medicare_cardPosition-group"  isNestedField="${true}" smRowOverride="2" hideHelpIconCol="${true}">
		<field_v2:count_select xpath="${fieldXpath}" min="1" max="9" step="1" title="your medicare card position" required="true" className="health_payment_medicare_cardPosition" placeHolder="#" disableErrorContainer="${true}"/>
	</form_v2:row>

	<c:set var="fieldXpath" value="${xpath}/firstName" />
	<form_v3:row fieldXpath="${fieldXpath}" label="First Name" hideHelpIconCol="true" smRowOverride="4" isNestedField="${true}">
		<field_v1:person_name xpath="${fieldXpath}" required="true" title="${title} first name" className="contactField health-medicare_details-first_name" placeholder="First name" maxlength="24" additionalAttributes="data-validation-position='append' " disableErrorContainer="${false}" />
	</form_v3:row>
	<c:if test="${showInitial eq true}">
		<c:set var="fieldXpath" value="${xpath}/middleName" />
		<form_v2:row fieldXpath="${fieldXpath}" label="Middle Name" hideHelpIconCol="true" smRowOverride="2" isNestedField="${true}">
			<field_v1:person_name xpath="${fieldXpath}" required="false" title="${title} middle name" className="contactField" placeholder="M" maxlength="1" disableErrorContainer="${true}" />
		</form_v2:row>
	</c:if>
	<c:set var="fieldXpath" value="${xpath}/surname" />
	<form_v2:row fieldXpath="${fieldXpath}" label="Last Name" hideHelpIconCol="true" smRowOverride="4" isNestedField="${true}">
		<field_v1:person_name xpath="${fieldXpath}" required="true" title="${title} last name" className="contactField" placeholder="Last name" additionalAttributes="data-rule-medicareLastName='true' data-validation-position='append' " disableErrorContainer="${false}" />
	</form_v2:row>
</form_v2:row>