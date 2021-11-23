<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" required="true" rtexprvalue="true" description="Set xpath base"%>
<%@ attribute name="showInitial" required="false" rtexprvalue="true" description="Toggle to display initial field"%>
<%@ attribute name="firstNameMaxlength" required="false" rtexprvalue="true" description="The maximum length for Person's First Name input field" %>
<%@ attribute name="lastNameMaxlength" required="false" rtexprvalue="true" description="The maximum length for Person's Last Name input field" %>

<c:set var="smRowOverride">3</c:set><%-- Specifies the bootstrap sm-col size for the title field --%>

<c:if test="${showInitial eq true}">
    <c:set var="smRowOverride">2</c:set>
</c:if>

<%-- HTML --%>
<form_v4:row label="Name as it appears on your Medicare Card" className="row" isNestedStyleGroup="${true}">
    <c:set var="fieldXpath" value="${xpath}/title" />
    <form_v4:row fieldXpath="${fieldXpath}" label="Title" smRowOverride="${smRowOverride}" isNestedField="${true}" className="selectContainerTitle" id="${go:nameFromXpath(fieldXpath)}Row">
        <field_v3:import_select xpath="${fieldXpath}" title="${title} title"  required="true" url="/WEB-INF/option_data/titles_quick.html" className="person-title data-hj-suppress" additionalAttributes=" data-rule-genderTitle='true' " placeHolder="Title" disableErrorContainer="${true}" />
    </form_v4:row>

    <c:set var="fieldXpath" value="${xpath}/firstname" />
    <form_v4:row fieldXpath="${fieldXpath}" label="First Name" smRowOverride="3" lgRowColSize="col-lg-4" isNestedField="${true}">
        <field_v1:person_name xpath="${fieldXpath}" required="true" title="${title} first name" className="contactField data-hj-suppress" placeholder="First name" disableErrorContainer="${true}" maxlength="${firstNameMaxlength}" />
    </form_v4:row>
    <c:if test="${showInitial eq true}">
        <c:set var="fieldXpath" value="${xpath}/middleName" />
        <form_v4:row fieldXpath="${fieldXpath}" label="Middle Initial" smRowOverride="2" isNestedField="${true}" className="nameGroupMiddleNameRow">
            <field_v1:person_name xpath="${fieldXpath}" required="false" title="${title} middle name" className="contactField data-hj-suppress" placeholder="M" disableErrorContainer="${true}" />
        </form_v4:row>
    </c:if>
    <c:set var="fieldXpath" value="${xpath}/surname" />
    <form_v4:row fieldXpath="${fieldXpath}" label="Last Name" smRowOverride="3" lgRowColSize="col-lg-4" isNestedField="${true}">
        <field_v1:person_name xpath="${fieldXpath}" required="true" title="${title} last name" className="contactField data-hj-suppress" placeholder="Last name" disableErrorContainer="${true}" maxlength="${lastNameMaxlength}" />
    </form_v4:row>
</form_v4:row>
