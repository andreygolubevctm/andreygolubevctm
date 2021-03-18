<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" required="true" rtexprvalue="true" description="Set xpath base"%>
<%@ attribute name="showInitial" required="false" rtexprvalue="true" description="Toggle to display initial field"%>

<%-- HTML --%>
<form_v4:row label="# and name on Medicare card" className="row" isNestedStyleGroup="${true}" id="medicare_group">

    <c:set var="fieldXpath" value="${xpath}/cardPosition" />
    <form_v4:row fieldXpath="${fieldXpath}" label="Position you appear on your medicare card"  className="health_payment_medicare_cardPosition-group"  isNestedField="${true}" smRowOverride="2">
        <field_v2:count_select xpath="${fieldXpath}" min="1" max="9" step="1" title="your medicare card position" required="true" className="health_payment_medicare_cardPosition data-hj-suppress" placeHolder="#" disableErrorContainer="${true}"/>
    </form_v4:row>

    <c:set var="fieldXpath" value="${xpath}/firstName" />
    <form_v4:row fieldXpath="${fieldXpath}" label="First Name" smRowOverride="4" isNestedField="${true}">
        <field_v1:person_name xpath="${fieldXpath}" required="true" title="${title} first name" className="contactField health-medicare_details-first_name hidden" placeholder="First name" maxlength="24" additionalAttributes="data-validation-position='append' " disableErrorContainer="${false}" />
    </form_v4:row>
    <c:if test="${showInitial eq true}">
        <c:set var="fieldXpath" value="${xpath}/middleName" />
        <form_v4:row fieldXpath="${fieldXpath}" label="Middle Name" smRowOverride="2" isNestedField="${true}">
            <field_v1:person_name xpath="${fieldXpath}" required="false" title="${title} middle name" className="contactField hidden" placeholder="M" maxlength="1" disableErrorContainer="${true}" />
        </form_v4:row>
    </c:if>
    <c:set var="fieldXpath" value="${xpath}/surname" />
    <form_v4:row fieldXpath="${fieldXpath}" label="Last Name" smRowOverride="4" isNestedField="${true}">
        <field_v1:person_name xpath="${fieldXpath}" required="true" title="${title} last name" className="contactField hidden" placeholder="Last name" additionalAttributes="data-rule-medicareLastName='true' data-validation-position='append' " disableErrorContainer="${false}" />
    </form_v4:row>
</form_v4:row>
