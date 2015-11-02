<%@ tag description="Utilities Preferences Form (Enquire)"%>
<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%@ attribute name="xpath" required="true" rtexprvalue="true" description="Fieldset XPath" %>

<form_new:fieldset legend="Preferences">
    <c:set var="fieldXPath" value="${xpath}/solarPanels" />
    <form_new:row label="Would you like us to include conditional discounts in our comparison ranking?" fieldXpath="${fieldXPath}" className="clear">
        <field_new:array_radio xpath="${fieldXPath}"
                               required="true"
                               className=""
                               items="Y=Yes,N=No"
                               id="${go:nameFromXpath(fieldXPath)}"
                               title="if you would like to view conditional discounts." />
    </form_new:row>
</form_new:fieldset>