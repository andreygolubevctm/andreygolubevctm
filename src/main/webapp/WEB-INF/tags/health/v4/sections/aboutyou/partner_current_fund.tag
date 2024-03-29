<%@ tag description="Select your partner's current health fund row"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="partner's current health fund xpath" %>

<c:set var="fieldXpath" value="${xpath}/partner/fundName" />
<c:set var="analyticsAttr"><field_v1:analytics_attr analVal="partner current health fund" quoteChar="\"" /></c:set>

<%-- Get default value from "health/previousfund/partner/fundName" else from "health/healthCover/partner/fundNameHidden" - useful when doing quote retrieval  --%>
<c:set var="defaultValue" value="" />
<c:set var="xpathPreviousFund" value="health/previousfund/partner/fundName" />
<c:set var="previousFundValue"><c:out value="${data[xpathPreviousFund]}" escapeXml="true"/></c:set>
<c:choose>
    <c:when test="${not empty previousFundValue}">
        <c:set var="defaultValue" value="${previousFundValue}" />
    </c:when>
    <c:otherwise>
        <c:set var="xpathHidden" value="${xpath}/partner/fundNameHidden" />
        <c:set var="hiddenValue"><c:out value="${data[xpathHidden]}" escapeXml="true"/></c:set>
        <c:if test="${not empty hiddenValue}">
            <c:set var="defaultValue" value="${hiddenValue}" />
        </c:if>
    </c:otherwise>
</c:choose>

<form_v4:row hideRowBorder="true" fieldXpath="${fieldXpath}" label="Your partner's current health fund" id="${name}_partner_fundName" className="">
    <field_v2:import_select xpath="${fieldXpath}" url="/WEB-INF/option_data/health_funds_condensed.html" title="your partner's current health fund" required="true" additionalAttributes=" data-attach='true' data-visible='true' ${analyticsAttr} " className="combobox" placeHolder="Start typing to search or select from list" requiredErrorMessage="No provider selected." disableErrorContainer="${true}" defaultValue="${defaultValue}" />

</form_v4:row>