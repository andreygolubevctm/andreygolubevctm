<%@ tag description="Australian Government Rebate modal"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- HTML --%>
<core_v1:js_template id="agr-modal-template">
    <%--your details--%>
    <health_v4_agr:your_details />

    <%--others details--%>
    <health_v4_agr:others_details />

    <%--the form--%>
    <health_v4_agr:form />
</core_v1:js_template>