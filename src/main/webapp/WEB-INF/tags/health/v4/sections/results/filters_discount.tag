<%@ tag description="The Health Cover Selections Discount Filter" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<core_v1:js_template id="filter-discount-template">
    <div class="filter-heading">Optional Filters</div>
    <div class="filter" data-filter-serverside="true">
        <div class="checkbox">
            <input type="checkbox" name="{{= model.discount.name }}" id="{{= model.discount.name }}" class="checkbox-custom checkbox" value="Y" />
            <label for="{{= model.discount.name }}">Apply all available discounts to show me the lowest possible price</label>
        </div>
    </div>
</core_v1:js_template>