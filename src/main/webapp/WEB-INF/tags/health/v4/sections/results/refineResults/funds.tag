<%@ tag description="Funds template for refine results menu for mobile"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<section data-panel-id="funds">
    <p>Quick select: <a href="javascript:;" class="refine-results-brands-toggle" data-toggle="true">All</a> <a href="javascript:;" class="refine-results-brands-toggle" data-toggle="false">None</a></p>

    <div class="refine-results-checkbox-list">
        {{ _.each(meerkat.site.providerList, function(object) { }}
            {{ var value = object.value || object.code; }}
            {{ var label = object.label || object.name; }}
            {{ var checked = ''; }}
            <div class="checkbox">
                <input type="checkbox" name="health_refine_results_brands" id="health_refine_results_brands_{{= value }}" value="{{= value }}" {{= checked }}
                       title="{{= label }}"/> <label for="health_refine_results_brands_{{= value }}" <field_v1:analytics_attr analVal="filter brands" quoteChar="\"" />>{{= label }}</label>
            </div>
        {{ }); }}
    </div>
</section>