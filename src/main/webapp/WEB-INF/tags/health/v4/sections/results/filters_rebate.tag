<%@ tag description="The Health Cover Selections Filter" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<core_v1:js_template id="filter-rebate-template">
    <div class="row filter" data-filter-serverside="true">
        <div class="col-xs-12">
            <div class="checkbox">
                <input type="checkbox" name="{{= model.rebate.name }}" id="{{= model.rebate.name }}" class="checkbox-custom checkbox" value="Y" />
                <label for="{{= model.rebate.name }}">Apply the Australian Government Rebate to lower my upfront premium</label>
            </div>
            <div class="income_container hidden">
                <div class="rebate-label" id="filtersRebateLabel">
                    <span></span> <a href="javascript:;" class="filtersEditTier">EDIT</a>
                </div>
                <div class="selectedRebate" id="filtersSelectedRebateText"></div>
                <div class="filter-income-holder"></div>
            </div>
        </div>
    </div>
</core_v1:js_template>