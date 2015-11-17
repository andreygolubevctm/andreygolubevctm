<%@ tag description="Input for additional estimate details"%>
<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%@ attribute name="xpath" required="true" rtexprvalue="true" description="Fieldset XPath" %>
<%@ attribute name="utilityType" required="true" rtexprvalue="true" description="electricity or gas" %>
<%@ attribute name="inputType" required="true" rtexprvalue="true" description="electricity or gas" %>
<%@ attribute name="helpId" required="false" rtexprvalue="true" description="help ID" %>
<%@ attribute name="required" required="false" rtexprvalue="true" description="Required field?" %>
<%@ attribute name="inputGroupText" required="true" rtexprvalue="true" description="Input group text" %>
<%@ attribute name="inputGroupTextPosition" required="false" rtexprvalue="true" description="Position of input group text" %>

<c:set var="inputFieldType"><field_new:get_numeric_input_type /></c:set>
<c:set var="formatNum">
    <c:choose>
        <c:when test='${inputType eq "text"}'>false</c:when>
        <c:otherwise>true</c:otherwise>
    </c:choose>
</c:set>

<c:set var="lowerCaseUtilityType" value="${fn:toLowerCase(utilityType)}" />

<c:choose>
    <c:when test="${inputType eq 'spend'}">
        <c:set var="xpath" value="${xpath}/${inputType}/${lowerCaseUtilityType}" />
    </c:when>
    <c:when test="${inputType eq 'days'}">
        <c:set var="xpath" value="${xpath}/${inputType}/${lowerCaseUtilityType}" />
    </c:when>
    <c:otherwise>
        <c:set var="xpath" value="${xpath}/usage/${lowerCaseUtilityType}/${inputType}" />
    </c:otherwise>
</c:choose>

<c:set var="headingHelp">
    <c:if test="${helpId ne ''}">
        <field_new:help_icon helpId="${helpId}" />
    </c:if>
</c:set>


<c:set var="amountValidationRules">
    <c:choose>
        <c:when test="${fn:contains(xpath, 'spend/electricity') || fn:contains(xpath, 'spend/gas')}">
            data-rule-maximumSpend='true'
        </c:when>
        <c:when test="${fn:contains(xpath, 'usage/electricity/peak') || fn:contains(xpath, 'usage/electricity/offpeak')}">
            data-rule-maximumUsage='true'
        </c:when>
        <c:when test="${fn:contains(xpath, 'usage/gas/peak') || fn:contains(xpath, 'usage/gas/offpeak')}">
            data-rule-maximumUsageGas='true'
        </c:when>
    </c:choose>
</c:set>

<div class="row clear ${lowerCaseUtilityType}">
    <div class="col-md-12 row-content">
        <div class="error-field" style="display:block;"><!-- empty --></div>
        <field_new:input type="${inputFieldType}" xpath="${xpath}/amount" required="${required}" inputGroupText="${inputGroupText}" requiredMessage="Please specify your ${lowerCaseUtilityType} usage." inputGroupTextPosition="${inputGroupTextPosition}" formattedInteger="true" additionalAttributes="${amountValidationRules}" />
    </div>
</div>