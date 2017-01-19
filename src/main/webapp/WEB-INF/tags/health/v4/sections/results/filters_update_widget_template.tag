<%@ tag description="The Health Results Filters Update now template" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<core_v1:js_template id="filters-update-template">
    <a href="javascript:;" class="btn btn-block btn-tertiary filter-update-changes" <field_v1:analytics_attr analVal="filter update results" quoteChar="\"" />>Update Products & Prices</a>
    <a class="small filter-cancel-changes" href="javascript:;" <field_v1:analytics_attr analVal="filter cancel changes" quoteChar="\"" />>cancel changes</a>
</core_v1:js_template>