<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<!-- Product Summary. Logo, price, LHC etc... -->
<div class="row priceRow productSummary hidden-xs">
    <div class="col-xs-8">
        <div class="companyLogo {{= info.provider }}"></div>
        <h2 class="noTopMargin productName hidden-xs">{{= info.productTitle }}</h2>
    </div>
    <div class="col-xs-4 text-center">
        {{= renderedPriceTemplate }}
        <a href="javascript:;">Get printable brochures in your email inbox</a>
    </div>
</div>