<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Medicare details group"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="field group's xpath" %>

<%-- VARIABLES --%>
<c:set var="name" 			value="${go:nameFromXpath(xpath)}" />

<%-- HTML --%>
<div id="${name}-selection" class="health-medicare_details">
    <c:set var="fieldXpath" value="${xpath}/cover" />
    <field_v1:hidden xpath="${fieldXpath}" defaultValue="Y" />

    <c:set var="fieldXpath" value="${xpath}/colour" />
    <form_v4:row fieldXpath="${fieldXpath}" label="What colour is your Medicare card?" id="medicareCoveredRow" helpId="291" >
        <p id="health_medicareDetails_coverMessage"></p>
        <field_v2:medicare_colour xpath="${fieldXpath}" />
    </form_v4:row>

    <form_v4:row label="Medicare card number and expiry" className="row" isNestedStyleGroup="${true}">
        <p id="health_medicareDetails_message"></p>
        <c:set var="fieldXpath" value="${xpath}/number" />
        <form_v4:row fieldXpath="${fieldXpath}" label="Your Medicare Card Number" smRowOverride="4" isNestedField="${true}">
            <field_v2:medicare_number xpath="${fieldXpath}" required="true" className="health-medicare_details-number sessioncamexclude" title="Medicare card number" disableErrorContainer="${true}" />
        </form_v4:row>

        <c:set var="fieldXpath" value="${xpath}/expiry" />
        <form_v4:row fieldXpath="${fieldXpath}" label="Medicare Expiry Date" isNestedField="${true}" smRowOverride="7">
            <field_v1:cards_expiry rule="mcExp" xpath="${fieldXpath}" title="Medicare card expiry date" required="true" className="health-medicare_details-expiry" maxYears="10" disableErrorContainer="${true}" />
        </form_v4:row>
    </form_v4:row>

    <health_v4_application:medicare_name_group xpath="${xpath}" showInitial="${true}" />

</div>