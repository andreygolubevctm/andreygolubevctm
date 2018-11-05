<%@ tag description="The Health Filters" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<core_v1:js_template id="filter-results-template">

    {{ var hiddenHospital = meerkat.modules.healthChoices.getCoverType() === 'E' ? ' hidden' : ''; }}

    <div class="separator-container bottom-separator top-separator-widget-padding">
        <div class="filter-excess filter need-hospital {{=hiddenHospital }}" data-filter-serverside="true">
            <div class="filter-sub-heading">Hospital Excess</div>
            <div class="filter-by-container">
                <span class="filter-by-excess small"></span>
                <a href="javascript:;" class="filter-toggle small" data-filter="excess" <field_v1:analytics_attr analVal="excess filter" quoteChar="\"" />>Change</a>
            </div>

            <health_v1:filter_excess useDefaultOutputField="true" />
        </div>
    </div>

    <div class="separator-container bottom-separator-widget-padding">
        <div class="filter-brands filter" data-filter-serverside="true">
            <div class="filter-sub-heading black-text">Insurance Funds</div>
            <div class="filter-by-container">
                <span class="filter-by-brands small float-left"></span>
                <a href="javascript:;" class="filter-toggle small full-width" data-filter="brands" <field_v1:analytics_attr analVal="brands filter" quoteChar="\"" />>Refine Fund selection <span class="icon expander large-bold right"></span></a>
            </div>

            <div class="health-filter-brands provider-list">
                <span class="small filter-select-all-none">Select: <a href="javascript:;" class="filter-brands-toggle" data-toggle="true">All</a> <a class="filter-brands-toggle" data-toggle="false">None</a></span>
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
    </div>
</core_v1:js_template>