<%@ tag description="The Health Filters" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<core_v1:js_template id="filter-results-template">

    {{ var hiddenHospital = meerkat.modules.health.getCoverType() === 'E' ? ' hidden' : ''; }}

    {{ var currentFamilySituation = meerkat.modules.healthChoices.returnCoverCode();}}
    {{ var hiddenExtendedFamily = (currentFamilySituation === 'F' ? '' : (currentFamilySituation === 'EF' ? '' : (currentFamilySituation === 'SPF' ? '' : (currentFamilySituation === 'ESP' ? '' : ' hidden' )))); }}

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
                    <label class="btn btn-form-inverse {{= active }}" <field_v1:analytics_attr analVal="filter payment freq" quoteChar="\"" />>
                        <input type="radio" name="{{= model.frequency.name }}" id="{{= model.frequency.name }}_{{= object.value }}" value="{{= object.value }}" {{=checked }}
                               title="{{= object.label }}"/> {{= object.label }}</label>
                    {{ }) }}
                </div>
            </div>
        </div>
    </div>

    <div class="row filter" data-filter-serverside="true">
        <div class="col-xs-12">
            <div class="filter-discount">
                <div class="checkbox">
                    <input type="checkbox" name="health_filterBar_discount" id="health_filterBar_discount" value="Y">
                    <label for="health_filterBar_discount">Apply all available discounts</label>
                </div>
            </div>
        </div>
    </div>

    <div class="row filter need-extendedFamily {{=hiddenExtendedFamily }}" data-filter-serverside="true">
        <div class="col-xs-12">
            <div class="sidebar-subtitle-container">
                <span class="heading-text">Family Type</span>
            </div>
            <div class="filter-cover-level select">
                <span class=" input-group-addon">
                    <i class="icon-sort"></i>
                </span>
                <select class="form-control array_select " id="health_filterBar_extendedFamily" name="health_filterBar_extendedFamily" data-msg-required="Please choose " <field_v1:analytics_attr analVal="filter familytype" quoteChar="\"" />>
                    {{ _.each(model.extendedFamily.values, function(object) { }}
                        {{ var selected = object.selected ? ' selected="selected"' : ''; }}
                        {{ if(currentFamilySituation === 'F' || currentFamilySituation === 'EF') { }}
                            {{ if(object.value === 'F' || object.value === 'EF') { }}
                                <option id="health_filterBar_extendedFamily_{{= object.value }}" value="{{= object.value }}" {{=selected }}>{{= object.label }}</option>
                            {{ } }}
                        {{ }  else { }}
                            {{ if(object.value === 'SPF' || object.value === 'ESP') { }}
                                <option id="health_filterBar_extendedFamily_{{= object.value }}" value="{{= object.value }}" {{=selected }}>{{= object.label }}</option>
                            {{ } }}
                        {{ } }}
                    {{ }) }}
                </select>
            </div>
        </div>
    </div>

    <div class="row filter need-hospital {{=hiddenHospital }}" data-filter-serverside="true">
        <div class="col-xs-12">
            <div class="sidebar-subtitle-container">
                <span class="helper-text"><a data-content="helpid:299" data-toggle="popover" tabindex="-1" <field_v1:analytics_attr analVal="filter help modal excess" quoteChar="\"" />>Help ?</a></span>
                <span class="heading-text">Hospital excess</span>
            </div>
            <div class="filter-excess">
                <health_v1:filter_excess useDefaultOutputField="true" />
            </div>
        </div>
    </div>

    {{ if (meerkat.modules.healthCoverDetails.isRebateApplied()) { }}
    <div class="row filter" data-filter-serverside="true">
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