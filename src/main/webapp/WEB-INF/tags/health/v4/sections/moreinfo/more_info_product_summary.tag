<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<!-- Product Summary. Logo, price, LHC etc... -->
<div class="row priceRow productSummary hidden-xs">
    <div class="col-xs-8">
        <div class="companyLogo {{= info.provider }}"></div>
        <h5 class="noTopMargin productName hidden-xs">{{= info.productTitle }}</h5>
    </div>
    <div class="col-xs-4 printableBrochuresLink">
        {{= renderedPriceTemplate }}
        <a href="javascript:;" class="getPrintableBrochures">Get printable brochures in your email inbox</a>
    </div>
</div>