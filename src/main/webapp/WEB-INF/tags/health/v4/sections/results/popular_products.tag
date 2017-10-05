<%@ tag description="The Health Top 3 banner" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:if test="${not empty showPopularProducts and showPopularProducts eq true}">
    <core_v1:js_template id="results-popular-products-banner-template">
        <div class="results-popular-products-banner invisible">
            <div class="popular-products-options">
                Need our help to decide?<button class="btn btn-hollow" data-popular-products="Y" <field_v1:analytics_attr analVal="popular filter" quoteChar="\"" />>View the most <span class="popular-plans-text">popular policies</span> people like you buy <span class="icon icon-angle-right"></span></button>
            </div>

            <div class="popular-products-deciding hidden">
                <button class="btn btn-hollow" data-popular-products="N" <field_v1:analytics_attr analVal="popular undo" quoteChar="\"" />><span class="icon icon-angle-left"></span> Go back to original results</button>
            </div>
        </div>
    </core_v1:js_template>

    <core_v1:js_template id="results-popular-products-tag-template">
        <div class="result-popular-products-tag">Popular plan <a href="javascript:;" class="icon icon-info" data-content="helpid:579" data-toggle="popover" <field_v1:analytics_attr analVal="popular help" quoteChar="\"" />></a></div>
    </core_v1:js_template>
</c:if>
