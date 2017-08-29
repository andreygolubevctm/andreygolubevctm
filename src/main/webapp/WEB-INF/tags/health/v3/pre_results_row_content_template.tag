<%@ tag description="The Health Logo template"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<core_v1:js_template id="pre-results-row-content-template">
    <h3>
        <span>Hi {{= obj.name }},	<c:if test="${not empty callCentre}">{{= obj.state }}, {{= obj.suburb }}, {{= obj.situation }}, {{= obj.age }}</c:if></span>
        <span class="pull-right">Transaction Id: {{= meerkat.modules.transactionId.get() }}</span>
    </h3>
    <c:if test="${empty callCentre}">
        <p>We found and summarised {{= Results.getFilteredResults().length }} products for you. <br />Please download the policy brochures for the full policy limits, inclusions and exclusions.</p>
    </c:if>
</core_v1:js_template>