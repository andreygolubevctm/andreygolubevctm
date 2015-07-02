<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ tag description="Registration Lookup Form Component"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" required="true" rtexprvalue="true" description="field group's xpath"%>

<%-- VARIABLES --%>
<c:set var="name"  value="${go:nameFromXpath(xpath)}" />
<c:set var="displaySuffix"><c:out value="${data[xpath].exists}" escapeXml="true"/></c:set>

<div id="rego-lookup-form">
    <form_new:row label="State">
        <field_new:array_select xpath="${xpath}/searchState" includeInForm="false" items="=Please choose...,ACT=Canberra,NT=Northern Territory,NSW=New South Wales,QLD=Queensland,SA=South Australia,TAS=Tasmania,VIC=Victoria,WA=Western Australia" title="state vehicle registered" required="false" className="rego-lookup-state sessioncamexclude" />
    </form_new:row>
    <form_new:row label="Enter your car's registration no." className="rego-entry-row">
        <div class="col-xs-12 col-sm-6 rego-lookup-number-col">
            <%-- Limit to 10 characters as will fail in Motorwebs service otherwise --%>
            <field_new:input xpath="${xpath}/searchRego" includeInForm="false" required="false" title="vehicle registration number" className="rego-lookup-number" maxlength="10" placeHolder="eg. 123ABC" />
        </div>
        <div class="col-xs-12 col-sm-6 rego-lookup-btn-col">
            <a href="#lookuprego" class="btn btn-next rego-lookup-button">Find Car<span class="icon icon-arrow-right"><!-- empty --></span></a>
        </div>
    </form_new:row>
    <div class="rego-lookup-feedback"><!-- populate by module --></div>
    <div class="rego-lookup-divider">
        <div class="line"><!-- empty --></div>
        <span>Or find you car by make and model</span>
    </div>
</div>