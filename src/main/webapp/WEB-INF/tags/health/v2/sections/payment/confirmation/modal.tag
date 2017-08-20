<%@ tag description="Simples Confirm all data is correct before submit modal"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- HTML --%>
<%-- TODO CHANGE THE id below --%>
<core_v1:js_template id="agr-modal-template">
    <%--your details  health_v2_confirmation  --%>
    <health_v2_confirmation:your_details />

    <%--others details--%>
    <health_v2_confirmation:others_details />

    <%--the form--%>
    <health_v2_confirmation:form />

</core_v1:js_template>