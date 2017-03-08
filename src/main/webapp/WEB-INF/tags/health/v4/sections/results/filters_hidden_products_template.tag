<%@ tag description="The Health Hidden Products Count Template" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<core_v1:js_template id="filter-results-hidden-products">
    <div class="filter-hidden-products">{{ var plural = count > 1 ? 's' : ''; }}
        {{= count }} Product{{= plural }} hidden <a href="javascript:;" class="reset-show-hide-filters">Show</a>
    </div>
</core_v1:js_template>