<%@ tag description="The Health Filters" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<core_v1:js_template id="filter-results-template">

    {{ var coverType = meerkat.modules.splitTest.isActive(13) ? $('#health_situation_coverType input').filter(":checked").val() : $('#health_situation_coverType').val() }}

    <div class="sidebar-title">Filter Results</div>
    <div class="row filter">
        <div class="col-xs-12">
            <div class="sidebar-subtitle-container">
                <span class="heading-text">Payment frequency</span>
            </div>
            <div class="filter-frequency" data-filter-type="radio">
                <div class="btn-group btn-group-justified " data-toggle="radio">
                    {{ _.each(model.frequency.values, function(object) { }}
                    {{ var checked = object.selected ? ' checked="checked"' : ''; }}
                    {{ var active = object.selected ? ' active' : ''; }}
                    <label class="btn btn-form-inverse {{= active }}">
                        <input type="radio" name="{{= model.frequency.name }}" id="{{= model.frequency.name }}_{{= object.value }}" value="{{= object.value }}" {{=checked }}
                               title="{{= object.label }}"/> {{= object.label }}</label>
                    {{ }) }}
                </div>
            </div>
        </div>
    </div>

    {{ if (coverType != 'E') { }}
    <div class="row filter">
        <div class="col-xs-12">
            <div class="sidebar-subtitle-container">
                <span class="helper-text"><a>Help ?</a></span>
                <span class="heading-text">Hospital cover level</span>
            </div>
            <div class="filter-cover-type" data-filter-type="radio">
                <field_v2:slider type="coverType" value="4" range="1,4" markers="4" legend="Limited,Basic,Mid,Top" xpath="health/filterBar/coverType"/>
            </div>
        </div>
    </div>

    {{ } }}

    {{ if (coverType != 'E') { }}
    <div class="row filter">
        <div class="col-xs-12">
            <div class="sidebar-subtitle-container">
                <span class="helper-text"><a>Help ?</a></span>
                <span class="heading-text">Hospital excess</span>
            </div>
            <div class="filter-excess" data-filter-type="slider" data-filter-serverside="true">
                <health_v1:filter_excess/>
            </div>
        </div>
    </div>
    {{ } }}
    {{ if (coverType != 'E') { }}
    <div class="row filter">
        <div class="col-xs-12">
            <div class="sidebar-subtitle-container">
                <span class="helper-text"><a>Help ?</a></span>
                <span class="heading-text">Government rebate</span>
            </div>
            <div data-filter-type="select" data-filter-serverside="true" class="filter-rebate-holder"></div>
        </div>
    </div>

    {{ } }}


    <div class="row filter">
        <div class="col-xs-12">
            <div class="sidebar-subtitle-container">
                <span class="helper-text">select <a href="javascript:;" class="filter-brands-toggle" data-toggle="true">all</a>/<a class="filter-brands-toggle" data-toggle="false">none</a></span>
                <span class="heading-text">Brands</span>
            </div>
            <div class="provider-list" data-filter-type="select" data-filter-serverside="true">
                {{ _.each(model.brands.values, function(object) { }}
                {{ var checked = !object.selected ? ' checked="checked"' : ''; }}
                {{ var active = !object.selected ? ' active' : ''; }}
                <div class="checkbox-none">
                    <input type="checkbox" name="{{= model.brands.name }}" id="{{= model.brands.name }}_{{= object.value }}" value="{{= object.value }}" {{= checked }}
                           title="{{= object.label }}"/> <label for="{{= model.brands.name }}_{{= object.value }}">{{= object.label }}</label>
                </div>
                {{ }) }}
            </div>
        </div>
    </div>
</core_v1:js_template>


<health_v3:filters_update_widget_template/>