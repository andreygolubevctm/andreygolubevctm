<%@ tag description="The Health Filters" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<core_v1:js_template id="filter-results-template">

    {{ var hiddenHospital = meerkat.modules.healthChoices.getCoverType() === 'E' ? ' hidden' : ''; }}

    <h3>Refine Results by</h3>
    <div class="row filter need-hospital {{=hiddenHospital }}" data-filter-serverside="true">
        <div class="col-xs-12">
            <h4>Hospital Excess</h4>
            <div class="sidebar-subtitle-container">
                <span class="helper-text"><a data-content="helpid:299" data-toggle="popover" tabindex="-1" <field_v1:analytics_attr analVal="filter help modal excess" quoteChar="\"" />>Help ?</a></span>
                <span class="heading-text">Hospital excess</span>
            </div>
            <div class="filter-excess">
                <health_v1:filter_excess useDefaultOutputField="true" />
            </div>
        </div>
    </div>

    {{ if (meerkat.modules.healthRebate.isRebateApplied()) { }}
    <div class="row filter need-hospital {{=hiddenHospital }}" data-filter-serverside="true">
        <div class="col-xs-12">
            <div class="sidebar-subtitle-container">
                <span class="helper-text"><a data-content="helpid:544" data-toggle="popover" tabindex="-1" <field_v1:analytics_attr analVal="filter help modal rebate" quoteChar="\"" />>Help ?</a></span>
                <span class="heading-text">Government rebate</span>
            </div>
            <div class="filter-rebate-holder"></div>
        </div>
    </div>
    {{ } }}

    <div class="row filter" data-filter-serverside="true">
        <div class="col-xs-12">
            <div class="filter-by-brand-container">
                <div class="sidebar-subtitle-container">
                    <span class="helper-text">select <a href="javascript:;" class="filter-brands-toggle" data-toggle="true">all</a>/<a class="filter-brands-toggle" data-toggle="false">none</a></span>
                    <span class="heading-text">Brands</span>
                </div>
                <div class="provider-list">
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
            <a href="javascript:void(0);" class="filter-by-brand-toggle"><span class="text">Filter by brand</span> <span class="icon icon-angle-down"></span></a>
        </div>
    </div>
</core_v1:js_template>