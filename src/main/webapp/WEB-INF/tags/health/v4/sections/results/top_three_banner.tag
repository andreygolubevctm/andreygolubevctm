<%@ tag description="The Health Top 3 banner" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:if test="${not empty showPopularProducts and showPopularProducts eq true}">
    <core_v1:js_template id="results-top-three-banner-template">
    <div class="results-top-three-banner invisible">
        <div class="top-three-options">
            Too many options?<button class="btn btn-hollow" data-popular-products="Y">View the top <span class="popular-plans-text">popular plans</span> people like you buy <span class="icon icon-angle-right"></span></button>
        </div>

        <div class="top-three-deciding hidden">
            Still deciding?<button class="btn btn-hollow" data-popular-products="N"><span class="icon icon-angle-left"></span> Go back and view all your results</button>
        </div>
    </div>
    </core_v1:js_template>
</c:if>