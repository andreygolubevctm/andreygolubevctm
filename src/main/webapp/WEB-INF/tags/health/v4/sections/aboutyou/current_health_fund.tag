<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Select your current health fund row"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="field group's xpath" %>

<%-- VARIABLES --%>
<c:set var="name" 			value="${go:nameFromXpath(xpath)}" />

<c:set var="fieldXpath" value="${xpath}/primary/fundName" />
<c:set var="analyticsAttr"><field_v1:analytics_attr analVal="current health fund" quoteChar="\"" /></c:set>
<c:set var="primaryCurrentHealthFund"><content:get key="primaryCurrentHealthFund" /></c:set>

<%-- Get default value from "health/previousfund/primary/fundName" else from "health/healthCover/primary/fundNameHidden" - useful when doing quote retrieval  --%>
<c:set var="defaultValue" value="" />
<c:set var="xpathPreviousFund" value="health/previousfund/primary/fundName" />
<c:set var="previousFundValue"><c:out value="${data[xpathPreviousFund]}" escapeXml="true"/></c:set>
<c:choose>
    <c:when test="${not empty previousFundValue}">
        <c:set var="defaultValue" value="${previousFundValue}" />
    </c:when>
    <c:otherwise>
        <c:set var="xpathHidden" value="${xpath}/primary/fundNameHidden" />
        <c:set var="hiddenValue"><c:out value="${data[xpathHidden]}" escapeXml="true"/></c:set>
        <c:if test="${not empty hiddenValue}">
            <c:set var="defaultValue" value="${hiddenValue}" />
        </c:if>
    </c:otherwise>
</c:choose>

<form_v4:row hideRowBorder="true" fieldXpath="${fieldXpath}" label="Who is your current health fund?" id="${name}_primary_fundName">
    <field_v2:import_select xpath="${fieldXpath}" url="/WEB-INF/option_data/health_funds_condensed.html" title="your current health fund" required="true" additionalAttributes=" data-attach='true' data-visible='true' ${analyticsAttr} " className="combobox" requiredErrorMessage="No provider selected." placeHolder="Start typing to search or select from list" disableErrorContainer="${true}" defaultValue="${defaultValue}" />
</form_v4:row>
