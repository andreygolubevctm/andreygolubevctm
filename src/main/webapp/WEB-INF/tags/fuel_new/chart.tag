<%@ tag description="Fuel History Chart" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<core:js_template id="price-chart-template">
    <div id="linechart_material"></div>
    <div class="short-disclaimer push-top-10">
        <a href="https://developers.google.com/chart/interactive/docs/">Google Charts</a> licensed under
        <a href="https://creativecommons.org/licenses/by/3.0/" target="_blank">CC BY 3.0</a>, {{= new Date().getUTCFullYear() }}. Data supplied by Motormouth.</div>
</core:js_template>