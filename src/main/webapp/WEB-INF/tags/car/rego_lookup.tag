<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Group for vehicle rego lookup" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" required="true" rtexprvalue="true"
              description="field group's xpath" %>

<%-- VARIABLES --%>
<c:set var="name" value="${go:nameFromXpath(xpath)}"/>

<%-- HTML --%>
<div id="rego_lookup_wrapper">
    <ui:bubble variant="chatty">
        <h4>Provide us with your registration details</h4>
        <p>This allows us to look up the details of your car without you having to input all of the details manually yourself.</p>
    </ui:bubble>

    <form_v2:fieldset legend="Your Car Registration Details" id="${name}_selection">
        <div id="unableToFindRego" class="hidden">
            <p>Sorry, your car cannot be matched using the registration provided</p>
            <p><em>Please select you car below</em></p>
            <br /><br />
        </div>
        <form_v2:row label="State" id="${name}_stateRow">
            <field_v2:array_select xpath="${xpath}/state" required="true" title=" the state you use your car in" items="=Please choose...,ACT=ACT,NSW=NSW,NT=NT,QLD=QLD,SA=SA,TAS=TAS,VIC=VIC,WA=WA" />
        </form_v2:row>

        <form_v2:row label="Registration number" id="${name}_registrationNumberRow">
            <field_v2:input xpath="${xpath}/registrationNumber" required="true" title=" the registration number of your car" additionalAttributes=" data-rule-regex='[a-zA-Z0-9]+' data-msg-regex='Please enter alphanumeric characters only'" />
        </form_v2:row>

        <div class="dontKnowRegoNo">
            <a href="javascript:;" class="carRegoExit">I don't know my car registration number</a>
        </div>
    </form_v2:fieldset>
</div>
