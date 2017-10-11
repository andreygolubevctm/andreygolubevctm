<%@ tag description="Main template for refine results menu for mobile"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<core_v1:js_template id="refine-results-template">
    <section data-panel="1" class="current">
        <span style="font-size: 16px;">Discounts</span>
        <field_v2:checkbox
                xpath="health_refine_results_discount"
                className="refine-results-discount"
                value="Y"
                required="true"
                label="${true}"
                title="Apply all available discounts to show me the lowest possible price"
        />

        <span style="font-size: 16px;">Rebate</span>
        <field_v2:checkbox
                xpath="health_refine_results_rebate"
                className="refine-results-rebate"
                value="Y"
                required="true"
                label="${true}"
                title="Apply the Australian Government Rebate to lower my upfront premium"
        />

        <div class="mobile-filters-menu-item-container">
            <div class="mobile-filters-menu-item" data-menu-id="hospitalPreferences">
                <div class="mobile-filter-type">Hospital insurance preferences</div>
                <div class="mobile-filter-type-selection">
                    <span class="refine-results-hospital-type">{{= hospitalType }} Hospital</span>
                    <span class="refine-results-count-text">{{= hospitalCountText }}</span>
                </div>
            </div>
            <div class="mobile-filters-menu-item" data-menu-id="extrasPreferences">
                <div class="mobile-filter-type">Extras insurance preferences</div>
                <div class="mobile-filter-type-selection">
                    <span class="refine-results-count-text">{{= extrasCountText }}</span>
                </div>
            </div>
            <div class="mobile-filters-menu-item" data-menu-id="excess">
                <div class="mobile-filter-type">Excess</div>
            </div>
            <div class="mobile-filters-menu-item" data-menu-id="funds">
                <div class="mobile-filter-type">Refine funds</div>
            </div>
        </div>
    </section>

    <health_v4_refine_results:hospital_preferences />
    <health_v4_refine_results:extras_preferences />
    <health_v4_refine_results:excess />
    <health_v4_refine_results:funds />
</core_v1:js_template>