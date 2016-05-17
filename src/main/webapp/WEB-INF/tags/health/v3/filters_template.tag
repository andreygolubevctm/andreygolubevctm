<%@ tag description="The Health Filters" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<core_v1:js_template id="filter-results-template">

    {{ var hiddenHospital = meerkat.modules.health.getCoverType() === 'E' ? ' hidden' : ''; }}

    <div class="sidebar-title hidden-xs">Filter Results</div>

    <div class="row filter">
        <div class="col-xs-12">
            <div class="sidebar-subtitle-container">
                <span class="heading-text">Payment frequency</span>
            </div>
            <div class="filter-frequency">
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

    <div class="row filter need-hospital {{=hiddenHospital }}" data-filter-serverside="true">
        <div class="col-xs-12">
            <div class="sidebar-subtitle-container">
                <span class="helper-text"><a data-content="#hospitalCoverTooltipText" data-title="Hospital Cover Information" data-toggle="popover" tabindex="-1">Help ?</a></span>
                <span class="heading-text">Hospital cover level</span>
                <div class="hidden" id="hospitalCoverTooltipText">
                    The hospital policies on our website fall into four categories which are broadly recognised in the industry. The categories give a helpful starting point to give you an indication of what a policy is likely to cover, but it is still important to look closely at what a particular policy covers, and doesn't cover, before you buy it.<br /><br />
                    The categories do not take into account benefit limitation periods, or the excess or co-payment that a particular policy might require. They also do not take into account hospital treatment for which Medicare pays no benefit, like cosmetic surgery or laser eye surgery.<br />
                    <h5>Top Hospital</h5>
                    A hospital health insurance policy will be categorised as having "Top Hospital" cover if it covers all services where Medicare pays a benefit.<br />
                    <h5>Medium Hospital</h5>
                    To be categorised a medium hospital product, a policy must provide cover against cardiac and cardiac related services, non-cosmetic plastic surgery, rehabilitation, psychiatric services and palliative care. The policy may not cover you for pregnancy and birth related services, assisted reproductive services, cataract and eye lens procedures, joint replacements, hip replacements, dialysis for chronic renal failure or sterilisation.<br />
                    <h5>Basic Hospital</h5>
                    A basic hospital product is one that doesn't cover one or more of cardiac and cardiac related services, non-cosmetic plastic surgery, rehabilitation, psychiatric services and palliative care. The inclusions for a basic hospital product differ from policy to policy, so it's important that you look at each product individually.<br />
                    <h5>Limited hospital cover</h5>
                    A limited hospital product is one that covers only 10 or less of the items for which Medicare pays a benefit. These policies provide lower than average cover and, in some instances, will only cover treatment as a result of an accident.
                </div>
            </div>
            <div class="filter-cover-level select">
                <span class=" input-group-addon">
                    <i class="icon-sort"></i>
                </span>
                <select class="form-control array_select " id="health_filterBar_coverLevel" name="health_filterBar_coverLevel" data-msg-required="Please choose ">
                    {{ _.each(model.coverLevel.values, function(object) { }}
                    {{ var selected = object.selected ? ' selected="selected"' : ''; }}
                    <option id="health_filterBar_coverLevel_{{= object.value }}" value="{{= object.value }}" {{=selected }}>{{= object.label }}</option>
                    {{ }) }}
                </select>
            </div>
        </div>
    </div>

    <div class="row filter need-hospital {{=hiddenHospital }}" data-filter-serverside="true">
        <div class="col-xs-12">
            <div class="sidebar-subtitle-container">
                <span class="helper-text"><a data-content="helpid:299" data-toggle="popover" tabindex="-1">Help ?</a></span>
                <span class="heading-text">Hospital excess</span>
            </div>
            <div class="filter-excess">
                <health_v1:filter_excess useDefaultOutputField="true" />
            </div>
        </div>
    </div>

    {{ if (meerkat.modules.healthCoverDetails.isRebateApplied()) { }}
    <div class="row filter need-hospital {{=hiddenHospital }}" data-filter-serverside="true">
        <div class="col-xs-12">
            <div class="sidebar-subtitle-container">
                <span class="helper-text"><a>Help ?</a></span>
                <span class="heading-text">Government rebate</span>
            </div>
            <div class="filter-rebate-holder"></div>
        </div>
    </div>
    {{ } }}

    <div class="row filter" data-filter-serverside="true">
        <div class="col-xs-12">
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
                           title="{{= object.label }}"/> <label for="{{= model.brands.name }}_{{= object.value }}">{{= object.label }}</label>
                </div>
                {{ }) }}
            </div>
        </div>
    </div>
</core_v1:js_template>