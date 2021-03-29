<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Bank account details form detail"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 			required="true"	 rtexprvalue="true"	 description="field group's xpath" %>
<%@ attribute name="className"		required="false" rtexprvalue="true"	 description="Additional class for the account number field" %>
<%@ attribute name="useValidator"	required="false" rtexprvalue="true"	 description="Flag to indicate bsb validator is required" %>

<%-- VARIABLES --%>
<c:set var="wrapperClass" value="bsb-validator-wrapper" />
<c:if test="${empty useValidator or not useValidator eq true}">
    <c:set var="useValidator" value="${false}" />
</c:if>

<%-- HTML --%>
<c:set var="fieldXpath" value="${xpath}/bsb" />
<form_v4:row fieldXpath="${fieldXpath}input" label="BSB" isNestedField="${not useValidator}" smRowOverride="6">
    <c:if test="${useValidator}">
        <div class="bsb-validator-messages"><!-- empty --></div>
        <div class="col-xs-12 col-sm-6 ${wrapperClass}">
    </c:if>
    <field_v2:bsb_number xpath="${fieldXpath}" title="bsb number" required="true" className="health-bank_details-bsb sessioncamexclude data-hj-suppress" placeHolder="BSB #" disableErrorContainer="${true}" />
    <c:if test="${useValidator}">
        </div>
    </c:if>
    <c:if test="${useValidator}">
        <div class="col-xs-12 col-sm-6 ${wrapperClass}">
            <a href="javascript:;" class="btn btn-cta btn-validate">Validate BSB</a>
        </div>
    </c:if>
</form_v4:row>

<c:set var="fieldXpath" value="${xpath}/number" />
<form_v4:row fieldXpath="${fieldXpath}" label="Account Number" isNestedField="${not useValidator}" smRowOverride="6" className="${className}">
    <field_v2:account_number xpath="${fieldXpath}" title="account number" minLength="5" maxLength="9" required="true" className="health-bank_details-account_number sessioncamexclude data-hj-suppress" placeHolder="Account #" disableErrorContainer="${true}" />
</form_v4:row>