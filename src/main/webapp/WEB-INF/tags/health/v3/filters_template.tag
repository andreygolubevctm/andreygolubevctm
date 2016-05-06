<%@ tag description="The Health Filters" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<core_v1:js_template id="filter-results-template">

    {{ var coverType = meerkat.modules.health.getCoverType(); }}

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
                <select class="form-control array_select " id="health_filterBar_coverLevel" name="health_filterBar_coverLevel" data-msg-required="Please choose ">
                    {{ _.each(model.coverLevel.values, function(object) { }}
                    {{ var selected = object.selected ? ' selected="selected"' : ''; }}
                    <option id="health_filterBar_coverLevel_{{= object.value }}" value="{{= object.value }}" {{=selected }}>{{= object.label }}</option>
                    {{ }) }}
                </select>
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
                <health_v1:filter_excess useDefaultOutputField="true" />
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
                    <input type="checkbox" name="{{= model.brands.name }}" id="{{= model.brands.name }}_{{= object.value }}" value="{{= object.value }}" {{=checked }}
                           title="{{= object.label }}"/> <label for="{{= model.brands.name }}_{{= object.value }}">{{= object.label }}</label>
                </div>
                {{ }) }}
            </div>
        </div>
    </div>
</core_v1:js_template>