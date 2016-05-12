<%@ tag description="The Health Logo template"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<core_v1:js_template id="pre-results-row-content-template">
    <h3>Hi {{= obj.name }},</h3>
    <p>We found {{= Results.getReturnedResults().length }} {{= obj.coverType }} products for {{= obj.situation }}</p>
</core_v1:js_template>