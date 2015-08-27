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

<c:set var="lowerCaseUtilityType" value="${fn:toLowerCase(utilityType)}" />

<c:choose>
    <c:when test="${inputType eq 'spend'}">
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

<c:set var="periodValidationRules">
    <c:choose>
        <c:when test="${fn:contains(xpath, 'usage/electricity/offpeak') || fn:contains(xpath, 'usage/gas/offpeak')}">
            data-rule-amountPeriodRequired='true' data-msg-amountPeriodRequired='Please choose the gas offpeak usage period'
        </c:when>
    </c:choose>
</c:set>

<div class="row clear ${lowerCaseUtilityType}">
    <div class="col-md-6 row-content">
        <h5>${utilityType} ${headingHelp}</h5>
        <div class="error-field" style="display:block;"><!-- empty --></div>
        <field_new:input xpath="${xpath}/amount" required="${required}" inputGroupText="${inputGroupText}" requiredMessage="Please specify your ${lowerCaseUtilityType} usage." inputGroupTextPosition="${inputGroupTextPosition}" formattedInteger="true" additionalAttributes="${amountValidationRules}" />
    </div>
    <div class="col-md-6 row-content">
        <h5 class="structural">&nbsp;</h5>
        <div class="error-field" style="display:block;"><!-- empty --></div>
        <c:choose>
            <c:when test="${inputType eq 'spend' and lowerCaseUtilityType eq 'gas'}">
                <c:set var="items" value="=Period,M=Month,B=2 Months,Q=Quarter,Y=Year" />
            </c:when>
            <c:otherwise>
                <c:set var="items" value="=Period,M=Month,Q=Quarter,Y=Year" />
            </c:otherwise>
        </c:choose>
        <field_new:array_select xpath="${xpath}/period" required="${required}" title="your ${lowerCaseUtilityType} period." items="${items}" extraDataAttributes="${periodValidationRules}" />
    </div>
</div>