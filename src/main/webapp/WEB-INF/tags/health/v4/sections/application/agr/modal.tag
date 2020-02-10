<%@ tag description="Australian Government Rebate modal"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:set var="fieldXpath" value="${pageSettings.getVerticalCode()}/application/agr/compliance" />

<field_v1:hidden xpath="${fieldXpath}/voiceConsent" />
<field_v1:hidden xpath="${fieldXpath}/applicantCovered" />
<field_v1:hidden xpath="${fieldXpath}/childOnlyPolicy" />
<field_v1:hidden xpath="${fieldXpath}/removeRebate1" />
<field_v1:hidden xpath="${fieldXpath}/removeRebate2" />

<c:set var="fieldXpath" value="${pageSettings.getVerticalCode()}/application/govtRebateDeclaration" />

<field_v1:hidden xpath="${fieldXpath}/applicantCovered" />
<field_v1:hidden xpath="${fieldXpath}/entitledToMedicare" />
<field_v1:hidden xpath="${fieldXpath}/declaration" />
<field_v1:hidden xpath="${fieldXpath}/declarationDate" />
<field_v1:hidden xpath="${fieldXpath}/voiceConsent" />
<field_v1:hidden xpath="${fieldXpath}/childOnlyPolicy" />

<%-- HTML --%>
<core_v1:js_template id="agr-modal-template">
    <%--your details--%>
    <health_v4_agr:your_details />

    <%--others details--%>
    <health_v4_agr:others_details />

    <%--the form--%>
    <health_v4_agr:form />

    <%--affixed jump to form--%>
    <health_v4_agr:affixed_jump_to_form />
</core_v1:js_template>