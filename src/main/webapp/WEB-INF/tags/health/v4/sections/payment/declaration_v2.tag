<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Contact Details group"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="field group's xpath" %>
<%@ attribute name="className" 	required="false" rtexprvalue="true"	 description="Class Name for Fieldset" %>
<%-- VARIABLES --%>
<c:set var="name" 			value="${go:nameFromXpath(xpath)}" />

<%-- HTML --%>
<div id="${name}-selection" class="health_declaration_v2">
    <h2>Declaration for <span></span></h2>
    <div class='join_declaration_content'></div>
    <c:set var="fieldXpath" value="${xpath}/rebateForm" />

    <form_v4:row fieldXpath="${fieldXpath}" label="Australian Government Rebate Form" className="ausgovtrebateform">
        <field_v2:checkbox xpath="${fieldXpath}"
                           value="Y" title="Do you authorise <em class='AHM'>ahm Health Insurance</em> to lodge the rebate form on your behalf?" required="false" label="true"/>
    </form_v4:row>

    <h3>Accept join declaration</h3>
    <c:set var="fieldXpath" value="${xpath}" />
    <field_v2:checkbox xpath="${fieldXpath}"
                       value="Y" title="I can confirm that I have read and understood the Join Declaration and the information relating to my product choice. I declare that the information I have provided is true and correct." required="true"
                       errorMsg="Please read the Join Declaration in order to proceed" label="false"
    />
</div>