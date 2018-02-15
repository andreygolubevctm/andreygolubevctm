<%@ tag description="Main template for refine results menu for mobile"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<core_v1:js_template id="refine-results-template">
    <div class="refine-results-mobile">
        <section data-panel-id="main" class="current">
            <span class="refine-results-mobile__sub-heading">Discounts</span>
            <field_v2:checkbox
                    xpath="health_refine_results_discount"
                    className="refine-results-discount"
                    value="Y"
                    required="true"
                    label="${true}"
                    title="Apply all available discounts to show me the lowest possible price"
            />

            <span class="refine-results-mobile__sub-heading">Rebate</span>
            <field_v2:checkbox
                    xpath="health_refine_results_rebate"
                    className="refine-results-rebate"
                    value="Y"
                    required="true"
                    label="${true}"
                    title="Apply the Australian Government Rebate to lower my upfront premium"
            />

            <span class="refine-results-mobile__sub-heading">Awards Schemes</span>
            <field_v2:checkbox
                    xpath="health_refine_results_awards_scheme"
                    className="refine-results-awards-scheme"
                    value="Y"
                    required="true"
                    label="${true}"
                    title="Show products with connected rewards schemes first"
            />

            <div class="refine-results-mobile__item-container">
                <div class="refine-results-mobile__item" data-menu-id="hospital">
                    <div class="refine-results-mobile__item-type">Hospital insurance preferences</div>
                    <div class="refine-results-mobile__item-type-selection">{{= hospitalType }} Hospital{{= hospitalCountText }}</div>
                </div>
                <div class="refine-results-mobile__item" data-menu-id="extras">
                    <div class="refine-results-mobile__item-type">Extras insurance preferences</div>
                    <div class="refine-results-mobile__item-type-selection">{{= extrasCountText }}</div>
                </div>
                <div class="refine-results-mobile__item" data-menu-id="excess">
                    <div class="refine-results-mobile__item-type">Excess</div>
                    <div class="refine-results-mobile__item-type-selection">
                        <span class="refine-results-mobile__">{{= excessText }}</span>
                    </div>
                </div>
                <div class="refine-results-mobile__item" data-menu-id="funds">
                    <div class="refine-results-mobile__item-type">Refine funds</div>
                    <div class="refine-results-mobile__item-type-selection">{{= fundsText }}</div>
                </div>
            </div>
        </section>

        <health_v4_refine_results:hospital_preferences />
        <health_v4_refine_results:extras_preferences />
        <health_v4_refine_results:excess />
        <health_v4_refine_results:funds />
    </div>
</core_v1:js_template>