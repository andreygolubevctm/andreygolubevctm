<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" required="true" rtexprvalue="true" description="Set xpath base"%>
<%@ attribute name="showInitial" required="false" rtexprvalue="true" description="Toggle to display initial field"%>

<%-- HTML --%>
<form_v2:row label="Position and name on Medicare card" hideHelpIconCol="true" className="row" isNestedStyleGroup="${true}">

	<c:set var="fieldXpath" value="${xpath}/cardPosition" />
	<form_v2:row fieldXpath="${fieldXpath}" label="Position you appear on your medicare card"  className="health_payment_medicare_cardPosition-group"  isNestedField="${true}" smRowOverride="2" hideHelpIconCol="${true}">
		<field_v2:count_select xpath="${fieldXpath}" min="1" max="5" step="1" title="your medicare card position" required="true" className="health_payment_medicare_cardPosition"/>
	</form_v2:row>

	<c:set var="fieldXpath" value="${xpath}/title" />
	<form_v2:row fieldXpath="${fieldXpath}" label="Title" hideHelpIconCol="true" smRowOverride="2" isNestedField="${true}" className="selectContainerTitle">
		<field_v3:import_select xpath="${fieldXpath}" title="${title} title"  required="true" url="/WEB-INF/option_data/titles_quick.html" className="person-title" additionalAttributes=" data-rule-genderTitle='true' "/>
	</form_v2:row>

	<c:set var="fieldXpath" value="${xpath}/firstname" />
	<form_v2:row fieldXpath="${fieldXpath}" label="First Name" hideHelpIconCol="true" smRowOverride="3" isNestedField="${true}">
		<field_v1:person_name xpath="${fieldXpath}" required="true" title="${title} first name" className="contactField" placeholder="First name" />
	</form_v2:row>
	<c:if test="${showInitial eq true}">
		<c:set var="fieldXpath" value="${xpath}/middleName" />
		<form_v2:row fieldXpath="${fieldXpath}" label="Middle Name" hideHelpIconCol="true" smRowOverride="2" isNestedField="${true}">
			<field_v1:person_name xpath="${fieldXpath}" required="true" title="${title} middle name" className="contactField" placeholder="M" />
		</form_v2:row>
	</c:if>
	<c:set var="fieldXpath" value="${xpath}/surname" />
	<form_v2:row fieldXpath="${fieldXpath}" label="Last Name" hideHelpIconCol="true" smRowOverride="3" isNestedField="${true}">
		<field_v1:person_name xpath="${fieldXpath}" required="true" title="${title} last name" className="contactField" placeholder="Last name" />
	</form_v2:row>
</form_v2:row>