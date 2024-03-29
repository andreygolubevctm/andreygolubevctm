<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" required="true" rtexprvalue="true" description="Set xpath base"%>
<%@ attribute name="showInitial" required="false" rtexprvalue="true" description="Toggle to display initial field"%>
<%@ attribute name="firstNameMaxlength" required="false" rtexprvalue="true" description="The maximum length for Person's First Name input field" %>
<%@ attribute name="lastNameMaxlength" required="false" rtexprvalue="true" description="The maximum length for Person's Last Name input field" %>
<%@ attribute name="middleInitialMaxlength" required="false" rtexprvalue="true" description="The maximum length for Person's Middle Initial input field" %> <%-- If the case where a person has several middle names, Medicare only uses the first initial from the first middlename --%>
<%@ attribute name="label" required="false" rtexprvalue="true" description="Overrides the text for the default row label" %>
<%@ attribute name="className" required="false" rtexprvalue="true" description="Class names to be passed through to the form_v2:row" %>

<c:set var="smRowOverride">3</c:set><%-- Specifies the bootstrap sm-col size for the title field --%>

<c:if test="${showInitial eq true}">
	<c:set var="smRowOverride">2</c:set>
</c:if>

<c:if test="${empty label}">
	<c:set var="label">Name</c:set>
</c:if>

<%-- HTML --%>
<form_v2:row label="${label}" hideHelpIconCol="true" className="row ${className}" isNestedStyleGroup="${true}">
	<c:set var="fieldXpath" value="${xpath}/title" />
	<form_v2:row fieldXpath="${fieldXpath}" label="Title" hideHelpIconCol="true" smRowOverride="${smRowOverride}" isNestedField="${true}" className="selectContainerTitle" id="${go:nameFromXpath(fieldXpath)}Row">
		<field_v3:import_select xpath="${fieldXpath}" title="${title} title"  required="true" url="/WEB-INF/option_data/titles_quick.html" className="person-title" additionalAttributes=" data-rule-genderTitle='true' " placeHolder="Title" disableErrorContainer="${false}" />
	</form_v2:row>

	<c:set var="fieldXpath" value="${xpath}/firstname" />
	<form_v2:row fieldXpath="${fieldXpath}" label="First Name" hideHelpIconCol="true" smRowOverride="4" isNestedField="${true}">
		<health_v3:check_name_capitalisation />
		<field_v1:person_name xpath="${fieldXpath}" required="true" title="${title} first name" className="contactField check-capitalisation expect-sentence-case" placeholder="First name" disableErrorContainer="${true}" maxlength="${firstNameMaxlength}" />
	</form_v2:row>
	<c:if test="${showInitial eq true}">
		<c:set var="fieldXpath" value="${xpath}/middleName" />
		<form_v2:row fieldXpath="${fieldXpath}" label="Middle Name" hideHelpIconCol="true" smRowOverride="2" isNestedField="${true}" className="nameGroupMiddleNameRow">
			<health_v3:check_name_capitalisation />
			<field_v1:person_name xpath="${fieldXpath}" required="false" title="${title} middle name" className="contactField check-capitalisation expect-sentence-case" placeholder="M" disableErrorContainer="${true}" maxlength="${middleInitialMaxlength}" />
		</form_v2:row>
	</c:if>
	<c:set var="fieldXpath" value="${xpath}/surname" />
	<form_v2:row fieldXpath="${fieldXpath}" label="Last Name" hideHelpIconCol="true" smRowOverride="4" isNestedField="${true}">
		<health_v3:check_name_capitalisation />
		<field_v1:person_name xpath="${fieldXpath}" required="true" title="${title} last name" className="contactField check-capitalisation expect-sentence-case" placeholder="Last name" disableErrorContainer="${true}" maxlength="${lastNameMaxlength}" />
	</form_v2:row>
</form_v2:row>