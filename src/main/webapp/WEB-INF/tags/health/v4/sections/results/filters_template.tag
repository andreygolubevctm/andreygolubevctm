<%@ tag description="The Health Filters" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<core_v1:js_template id="filter-results-template">

    {{ var hiddenHospital = meerkat.modules.healthChoices.getCoverType() === 'E' ? ' hidden' : ''; }}

    <h3>Refine Results by</h3>

    <div class="filter-excess filter need-hospital {{=hiddenHospital }}" data-filter-serverside="true">
        <h4>Hospital Excess</h4>
        <div class="filter-by-container">
            <span class="filter-by-excess"></span>
            <a href="javascript:;" class="filter-toggle" data-filter="excess">Change</a>
        </div>

        <health_v1:filter_excess useDefaultOutputField="true" />
    </div>

    <div class="filter-brands filter" data-filter-serverside="true">
        <h4>Brands</h4>
        <div class="filter-by-container">
            <span class="filter-by-brands"></span>
            <a href="javascript:;" class="filter-toggle" data-filter="brands">Change</a>
        </div>

        <div class="health-filter-brands provider-list">
            <span class="filter-select-all-none">Select: <a href="javascript:;" class="filter-brands-toggle" data-toggle="true">All</a> <a class="filter-brands-toggle" data-toggle="false">None</a></span>
            {{ _.each(model.brands.values, function(object) { }}
            {{ var checked = !object.selected ? ' checked="checked"' : ''; }}
            {{ var active = !object.selected ? ' active' : ''; }}
            <div class="checkbox">
                <input type="checkbox" name="{{= model.brands.name }}" id="{{= model.brands.name }}_{{= object.value }}" value="{{= object.value }}" {{=checked }}
                       title="{{= object.label }}"/> <label for="{{= model.brands.name }}_{{= object.value }}" <field_v1:analytics_attr analVal="filter brands" quoteChar="\"" />>{{= object.label }}</label>
            </div>
            {{ }) }}
        </div>
    </div>
</core_v1:js_template>