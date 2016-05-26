<%@ tag description="The Health Logo template"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<core_v1:js_template id="pre-results-row-content-template">
    <h3>Hi {{= obj.name }},</h3>
    <%--<p>We found {{= Results.getFilteredResults().length }} {{= obj.coverType }} products for {{= obj.situation }}</p>--%>
    <p>We found and summarised {{= Results.getFilteredResults().length }} products for you. <br />Please download the policy brochures for the full policy limits, inclusions and exclusions.</p>
</core_v1:js_template>